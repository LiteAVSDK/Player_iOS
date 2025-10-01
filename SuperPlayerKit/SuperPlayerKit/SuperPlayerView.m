#import "SuperPlayerView.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#if __has_include(<SDWebImage/SDWebImage.h>)
#import <SDWebImage/SDWebImage.h>
#else
#import "SDWebImage.h"
#endif

#import "DataReport.h"
#import "J2Obj.h"
#import "NSString+URL.h"
#import "SPDefaultControlView.h"
#import "StrUtils.h"
#import "SuperPlayer.h"
#import "SuperPlayerControlViewDelegate.h"
#import "SuperPlayerModelInternal.h"
#import "SuperPlayerView+Private.h"
#import "TXBitrateItemHelper.h"
#import "TXCUrl.h"
#import "UIView+Fade.h"
#import "UIView+MMLayout.h"
#import "UIInterface+TXRotation.h"
// TODO: 处理头部引用
#if __has_include("TXAudioCustomProcessDelegate.h")
#import "TXAudioCustomProcessDelegate.h"
#endif
#if __has_include("TXAudioRawDataDelegate.h")
#import "TXAudioRawDataDelegate.h"
#endif
#if __has_include("TXBitrateItem.h")
#import "TXBitrateItem.h"
#endif
#if __has_include("TXImageSprite.h")
#import "TXImageSprite.h"
#endif
#if __has_include("TXLiteAVCode.h")
#import "TXLiteAVCode.h"
#endif
#import "TXLiveAudioSessionDelegate.h"
#import "TXLiveBase.h"
#import "TXLivePlayConfig.h"
#import "TXLivePlayListener.h"
#import "TXLivePlayer.h"
#import "TXLiveRecordListener.h"
#import "TXLiveRecordTypeDef.h"
#if __has_include("TXLiveSDKEventDef.h")
#import "TXLiveSDKEventDef.h"
#endif
#if __has_include("TXLiveSDKTypeDef.h")
#import "TXLiveSDKTypeDef.h"
#endif
#import "TXPlayerAuthParams.h"
#import "TXVipTipView.h"
#import "TXVipWatchView.h"
#import "TXVipWatchModel.h"
#import "DynamicWatermarkView.h"
#import "DynamicWaterModel.h"
#import "SuperPlayerLocalized.h"
#import "SuperPlayerTrackView.h"
#import "SuperPlayerSubtitles.h"
#ifdef ENABLE_UGC
#import "TXUGCBase.h"
#import "TXUGCPartsManager.h"
#import "TXUGCRecord.h"
#import "TXUGCRecordListener.h"
#import "TXUGCRecordTypeDef.h"
#endif
#import "TXVideoCustomProcessDelegate.h"
#import "TXVodPlayConfig.h"
#import "TXVodPlayListener.h"
#import "TXVodPlayer.h"
#import "TXPlayerGlobalSetting.h"

#import "SuperPlayerSmallWindowManager.h"
#import "SuperPlayerPIPManager.h"
static UISlider *_volumeSlider;

#define CellPlayerFatherViewTag     200
#define SUPPORT_PARAM_MAJOR_VERSION (8)
#define SUPPORT_PARAM_MINOR_VERSION (2)
#define PLAY_FORWARD_SPEED_RATE     3
#define PLAY_BACKWARD_SEEK_TIME     5

//ignore compiler warnings
//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface SuperPlayerView()<TXVipTipViewDelegate,TXVipWatchViewDelegate,
TXLiveBaseDelegate,TXLivePlayListener,TXVodPlayListener>

@property (nonatomic, strong) UIActivityIndicatorView  *pipLoadingView;
@property (nonatomic, strong) dispatch_source_t         timer;
@property (nonatomic, strong) UIImageView              *playforwardImageView;
@property (nonatomic, strong) UIImageView              *playforwardView;
@property (nonatomic, strong) UILabel                  *playforwardLabel;
@property (nonatomic, strong) UIImageView              *playbackwardImageView;
@property (nonatomic, strong) UIImageView              *playbackwardView;
@property (nonatomic, strong) UILabel                  *playbackwardLabel;
@property (nonatomic, strong) DynamicWatermarkView     *watermarkView;  ///动态水印
///Full screen playback window background
///全屏播放窗口背景
@property (nonatomic, strong) UIView *fullScreenBlackView;

@end

@implementation SuperPlayerView {
    
    SuperPlayerControlView *_controlView;
    NSURLSessionTask *      _currentLoadingTask;
    BOOL  isShowVipTipView;
    BOOL  isShowVipWatchView;
    NSString               *_currentVideoUrl;
    BOOL                   _isPrepare;
    BOOL                   _hasStartPip;
    BOOL                   _restoreUI;
    BOOL                   _hasStartPipLoading;

    NSInteger              _playingIndex;
    BOOL                   _isLoopPlayList;
    BOOL                   _isVideoList;
    NSArray                *_videoModelList;
    NSInteger              _lastSubtitleIndex;
    NSInteger              _lastAudioTrackIndex;
}

#pragma mark - life Cycle

+ (void)initialize {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *cachePath = [path stringByAppendingString:@"/TXCache"];
    [TXPlayerGlobalSetting setCacheFolderPath:cachePath];
    [TXPlayerGlobalSetting setMaxCacheSize:500];
}

 /// Code initialization calls this method
 /// 代码初始化调用此方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeThePlayer];
    }
    return self;
}

/// storyboard, xib loading playerView will call this method
/// storyboard、xib加载playerView会调用此方法
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeThePlayer];
}

/**
  * Initialize the player
  */
/**
 *  初始化player
 */
- (void)initializeThePlayer {
    LOG_ME;


    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (!window.isHidden) {
            [window addSubview:self.volumeView];
            break;
        }
    }
    // singleton slider
    // 单例slider
    _volumeSlider = nil;
    for (UIView *view in [self.volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            _volumeSlider = (UISlider *)view;
            break;
        }
    }

    _playerConfig = [[SuperPlayerViewConfig alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    SuperPlayerWindowShared.closeHandler = ^{
        __strong __typeof(weakSelf) self = weakSelf;
        if (self) {
            [self resetPlayer];
        }
        if (self && self->_watermarkView) {
            [self->_watermarkView releaseDynamicWater];
            [self->_watermarkView removeFromSuperview];
            self->_watermarkView = nil;
        }
        if (self && self->_vodPlayer){
            [self->_vodPlayer exitPictureInPicture];
        }
        [SuperPlayerWindowShared hide];
        SuperPlayerWindowShared.backController = nil;
    };
    
    // add notification
    // 添加通知
    [self addNotifications];
    // add gesture
    // 添加手势
    [self createGesture];
    //Add fast forward and rewind view
    //添加快进快退view
    [self setUIView];
    
    self.autoPlay = YES;
    _hasStartPip = NO;
    _restoreUI = NO;
    _hasStartPipLoading = NO;
    _lastSubtitleIndex = -1;
    _lastAudioTrackIndex = 0;
}

- (void)dealloc {
    LOG_ME;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self reportPlay];
    [self.netWatcher stopWatch];
    [self.volumeView removeFromSuperview];
    
    if (_vodPlayer) {
        [_vodPlayer exitPictureInPicture];
        [_vodPlayer stopPlay];
        [_vodPlayer removeVideoWidget];
        _vodPlayer = nil;
    }
    
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

#pragma mark - 观察者、通知

/**
 *  添加观察者、通知
 */
- (void)addNotifications {
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground:) name:UIApplicationWillResignActiveNotification
                                               object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterPlayground:) name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onStatusBarOrientationChange)
     name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

#pragma mark - layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.subviews.count > 0) {
        UIView *innerView = self.subviews[0];
        if ([innerView isKindOfClass:NSClassFromString(@"TXIJKSDLGLView")] || [innerView isKindOfClass:NSClassFromString(@"TXCAVPlayerView")] || [innerView isKindOfClass:NSClassFromString(@"TXCThumbPlayerView")]) {
            innerView.frame = self.bounds;
        }
    }
}

#pragma mark - Public Method
- (void)playWithModelListNeedLicence:(NSArray *)playModelList isLoopPlayList:(BOOL)isLoop startIndex:(NSInteger)index {
    if (playModelList.count <= 0) {
        return;
    }
    _videoModelList = playModelList;
    _playingIndex = index;
    _isLoopPlayList = isLoop;
    _isVideoList = YES;
    [self.vodPlayer stopPlay];
    [self playModelInList:index];
}

- (void)playWithModelNeedLicence:(SuperPlayerModel *)playerModel {
    LOG_ME;
    _videoModelList = nil;
    _playerModel = playerModel;
    _isVideoList = NO;
    [self.controlView setNextBtnState:NO];
    [self setChildViewState];
    [self _playWithModel:playerModel];
    
}

- (void)reloadModel {
    SuperPlayerModel *model = _playerModel;
    if (model) {
        [self resetPlayer];
        [self _playWithModel:_playerModel];
        [self addNotifications];
    }
}

- (void)_playWithModel:(SuperPlayerModel *)playerModel {
    [_currentLoadingTask cancel];
    _currentLoadingTask = nil;
    _currentVideoUrl = nil;

    self.controlView.hidden = YES;
    [self configTXPlayer];
}

/**
 *  player添加到fatherView上
 */
- (void)addPlayerToFatherView:(UIView *)view {
    [self.fullScreenBlackView removeFromSuperview];
    [self removeFromSuperview];
    if (view) {
        [view addSubview:self.fullScreenBlackView];
        [view addSubview:self];
        [self.fullScreenBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
    }
}

- (void)setFatherView:(UIView *)fatherView {
    if (fatherView) {
        [self addPlayerToFatherView:fatherView];
    }
    _fatherView = fatherView;
}

/**
 *  重置player
 */
- (void)resetPlayer {
    LOG_ME;
    [self.vodPlayer exitPictureInPicture];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];

    [self.vodPlayer stopPlay];
    [self.vodPlayer removeVideoWidget];
    self.vodPlayer = nil;

    [self.livePlayer stopPlay];
    [self.livePlayer removeVideoWidget];
    self.livePlayer = nil;

    [self reportPlay];

    self.state = StateStopped;
}

/**
 *  播放
 */
- (void)resume {
    LOG_ME;
    [self.controlView setPlayState:YES];
    self.isPauseByUser = NO;
    self.centerPlayBtn.hidden = YES;
    
    if (self.controlView.enableFadeAction) {
        [self.controlView setSliderState:YES];
        [self.controlView setTopViewState:YES];
        if (_playerModel.action == PLAY_ACTION_MANUAL_PLAY) {
            [self showOrHideBackBtn:YES];
        }
    }
    
    if (self.isLive) {
        self.state         = StatePlaying;
        [_livePlayer resume];
    } else {
        if (self.state == StatePause || self.state == StateBuffering) {
            [self.vodPlayer resume];
            self.state = StatePlaying;
            if (self.delegate && [self.delegate respondsToSelector:@selector(superPlayerDidStart:)]) {
                [self.delegate superPlayerDidStart:self];
            }
        } else if (self.state == StatePlaying) {
            [self.spinner stopAnimating];
        } else {
            if (self.state == StatePrepare) {
                self.state         = StatePlaying;
                self.coverImageView.hidden = YES;
                [self.vodPlayer resume];
            } else {
                self.centerPlayBtn.hidden = NO;
                _isPrepare = YES;
            }
        }
    }
}

/**
 * 暂停
 */
- (void)pause {
    LOG_ME;
    if (!self.isLoaded) return;
    if (self.playDidEnd) return;
    self.repeatBtn.hidden     = YES;
    if (self.controlView.enableFadeAction) {
        [[self.controlView fadeShow] fadeOut:1];
    }
    [self.controlView setPlayState:NO];
    self.isPauseByUser = YES;
    self.state         = StatePause;
    self.centerPlayBtn.hidden = NO;
    if (self.isLive) {
        [_livePlayer pause];
    } else {
        [self.vodPlayer pause];
    }
}

/**
 *  展示vipTipView
 */
- (void)showVipTipView {
    
    [self addSubview:self.vipTipView];

    if (SuperPlayerWindowShared.isShowing) {
          self.vipTipView.textFontSize = WINDOW_VIP_TIPVIEW_TEXT_FONT;
          [self.vipTipView mas_makeConstraints:^(MASConstraintMaker *make) {
              make.bottom.equalTo(self).offset(-WINDOW_VIP_TIPVIEW_BOTTOM);
              make.left.equalTo(self).offset(WINDOW_VIP_TIPVIEW_LEFT);
              make.right.equalTo(self);
              make.height.mas_equalTo(VIP_TIPVIEW_DEFAULT_HEIGHT);
          }];
    } else {
        [self.vipTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (self.isFullScreen) {
                if (@available(iOS 11.0, *)) {
                    make.bottom.equalTo(self).offset(-VIP_TIPVIEW_DEFAULTX_BOTTOM);
                } else {
                    make.bottom.equalTo(self).offset(-VIP_TIPVIEW_DEFAULT_BOTTOM);
                }
            } else {
                make.bottom.equalTo(self).offset(-VIP_TIPVIEW_DEFAULT_BOTTOM);
            }
            make.left.equalTo(self).offset(VIP_TIPVIEW_DEFAULT_LEFT);
            make.right.equalTo(self);
            make.height.mas_equalTo(VIP_TIPVIEW_DEFAULT_HEIGHT);
        }];
    };
    
    [self.vipTipView setVipWatchModel:[self setCurrentVipModel]];
    isShowVipTipView = YES;
    self.isCanShowVipTipView = YES;
    
    self.vipWatchView.vipWatchModel = [self setCurrentVipModel];
}

/**
 *  隐藏vipTipView
 */
- (void)hideVipTipView {
    [self.vipTipView removeFromSuperview];
    self.vipTipView = nil;
}

/**
 *  展示vipWatchView
 */
- (void)showVipWatchView {
    
    if (!isShowVipWatchView) {
        return;
    }
    
    [self hideVipTipView];
    [self hideVipWatchView];
    self.isCanShowVipTipView = NO;
    
    [self addSubview:self.vipWatchView];
    self.vipWatchView.frame = self.bounds;
    
    self.vipWatchView.vipWatchModel = [self setCurrentVipModel];
    
    if (SuperPlayerWindowShared.isShowing) {
        self.vipWatchView.textFontSize = 10;
    }
    
    if (self.isFullScreen) {
        self.vipWatchView.scale = self.vipWatchView.frame.size.width / ScreenWidth;
    } else {
        self.vipWatchView.scale = self.vipWatchView.frame.size.height / ScreenWidth;
    }
    
    [self.vipWatchView initVipWatchSubViews];
}

/**
 *  隐藏vipWatchView
 */
- (void)hideVipWatchView {
    [self.vipWatchView removeFromSuperview];
    self.vipWatchView = nil;
}

- (void)removeVideo {
    _isPrepare = NO;
    self.state = StateStopped;
    [self.vodPlayer stopPlay];
    [self.vodPlayer removeVideoWidget];
}

- (void)showOrHideBackBtn:(BOOL)isShow {
    [self.controlView showOrHideBackBtn:isShow];
}

- (void)enterPictureInPicture {
    [self.vodPlayer enterPictureInPicture];
}

- (void)exitPictureInPicture {
    [self.vodPlayer exitPictureInPicture];
}
- (BOOL)isSupportPictureInPicture {
    if ([TXVodPlayer isSupportPictureInPicture]) {
        if (self.playerConfig.pipAutomatic) { // 2.0
            if ([TXVodPlayer isSupportSeamlessPictureInPicture]) {
                return YES;
            } else {
                return NO;
            }
        } else { // 1.0
            return YES;
        }
    }
    return NO;
}
#pragma mark - Control View Configuration
- (void)resetControlViewWithLive:(BOOL)isLive shiftPlayback:(BOOL)isShiftPlayback isPlaying:(BOOL)isPlaying {
    [_controlView resetWithResolutionNames:self.playerModel.playDefinitions
                    currentResolutionIndex:self.playerModel.playingDefinitionIndex
                                    isLive:isLive
                            isTimeShifting:isShiftPlayback
                                 isPlaying:isPlaying];
}

#pragma mark - Private Method
- (void)playModelInList:(NSInteger)index {
    if (index < 0) {
        return;
    }
    
    if (index >= _videoModelList.count) {
        return;
    }
    
    _playerModel = _videoModelList[index];
    [self.controlView setNextBtnState:YES];
    [self setChildViewState];
    [self.controlView setTitle:_playerModel.name];
    
    [self _playWithModel:_playerModel];
}

- (TXVipWatchModel *)setCurrentVipModel {
    TXVipWatchModel *model = [TXVipWatchModel new];
    if (self.vipWatchModel == nil) {
        model.tipTtitle = VIP_VIDEO_DEFAULT_TIP_TITLE;
        model.canWatchTime = 15;
    } else {
        model = self.vipWatchModel;
    }
    
    return model;
}
- (BOOL)isSupportAppendParam {
    NSString *version = [TXLiveBase getSDKVersionStr];
    NSArray * vers    = [version componentsSeparatedByString:@"."];
    if (vers.count <= 1) {
        return NO;
    }
    NSInteger majorVer = [vers[0] integerValue] ?: 0;
    NSInteger minorVer = [vers[1] integerValue] ?: 0;
    return majorVer >= SUPPORT_PARAM_MAJOR_VERSION && minorVer >= SUPPORT_PARAM_MINOR_VERSION;
}

/**
 *  设置Player相关参数
 */
- (void)configTXPlayer {
    LOG_ME;
    
    if (_playerConfig.enableLog) {
        [TXLiveBase setLogLevel:LOGLEVEL_DEBUG];
        [TXLiveBase sharedInstance].delegate = self;
        [TXLiveBase setConsoleEnabled:YES];
    }
    
    [self.vodPlayer stopPlay];
    [self.livePlayer stopPlay];
    [self.vodPlayer removeVideoWidget];
    [self.livePlayer removeVideoWidget];
    _hasStartPip = NO;
    _vodPlayer = nil;

    self.liveProgressTime = self.maxLiveProgressTime = 0;
    
    // 如果videoUrl存在，则是直播
    int liveType = -1;
    if (self.playerModel.videoURL && self.playerModel.videoURL.length > 0) {
        liveType = [self livePlayerType];
        if (liveType >= 0) {
            self.isLive = YES;
        } else {
            self.isLive = NO;
        }
    } else {
        self.isLive = NO;
    }

    self.isLoaded = NO;

    self.netWatcher.playerModel = self.playerModel;
    // 时移
    [TXLiveBase setAppID:[NSString stringWithFormat:@"%ld", _playerModel.appId]];
    if (self.isLive) {
        if (!self.livePlayer) {
            self.livePlayer          = [[TXLivePlayer alloc] init];
            self.livePlayer.delegate = self;
        }
        [self setLivePlayerConfig];
        [self.controlView setProgressTime:0 totalTime:-1 progressValue:1 playableValue:0];
        [self.livePlayer startLivePlay:self.playerModel.videoURL type:liveType];
        _currentVideoUrl = self.playerModel.videoURL;
        TXCUrl *curl = [[TXCUrl alloc] initWithString:self.playerModel.videoURL];
    } else {
        
        [self setVodPlayConfig];
        
        NSString *videoUrlStr = _playerModel.videoURL;
        if (videoUrlStr && videoUrlStr.length > 0) {
            [self preparePlayWithUrl:videoUrlStr];
        } else {
            NSArray *multiVideoURLs = _playerModel.multiVideoURLs;
            if (multiVideoURLs.count > 0 && multiVideoURLs.firstObject) {
                SuperPlayerUrl *videoUrl = multiVideoURLs.firstObject;
                if (videoUrl.url && videoUrl.url.length > 0) {
                    [self preparePlayWithUrl:videoUrl.url];
                } else {
                    TXPlayerAuthParams *params = [[TXPlayerAuthParams alloc] init];
                    params.appId = (int)_playerModel.appId;
                    params.fileId = _playerModel.videoId.fileId;
                    params.sign = _playerModel.videoId.psign;
                    [self preparePlayWithVideoParams:params];
                }
            } else {
                TXPlayerAuthParams *params = [[TXPlayerAuthParams alloc] init];
                params.appId = (int)_playerModel.appId;
                params.fileId = _playerModel.videoId.fileId;
                params.sign = _playerModel.videoId.psign;
                [self preparePlayWithVideoParams:params];
            }
        }
    }
    [self resetControlViewWithLive:self.isLive shiftPlayback:self.isShiftPlayback isPlaying:self.state == StatePlaying ? YES : NO];
    self.controlView.playerConfig = self.playerConfig;
    self.repeatBtn.hidden         = YES;
    self.playDidEnd               = NO;
    [self.middleBlackBtn fadeOut:0.1];
}

- (void)setVodPlayConfig {
    TXVodPlayConfig *config    = [[TXVodPlayConfig alloc] init];
    config.smoothSwitchBitrate = YES;
    config.progressInterval = 0.02;
    config.headers = self.playerConfig.headers;
    config.keepLastFrameWhenStop = YES;

    config.overlayIv = self.playerModel.overlayIv;
    config.overlayKey = self.playerModel.overlayKey;
    config.preferredResolution = 720 * 1280;
    
    config.timeout = 5;
    config.connectRetryInterval = 1;
    config.connectRetryCount = 1;
    [self.vodPlayer setConfig:config];
    // 挂载字幕
    if (_playerModel.subtitlesArray.count > 0) {
        for (SuperPlayerSubtitles *subtitles in _playerModel.subtitlesArray) {
            [self.vodPlayer addSubtitleSource:subtitles.subtitlesUrl name:subtitles.subtitlesName mimeType:(NSInteger)subtitles.subtitlesType];
        }
    }
    
    //设置字幕默认样式
    NSDictionary *dic = [(SPDefaultControlView *)self.controlView subtitlesConfig];
    [self setSubtitleStyle:dic];
        
    self.vodPlayer.token    = self.playerModel.drmToken;

    self.vodPlayer.enableHWAcceleration = self.playerConfig.hwAcceleration;
    [self.vodPlayer setStartTime:self.startTime];
    self.startTime = 0;
    
    [self.vodPlayer setupVideoWidget:self insertIndex:0];
    [self.vodPlayer setRate:self.playerConfig.playRate];
    [self.vodPlayer setMirror:self.playerConfig.mirror];
    [self.vodPlayer setMute:self.playerConfig.mute];
    [self.vodPlayer setRenderMode:self.playerConfig.renderMode];
    [self.vodPlayer setLoop:self.loop];
    if (self.vipWatchView.vipWatchModel != nil) {
        [self.vodPlayer setAutoPictureInPictureEnabled:NO];///试看禁止开启画中画2.0
    } else {
        [self.vodPlayer setAutoPictureInPictureEnabled:self.playerConfig.pipAutomatic];
    }
    
    [self.netWatcher startWatch];
    __weak SuperPlayerView *weakSelf = self;
    [self.netWatcher setNotifyTipsBlock:^(NSString *msg) {
        SuperPlayerView *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf showMiddleBtnMsg:msg withAction:ActionSwitch];
            [strongSelf.middleBlackBtn fadeOut:2];
        }
    }];
}

- (void)setLivePlayerConfig {
    TXLivePlayConfig *config      = [[TXLivePlayConfig alloc] init];
    config.bAutoAdjustCacheTime   = NO;
    config.maxAutoAdjustCacheTime = 5.0f;
    config.minAutoAdjustCacheTime = 5.0f;
    config.headers                = self.playerConfig.headers;
    [self.livePlayer setConfig:config];
    
    self.livePlayer.enableHWAcceleration = self.playerConfig.hwAcceleration;
    [self.livePlayer setupVideoWidget:CGRectZero containView:self insertIndex:0];
    [self.livePlayer setMute:self.playerConfig.mute];
    [self.livePlayer setRenderMode:self.playerConfig.renderMode];
    self.isPauseByUser = NO;
    
    [self.netWatcher startWatch];
    __weak SuperPlayerView *weakSelf = self;
    [self.netWatcher setNotifyTipsBlock:^(NSString *msg) {
        SuperPlayerView *strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf showMiddleBtnMsg:msg withAction:ActionSwitch];
            [strongSelf.middleBlackBtn fadeOut:2];
        }
    }];
}

- (void)preparePlayVideo {
    [self.controlView setProgressTime:0 totalTime:_playerModel.duration progressValue:0 playableValue:0 / _playerModel.duration];
    if (_playerModel.action == PLAY_ACTION_AUTO_PLAY) {
        if (!SuperPlayerWindowShared.isShowing) {
            [self.controlView setPlayState:YES];
            [self.controlView setSliderState:YES];
        } else {
            if (self.controlView.enableFadeAction) {
                [self.controlView fadeOut:0.2];
            }
        }
        self.isPauseByUser = NO;
        self.centerPlayBtn.hidden = YES;
    } else if (_playerModel.action == PLAY_ACTION_PRELOAD) {
        self.vodPlayer.isAutoPlay = NO;
        self.spinner.hidden = YES;
        self.centerPlayBtn.hidden = NO;
        self.coverImageView.hidden = NO;
        self.isPauseByUser = YES;
        [self.controlView setPlayState:NO];
        [self.controlView setSliderState:YES];
    } else {
        self.spinner.hidden = YES;
        self.coverImageView.hidden = self.state == StateStopped ? NO : YES;
        self.centerPlayBtn.hidden = NO;
        self.isPauseByUser = YES;
        [self.controlView setPlayState:NO];
        [self.controlView setSliderState:NO];
        [self.controlView setTopViewState:NO];
        [self showOrHideBackBtn:NO];
    }
}

- (void)preparePlayWithVideoParams:(TXPlayerAuthParams *)params {
    [self preparePlayVideo];
    if (_playerModel.action == PLAY_ACTION_AUTO_PLAY || _playerModel.action == PLAY_ACTION_PRELOAD) {
        [self.vodPlayer startVodPlayWithParams:params];
    }
}

- (void)preparePlayWithUrl:(NSString *)videoUrl {
    _currentVideoUrl = videoUrl;
    [self preparePlayVideo];
    if (_playerModel.action == PLAY_ACTION_AUTO_PLAY || _playerModel.action == PLAY_ACTION_PRELOAD) {
        [self.vodPlayer startVodPlay:videoUrl];
    }
}

- (void)startPlay {
    if (_currentVideoUrl) {
        [self.vodPlayer startVodPlay:_currentVideoUrl];
    } else {
        TXPlayerAuthParams *params = [[TXPlayerAuthParams alloc] init];
        params.appId = (int)_playerModel.appId;
        params.fileId = _playerModel.videoId.fileId;
        params.sign = _playerModel.videoId.psign;
        [self.vodPlayer startVodPlayWithParams:params];
    }
}

- (void)setCoverImage {
    self.coverImageView.hidden = NO;
    NSURL *customUrl = [NSURL URLWithString:_playerModel.customCoverImageUrl];
    NSURL *defaultUrl = [NSURL URLWithString:_playerModel.defaultCoverImageUrl];
    CGRect rect = CGRectMake(0, 0, 100, 100);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    UIColor *color = [UIColor colorWithRed:32/255 green:37/255 blue:48/255 alpha:1];
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.coverImageView sd_setImageWithURL:_playerModel.customCoverImageUrl.length > 0 ? customUrl : defaultUrl
                           placeholderImage:image
                                    options:SDWebImageAvoidDecodeImage];
}

- (void)restart {
    [self.spinner startAnimating];
    self.centerPlayBtn.hidden = YES;
    self.repeatBtn.hidden = YES;
    self.playDidEnd = NO;
    
    if ([self.vodPlayer supportedBitrates].count > 1) {
        [self.vodPlayer resume];
    } else {
        [self startPlay];
        if (_playerModel.action == PLAY_ACTION_PRELOAD) {
            [self resume];
        }
    }
}

- (void)controllViewPlayClick {
    [self.spinner startAnimating];
    if (!self.vodPlayer.isAutoPlay) {
        [self resume];
    } else {
        if (self.state == StateStopped) {
            [self.controlView setPlayState:YES];
            self.isPauseByUser = NO;
            self.centerPlayBtn.hidden = YES;
            [self.controlView setSliderState:YES];
            [self.controlView setTopViewState:YES];
            if (_playerModel.action == PLAY_ACTION_MANUAL_PLAY) {
                [self showOrHideBackBtn:YES];
            }
            [self startPlay];
        } else {
            [self resume];
        }
    }
}

/**
 *  创建手势
 */
- (void)createGesture {
    // 单击
    self.singleTap                         = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    self.singleTap.delegate                = self;
    self.singleTap.numberOfTouchesRequired = 1;  //手指数
    self.singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:self.singleTap];

    // 双击(播放/暂停)
    self.doubleTap                         = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    self.doubleTap.delegate                = self;
    self.doubleTap.numberOfTouchesRequired = 1;  //手指数
    self.doubleTap.numberOfTapsRequired    = 2;
    [self addGestureRecognizer:self.doubleTap];
    
    // 长按(快进/快退)
    self.longPress                         =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    self.longPress.numberOfTouchesRequired = 1;  //手指数
    [self addGestureRecognizer:self.longPress];

    // 解决点击当前view时候响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];

    // 加载完成后，再添加平移手势
    // 添加平移手势，用来控制音量、亮度、快进快退
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDirection:)];
    panRecognizer.delegate                = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelaysTouchesBegan:YES];
    [panRecognizer setDelaysTouchesEnded:YES];
    [panRecognizer setCancelsTouchesInView:YES];
    [self addGestureRecognizer:panRecognizer];
}

- (void)detailPrepareState {
    // 防止暂停导致加载进度不消失
    if (self.isPauseByUser) [self.spinner stopAnimating];
    self.state = StatePrepare;
    if (self->_isPrepare) {
        [self.vodPlayer resume];
        self->_isPrepare = NO;
        self.isPauseByUser = NO;
        [self.controlView setPlayState:YES];
        self.centerPlayBtn.hidden = YES;
    }
}

- (void)detailTrackAndSubtitlesWithPlayer:(TXVodPlayer *)player {
    
    NSMutableArray *trackArray = [NSMutableArray array];
    NSMutableArray *subtitlesArray = [NSMutableArray array];
    TXTrackInfo *offInfo = [[TXTrackInfo alloc] init];
    offInfo.name = superPlayerLocalized(@"SuperPlayer.off");
    offInfo.trackIndex = -1;
    offInfo.isInternal = false;
    offInfo.trackType = TX_VOD_MEDIA_TRACK_TYPE_SUBTITLE;
    
    NSInteger subtitlesIndex = 0;
    if (player.getSubtitleTrackInfo.count > 0) {
        [subtitlesArray addObjectsFromArray:player.getSubtitleTrackInfo];
        [subtitlesArray insertObject:offInfo atIndex:0];
        
        for (int i = 0; i < subtitlesArray.count; i++) {
            TXTrackInfo *info = subtitlesArray[i];
            if (info.trackIndex == self->_lastSubtitleIndex) {
                subtitlesIndex = i;
                break;
            }
        }
    }
    
    [trackArray addObjectsFromArray:player.getAudioTrackInfo];
    [trackArray insertObject:offInfo atIndex:0];
    
    __block NSInteger audioTrackIndex = 1;
    [trackArray enumerateObjectsUsingBlock:^(TXTrackInfo * _Nonnull obj,
                                                           NSUInteger idx,
                                                           BOOL * _Nonnull stop) {
        if (obj.trackIndex == self->_lastAudioTrackIndex) {
            audioTrackIndex = idx;
        }
    }];
    [self.controlView resetWithTracks:trackArray currentTrackIndex:audioTrackIndex subtitles:subtitlesArray currentSubtitlesIndex:subtitlesIndex];
    
    if (self->_lastSubtitleIndex != -1) {
        [self.vodPlayer selectTrack:self->_lastSubtitleIndex];
    }
    
    if (self->_lastAudioTrackIndex != -1) {
        [self.vodPlayer setMute:NO];
        [self.vodPlayer selectTrack:self->_lastAudioTrackIndex];
    } else {
        [self.vodPlayer setMute:YES];
    }
}

- (void)detailProgress {
    // StateStopped 是当前播放的状态  playDidEnd 是否播放完了
    // StatePrepare 是在接受到onPlayEvent回调的状态  _isPrepare是用户主动触发resume的状态
    if (self.state == StateStopped) return;
    if (self.playDidEnd) return;
    if (_playerModel.action == PLAY_ACTION_PRELOAD) {
        // 预加载状态下才会有此判断
        if (self.state == StatePrepare || !self->_isPrepare) {
            return;
        };
    }
    
    if (self.state == StatePlaying) {
        self.centerPlayBtn.hidden = YES;
        self.repeatBtn.hidden = YES;
        self.playDidEnd = NO;
    }
}

- (void)detailPlayerEvent:(TXVodPlayer *)player event:(int)evtID param:(NSDictionary *)param{
    if (evtID == PLAY_ERR_NET_DISCONNECT) {
        [self showMiddleBtnMsg:kStrBadNetRetry withAction:ActionContinueReplay];
    } else {
        [self showMiddleBtnMsg:kStrLoadFaildRetry withAction:ActionRetry];
    }
    self.state = StateFailed;
    [player stopPlay];
    if ([self.delegate respondsToSelector:@selector(superPlayerError:errCode:errMessage:)]) {
        [self.delegate superPlayerError:self errCode:evtID errMessage:param[EVT_MSG]];
    }
}

- (void)setChildViewState {
    isShowVipWatchView = NO;
    [self.controlView setOrientationPortraitConstraint];
    [self setCoverImage];
    [_watermarkView releaseDynamicWater];
    [_watermarkView removeFromSuperview];
    _watermarkView = nil;
    if (_playerModel.dynamicWaterModel) {
        [self addSubview:self.watermarkView];
        [self.watermarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.watermarkView setDynamicWaterModel:_playerModel.dynamicWaterModel];
    }
    self.isShiftPlayback  = NO;
    self.imageSprite      = nil;
    self.state         = StateStopped;
    [self reportPlay];
    self.reportTime = [NSDate date];
    [self _removeOldPlayer];
    self.centerPlayBtn.hidden = YES;
    if (_playerModel.action == PLAY_ACTION_AUTO_PLAY) {
        self.state         = StateBuffering;
        [self.spinner startAnimating];
    }
    
    [self.controlView setDisableOfflineBtn:!self.playerModel.isEnableCache];
    self.repeatBtn.hidden     = YES;
    // 播放时添加监听
    [self addNotifications];
}

- (void)prepareAutoplay {
    if (!self.autoPlay) {
        self.autoPlay = YES; // 下次用户设置自动播放失效
        [self pause];
    }
    
    if ([self.delegate respondsToSelector:@selector(superPlayerDidStart:)]) {
        [self.delegate superPlayerDidStart:self];
    }
    
    // 重新添加字幕
    if (self->_lastSubtitleIndex != -1) {
        [self.vodPlayer selectTrack:self->_lastSubtitleIndex];
    }
    // 音轨
    if (self->_lastAudioTrackIndex != -1) {
        [self.vodPlayer setMute:NO];
        [self.vodPlayer selectTrack:self->_lastAudioTrackIndex];
    } else {
        [self.vodPlayer setMute:YES];
    }
}

- (NSArray<NSURL *> *)convertImageSpriteList:(NSArray<NSString *> *)imageSpriteList
{
    if (!imageSpriteList) {
        return nil;
    }
    
    NSMutableArray<NSURL *> *imageSpriteURLs = [NSMutableArray array];
    for (NSString *imageSpriteStr in imageSpriteList) {
        NSURL *imageSpriteURL = [NSURL URLWithString:imageSpriteStr];
        if (imageSpriteURL) {
            [imageSpriteURLs addObject:imageSpriteURL];
        }
    }
    
    return [imageSpriteURLs copy];
}

#pragma mark - KVO

- (UIDeviceOrientation)_orientationForFullScreen:(BOOL)fullScreen {
    UIDeviceOrientation targetOrientation = [UIDevice currentDevice].orientation;
    if (fullScreen) {
        if (!UIDeviceOrientationIsLandscape(targetOrientation)) {
            targetOrientation = UIDeviceOrientationLandscapeLeft;
        }
    } else {
        if (!UIDeviceOrientationIsPortrait(targetOrientation)) {
            targetOrientation = UIDeviceOrientationPortrait;
        }
    }
    return targetOrientation;
}

- (void)_switchToFullScreen:(BOOL)fullScreen {

    if (fullScreen) {
        [self fullScreenLayout];
        self.fatherView.viewController.navigationController.navigationBarHidden = YES;
    } else {
        [self addPlayerToFatherView:self.fatherView];
        self.fatherView.viewController.navigationController.navigationBarHidden = NO;
    }
}

//Mars 全屏布局
- (void)fullScreenLayout {
    UIViewController *vc = self.fatherView.viewController;
    if (!vc) {
        return;
    }
    [self.fullScreenBlackView removeFromSuperview];
    [self removeFromSuperview];
    [vc.view addSubview:self.fullScreenBlackView];
    [vc.view addSubview:self];
    [self.fullScreenBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(vc.view);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.mas_equalTo(vc.view.mas_safeAreaLayoutGuideLeft);
            make.right.mas_equalTo(vc.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.left.mas_equalTo(vc.view.mas_left);
            make.right.mas_equalTo(vc.view.mas_right);
        }
        make.top.mas_equalTo(vc.view.mas_top);
        make.bottom.mas_equalTo(vc.view.mas_bottom);
    }];
    
}


#pragma mark - Action

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (SuperPlayerWindowShared.isShowing) return;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(singleTapClick)] && self.isFullScreen) {
            [self.delegate singleTapClick];
        }

        if (self.controlView.enableFadeAction) {
            if (self.controlView.hidden) {
                [[self.controlView fadeShow] fadeOut:5];
            } else {
                [self.controlView fadeOut:0.2];
            }
        }
        
        if (self.isFullScreen) {
            [self.controlView setTopViewState:!self.isLockScreen];
        } else {
            [self.controlView setTopViewState:(self.state == StateStopped && _playerModel.action == PLAY_ACTION_MANUAL_PLAY) ? NO : YES];
        }
    }
}

/**
 *  双击播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    // 显示控制层
    if (self.controlView.enableFadeAction) {
        [self.controlView fadeShow];
    }
    
    if (self.playDidEnd) {
        [self.vodPlayer stopPlay];
        [self setVodPlayConfig];
        [self restart];
    } else {
        if (self.isPauseByUser) {
            _playerModel.action == PLAY_ACTION_MANUAL_PLAY ? [self controllViewPlayClick] : [self resume];
        } else {
            [self pause];
        }
    }
}

/**
 *  长按快进/快退
 *
 *  @param gesture UITapGestureRecognizer
 */
-(void)longPressAction:(UILongPressGestureRecognizer *)gesture{
    if (!self.isFullScreen) {
        return;
    }
    CGPoint forwardPoint = [gesture locationInView:self.playforwardView];
    BOOL forward = [self.playforwardView.layer containsPoint:forwardPoint];
    CGPoint backwardPoint = [gesture locationInView:self.playbackwardView];
    BOOL backward = [self.playbackwardView.layer containsPoint:backwardPoint];
    if (!(forward || backward)) {
        return;
    }
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (forward) {
            [self setPlayforwardHide:NO];
        }
        if (backward) {
            [self setPlaybackwardHide:NO];
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        if (forward) {
            [self setPlayforwardHide:YES];
        }
        if (backward) {
            [self setPlaybackwardHide:YES];
        }
    }
}

/**
 快退
 */
- (void)setPlaybackwardHide:(BOOL)hide{
    self.playbackwardView.hidden = hide;
    self.playbackwardLabel.hidden = hide;
    self.playbackwardImageView.hidden = hide;
    if (!hide) {
        [self setTimer];
    }else{
        if (_timer) {
            dispatch_source_cancel(_timer);
            _timer = nil;
        }
    }
}

/**
 快进
 */
- (void)setPlayforwardHide:(BOOL)hide{
    self.playforwardView.hidden = hide;
    self.playforwardLabel.hidden = hide;
    self.playforwardImageView.hidden = hide;
    if (!hide) {
        [self.vodPlayer setRate:PLAY_FORWARD_SPEED_RATE];
    }else{
        [self.vodPlayer setRate:self.playerConfig.playRate];
    }
}

/** 全屏 */
- (void)setFullScreen:(BOOL)fullScreen {
    if (fullScreen) {
        if (self.vodPlayer.getSubtitleTrackInfo.count <= 0) {
            [self.controlView setSubtitlesBtnState:NO];
        } else {
            [self.controlView setSubtitlesBtnState:YES];
        }
        [[UIApplication sharedApplication] setStatusBarHidden:fullScreen];
        [self.controlView setTopViewState:YES];
        [self showOrHideBackBtn:YES];
    }
    _isFullScreen = fullScreen;
    
    [(SPDefaultControlView*)self.controlView fullScreenButtonSelectState:fullScreen];
    self.controlView.compact = !fullScreen;
}
///代码手动旋转屏幕
- (BOOL)rotateScreenIsFullScreen:(BOOL)isFullScreen {
    if (!self.isLoaded) {
        return NO;
    }
    if (self.isLockScreen) {
        return NO;
    }
    if (self.didEnterBackground) {
        return NO;
    };
    if (SuperPlayerWindowShared.isShowing) {
        return NO;
    }
    UIViewController *vc = (UIViewController *)self.viewController;
    if (vc == nil) {
        return NO;
    }
    if (isFullScreen ) {
        if ([self.delegate respondsToSelector:@selector(screenRotation:)]) {
            [self.delegate screenRotation:YES];
            [vc tx_rotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
            [vc tx_setNeedsUpdateOfSupportedInterfaceOrientations];
        } else {
            return NO;
        }
        
    } else {
        if ([self.delegate respondsToSelector:@selector(screenRotation:)]) {
            [self.delegate screenRotation:NO];
            [vc tx_rotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
            [vc tx_setNeedsUpdateOfSupportedInterfaceOrientations];
        } else {
            return NO;
        }
    }
    return YES;

}


/**
 *  播放完了
 *
 */
- (void)moviePlayDidEnd {
    self.state      = StateStopped;
    self.playDidEnd = YES;
    // 播放结束隐藏
    if (SuperPlayerWindowShared.isShowing) {
        if (!_isVideoList) {   // 非轮播
            if (_watermarkView) {
                [_watermarkView releaseDynamicWater];
                [_watermarkView removeFromSuperview];
                _watermarkView = nil;
            }
            [SuperPlayerWindowShared hide];
            [self resetPlayer];
            SuperPlayerWindowShared.backController = nil;
        } else {  // 轮播，如果不是循环播放并且是列表的最后一个，则需要隐藏小窗口
            if (!_isLoopPlayList && _playingIndex == _videoModelList.count - 1) {
                [SuperPlayerWindowShared hide];
                [self resetPlayer];
            }
        }
    }
    
    [self.controlView setPlayState:NO];
    [self.controlView fadeOut:0.2];
    [self fastViewUnavaliable];
    [self.netWatcher stopWatch];
    self.repeatBtn.hidden     = NO;
    self.centerPlayBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(superPlayerDidEnd:)]) {
        [self.delegate superPlayerDidEnd:self];
    }
    /// 1、画中画目前暂不支持后台轮播，当后台或者退出当前vc的时候停止轮播
    if (SuperPlayerPIPShared.isShowing &&
        (self.didEnterBackground || ![self.viewController.navigationController.topViewController isKindOfClass:self.viewController.class])) {
        return;
    }
    if (_isVideoList) {
        _playingIndex = (_playingIndex < _videoModelList.count - 1) ? _playingIndex += 1 : 0;
        if (_playingIndex == 0) {
            _isLoopPlayList ? [self playModelInList:_playingIndex] : nil;
        } else {
            [self playModelInList:_playingIndex];
        }
    }
}

- (void)centerPlayBtnClick {
    self.centerPlayBtn.hidden = YES;
    [self.controlView setSliderState:YES];
    [self.controlView setTopViewState:YES];
    [self.spinner startAnimating];
    if (_playerModel.action == PLAY_ACTION_MANUAL_PLAY) {
        [self showOrHideBackBtn:YES];
    }
    
    [self controllViewPlayClick];
}

#pragma mark - UIKit Notifications

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground:(NSNotification *)notify {
    [self fastViewUnavaliable];
    NSLog(@"appDidEnterBackground");
    self.didEnterBackground = YES;
    if (self.isLive) {
        return;
    }
    
    if (_hasStartPip) {
        return;
    }
    
    if (!self.isPauseByUser && (self.state != StateStopped && self.state != StateFailed)) {
        
        if (self.playerConfig.pipAutomatic == YES) {
            if (![TXVodPlayer isSupportSeamlessPictureInPicture]) {
                [_vodPlayer pause];
                self.state = StatePause;
            }
        } else {
            [_vodPlayer pause];
            self.state = StatePause;
        }
    }
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground:(NSNotification *)notify {
    [self fastViewUnavaliable];
    NSLog(@"appDidEnterPlayground");
    self.didEnterBackground = NO;
    if (self.isLive) {
        return;
    }
    
    if (_hasStartPip) {
        return;
    }
    
    if (!self.isPauseByUser && (self.state != StateStopped && self.state != StateFailed)) {
        self.state = StatePlaying;
        [_vodPlayer resume];
        CGFloat value        = _vodPlayer.currentPlaybackTime / _vodPlayer.duration;
        CGFloat playable     = _vodPlayer.playableDuration / _vodPlayer.duration;
        self.controlView.isDragging = NO;
        [self.controlView setProgressTime:self.playCurrentTime totalTime:_vodPlayer.duration progressValue:value playableValue:playable];
        [_vodPlayer seek:self.playCurrentTime];
    } else if (self.state != StateStopped) {
        self.repeatBtn.hidden = YES;
    }
}

#pragma mark -- 屏幕方向发生变化
- (void)onStatusBarOrientationChange {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreenHookAction)]){
        return;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(backHookAction)]){
        return;
    }
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationUnknown:
            break;
        case UIInterfaceOrientationPortrait:
            self.isFullScreen = NO;
            [self _switchToFullScreen:NO];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            break;
        case UIInterfaceOrientationLandscapeLeft:
            self.isFullScreen = YES;
            [self _switchToFullScreen:YES];
            break;
        case UIInterfaceOrientationLandscapeRight:
            self.isFullScreen = YES;
            [self _switchToFullScreen:YES];
            break;
        default:
            break;
    }
}

#pragma mark -
- (void)seekToTime:(NSInteger)dragedSeconds {
    if (!self.isLoaded || self.state == StateStopped) {
        return;
    }
    if (self.isLive) {
        [DataReport report:@"timeshift" param:nil];
    } else {
        if (!_vodPlayer) {
            [self setVodPlayConfig];
            [self restart];
        } else {
            [self.vodPlayer resume];
            [self.spinner startAnimating];
            [self.vodPlayer seek:dragedSeconds];
            [self.controlView setPlayState:YES];
        }
    }
}

#pragma mark - UIPanGestureRecognizer手势方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (((UITapGestureRecognizer *)gestureRecognizer).numberOfTapsRequired == 2) {
            if (self.isLockScreen) return NO;
        }
        return YES;
    }

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        if (!self.isLoaded) {
            return NO;
        }
        if (self.isLockScreen) {
            return NO;
        }
        if (SuperPlayerWindowShared.isShowing) {
            return NO;
        }
        if (self.isFullScreen) {
            return YES;
        } else {
            UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
            CGPoint veloctyPoint = [pan velocityInView:self];
            CGFloat pointX = fabs(veloctyPoint.x);
            CGFloat pointY = fabs(veloctyPoint.y);
            if (pointX > pointY) {
                return YES;
            } else {
                return self.disableGesture ? YES : NO;
            }
        }
        
        return YES;
    }

    return NO;
}
/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];

    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];

    if (self.state == StateStopped) return;

    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {  // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) {  // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                self.sumTime      = [self playCurrentTime];
            } else if (x < y) {  // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                } else {  // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            self.isDragging = YES;
            [self.controlView fadeOut:0.2];
            break;
        }
        case UIGestureRecognizerStateChanged: {  // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved: {
                    [self horizontalMoved:veloctyPoint.x];  // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved: {
                    [self verticalMoved:veloctyPoint.y];  // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            self.isDragging = YES;
            break;
        }
        case UIGestureRecognizerStateEnded: {  // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved: {
                    self.isPauseByUser = NO;
                    [self seekToTime:self.sumTime];
                    // 把sumTime滞空，不然会越加越多
                    self.sumTime = 0;
                    break;
                }
                case PanDirectionVerticalMoved: {
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    break;
                }
                default:
                    break;
            }
            [self fastViewUnavaliable];
            self.isDragging = NO;
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            self.sumTime  = 0;
            self.isVolume = NO;
            [self fastViewUnavaliable];
            self.isDragging = NO;
        }
        default:
            break;
    }
}

/**
 *  pan垂直移动的方法
 *
 *  @param value void
 */
- (void)verticalMoved:(CGFloat)value {
    if (!self.disableGesture) {
        return;
    }
    
    self.isVolume ? ([[self class] volumeViewSlider].value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);

    if (self.isVolume) {
        [self fastViewImageAvaliable:SuperPlayerImage(@"sound_max") progress:[[self class] volumeViewSlider].value];
    } else {
        [self fastViewImageAvaliable:SuperPlayerImage(@"light_max") progress:[UIScreen mainScreen].brightness];
    }
}

/**
 *  pan水平移动的方法
 *
 *  @param value void
 */
- (void)horizontalMoved:(CGFloat)value {
    // 每次滑动需要叠加时间
    CGFloat totalMovieDuration = [self playDuration];
    self.sumTime += value / 10000 * totalMovieDuration;

    if (self.sumTime > totalMovieDuration) {
        self.sumTime = totalMovieDuration;
    }
    if (self.sumTime < 0) {
        self.sumTime = 0;
    }

    [self fastViewProgressAvaliable:self.sumTime];
}

- (void)volumeChanged:(NSNotification *)notification {
    if (self.isDragging) return;  // 正在拖动，不响应音量事件

    if (![[[notification userInfo] objectForKey:VOLUME_CHANGE_PARAMATER] isEqualToString:VOLUME_EXPLICIT_CHANGE]) {
        return;
    }
    float volume = [[[notification userInfo] objectForKey:VOLUME_CHANGE_KEY] floatValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.disableVolumControl) {
            [self fastViewImageAvaliable:SuperPlayerImage(@"sound_max") progress:volume];
            [self.fastView fadeOut:1];
        }
    });
}

- (SuperPlayerFastView *)fastView {
    if (_fastView == nil) {
        _fastView = [[SuperPlayerFastView alloc] init];
        [self addSubview:_fastView];
        [_fastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _fastView;
}

- (void)fastViewImageAvaliable:(UIImage *)image progress:(CGFloat)draggedValue {
    if (self.controlView.isShowSecondView) return;
    [self.fastView showImg:image withProgress:draggedValue];
    [self.fastView fadeShow];
}

- (void)fastViewProgressAvaliable:(NSInteger)draggedTime {
    NSInteger totalTime = 0;
    if (_playerModel.duration > 0) {
        totalTime = _playerModel.duration;
    } else {
        totalTime = [self playDuration];
    }
    NSString *currentTimeStr = [StrUtils timeFormat:draggedTime];
    NSString *totalTimeStr   = [StrUtils timeFormat:totalTime];
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    if (self.isLive) {
        timeStr = [NSString stringWithFormat:@"%@", currentTimeStr];
    }

    UIImage *thumbnail;
    if (self.isFullScreen) {
        thumbnail = [self.imageSprite getThumbnail:draggedTime];
    }
    if (thumbnail) {
        self.fastView.videoRatio = self.videoRatio;
        [self.fastView showThumbnail:thumbnail withText:timeStr];
    } else {
        CGFloat sliderValue = 1;
        if (totalTime > 0) {
            sliderValue = (CGFloat)draggedTime / totalTime;
        }
        if (self.isLive && totalTime > MAX_SHIFT_TIME) {
            CGFloat base = totalTime - MAX_SHIFT_TIME;
            if (self.sumTime < base) self.sumTime = base;
            sliderValue = (self.sumTime - base) / MAX_SHIFT_TIME;
            NSLog(@"%f", sliderValue);
        }
        [self.fastView showText:timeStr withText:sliderValue];
    }
    [self.fastView fadeShow];
}

- (void)fastViewUnavaliable {
    [self.fastView fadeOut:0.1];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UISlider class]] || [touch.view.superview isKindOfClass:[UISlider class]]) {
        return NO;
    }
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
        return NO;
    }

    if (SuperPlayerWindowShared.isShowing) {
        return NO;
    }
    return YES;
}

#pragma mark - Setter

/**
 *  设置播放的状态
 *
 *  @param state SuperPlayerState
 */
- (void)setState:(SuperPlayerState)state {
    _state = state;
    // 控制菊花显示、隐藏
    if (state == StateBuffering && !_playDidEnd) {
        [self.spinner startAnimating];
    } else {
        [self.spinner stopAnimating];
    }
    if (state == StatePlaying) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:VOLUME_NOTIFICATION_NAME object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:VOLUME_NOTIFICATION_NAME object:nil];
    } else if (state == StateFirstFrame) {
        _state = StatePlaying;
        if (self.coverImageView.alpha == 1) {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.coverImageView.hidden = YES;
                             }];
        }
    } else if (state == StateFailed) {
    } else if (state == StateStopped) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:VOLUME_NOTIFICATION_NAME object:nil];
        
        // 如果在播放结束需要显示封面，打开此行
//        self.coverImageView.hidden = NO;

    } else if (state == StatePause) {
        // 如果在播放暂停需要显示封面，打开此行
//        self.coverImageView.hidden = NO;
    }
}

- (void)setControlView:(SuperPlayerControlView *)controlView {
    if (_controlView == controlView) {
        return;
    }
    [_controlView removeFromSuperview];

    _controlView         = controlView;
    controlView.delegate = self;
    [self addSubview:controlView];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self resetControlViewWithLive:self.isLive shiftPlayback:self.isShiftPlayback isPlaying:self.state == StatePlaying ? YES : NO];
    [controlView setTitle:_controlView.title];
    [controlView setPointArray:_controlView.pointArray];
}

- (SuperPlayerControlView *)controlView {
    if (_controlView == nil) {
        self.controlView = [[SPDefaultControlView alloc] initWithFrame:CGRectZero];
    }
    return _controlView;
}

- (void)setDragging:(BOOL)dragging {
    _isDragging = dragging;
    if (dragging) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:VOLUME_NOTIFICATION_NAME object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:VOLUME_NOTIFICATION_NAME object:nil];
    }
}

- (void)setLoop:(BOOL)loop {
    _loop = loop;
    if (self.vodPlayer) {
        self.vodPlayer.loop = loop;
    }
}
- (void)setPlayerConfig:(SuperPlayerViewConfig *)playerConfig {
    _playerConfig = playerConfig;
    if (playerConfig) {
        [TXPlayerGlobalSetting setMaxCacheSize:playerConfig.maxCacheSizeMB];
    }
    
}
#pragma mark - Getter

- (CGFloat)playDuration {
    if (self.isLive) {
        return self.maxLiveProgressTime;
    }
    return self.vodPlayer.duration;
}

- (CGFloat)playCurrentTime {
    if (self.isLive) {
        if (self.isShiftPlayback) {
            return self.liveProgressTime;
        }
        return self.maxLiveProgressTime;
    }

    return _playCurrentTime;
}

+ (UISlider *)volumeViewSlider {
    return _volumeSlider;
}

- (TXImageSprite *)imageSprite
{
    if (!_imageSprite) {
        _imageSprite = [[TXImageSprite alloc] init];
    }
    
    return _imageSprite;
}

- (BOOL)isPipStart {
    if (self.playerConfig.pipAutomatic){
        return YES;
    }
    return _hasStartPip;
}
#pragma mark - SuperPlayerControlViewDelegate

- (void)controlViewPlay:(SuperPlayerControlView *)controlView {
    ///播放中断，重新播放的时候隐藏middlemsg
    if (self.middleBlackBtn.hidden == NO) {
        self.middleBlackBtn.hidden = YES;
    }
    if (self.playDidEnd) {
        [self.vodPlayer stopPlay];
        [self setVodPlayConfig];
        [self restart];
    } else {
        [self controllViewPlayClick];
    }
}

- (void)controlViewPause:(SuperPlayerControlView *)controlView {
    [self pause];
    if (self.state == StatePlaying) {
        self.state = StatePause;
    }
}

- (void)controlViewNextClick:(UIView *)controlView {
    [self.vodPlayer pause];
    [self moviePlayDidEnd];
}

- (void)controlViewBack:(SuperPlayerControlView *)controlView {
    [self controlViewBackAction:controlView];
}

///返回按钮事件
- (void)controlViewBackAction:(id)sender {
    if (self.isFullScreen) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(backHookAction)]){
            [self.delegate backHookAction];
            self.isFullScreen = NO;
            return;
        }
        BOOL result = [self rotateScreenIsFullScreen:NO];
        if (result) {
            self.isFullScreen = NO;
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(superPlayerBackAction:)]) {
        [self.delegate superPlayerBackAction:self];
    }
}

///屏幕放大/缩小
-(void)controlViewChangeScreen:(UIView *)controlView
                withFullScreen:(BOOL)isFullScreen
                  successBlock:(void (^)(void))successBlock
                  failuerBlock:(void (^)(void))failuerBlock {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreenHookAction)]){
        [self.delegate fullScreenHookAction];
        self.isFullScreen = isFullScreen;
        return;
    }
    BOOL result = [self rotateScreenIsFullScreen:isFullScreen];
    if (result) {
        self.isFullScreen = isFullScreen;
    }
    
}

- (void)controlViewDidChangeScreen:(UIView *)controlView {
    if (self.state == StatePlaying || self.repeatBtn.hidden == NO) {
        if ([self.delegate respondsToSelector:@selector(superPlayerFullScreenChanged:)]) {
            [self.delegate superPlayerFullScreenChanged:self];
        }
    }
    
    if (isShowVipWatchView && [self.delegate respondsToSelector:@selector(superPlayerFullScreenChanged:)]) {
        [self.delegate superPlayerFullScreenChanged:self];
    }
}

- (void)controlViewLockScreen:(SuperPlayerControlView *)controlView withLock:(BOOL)isLock {
    self.isLockScreen = isLock;
    if ([self.delegate respondsToSelector:@selector(lockScreen:)]){
        [self.delegate lockScreen:isLock];
    }
}

- (void)controlViewSwitch:(SuperPlayerControlView *)controlView withDefinition:(NSString *)definition {
    
    if ([self.playerModel.playingDefinition isEqualToString:definition]) return;
    self.playerModel.playingDefinition = definition;
    
    if (self.isLive) {
        [self.livePlayer switchStream:_currentVideoUrl];
        [self showMiddleBtnMsg:[NSString stringWithFormat:@"正在切换到%@...", definition] withAction:ActionNone];
    } else {
        self.controlView.hidden = YES;
        if (!self.playDidEnd) {
            if ([self.vodPlayer supportedBitrates].count > 1) {
                [self.vodPlayer setBitrateIndex:self.playerModel.playingDefinitionIndex];
            } else {
                CGFloat startTime = [self.vodPlayer currentPlaybackTime];
                [self.vodPlayer stopPlay];
                self.state = StateStopped;
                [self.vodPlayer setStartTime:startTime];
                [self.vodPlayer startVodPlay:_currentVideoUrl];
                if (_playerModel.action == PLAY_ACTION_PRELOAD) {
                    [self resume];
                }
            }
        }
    }
    
    [self.controlView setResolutionViewState:NO];
    
    [self.vodPlayer setRate:self.playerConfig.playRate];
    [self.vodPlayer setMirror:self.playerConfig.mirror];
    [self.vodPlayer setMute:self.playerConfig.mute];
    [self.vodPlayer setRenderMode:self.playerConfig.renderMode];
}

- (void)controlViewConfigUpdate:(SuperPlayerView *)controlView withReload:(BOOL)reload {
    if (self.state == StateStopped && !self.isLive) {
        return;
    }
    
    if (self.isLive) {
        [self.livePlayer setMute:self.playerConfig.mute];
        [self.livePlayer setRenderMode:self.playerConfig.renderMode];
    } else {
        [self.vodPlayer setRate:self.playerConfig.playRate];
        [self.vodPlayer setMirror:self.playerConfig.mirror];
        [self.vodPlayer setMute:self.playerConfig.mute];
        [self.vodPlayer setRenderMode:self.playerConfig.renderMode];
        [self.vodPlayer setAutoPictureInPictureEnabled:self.playerConfig.pipAutomatic];
    }
    if (reload) {
        if (!self.isLive) self.startTime = [self.vodPlayer currentPlaybackTime];
        self.isShiftPlayback = NO;
        [self configTXPlayer];
        self.state = StateStopped;
        if (_playerModel.action == PLAY_ACTION_PRELOAD) {
            [self resume];
        }
        
        if (self.state != StatePlaying && _playerModel.action == PLAY_ACTION_MANUAL_PLAY) {
            [self controllViewPlayClick];
        }
    }
}

- (void)controlViewReload:(UIView *)controlView {
    if (self.isLive) {
        self.isShiftPlayback = NO;
        self.isLoaded        = NO;
        [self resetControlViewWithLive:self.isLive shiftPlayback:self.isShiftPlayback isPlaying:YES];
    } else {
        self.startTime = [self.vodPlayer currentPlaybackTime];
        [self configTXPlayer];
    }
}

- (void)controlViewSnapshot:(SuperPlayerControlView *)controlView {
    void (^block)(UIImage *img) = ^(UIImage *img) {
        [self.fastView showSnapshot:img];

        if ([self.fastView.snapshotView gestureRecognizers].count == 0) {
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPhotos)];
            singleTap.numberOfTapsRequired    = 1;
            [self.fastView.snapshotView setUserInteractionEnabled:YES];
            [self.fastView.snapshotView addGestureRecognizer:singleTap];
        }
        [self.fastView fadeShow];
        [self.fastView fadeOut:2];
        PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [library
                       performChanges:^{
                           if (@available(iOS 9, *)) {
                               PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
                               [request addResourceWithType:PHAssetResourceTypePhoto data:UIImagePNGRepresentation(img) options:nil];
                           } else {
                               NSLog(@"SuperPlayerView controlViewSnapshot failed, your iOS version is lower than 9.0, please update your system!");
                           }
                       }
                    completionHandler:^(BOOL success, NSError *_Nullable error){
                    }];
            } else {
                NSLog(@"SuperPlayerView controlViewSnapshot failed, unauthorized");
            }
        }];
    };

    if (_isLive) {
        [_livePlayer snapshot:block];
    } else {
        [_vodPlayer snapshot:block];
    }
}

- (void)openPhotos {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"photos-redirect://"]];
}

- (CGFloat)sliderPosToTime:(CGFloat)pos {
    // 视频总时间长度
    CGFloat totalTime = 0;
    if (_playerModel.duration > 0) {
        totalTime = _playerModel.duration;
    } else {
        totalTime = [self playDuration];
    }

    //计算出拖动的当前秒数
    CGFloat dragedSeconds = floorf(totalTime * pos);
    if (self.isLive && totalTime > MAX_SHIFT_TIME) {
        CGFloat base  = totalTime - MAX_SHIFT_TIME;
        dragedSeconds = floor(MAX_SHIFT_TIME * pos) + base;
    }
    return dragedSeconds;
}

- (void)controlViewSeek:(SuperPlayerControlView *)controlView where:(CGFloat)pos {
    CGFloat dragedSeconds = [self sliderPosToTime:pos];
    if (_playerModel.action == PLAY_ACTION_PRELOAD) {
        self->_isPrepare = NO;
        self.isPauseByUser = NO;
        [self.controlView setPlayState:YES];
        self.centerPlayBtn.hidden = YES;
        [self.vodPlayer resume];
        [self.vodPlayer seek:dragedSeconds];
        if (self.delegate && [self.delegate respondsToSelector:@selector(superPlayerDidStart:)]) {
            [self.delegate superPlayerDidStart:self];
        }
    } else {
        if (self.state == StateStopped) {
            [self.vodPlayer setStartTime:dragedSeconds];
            [self.vodPlayer startVodPlay:_currentVideoUrl];
        } else {
            [self seekToTime:dragedSeconds];
        }
        
        [self.controlView setPlayState:YES];
        self.centerPlayBtn.hidden = YES;
        self.repeatBtn.hidden = YES;

    }
    [self fastViewUnavaliable];
}

- (void)controlViewPreview:(SuperPlayerControlView *)controlView where:(CGFloat)pos {
    CGFloat dragedSeconds = [self sliderPosToTime:pos];
    if ([self playDuration] > 0) {  // 当总时长 > 0时候才能拖动slider
        [self fastViewProgressAvaliable:dragedSeconds];
    }
}

//画中画
- (void)controlViewPip:(UIView *)controlView {
    if (![TXVodPlayer isSupportPictureInPicture]) {
        [self setPipLoadingWithText:superPlayerLocalized(@"SuperPlayer.notsupportpip")];
        [self.pipLoadingView startAnimating];
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [self.pipLoadingView stopAnimating];
        });
        return;
    }
    
    if (_hasStartPip) {
        return;
    } else {
        
        if (_hasStartPipLoading) {
            return;
        }
        
        if (self.state == StateStopped) {
            return;
        }
        
        [self setPipLoadingWithText:PIP_START_LOADING_TEXT];
        [self.pipLoadingView startAnimating];
        _hasStartPipLoading = YES;
        [_vodPlayer enterPictureInPicture];
    }
}

- (void)onCloseClick {
    [self hideVipTipView];
    isShowVipTipView = NO;
    self.isCanShowVipTipView = NO;
}
///vipWatchView返回按钮
- (void)onBackClick {
    [self.vipWatchView removeFromSuperview];
    self.centerPlayBtn.hidden = YES;
    if (isShowVipTipView) {
        [self showVipTipView];
    }
    if (!self.isFullScreen) {
        isShowVipWatchView = NO;
        [self seekToTime:0];
    } else {
        isShowVipWatchView = YES;
        ///返回小屏状态
        BOOL result = [self rotateScreenIsFullScreen:NO];
        if (result) {
            self.isFullScreen = NO;
        }
    }
}
///vipWatchView重新播放
- (void)onRepeatClick {
    isShowVipTipView = NO;
    self.centerPlayBtn.hidden = YES;
    self.isCanShowVipTipView = NO;
    isShowVipWatchView = NO;
    [self.vipWatchView removeFromSuperview];
    [self seekToTime:0];
}

- (void)onOpenVIPClick {
    NSURL * helpUrl = [NSURL URLWithString:@"https://cloud.tencent.com/document/product/454/18871"];
    UIApplication *myApp   = [UIApplication sharedApplication];
    if ([myApp canOpenURL:helpUrl]) {
        [myApp openURL:helpUrl];
    }
}

- (void)showVipView {
    isShowVipWatchView = YES;
    [self pause];
    [self hideVipTipView];
    [self showVipWatchView];
    if (_hasStartPip) {
        [_vodPlayer exitPictureInPicture];
    }
    self.isPauseByUser = NO;
}

//配置SPVideoFrameDescription
-(NSArray<SPVideoFrameDescription *> *)getKeyFrameDescList:(NSArray *)contentList
                                                  timeList:(NSArray *)timeList{
    NSMutableArray<SPVideoFrameDescription *> *keyFrameDescLists = [NSMutableArray new];
    NSInteger min = MIN(contentList.count, timeList.count);
    for (int i = 0; i < min; i++) {
        SPVideoFrameDescription *frame = [[SPVideoFrameDescription alloc] init];
        frame.text = contentList[i];
        frame.time = [timeList[i] doubleValue];
        [keyFrameDescLists addObject:frame];
    }
    return keyFrameDescLists;
}

-(void)setSubtitleStyle:(NSDictionary *)dic{
    TXPlayerSubtitleRenderModel *model = [[TXPlayerSubtitleRenderModel alloc] init];
    model.canvasWidth = 1920;  // 字幕渲染画布的宽
    model.canvasHeight = 1080;  // 字幕渲染画布的高
    model.isBondFontStyle = [dic[@"bondFont"] boolValue];  // 设置字幕字体是否为粗体
    model.fontColor = [(NSNumber *)dic[@"fontColor"] unsignedIntValue]; // 设置字幕字体颜色，默认白色
    model.outlineWidth = [(NSNumber *)dic[@"outlineWidth"] floatValue]; //描边宽度
    model.outlineColor = [(NSNumber *)dic[@"outlineColor"] unsignedIntValue]; //描边颜色
    [self.vodPlayer setSubtitleStyle:model];
}

- (void)controlViewSwitch:(UIView *)controlView withTrackInfo:(TXTrackInfo *)info preTrackInfo:(TXTrackInfo *)preInfo {
    if (info.trackIndex == -1) {
        [self.vodPlayer deselectTrack:preInfo.trackIndex];
        [self.vodPlayer setMute:YES];
        self -> _lastAudioTrackIndex = -1;
    } else {
        [self.vodPlayer setMute:NO];
        if (preInfo.trackIndex != -1) {
            [self.vodPlayer deselectTrack:preInfo.trackIndex];
            [self.vodPlayer selectTrack:info.trackIndex];
        }
        self -> _lastAudioTrackIndex = info.trackIndex;
    }
    
    [self.controlView fadeOut:1];
}

- (void)controlViewSwitch:(UIView *)controlView withSubtitlesInfo:(TXTrackInfo *)info preSubtitlesInfo:(TXTrackInfo *)preInfo {
    if (info.trackIndex == -1) {
        [self.vodPlayer deselectTrack:preInfo.trackIndex];
        self->_lastSubtitleIndex = -1;
    } else {
        if (preInfo.trackIndex != -1) {
            [self.vodPlayer deselectTrack:preInfo.trackIndex];
        }
        [self.vodPlayer selectTrack:info.trackIndex];
        self->_lastSubtitleIndex = info.trackIndex;
    }
    
    [self.controlView fadeOut:1];
}

- (void)onSettingViewDoneClickWithDic:(NSMutableDictionary *)dic{
    [self setSubtitleStyle:dic];
}

- (void)onLongPressAction:(UILongPressGestureRecognizer *)gesture{
    [self longPressAction:gesture];
}

- (void)setTimer{
    if (!_timer) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    }
    //快退5秒，播放1秒
    __weak __typeof(self)weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        __strong typeof(self) strongSelf = weakSelf;
        float seekTime = strongSelf.playCurrentTime - PLAY_BACKWARD_SEEK_TIME;
        if (seekTime < 0 ) {
            seekTime = 0;
        }
        [self.vodPlayer seek:seekTime];
    });
    dispatch_resume(_timer);
}

#pragma clang diagnostic pop
#pragma mark - 点播回调

- (void)_removeOldPlayer {
    for (UIView *w in [self subviews]) {
        if ([w isKindOfClass:NSClassFromString(@"TXCRenderView")]) [w removeFromSuperview];
        if ([w isKindOfClass:NSClassFromString(@"TXIJKSDLGLView")]) [w removeFromSuperview];
        if ([w isKindOfClass:NSClassFromString(@"TXCAVPlayerView")]) [w removeFromSuperview];
        if ([w isKindOfClass:NSClassFromString(@"TXCThumbPlayerView")]) [w removeFromSuperview];
    }
}

- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID != PLAY_EVT_PLAY_PROGRESS) {
            NSString *desc = [param description];
            NSLog(@"%@", [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding]);
        }

        float duration = self->_playerModel.duration > 0 ? self->_playerModel.duration : player.duration;
        
        if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
            self.state = StateFirstFrame;
        }

        if (EvtID == EVT_VIDEO_PLAY_BEGIN) {
            self.isLoaded = YES;
            for (SPVideoFrameDescription *p in self.keyFrameDescList) {
                if (player.duration > 0) p.where = p.time / duration;
            }
            self.controlView.pointArray = self.keyFrameDescList;
            self.state = StatePlaying;
            [self.controlView setPlayState:YES];
            self.centerPlayBtn.hidden = YES;
            self.repeatBtn.hidden = YES;
            self.playDidEnd = NO;
            self.controlView.hidden = SuperPlayerWindowShared.isShowing ? YES : NO;
            // 不使用vodPlayer.autoPlay的原因是暂停的时候会黑屏，影响体验
            [self prepareAutoplay];
        }
        if (EvtID == PLAY_EVT_VOD_PLAY_PREPARED) {
            [self updateBitrates:player.supportedBitrates];
            [self detailPrepareState];
            [self detailTrackAndSubtitlesWithPlayer:player];
        }
        if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            [self detailProgress];
            self.playCurrentTime = player.currentPlaybackTime;
            CGFloat totalTime    = duration;
            CGFloat value        = player.currentPlaybackTime / duration;
            CGFloat playable     = player.playableDuration / duration;
            
            if (self.state == StatePlaying) {
                [self.controlView setProgressTime:self.playCurrentTime totalTime:totalTime progressValue:value playableValue:playable];
                [self.vipWatchView setCurrentTime:self.playCurrentTime];
            }
            
        } else if (EvtID == PLAY_EVT_PLAY_END) {
            [self.controlView setProgressTime:[self playDuration] totalTime:[self playDuration] progressValue:player.duration / duration playableValue:player.duration / duration];
            [self moviePlayDidEnd];
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_ERR_FILE_NOT_FOUND
                   || EvtID == PLAY_ERR_HLS_KEY || EvtID == VOD_PLAY_ERR_DEMUXER_FAIL ||
                   EvtID == PLAY_ERR_GET_PLAYINFO_FAIL) {
            self.playDidEnd = YES;
            [self.controlView setPlayState:NO];
            [self detailPlayerEvent:player event:EvtID param:param];
            
        } else if (EvtID == PLAY_EVT_PLAY_LOADING) {
            // 当缓冲是空的时候
            if (self->_playerModel.action != PLAY_ACTION_PRELOAD) {
                self.state = StateBuffering;
            }
        } else if (EvtID == PLAY_EVT_VOD_LOADING_END) {
            if (self.state == StateBuffering) {
                self.state = StatePlaying;
            }
            [self.spinner stopAnimating];
        } else if (EvtID == PLAY_EVT_CHANGE_RESOLUTION) {
            if (player.height != 0) {
                self.videoRatio = (GLfloat)player.width / player.height;
            }
        } else if (EvtID == PLAY_EVT_GET_PLAYINFO_SUCC) {
            self.keyFrameDescList = [self getKeyFrameDescList:
            [param objectForKey:VOD_PLAY_EVENT_KEY_FRAME_CONTENT_LIST]
            timeList:[param objectForKey:VOD_PLAY_EVENT_KEY_FRAME_TIME_LIST]];
            self.controlView.pointArray = self.keyFrameDescList;
            self->_currentVideoUrl = [param objectForKey:VOD_PLAY_EVENT_PLAY_URL];
            NSString *imageSpriteVtt = [param objectForKey:VOD_PLAY_EVENT_IMAGESPRIT_WEBVTTURL]?:@"";
            NSArray<NSString *> *imageSpriteList = [param objectForKey:VOD_PLAY_EVENT_IMAGESPRIT_IMAGEURL_LIST];
            NSArray<NSURL *> *imageURLs = [self convertImageSpriteList:imageSpriteList];
            [self.imageSprite setVTTUrl:[NSURL URLWithString:imageSpriteVtt] imageUrls:imageURLs];
            ///幽灵水印
            NSString *ghostWaterText = [param objectForKey:@"EVT_KEY_WATER_MARK_TEXT"];
            if (ghostWaterText && ghostWaterText.length > 0) {
                DynamicWaterModel *model = [[DynamicWaterModel alloc] init];
                model.showType = ghost;
                model.duration = self.playerModel.duration;
                model.dynamicWatermarkTip = ghostWaterText;
                model.textFont = 30;
                model.textColor = [UIColor redColor];
                if (![self.subviews containsObject:self.watermarkView]) {
                    [self addSubview:self.watermarkView];
                    [self.watermarkView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(self);
                    }];
                }
                [self.watermarkView setDynamicWaterModel:model];
            }
        }
        
        [self onVodPlayEvent:player event:EvtID withParam:param];
    });
}

- (void)onVodPlayEvent:(TXVodPlayer *)player event:(int)evtID withParam:(NSDictionary *)param
{
    if ([self.playListener respondsToSelector:@selector(onVodPlayEvent:event:withParam:)]) {
        [self.playListener onVodPlayEvent:player event:evtID withParam:param];
    }
}

-(void) onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary*)param
{
    NSDictionary *dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.playListener respondsToSelector:@selector(onVodNetStatus:withParam:)]) {
            [self.playListener onVodNetStatus:player withParam:dict];
        }
    });
}

// 更新当前播放的视频信息，包括清晰度、码率等
- (void)updateBitrates:(NSArray<TXBitrateItem *> *)bitrates;
{
    // 播放离线视频，不更新清晰度，离线视频只有一个清晰度
    if ([_currentVideoUrl containsString:@"/var/mobile/Containers/Data/Application/"]) {
        return;
    }
    
    if (bitrates.count > 0) {
        if (self.resolutions) {
            if (_playerModel.multiVideoURLs == nil) {
                NSMutableArray *urlDefs = [[NSMutableArray alloc] initWithCapacity:self.resolutions.count];
                for (SPSubStreamInfo *info in self.resolutions) {
                    SuperPlayerUrl *url = [[SuperPlayerUrl alloc] init];
                    url.title           = info.resolutionName;
                    [urlDefs addObject:url];
                }
                _playerModel.playingDefinition = _playerModel.multiVideoURLs.firstObject.title;
            }
        } else {
            NSArray *titles             = [TXBitrateItemHelper sortWithBitrate:bitrates];
            _playerModel.multiVideoURLs = titles;
            self.netWatcher.playerModel = _playerModel;
            NSInteger index = self.vodPlayer.bitrateIndex;
            if (_playerModel.playDefinitions.count > 0) {
                if (_playerModel.playDefinitions.count > index) {
                    _playerModel.playingDefinition = _playerModel.playDefinitions[index < 0 ? 0 : index];
                } else {
                    _playerModel.playingDefinition = _playerModel.playDefinitions.lastObject;
                }
            }
        }
        [self resetControlViewWithLive:self.isLive shiftPlayback:self.isShiftPlayback isPlaying:self.state == StatePlaying ? YES : NO];
        if (_isFullScreen) {
            [self.controlView setOrientationLandscapeConstraint];
        }
    }
}

#pragma mark - 直播回调

- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
    NSDictionary *dict = param;

    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID != PLAY_EVT_PLAY_PROGRESS) {
            NSString *desc = [param description];
            NSLog(@"%@", [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding]);
        }
        
        if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
            self.state = StateFirstFrame;
        }

        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            if (!self.isLoaded) {
                self.isLoaded = YES;
                self.state = StatePlaying;
                [self.controlView setPlayState:YES];
                if ([self.delegate respondsToSelector:@selector(superPlayerDidStart:)]) {
                    [self.delegate superPlayerDidStart:self];
                }
            }

            if (self.state == StateBuffering) self.state = StatePlaying;
            [self.netWatcher loadingEndEvent];
        } else if (EvtID == PLAY_EVT_PLAY_END) {
            [self moviePlayDidEnd];
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT) {
            if (self.isShiftPlayback) {
                [self controlViewReload:self.controlView];
                [self showMiddleBtnMsg:kStrTimeShiftFailed withAction:ActionRetry];
                [self.middleBlackBtn fadeOut:2];
            } else {
                [self showMiddleBtnMsg:kStrBadNetRetry withAction:ActionRetry];
                self.state = StateFailed;
            }
            if ([self.delegate respondsToSelector:@selector(superPlayerError:errCode:errMessage:)]) {
                [self.delegate superPlayerError:self errCode:EvtID errMessage:param[EVT_MSG]];
            }
        } else if (EvtID == PLAY_EVT_PLAY_LOADING) {
            // 当缓冲是空的时候
            self.state = StateBuffering;
            if (!self.isShiftPlayback) {
                [self.netWatcher loadingEvent];
            }
        } else if (EvtID == PLAY_EVT_STREAM_SWITCH_SUCC) {
            [self showMiddleBtnMsg:[@"已切换为" stringByAppendingString:self.playerModel.playingDefinition] withAction:ActionNone];
            [self.middleBlackBtn fadeOut:1];
        } else if (EvtID == PLAY_ERR_STREAM_SWITCH_FAIL) {
            [self showMiddleBtnMsg:kStrHDSwitchFailed withAction:ActionRetry];
            self.state = StateFailed;
        } else if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            if (self.state == StateStopped) return;
            NSInteger progress       = [dict[EVT_PLAY_PROGRESS] intValue];
            self.liveProgressTime    = progress;
            self.maxLiveProgressTime = MAX(self.maxLiveProgressTime, self.liveProgressTime);

            if (self.isShiftPlayback) {
                CGFloat sv = 0;
                if (self.maxLiveProgressTime > MAX_SHIFT_TIME) {
                    CGFloat base = self.maxLiveProgressTime - MAX_SHIFT_TIME;
                    sv           = (self.liveProgressTime - base) / MAX_SHIFT_TIME;
                } else {
                    sv = self.liveProgressTime / (self.maxLiveProgressTime + 1);
                }
                [self.controlView setProgressTime:self.liveProgressTime totalTime:-1 progressValue:sv playableValue:0];
            } else {
                [self.controlView setProgressTime:self.maxLiveProgressTime totalTime:-1 progressValue:1 playableValue:0];
            }
        }
        
        if ([self.playListener respondsToSelector:@selector(onLivePlayEvent:event:withParam:)]) {
            [self.playListener onLivePlayEvent:self.livePlayer event:EvtID withParam:dict];
        }
    });
}

- (void)onNetStatus:(NSDictionary *)param
{
    NSDictionary *dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.playListener respondsToSelector:@selector(onLiveNetStatus:withParam:)]) {
            [self.playListener onLiveNetStatus:self.livePlayer withParam:dict];
        }
    });
}

// 日志回调
- (void)onLog:(NSString *)log LogLevel:(int)level WhichModule:(NSString *)module {
    NSLog(@"%@:%@", module, log);
}

- (int)livePlayerType {
    int              playType   = -1;
    NSString *       videoURL   = self.playerModel.videoURL;
    NSURLComponents *components = [NSURLComponents componentsWithString:videoURL];
    NSString *       scheme     = [[components scheme] lowercaseString];
    if ([scheme isEqualToString:@"rtmp"] || [scheme isEqualToString:@"webrtc"]) {
        playType = PLAY_TYPE_LIVE_RTMP;
    } else if ([scheme hasPrefix:@"http"] && [[components path].lowercaseString hasSuffix:@".flv"]) {
        playType = PLAY_TYPE_LIVE_FLV;
    }
    return playType;
}

- (void)reportPlay {
    if (self.reportTime == nil) return;
    int usedtime = -[self.reportTime timeIntervalSinceNow];
    if (self.isLive) {
        [DataReport report:@"superlive" param:@{@"usedtime" : @(usedtime)}];
    } else {
        [DataReport report:@"supervod" param:@{@"usedtime" : @(usedtime), @"fileid" : @(self.playerModel.videoId.fileId ? 1 : 0)}];
    }
    if (self.imageSprite) {
        [DataReport report:@"image_sprite" param:nil];
    }
    self.reportTime = nil;
}

#pragma mark - 画中画回调
/**
 * 画中画状态回调
 */
- (void)onPlayer:(TXVodPlayer *)player pictureInPictureStateDidChange:(TX_VOD_PLAYER_PIP_STATE)pipState withParam:(NSDictionary *)param {
    if (pipState == TX_VOD_PLAYER_PIP_STATE_DID_START) {
        _hasStartPip = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            // 需要关掉菊花
            [self.pipLoadingView stopAnimating];
            self->_hasStartPipLoading = NO;
            
            self->_controlView.hidden = YES;
            
            [SuperPlayerPIPShared show:self.viewController];
        });
    }
    
    if (pipState == TX_VOD_PLAYER_PIP_STATE_RESTORE_UI) {
        [SuperPlayerPIPShared back];
        _restoreUI = YES;
        [player exitPictureInPicture];
    }
    
    if (pipState == TX_VOD_PLAYER_PIP_STATE_DID_STOP) {
        _hasStartPip = NO;
        if (!_playDidEnd && !isShowVipWatchView && _restoreUI) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [player resume];
                self->_restoreUI = NO;
            });
        } else {
            if (!self.didEnterBackground) {
                if (_playDidEnd || isShowVipWatchView) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self pause];
                        [player stopPlay];
                        [player removeVideoWidget];
                        [self.vodPlayer stopPlay];
                        [self.vodPlayer removeVideoWidget];
                        self.vodPlayer = nil;
                        self.state = StateStopped;
                        [self.spinner stopAnimating];
                    });
                } else {
                    [player exitPictureInPicture];
                }
            }
        }
        [SuperPlayerPIPShared close];
    }
}

/**
 * 画中画状态回调
 */
- (void)onPlayer:(TXVodPlayer *)player pictureInPictureErrorDidOccur:(TX_VOD_PLAYER_PIP_ERROR_TYPE)errorType withParam:(NSDictionary *)param {
    if (errorType == TX_VOD_PLAYER_PIP_ERROR_TYPE_DEVICE_NOT_SUPPORT
        || errorType == TX_VOD_PLAYER_PIP_ERROR_TYPE_PLAYER_NOT_SUPPORT
        || errorType == TX_VOD_PLAYER_PIP_ERROR_TYPE_VIDEO_NOT_SUPPORT
        || errorType == TX_VOD_PLAYER_PIP_ERROR_TYPE_PIP_IS_NOT_POSSIBLE
        || errorType == TX_VOD_PLAYER_PIP_ERROR_TYPE_ERROR_FROM_SYSTEM
        || errorType == TX_VOD_PLAYER_PIP_ERROR_TYPE_PIP_NOT_RUNNING
        || errorType == TX_VOD_PLAYER_PIP_ERROR_TYPE_SEAMLESS_PIP_ERROR) {
        _hasStartPip = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pause]; ///画中画开启失败后手动暂停
            if (self->_hasStartPipLoading) {
                [self.pipLoadingView stopAnimating];
            }
            
            [self setPipLoadingWithText:PIP_ERROR_LOADING_TEXT];
            [self.pipLoadingView startAnimating];
            self->_hasStartPipLoading = YES;
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [self.pipLoadingView stopAnimating];
                self->_hasStartPipLoading = NO;
            });
            
            self->_controlView.hidden = NO;
        });
    }
}

#pragma mark - middle btn

- (UIButton *)middleBlackBtn {
    
    if (_middleBlackBtn == nil) {
        _middleBlackBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_middleBlackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _middleBlackBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _middleBlackBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
        [_middleBlackBtn addTarget:self action:@selector(middleBlackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_middleBlackBtn];
        [_middleBlackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(33);
        }];
    }
    return _middleBlackBtn;
}

- (void)showMiddleBtnMsg:(NSString *)msg withAction:(ButtonAction)action {
    [self.middleBlackBtn setTitle:msg forState:UIControlStateNormal];
    self.middleBlackBtn.titleLabel.text = msg;
    self.middleBlackBtnAction           = action;
    CGFloat width                       = self.middleBlackBtn.titleLabel.attributedText.size.width;

    [self.middleBlackBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width + 10));
    }];
    [self.middleBlackBtn fadeShow];
}

- (void)middleBlackBtnClick:(UIButton *)btn {
    switch (self.middleBlackBtnAction) {
        case ActionNone:
            break;
        case ActionContinueReplay: {
            if (!self.isLive) {
                self.startTime = self.playCurrentTime;
            }
            [self configTXPlayer];
        } break;
        case ActionRetry:
            [self reloadModel];
            break;
        case ActionSwitch:
            [self controlViewSwitch:self.controlView withDefinition:self.netWatcher.adviseDefinition];
            [self resetControlViewWithLive:self.isLive shiftPlayback:self.isShiftPlayback isPlaying:YES];
            break;
        case ActionIgnore:
            return;
        default:
            break;
    }
    [btn fadeOut:0.2];
}

- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:SuperPlayerImage(@"repeat_video") forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _repeatBtn.hidden = YES;
        [self addSubview:_repeatBtn];
        [_repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }
    return _repeatBtn;
}

- (void)setUIView{
    
    [self addSubview:self.playforwardView];
    [self addSubview:self.playforwardImageView];
    [self addSubview:self.playforwardLabel];
    [self addSubview:self.playbackwardView];
    [self addSubview:self.playbackwardImageView];
    [self addSubview:self.playbackwardLabel];
    
    
    [_playforwardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(180);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.trailing.equalTo(self.mas_trailing);
    }];
    [_playforwardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_playforwardView.mas_leading).offset(70);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(40);
    }];
    [_playforwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playforwardImageView.mas_bottom).offset(5);
        make.centerX.equalTo(_playforwardImageView.mas_centerX);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(40);
    }];
    [_playbackwardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(180);
    }];
    [_playbackwardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(70);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(40);
    }];
    [_playbackwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_playbackwardImageView.mas_bottom).offset(5);
        make.centerX.equalTo(_playbackwardImageView.mas_centerX);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(40);
    }];
}

- (UIImageView *)playforwardImageView{
    if (!_playforwardImageView) {
        UIImage *image = SuperPlayerImage(@"playforward");
        _playforwardImageView = [[UIImageView alloc] init];
        [_playforwardImageView setImage:image];
        _playforwardImageView.hidden = YES;
    }
    return _playforwardImageView;
}

- (UILabel *)playforwardLabel{
    if (!_playforwardLabel) {
        _playforwardLabel = [[UILabel alloc] init];
        _playforwardLabel.font = [UIFont systemFontOfSize:16];
        _playforwardLabel.textColor = [UIColor whiteColor];
        _playforwardLabel.textAlignment = NSTextAlignmentCenter;
        _playforwardLabel.text = superPlayerLocalized(@"SuperPlayer.fastForward");
        _playforwardLabel.hidden = YES;
    }
    return _playforwardLabel;
}
- (UIImageView *)playforwardView{
    if (!_playforwardView) {
        UIImage *image = SuperPlayerImage(@"playforward_bg");
        _playforwardView = [[UIImageView alloc] init];
        [_playforwardView setImage:image];
        _playforwardView.hidden = YES;
    }
    return _playforwardView;
}
- (UIImageView *)playbackwardImageView{
    if (!_playbackwardImageView) {
        UIImage *image = SuperPlayerImage(@"playbackward");
        _playbackwardImageView = [[UIImageView alloc] init];
        [_playbackwardImageView setImage:image];
        _playbackwardImageView.hidden = YES;
    }
    return _playbackwardImageView;
}
- (UILabel *)playbackwardLabel{
    if (!_playbackwardLabel) {
        _playbackwardLabel = [[UILabel alloc] init];
        _playbackwardLabel.font = [UIFont systemFontOfSize:16];
        _playbackwardLabel.textColor = [UIColor whiteColor];
        _playbackwardLabel.textAlignment = NSTextAlignmentCenter;
        _playbackwardLabel.text = superPlayerLocalized(@"SuperPlayer.rewind");
        _playbackwardLabel.hidden = YES;
    }
    return _playbackwardLabel;
}
- (UIImageView *)playbackwardView{
    if (!_playbackwardView) {
        UIImage *image = SuperPlayerImage(@"playbackward_bg");
        _playbackwardView = [[UIImageView alloc] init];
        [_playbackwardView setImage:image];
        _playbackwardView.hidden = YES;
    }
    return _playbackwardView;
}

- (UIButton *)repeatBackBtn {
    if (!_repeatBackBtn) {
        _repeatBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBackBtn setImage:SuperPlayerImage(@"back_full") forState:UIControlStateNormal];
        [_repeatBackBtn addTarget:self action:@selector(controlViewBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_repeatBackBtn];
        [_repeatBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(15);
            make.width.mas_equalTo(@30);
        }];
    }
    return _repeatBackBtn;
}

- (void)repeatBtnClick:(UIButton *)sender {
    [self.vodPlayer stopPlay];
    [self setVodPlayConfig];
    [self restart];
}

- (MMMaterialDesignSpinner *)spinner {
    if (!_spinner) {
        _spinner                  = [[MMMaterialDesignSpinner alloc] init];
        _spinner.lineWidth        = 1;
        _spinner.duration         = 1;
        _spinner.hidden           = YES;
        _spinner.hidesWhenStopped = YES;
        _spinner.tintColor        = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
        [self addSubview:_spinner];
        [_spinner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.with.height.mas_equalTo(45);
        }];
    }
    return _spinner;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView                        = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode            = UIViewContentModeScaleAspectFill;
        [self insertSubview:_coverImageView belowSubview:self.controlView];
        [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _coverImageView;
}

- (TXVipTipView *)vipTipView {
    if (!_vipTipView) {
        _vipTipView = [TXVipTipView new];
        _vipTipView.delegate = self;
    }
    return _vipTipView;
}

- (TXVipWatchView *)vipWatchView {
    if (!_vipWatchView) {
        _vipWatchView = [TXVipWatchView new];
        _vipWatchView.delegate = self;
    }
    return _vipWatchView;
}

- (UIButton *)centerPlayBtn {
    if (!_centerPlayBtn) {
        _centerPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerPlayBtn.hidden = YES;
        [_centerPlayBtn setImage:SuperPlayerImage(@"play") forState:UIControlStateNormal];
        [_centerPlayBtn addTarget:self action:@selector(centerPlayBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_centerPlayBtn];
        [_centerPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(120);
        }];
    }
    return _centerPlayBtn;
}

- (TXVodPlayer *)vodPlayer {
    if (!_vodPlayer) {
        _vodPlayer = [[TXVodPlayer alloc] init];
        _vodPlayer.vodDelegate = self;
    }
    return _vodPlayer;
}


- (void)setPipLoadingWithText:(NSString *)text {
    CGFloat width=[(NSString *)text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 21)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:
                                                               [UIFont systemFontOfSize:DEFAULT_PIP_LOADING_FONT_SIZE]}
                                                 context:nil].size.width;
    CGFloat x = (ScreenWidth - (width + DEFAULT_PIP_LOADING_WIDTH_MARGIN)) / 2;
    CGFloat y = (ScreenHeight/2) - DEFAULT_PIP_LOADING_HEIGHT;
    CGFloat w = width + DEFAULT_PIP_LOADING_WIDTH_MARGIN;
    CGFloat h = DEFAULT_PIP_LOADING_HEIGHT * 2;
    _pipLoadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x,y,w,h)];
    _pipLoadingView.backgroundColor = [UIColor blackColor];
    _pipLoadingView.layer.cornerRadius = 10;
    _pipLoadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               DEFAULT_PIP_LOADING_LABEL_MARGIN,
                                                               DEFAULT_PIP_LOADING_LABEL_MARGIN + DEFAULT_PIP_LOADING_HEIGHT,
                                                               width,
                                                               DEFAULT_PIP_LOADING_LABEL_HEIGHT)];
    label.text = text;
    label.font = [UIFont systemFontOfSize:DEFAULT_PIP_LOADING_FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    [_pipLoadingView addSubview:label];
    [self.fatherView.viewController.view addSubview:_pipLoadingView];
}


- (UIView *)fullScreenBlackView {
    if (!_fullScreenBlackView) {
        _fullScreenBlackView = [[UIView alloc] init];
        _fullScreenBlackView.backgroundColor = [UIColor blackColor];
    }
    return  _fullScreenBlackView;
}

- (NetWatcher *)netWatcher {
    if (!_netWatcher) {
        _netWatcher = [[NetWatcher alloc] init];
    }
    return _netWatcher;
}

- (MPVolumeView *)volumeView {
    if(!_volumeView) {
        CGRect frame    = CGRectMake(0, -100, 10, 0);
        _volumeView = [[MPVolumeView alloc] initWithFrame:frame];
        [_volumeView sizeToFit];
    }
    return  _volumeView;
}

-(DynamicWatermarkView *)watermarkView{
    if (!_watermarkView) {
        _watermarkView = [[DynamicWatermarkView alloc] init];
    }
    return _watermarkView;
}
@end
