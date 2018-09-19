#import "SuperPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "SuperPlayer.h"
#import "CFDanmakuView.h"
#import "SuperPlayerControlViewDelegate.h"
#import "J2Obj.h"
#import "SuperPlayerView+Private.h"
#import "DataReport.h"
#import "TXCUrl.h"

static UISlider * _volumeSlider;

@interface TXBitrateItemHelper : NSObject
@property NSInteger bitrate;
@property NSString *title;
@property int index;
@end

@implementation TXBitrateItemHelper

+ (NSArray<SuperPlayerUrl *> *)sortWithBitrate:(NSArray<TXBitrateItem *> *)bitrates defaultIndex:(int *)defaultIndex; {
    NSMutableArray *origin = [NSMutableArray new];
    NSArray *titles = @[@"流畅",@"高清",@"超清",@"原画",@"2K",@"4K"];
    NSMutableArray *retArray = [[NSMutableArray alloc] initWithCapacity:bitrates.count];
    
    for (int i = 0; i < bitrates.count; i++) {
        TXBitrateItemHelper *h = [TXBitrateItemHelper new];
        h.bitrate = bitrates[i].bitrate;
        h.index = i;
        [origin addObject:h];
        [retArray addObject:[NSNull null]];
    }
    
    NSArray *sorted = [origin sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"bitrate" ascending:YES]]];
    
    *defaultIndex = -1;
    [sorted enumerateObjectsUsingBlock:^(TXBitrateItemHelper *h, NSUInteger idx, BOOL *stop) {
        SuperPlayerUrl *sub = [SuperPlayerUrl new];
        sub.title = titles[idx];
        retArray[h.index] = sub;
        *defaultIndex = h.index;
     }];
    return retArray;
}

@end


#define CellPlayerFatherViewTag  200

//忽略编译器的警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"




@implementation SuperPlayerView {
    UIView *_fullScreenBlackView;
}


#pragma mark - life Cycle

/**
 *  代码初始化调用此方法
 */
- (instancetype)init {
    self = [super init];
    if (self) { [self initializeThePlayer]; }
    return self;
}

/**
 *  storyboard、xib加载playerView会调用此方法
 */
- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeThePlayer];
}

/**
 *  初始化player
 */
- (void)initializeThePlayer {
    
    [self setupDanmakuView];
    [self setupDanmakuData];
    self.netWatcher = [[NetWatcher alloc] init];
    
    CGRect frame = CGRectMake(0, -100, 10, 0);
    self.volumeView = [[MPVolumeView alloc] initWithFrame:frame];
    [self.volumeView sizeToFit];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self.volumeView];
    
    _fullScreenBlackView = [UIView new];
    _fullScreenBlackView.backgroundColor = [UIColor blackColor];
    
    // 单例slider
    _volumeSlider = nil;
    for (UIView *view in [self.volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeSlider = (UISlider *)view;
            break;
        }
    }
}

- (void)dealloc {
    [self.controlView playerCancelAutoFadeOutControlView];
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [self reportPlay];
    [self.netWatcher stopWatch];
    [self.volumeView removeFromSuperview];
}

#pragma mark -

- (void)setupDanmakuView
{
    _danmakuView = [[CFDanmakuView alloc] initWithFrame:CGRectZero];
    _danmakuView.duration = 6.5;
    _danmakuView.centerDuration = 2.5;
    _danmakuView.lineHeight = 25;
    _danmakuView.maxShowLineCount = 15;
    _danmakuView.maxCenterLineCount = 5;
    
    _danmakuView.delegate = self;
    [self addSubview:_danmakuView];
    
    [_danmakuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
}
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]
#define font [UIFont systemFontOfSize:15]

- (void)setupDanmakuData
{
    NSString *danmakufile = [[NSBundle mainBundle] pathForResource:@"danmakufile" ofType:nil];
    NSArray *danmakusDicts = [NSArray arrayWithContentsOfFile:danmakufile];
    
    NSMutableArray* danmakus = [NSMutableArray array];
    for (NSDictionary* dict in danmakusDicts) {
        CFDanmaku* danmaku = [[CFDanmaku alloc] init];
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:dict[@"m"] attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : kRandomColor}];
        
        NSString* emotionName = [NSString stringWithFormat:@"smile_%u", arc4random_uniform(90)];
        UIImage* emotion = [UIImage imageNamed:emotionName];
        NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
        attachment.image = emotion;
        attachment.bounds = CGRectMake(0, -font.lineHeight*0.3, font.lineHeight*1.5, font.lineHeight*1.5);
        NSAttributedString* emotionAttr = [NSAttributedString attributedStringWithAttachment:attachment];
        
        [contentStr appendAttributedString:emotionAttr];
        danmaku.contentStr = contentStr;
        
        NSString* attributesStr = dict[@"p"];
        NSArray* attarsArray = [attributesStr componentsSeparatedByString:@","];
        danmaku.timePoint = [[attarsArray firstObject] doubleValue] / 1000;
        danmaku.position = [attarsArray[1] integerValue];
        //        if (danmaku.position != 0) {
        
        [danmakus addObject:danmaku];
        //        }
    }
    
    [_danmakuView prepareDanmakus:danmakus];
}

- (NSTimeInterval)danmakuViewGetPlayTime:(CFDanmakuView *)danmakuView
{
    return -[self.danmakuStartTime timeIntervalSinceNow];
}

- (BOOL)danmakuViewIsBuffering:(CFDanmakuView *)danmakuView
{
    return self.state != StatePlaying;
}




#pragma mark - 观察者、通知

/**
 *  添加观察者、通知
 */
- (void)addNotifications {
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStatusBarOrientationChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

#pragma mark - layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    UIView *innerView = self.subviews[0];
    if ([innerView isKindOfClass:NSClassFromString(@"TXIJKSDLGLView")] ||
        [innerView isKindOfClass:NSClassFromString(@"TXCAVPlayerView")]) {
        innerView.frame = self.bounds;
    }
}

#pragma mark - Public Method

- (void)playWithModel:(SuperPlayerModel *)playerModel {
    self.imageSprite = nil;
    self.keyFrameDescList = nil;
    [self reportPlay];
    self.reportTime = [NSDate date];
    [self _removeOldPlayer];
    [self _playWithModel:playerModel];
}

- (void)_playWithModel:(SuperPlayerModel *)playerModel {
    _playerModel = playerModel;
    _videoIndex  = 0;
    
    if (self.controlView == nil) {
        self.controlView = [SuperPlayerControlView new];
    } else {
        [self.controlView playerResetControlView];
    }
    [self.controlView playerTitle:playerModel.title];
    [self pause];
    // 设置网络占位图片
    if (playerModel.placeholderImageURLString) {
        [self.controlView playerBackgroundImageUrl:[NSURL URLWithString:playerModel.placeholderImageURLString] placeholderImage:playerModel.placeholderImage];
    } else {
        [self.controlView playerBackgroundImage:playerModel.placeholderImage];
    }
    
    self.videoURL = playerModel.videoURL;
    if (self.videoURL == nil && playerModel.multiVideoURLs.count >= 1) {
        self.videoURL = playerModel.multiVideoURLs[0].url;
    }
    if (self.videoURL != nil) {
        [self configTXPlayer];
    } else if (playerModel.appId != 0 && playerModel.fileId != nil) {
        self.isLive = NO;
        [self getPlayInfo:playerModel.appId withFileId:playerModel.fileId];
    } else {
        NSLog(@"无播放地址");
    }
}

/**
 *  player添加到fatherView上
 */
- (void)addPlayerToFatherView:(UIView *)view {
    // 这里应该添加判断，因为view有可能为空，当view为空时[view addSubview:self]会crash
    if (view) {
        [self removeFromSuperview];
        [view addSubview:self];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(UIEdgeInsetsZero);
        }];
    }
}

- (void)setFatherView:(UIView *)fatherView {
    if (fatherView != _fatherView) {
        [self addPlayerToFatherView:fatherView];
    }
    _fatherView = fatherView;
}

/**
 *  重置player
 */
- (void)resetPlayer {
    // 改为为播放完
    self.playDidEnd         = NO;
    self.didEnterBackground = NO;
    // 视频跳转秒数置0
    self.seekTime           = 0;
    

    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 暂停
    [self pause];
    
    [self.vodPlayer stopPlay];
    [self.vodPlayer removeVideoWidget];
    
    [self.livePlayer stopPlay];
    [self.livePlayer removeVideoWidget];
    
    [self.controlView playerResolutionArray:nil defaultIndex:0];
    [self reportPlay];
}

/**
 *  播放
 */
- (void)resume {
    [self.controlView playerPlayBtnState:YES];
    self.isPauseByUser = NO;
    if (self.isLive) {
        [_livePlayer resume];
    } else {
        [_vodPlayer resume];
    }
}

/**
 * 暂停
 */
- (void)pause {
    [self.controlView playerPlayBtnState:NO];
    self.isPauseByUser = YES;
    if (self.isLive) {
        [_livePlayer pause];
    } else {
        [_vodPlayer pause];
    }
}

- (TXVodPlayer *)vodPlayer
{
    if (_vodPlayer == nil) {
        _vodPlayer = [[TXVodPlayer alloc] init];
        TXVodPlayConfig *config = [[TXVodPlayConfig alloc] init];
        config.maxCacheItems = 5;
        config.cacheFolderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/TXCache"];
        config.progressInterval = 0.02;
//        config.playerType = PLAYER_AVPLAYER;
        [_vodPlayer setConfig:config];
    }
    _vodPlayer.vodDelegate = self;
    _vodPlayer.enableHWAcceleration = SuperPlayerGlobleConfigShared.enableHWAcceleration;
    [_vodPlayer setRenderMode:SuperPlayerGlobleConfigShared.renderMode];
    return _vodPlayer;
}

- (TXLivePlayer *)livePlayer
{
    if (_livePlayer == nil) {
        _livePlayer = [[TXLivePlayer alloc] init];
        TXLivePlayConfig *config = [[TXLivePlayConfig alloc] init];
        config.bAutoAdjustCacheTime = NO;
        config.maxAutoAdjustCacheTime = 5.0f;
        config.minAutoAdjustCacheTime = 5.0f;
        [_livePlayer setConfig:config];
        _livePlayer.delegate = self;
    }
    _livePlayer.enableHWAcceleration = SuperPlayerGlobleConfigShared.enableHWAcceleration;
    [_livePlayer setRenderMode:SuperPlayerGlobleConfigShared.renderMode];
    return _livePlayer;
}

#pragma mark - Private Method
/**
 *  设置Player相关参数
 */
- (void)configTXPlayer {
    self.backgroundColor = [UIColor blackColor];
    
    [self.vodPlayer stopPlay];
    [self.vodPlayer removeVideoWidget];
    [self.livePlayer stopPlay];
    [self.livePlayer removeVideoWidget];
    
    self.liveProgressTime = self.maxLiveProgressTime = 0;
    
    int liveType = [self livePlayerType];
    if (liveType >= 0) {
        self.isLive = YES;
    } else {
        self.isLive = NO;
    }
    self.isLoaded = NO;
    
    if (self.isLive) {
        [self.livePlayer startPlay:_videoURL type:liveType];
        self.controlView.liveUrl = _videoURL;
        // 时移
        [TXLiveBase setAppID:[NSString stringWithFormat:@"%ld", _playerModel.appId]];
        TXCUrl *curl = [[TXCUrl alloc] initWithString:_videoURL];
        [self.livePlayer prepareLiveSeek];
    } else {
        [self.vodPlayer startPlay:_videoURL];
        [self.vodPlayer setBitrateIndex:_videoIndex];
        
        self.controlView.liveUrl = nil;
        
        [self.vodPlayer setRate:SuperPlayerGlobleConfigShared.playRate];
        [self.vodPlayer setMirror:SuperPlayerGlobleConfigShared.mirror];
    }
    
    self.state = StateBuffering;
    self.isPauseByUser = NO;
    
    if (self.playerModel.multiVideoURLs.count > 0) {
        for (int i = 0; i < self.playerModel.multiVideoURLs.count; i++) {
            if ([self.playerModel.multiVideoURLs[i].url isEqualToString:_videoURL]) {
                _videoIndex = i;
                break;
            }
        }
        
        [self.controlView playerResolutionArray:self.playerModel.multiVideoURLs defaultIndex:_videoIndex];
        
        // 多码率启用网络监听
        [self.netWatcher startWatch];
        __weak SuperPlayerView *weakSelf = self;
        [self.netWatcher setNotifyBlock:^(NSString *msg) {
            SuperPlayerView *strongSelf = weakSelf;
            if (strongSelf) {
                if (strongSelf.videoIndex < self.playerModel.multiVideoURLs.count) {
                    [strongSelf.controlView playerBadNet:msg];
                }
            }
        }];
    } else {
        [self.controlView playerResolutionArray:nil defaultIndex:0];
    }
    [self.controlView playerControlViewLive:self.isLive];
}

/**
 *  创建手势
 */
- (void)createGesture {
    // 单击
    self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    self.singleTap.delegate                = self;
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired    = 1;
    [self addGestureRecognizer:self.singleTap];
    
    // 双击(播放/暂停)
    self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    self.doubleTap.delegate                = self;
    self.doubleTap.numberOfTouchesRequired = 1; //手指数
    self.doubleTap.numberOfTapsRequired    = 2;
    [self addGestureRecognizer:self.doubleTap];

    // 解决点击当前view时候响应其他控件事件
    [self.singleTap setDelaysTouchesBegan:YES];
    [self.doubleTap setDelaysTouchesBegan:YES];
    // 双击失败响应单击事件
    [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    
    // 加载完成后，再添加平移手势
    // 添加平移手势，用来控制音量、亮度、快进快退
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    panRecognizer.delegate = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelaysTouchesBegan:YES];
    [panRecognizer setDelaysTouchesEnded:YES];
    [panRecognizer setCancelsTouchesInView:YES];
    [self addGestureRecognizer:panRecognizer];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}

#pragma mark - KVO

/**
 *  设置横屏的约束
 */
- (void)setOrientationLandscapeConstraint:(UIInterfaceOrientation)orientation {
    [self toOrientation:orientation];
    self.isFullScreen = YES;
}

/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {

    [self addPlayerToFatherView:self.fatherView];
    
    [self toOrientation:UIInterfaceOrientationPortrait];
    self.isFullScreen = NO;
}

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) { return; }
    
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {//
        // 这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self removeFromSuperview];
            if (IsIPhoneX) {
                [[UIApplication sharedApplication].keyWindow addSubview:_fullScreenBlackView];
                [_fullScreenBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(ScreenHeight));
                    make.height.equalTo(@(ScreenWidth));
                    make.center.equalTo([UIApplication sharedApplication].keyWindow);
                }];
            }
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (IsIPhoneX) {
                    make.width.equalTo(@(ScreenHeight-88));
                } else {
                    make.width.equalTo(@(ScreenHeight));
                }

                make.height.equalTo(@(ScreenWidth));
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        }
    } else {
        [_fullScreenBlackView removeFromSuperview];
    }
    // iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    // 也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    // 获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    // 给你的播放视频的view视图设置旋转
    self.transform = CGAffineTransformIdentity;
    self.transform = [self getTransformRotationAngle];
    
    _fullScreenBlackView.transform = self.transform;
    // 开始旋转
    [UIView commitAnimations];
}

/**
 * 获取变换的旋转角度
 *
 * @return 角度
 */
- (CGAffineTransform)getTransformRotationAngle {
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

#pragma mark 屏幕转屏相关

/**
 *  屏幕转屏
 *
 *  @param orientation 屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
        // 设置横屏
        [self setOrientationLandscapeConstraint:orientation];
    } else if (orientation == UIInterfaceOrientationPortrait) {
        // 设置竖屏
        [self setOrientationPortraitConstraint];
    }
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    if (!self.isLoaded) { return; }
    if (self.isLockScreen) { return; }
    if (self.didEnterBackground) { return; };
    if (SuperPlayerWindowShared.isShowing) { return; }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown ) { return; }
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
        }
            break;
        case UIInterfaceOrientationPortrait:{
            if (self.isFullScreen) {
                [self toOrientation:UIInterfaceOrientationPortrait];
                
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            if (self.isFullScreen == NO) {
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
                self.isFullScreen = YES;
            } else {
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
            
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            if (self.isFullScreen == NO) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
                self.isFullScreen = YES;
            } else {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            }
        }
            break;
        default:
            break;
    }
}

// 状态条变化通知（在前台播放才去处理）
- (void)onStatusBarOrientationChange {
    if (!self.didEnterBackground) {
        // 获取到当前状态条的方向
        UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
            [self setOrientationPortraitConstraint];
        } else {
            if (currentOrientation == UIInterfaceOrientationLandscapeRight) {
                [self toOrientation:UIInterfaceOrientationLandscapeRight];
            } else if (currentOrientation == UIDeviceOrientationLandscapeLeft){
                [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            }
        }
    }
}

/**
 *  解锁屏幕方向锁定
 */
- (void)unLockTheScreen {
    [self.controlView playerLockBtnState:NO];
    self.isLockScreen = NO;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}


#pragma mark - Action

/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        
        if (self.playDidEnd) {
            return;
        }
        if (SuperPlayerWindowShared.isShowing)
            return;
        
        [self.controlView playerShowOrHideControlView];
    }
}

/**
 *  双击播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    if (self.playDidEnd) { return;  }
    // 显示控制层
    [self.controlView playerShowControlView];
    if (self.isPauseByUser) {
        [self resume];
    } else {
        [self pause];
    }
}



/** 全屏 */
- (void)_fullScreenAction {
    if (self.isLockScreen) {
        [self unLockTheScreen];
        return;
    }
    if (self.isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        self.isFullScreen = NO;
        return;
    } else {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight) {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        } else {
            [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
        self.isFullScreen = YES;
    }
}

#pragma mark - NSNotification Action

/**
 *  播放完了
 *
 */
- (void)moviePlayDidEnd {
    self.state = StateStopped;
    self.playDidEnd = YES;
    // 播放结束隐藏
    if (SuperPlayerWindowShared.isShowing) {
        [SuperPlayerWindowShared hide];
        [self resetPlayer];
    }
    [self.controlView playerPlayEnd];
    [self.netWatcher stopWatch];
}

/**
 *  应用退到后台
 */
- (void)appDidEnterBackground {
    NSLog(@"appDidEnterBackground");
    self.didEnterBackground     = YES;
    if (self.state == StatePlaying && !self.isLive) {
        [_vodPlayer pause];
        self.state                  = StatePause;
    }
}

/**
 *  应用进入前台
 */
- (void)appDidEnterPlayground {
    NSLog(@"appDidEnterPlayground");
    self.didEnterBackground     = NO;
    if (!self.isPauseByUser && self.state == StatePause && !self.isLive) {
        self.state         = StatePlaying;
        self.isPauseByUser = NO;
        [self resume];
    }
}

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds {
    if (!self.isLoaded || self.state == StateStopped) {
        [self.controlView playerDraggedEnd];
        return;
    }
    if (self.isLive) {
        [DataReport report:@"timeshift" param:nil];
        int ret = [self.livePlayer seek:dragedSeconds];
        if (ret != 0) {
            [self.controlView playerShowTips:@"时移失败，返回直播" delay:2];
            [self.controlView playerResolutionArray:self.playerModel.multiVideoURLs defaultIndex:_videoIndex];
        } else {
            self.isShiftPlayback = YES;
            self.state = StateBuffering;
            self.isLoaded = NO;
            [self.controlView playerResolutionArray:nil defaultIndex:0];    //时移播放不能切码率
        }
    } else {
        [self.vodPlayer seek:dragedSeconds];
        self.seekTime = 0;
        [self.vodPlayer resume];
    }
    [self.controlView playerDraggedEnd];
}

#pragma mark - UIPanGestureRecognizer手势方法

/**
 *  pan手势事件
 *
 *  @param pan UIPanGestureRecognizer
 */
- (void)panDirection:(UIPanGestureRecognizer *)pan {
    
    if (!self.isLoaded) { return; }
    if (self.isLockScreen) { return; }
    if (self.didEnterBackground) { return; };
    if (SuperPlayerWindowShared.isShowing) { return; }
    
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [pan locationInView:self];
    
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    // 判断是垂直移动还是水平移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            // 使用绝对值来判断移动的方向
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { // 水平移动
                // 取消隐藏
                self.panDirection = PanDirectionHorizontalMoved;
                self.sumTime      = [self getCurrentTime];
            }
            else if (x < y){ // 垂直移动
                self.panDirection = PanDirectionVerticalMoved;
                // 开始滑动的时候,状态改为正在控制音量
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.isVolume = YES;
                }else { // 状态改为显示亮度调节
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 正在移动
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    [self horizontalMoved:veloctyPoint.x]; // 水平移动的方法只要x方向的值
                    break;
                }
                case PanDirectionVerticalMoved:{
                    [self verticalMoved:veloctyPoint.y]; // 垂直移动方法只要y方向的值
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (self.panDirection) {
                case PanDirectionHorizontalMoved:{
                    self.isPauseByUser = NO;
                    [self seekToTime:self.sumTime];
                    // 把sumTime滞空，不然会越加越多
                    self.sumTime = 0;
                    [self.controlView playerDraggedEnd];
                    break;
                }
                case PanDirectionVerticalMoved:{
                    // 垂直移动结束后，把状态改为不再控制音量
                    self.isVolume = NO;
                    [self.controlView playerDraggedEnd];
                    break;
                }
                default:
                    break;
            }
            break;
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
   
    self.isVolume ? ([[self class] volumeViewSlider].value -= value / 10000) : ([UIScreen mainScreen].brightness -= value / 10000);

    if (self.isVolume) {
        [self.controlView playerDraggedVolume:[[self class] volumeViewSlider].value];
    } else {
        [self.controlView playerDraggedLight:[UIScreen mainScreen].brightness];
    }
}

/**
 *  pan水平移动的方法
 *
 *  @param value void
 */
- (void)horizontalMoved:(CGFloat)value {
    // 每次滑动需要叠加时间
    CGFloat totalMovieDuration = [self getTotalTime];
    self.sumTime += value / 10000 * totalMovieDuration;
    
    if (self.sumTime > totalMovieDuration) { self.sumTime = totalMovieDuration;}
    if (self.sumTime < 0) { self.sumTime = 0; }
    
    CGFloat slider = self.sumTime / totalMovieDuration;
    if (self.isLive && totalMovieDuration > MAX_SHIFT_TIME) {
        CGFloat base = totalMovieDuration - MAX_SHIFT_TIME;
        if (self.sumTime < base)
            self.sumTime = base;
        slider = (self.sumTime - base) / MAX_SHIFT_TIME;
        NSLog(@"%f",slider);
    }
    UIImage *thumbnail;
    if (self.isFullScreen) {
        thumbnail = [self.imageSprite getThumbnail:self.sumTime];
    }
    [self.controlView playerDraggedTime:self.sumTime totalTime:totalMovieDuration sliderValue:slider thumbnail:thumbnail];
}

- (void)volumeChanged:(NSNotification *)notification
{
    if (self.isVolume)
        return; // 正在拖动，不响应音量事件
    
    if (![[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"] isEqualToString:@"ExplicitVolumeChange"]) {
        return;
    }
    float volume = [[[notification userInfo]      objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [self.controlView playerDraggedVolume:volume];
    [self.controlView playerDraggedEnd];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (self.playDidEnd){
            return NO;
        }
    }

    if ([touch.view isKindOfClass:[UISlider class]] || [touch.view.superview isKindOfClass:[UISlider class]]) {
        return NO;
    }
    
    if (SuperPlayerWindowShared.isShowing)
        return NO;

    return YES;
}

#pragma mark - Setter 

/**
 *  videoURL的setter方法
 *
 *  @param videoURL videoURL
 */
- (void)setVideoURL:(NSString *)videoURL {
    _videoURL = videoURL;
    
    // 每次加载视频URL都设置重播为NO
    self.repeatToPlay = NO;
    self.playDidEnd   = NO;
    
    // 添加通知
    [self addNotifications];
    
    self.isPauseByUser = YES;
    
    // 添加手势
    [self createGesture];
    
}

/**
 *  设置播放的状态
 *
 *  @param state ZFPlayerState
 */
- (void)setState:(SuperPlayerState)state {
    _state = state;
    // 控制菊花显示、隐藏
    [self.controlView playerIsActivity:state == StateBuffering];
    if (state == StatePlaying || state == StateBuffering) {
        // 隐藏占位图
        [self.controlView playerPlayBtnState:YES];
        [self.controlView playerIsPlaying];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(volumeChanged:)
         name:@"AVSystemController_SystemVolumeDidChangeNotification"
         object:nil];
        
    } else if (state == StateFailed) {
        
    } else if (state == StateStopped) {
        
        [[NSNotificationCenter defaultCenter]
         removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
        
    } else if (state == StatePause) {
        [self.controlView playerPlayBtnState:NO];
    }
}

- (void)setControlView:(SuperPlayerControlView *)controlView {
    if (_controlView) { return; }
    _controlView = controlView;
    controlView.delegate = self;
    [self addSubview:controlView];
    [controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setIsShiftPlayback:(BOOL)isShiftPlayback {
    _isShiftPlayback = isShiftPlayback;
    [self.controlView playerBackLiveBtnHidden:!isShiftPlayback];
}

- (void)setVideoRatio:(CGFloat)videoRatio {
    _videoRatio = videoRatio;
    self.controlView.videoRatio = videoRatio;
}

- (void)showControlView:(BOOL)isShow {
    if (isShow) {
        [self.controlView playerShowControlView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.controlView playerCancelAutoFadeOutControlView];
        });
    } else {
        [self.controlView playerHideControlView];
    }
}

#pragma mark - Getter

- (CGFloat)getTotalTime {
    if (self.isLive) {
        return self.maxLiveProgressTime;
    }
    
    return self.vodPlayer.duration;
}

- (CGFloat)getCurrentTime {
    if (self.isLive) {
        if (self.isShiftPlayback) {
            return self.liveProgressTime;
        }
        return self.maxLiveProgressTime;
    }
    
    return self.vodPlayer.currentPlaybackTime;
}

+ (UISlider *)volumeViewSlider {
    return _volumeSlider;
}
#pragma mark - SuperPlayerControlViewDelegate

- (void)onControlView:(UIView *)controlView playAction:(UIButton *)sender {
    self.isPauseByUser = !self.isPauseByUser;
    if (self.isPauseByUser) {
        [self pause];
        if (self.state == StatePlaying) { self.state = StatePause;}
    } else {
        [self resume];
        if (self.state == StatePause) { self.state = StatePlaying; }
    }
}

- (void)onControlView:(UIView *)controlView backAction:(UIButton *)sender {
    if (self.isLockScreen) {
        [self unLockTheScreen];
    } else {
        if (!self.isFullScreen) {
            if ([self.delegate respondsToSelector:@selector(onPlayerBackAction)]) { [self.delegate onPlayerBackAction]; }
        } else {
            [self interfaceOrientation:UIInterfaceOrientationPortrait];
        }
    }
}

- (void)onControlView:(UIView *)controlView closeAction:(UIButton *)sender {
    [self resetPlayer];
    [self removeFromSuperview];
}

- (void)onControlView:(UIView *)controlView fullScreenAction:(UIButton *)sender {
    [self _fullScreenAction];
}

- (void)onControlView:(UIView *)controlView lockScreenAction:(UIButton *)sender {
    self.isLockScreen = sender.selected;
}

- (void)onControlView:(UIView *)controlView cneterPlayAction:(UIButton *)sender {
    [self configTXPlayer];
}

- (void)onControlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender {
    // 没有播放完
    self.playDidEnd   = NO;
    // 重播改为NO
    self.repeatToPlay = NO;
    
    self.state = StateBuffering;
    // 开始播放
    [self configTXPlayer];
    self.isPauseByUser = NO;
    
    self.state = StateBuffering;
}

/** 加载失败按钮事件 */
- (void)onControlView:(UIView *)controlView failAction:(UIButton *)sender {
     [self configTXPlayer];
}

- (void)onControlView:(UIView *)controlView badNetAction:(UIButton *)sender {
    NSUInteger idx = _videoIndex+1;
    if (idx < self.playerModel.multiVideoURLs.count) {
        [self onControlView:controlView resolutionAction:self.playerModel.multiVideoURLs[idx]];
        [self.controlView playerResolutionIndex:idx];
    }
}

- (void)onControlView:(UIView *)controlView resolutionAction:(SuperPlayerUrl *)model {
    NSUInteger index = [self.playerModel.multiVideoURLs indexOfObject:model];
    if (index == _videoIndex || index == NSNotFound)
        return;
    _videoIndex = (int)index;
    if (self.isLive) {
        [self.livePlayer switchStream:model.url];
    
        [self.controlView playerShowTips:[NSString stringWithFormat:@"正在切换到%@...", model.title] delay:30];
    } else {
        if (model.url == nil) {
            [self.vodPlayer setBitrateIndex:index];
        } else {
            self.seekTime = [self.vodPlayer currentPlaybackTime];
            [self.vodPlayer startPlay:model.url];
            _videoURL = model.url;
        }
    }
}

- (void)onControlView:(UIView *)controlView changeSpeed:(CGFloat)value {
    [self.vodPlayer setRate:value];
    SuperPlayerGlobleConfigShared.playRate = value;
}

- (void)onControlView:(UIView *)controlView changeMirror:(BOOL)value {
    [self.vodPlayer setMirror:value];
    SuperPlayerGlobleConfigShared.mirror = value;
}

- (void)onControlView:(UIView *)controlView changeHWAccelerate:(BOOL)value {
    SuperPlayerGlobleConfigShared.enableHWAcceleration = value;
    self.seekTime = [self.vodPlayer currentPlaybackTime];
    [self configTXPlayer];
}

- (void)onControlView:(UIView *)controlView captureAction:(UIButton *)sender {
    
    void (^block)(UIImage *img) = ^(UIImage *img) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        imageView.layer.borderWidth = 3;
        imageView.layer.cornerRadius = 3;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        int height = 60;
        int width  = 60 * 16 / 9;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(sender);
            make.centerY.equalTo(sender.mas_bottom).offset(height/2);
            make.height.equalTo(@(height));
            make.width.equalTo(@(width));
        }];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCaptureDetected)];
        singleTap.numberOfTapsRequired = 1;
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:singleTap];
        
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
            
            [UIView animateWithDuration:1.0f animations:^{
                [imageView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [imageView removeFromSuperview];
            }];
        });
    };
    
    if (_isLive) {
        [_livePlayer snapshot:block];
    } else {
        [_vodPlayer snapshot:block];
    }
}

-(void)tapCaptureDetected{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"photos-redirect://"]];
}

- (void)onControlView:(UIView *)controlView danmakuAction:(UIButton *)sender {
    if (sender.isSelected) {
        [_danmakuView start];
        _danmakuView.hidden = NO;
        self.danmakuStartTime = [NSDate date];
    } else {
        [_danmakuView pause];
        _danmakuView.hidden = YES;
    }
}

- (void)onControlView:(SuperPlayerControlView *)controlView progressSliderTap:(CGFloat)value {
    // 视频总时间长度
    CGFloat total = [self getTotalTime];
    //计算出拖动的当前秒数
    NSInteger dragedSeconds = floorf(total * value);
    [self.controlView playerPlayBtnState:YES];
    [self seekToTime:dragedSeconds];
}

- (void)onControlView:(SuperPlayerControlView *)controlView progressSliderValueChanged:(UISlider *)slider {
    // 拖动改变视频播放进度
    if (self.isLoaded) {
        
        self.sliderLastValue  = slider.value;
        // 视频总时间长度
        CGFloat totalTime = [self getTotalTime];
        //计算出拖动的当前秒数
        CGFloat dragedSeconds = floorf(totalTime * slider.value);
        if (self.isLive && totalTime > MAX_SHIFT_TIME) {
            CGFloat base = totalTime - MAX_SHIFT_TIME;
            dragedSeconds = floor(MAX_SHIFT_TIME * slider.value) + base;
        }

        if (totalTime > 0) { // 当总时长 > 0时候才能拖动slider
            UIImage *thumbnail;
            if (self.isFullScreen) {
                thumbnail = [self.imageSprite getThumbnail:dragedSeconds];
            }
            [self.controlView playerDraggedTime:dragedSeconds totalTime:totalTime sliderValue:slider.value thumbnail:thumbnail];
        }
    }
}

- (void)onControlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider {
    if (self.isLoaded) {
        self.isPauseByUser = NO;
        // 视频总时间长度
        CGFloat total = [self getTotalTime];
        //计算出拖动的当前秒数
        NSInteger dragedSeconds = floorf(total * slider.value);
        if (self.isLive && total > MAX_SHIFT_TIME) {
            CGFloat base = total - MAX_SHIFT_TIME;
            dragedSeconds = floor(MAX_SHIFT_TIME * slider.value) + base;
        }
        [self seekToTime:dragedSeconds];
    }
}

- (void)onControlView:(UIView *)controlView backLiveAction:(UIButton *)sender {
    if (self.isLive) {
        self.isShiftPlayback = NO;
        self.isLoaded = NO;
        [self.livePlayer resumeLive];
        [self.controlView playerResolutionArray:self.playerModel.multiVideoURLs defaultIndex:_videoIndex];
    }
}

#pragma clang diagnostic pop
#pragma mark - 点播回调

- (void)_removeOldPlayer
{
    for (UIView *w in [self subviews]) {
        if ([w isKindOfClass:NSClassFromString(@"TXCRenderView")])
            [w removeFromSuperview];
        if ([w isKindOfClass:NSClassFromString(@"TXIJKSDLGLView")])
            [w removeFromSuperview];
        if ([w isKindOfClass:NSClassFromString(@"TXCAVPlayerView")])
            [w removeFromSuperview];
    }
}

-(void) onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param
{
    NSDictionary* dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
            [self setNeedsLayout];
            [self layoutIfNeeded];
            self.isLoaded = YES;
            [self _removeOldPlayer];
            [self.vodPlayer setupVideoWidget:self insertIndex:0];
            [self layoutSubviews];  // 防止横屏状态下添加view显示不全
            self.state = StatePlaying;
            
            if (player.supportedBitrates.count != self.playerModel.multiVideoURLs.count) {
                [self updateBitrates:player.supportedBitrates];
            }
            [self updatePlayerPoint];
        }
        if (EvtID == PLAY_EVT_VOD_PLAY_PREPARED) {
            if (self.seekTime > 0) {
                [player seek:self.seekTime];
                self.seekTime = 0;
            }
        }
        
        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            if (self.state == StateBuffering)
                self.state = StatePlaying;
            [self.controlView playerPlayBtnState:YES];
        } else if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            if (self.state == StateStopped)
                return;

            NSInteger currentTime = player.currentPlaybackTime;
            CGFloat totalTime     = player.duration;
            CGFloat value         = player.currentPlaybackTime / player.duration;
            [self.controlView playerCurrentTime:currentTime totalTime:totalTime sliderValue:value];
            NSTimeInterval playableDuration = player.playableDuration;
            [self.controlView playerPlayableProgress:playableDuration / totalTime];
        } else if (EvtID == PLAY_EVT_PLAY_END) {
            self.state = StateStopped;
            [self moviePlayDidEnd];
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_ERR_FILE_NOT_FOUND || EvtID == PLAY_ERR_HLS_KEY) {
            if (EvtID == PLAY_ERR_NET_DISCONNECT) {
                [self.controlView playerIsFailed:@"网络不给力,点击重试"];
            } else {
                [self.controlView playerIsFailed:@"加载失败,点击重试"];
            }
            self.state = StateFailed;
            [player stopPlay];
        } else if (EvtID == PLAY_EVT_PLAY_LOADING){
            // 当缓冲是空的时候
            self.state = StateBuffering;
        } else if (EvtID == PLAY_EVT_CHANGE_RESOLUTION) {
            if (player.height != 0) {
                self.videoRatio = (GLfloat)player.width / player.height;
            }
        }
     });
}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {
    
}

- (void)updateBitrates:(NSArray<TXBitrateItem *> *)bitrates;
{
    if (bitrates.count > 0) {
        int defaultIndex;
        NSArray *titles = [TXBitrateItemHelper sortWithBitrate:bitrates defaultIndex:&defaultIndex];
        _playerModel.multiVideoURLs = titles;
        [self.controlView playerResolutionArray:titles defaultIndex:defaultIndex];
    }
}

- (void)updatePlayerPoint {
    [self.controlView playerRemoveAllPoints];
    
    for (NSDictionary *keyFrameDesc in self.keyFrameDescList) {
        NSInteger time = [J2Num([keyFrameDesc valueForKeyPath:@"timeOffset"]) intValue];
        NSString *content = J2Str([keyFrameDesc valueForKeyPath:@"content"]);
        [self.controlView playerAddVideoPoint:time/1000.0/([self getTotalTime]+1)
                                         text:[content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                         time:time];
    }
}
#pragma mark - 直播回调

- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param {
    NSDictionary* dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{

        if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME && !self.isLoaded) {
            [self setNeedsLayout];
            [self layoutIfNeeded];
            self.isLoaded = YES;
            [self _removeOldPlayer];
            [self.livePlayer setupVideoWidget:CGRectZero containView:self insertIndex:0];
            [self layoutSubviews];  // 防止横屏状态下添加view显示不全
            self.state = StatePlaying;
            [self updatePlayerPoint];
        }
        
        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            if (self.state == StateBuffering)
                self.state = StatePlaying;
            [self.controlView playerPlayBtnState:YES];
            [self.netWatcher loadingEndEvent];
        } else if (EvtID == PLAY_EVT_PLAY_END) {
            self.state = StateStopped;
            [self moviePlayDidEnd];
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT) {
            if (self.isShiftPlayback) {
                [self onControlView:nil backLiveAction:nil];
                [self.controlView playerShowTips:@"时移失败，返回直播" delay:2];
            } else {
                [self.controlView playerIsFailed:@"网络不给力,点击重试"];
                self.state = StateFailed;
            }
        } else if (EvtID == PLAY_EVT_PLAY_LOADING){
            // 当缓冲是空的时候
            self.state = StateBuffering;
            if (!self.isShiftPlayback) {
                [self.netWatcher loadingEvent];
            }
        } else if (EvtID == PLAY_EVT_CHANGE_RESOLUTION) {
//            _videoWidth = [dict[EVT_PARAM1] intValue];
//            _videoHeight = [dict[EVT_PARAM2] intValue];

        } else if (EvtID == PLAY_EVT_STREAM_SWITCH_SUCC) {
            [self.controlView playerShowTips:[NSString stringWithFormat:@"已切换为%@", self.playerModel.multiVideoURLs[_videoIndex].title] delay:2];
        } else if (EvtID == PLAY_ERR_STREAM_SWITCH_FAIL) {
            [self.controlView playerIsFailed:@"清晰度切换失败"];
            self.state = StateFailed;
        } else if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            if (self.state == StateStopped)
                return;
            NSInteger progress = [dict[EVT_PLAY_PROGRESS] intValue];
            self.liveProgressTime = progress;
            self.maxLiveProgressTime = MAX(self.maxLiveProgressTime, self.liveProgressTime);
            
            if (self.isShiftPlayback) {
                CGFloat sv = 0;
                if (self.maxLiveProgressTime > MAX_SHIFT_TIME) {
                    CGFloat base = self.maxLiveProgressTime - MAX_SHIFT_TIME;
                    sv = (self.liveProgressTime - base) / MAX_SHIFT_TIME;
                } else {
                    sv = self.liveProgressTime / (self.maxLiveProgressTime + 1);
                }
                [self.controlView playerCurrentTime:self.liveProgressTime totalTime:-1 sliderValue:sv];
            } else {
                [self.controlView playerCurrentTime:self.maxLiveProgressTime totalTime:-1 sliderValue:1];
            }
        }
    });
}

- (void)onNetStatus:(NSDictionary *)param {
    
}


#pragma mark - Net
- (void)getPlayInfo:(NSInteger)appid withFileId:(NSString *)fileId {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://playvideo.qcloud.com/getplayinfo/v2/%ld/%@", appid, fileId];
    
    __weak SuperPlayerView *weakSelf = self;
    SuperPlayerModel *theModel = _playerModel;
    self.getInfoHttpTask = [manager GET:url parameters:nil progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    
                                    __strong SuperPlayerView *strongSelf = weakSelf;
                                    
                                    NSString *masterUrl = J2Str([responseObject valueForKeyPath:@"videoInfo.masterPlayList.url"]);
                                    //    masterUrl = nil;
                                    if (masterUrl.length > 0) {
                                        theModel.videoURL = masterUrl;
                                    } else {
                                        NSString *mainDefinition = J2Str([responseObject valueForKeyPath:@"playerInfo.defaultVideoClassification"]);
                                        
                                        
                                        NSArray *videoClassification = J2Array([responseObject valueForKeyPath:@"playerInfo.videoClassification"]);
                                        NSArray *transcodeList = J2Array([responseObject valueForKeyPath:@"videoInfo.transcodeList"]);
                                        
                                        NSMutableArray<SuperPlayerUrl *> *result = [NSMutableArray new];
                                        
                                        for (NSDictionary *transcode in transcodeList) {
                                            SuperPlayerUrl *subModel = [SuperPlayerUrl new];
                                            subModel.url = J2Str(transcode[@"url"]);
                                            NSNumber *theDefinition = J2Num(transcode[@"definition"]);
                                            
                                            
                                            for (NSDictionary *definition in videoClassification) {
                                                for (NSObject *definition2 in J2Array([definition valueForKeyPath:@"definitionList"])) {
                                                    
                                                    if ([definition2 isEqual:theDefinition]) {
                                                        subModel.title = J2Str([definition valueForKeyPath:@"name"]);
                                                        NSString *definitionId = J2Str([definition valueForKeyPath:@"id"]);
                                                        // 初始播放清晰度
                                                        if ([definitionId isEqualToString:mainDefinition]) {
                                                            if (![theModel.videoURL containsString:@".mp4"])
                                                                theModel.videoURL = subModel.url;
                                                        }
                                                        break;
                                                    }
                                                }
                                            }
                                            // 同一个清晰度可能存在多个转码格式，这里只保留一种格式，且优先mp4类型
                                            for (SuperPlayerUrl *item in result) {
                                                if ([item.title isEqual:subModel.title]) {
                                                    if (![item.url containsString:@".mp4"]) {
                                                        item.url = subModel.url;
                                                    }
                                                    subModel = nil;
                                                    break;
                                                }
                                            }
                                            
                                            if (subModel) {
                                                [result addObject:subModel];
                                            }
                                        }
                                        theModel.multiVideoURLs = result;
                                    }
                                    if (theModel.videoURL == nil) {
                                        NSString *source = J2Str([responseObject valueForKeyPath:@"videoInfo.sourceVideo.url"]);
                                        theModel.videoURL = source;
                                    }
                                    
                                    NSArray *imageSprites = J2Array([responseObject valueForKeyPath:@"imageSpriteInfo.imageSpriteList"]);
                                    if (imageSprites.count > 0) {
                                        //                 id imageSpriteObj = imageSprites[0];
                                        id imageSpriteObj = imageSprites.lastObject;
                                        NSString *vtt = J2Str([imageSpriteObj valueForKeyPath:@"webVttUrl"]);
                                        NSArray *imgUrls = J2Array([imageSpriteObj valueForKeyPath:@"imageUrls"]);
                                        NSMutableArray *imgUrlArray = @[].mutableCopy;
                                        for (NSString *url in imgUrls) {
                                            NSURL *nsurl = [NSURL URLWithString:url];
                                            if (nsurl) {
                                                [imgUrlArray addObject:nsurl];
                                            }
                                        }
                                        
                                        TXImageSprite *imageSprite = [[TXImageSprite alloc] init];
                                        [imageSprite setVTTUrl:[NSURL URLWithString:vtt] imageUrls:imgUrlArray];
                                        strongSelf.imageSprite = imageSprite;
                                        
                                        [DataReport report:@"image_sprite" param:nil];
                                    }
                                    
                                    NSArray *keyFrameDescList = J2Array([responseObject valueForKeyPath:@"keyFrameDescInfo.keyFrameDescList"]);
                                    if (keyFrameDescList.count > 0) {
                                        strongSelf.keyFrameDescList = keyFrameDescList;
                                    } else {
                                        strongSelf.keyFrameDescList = nil;
                                    }
                                    
                                    [strongSelf _playWithModel:theModel];
                                    
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    // error 错误信息
                                    [self.controlView playerIsFailed:[error localizedDescription]];
                                }];
    [manager invalidateSessionCancelingTasks:NO];
}

- (int)livePlayerType {
    int playType = -1;
    if (self.playerModel.fileId != nil)
        return -1;
    if ([_videoURL hasPrefix:@"rtmp:"]) {
        playType = PLAY_TYPE_LIVE_RTMP;
    } else if (([_videoURL hasPrefix:@"https:"] || [_videoURL hasPrefix:@"http:"]) && ([_videoURL rangeOfString:@".flv"].length > 0)) {
        playType = PLAY_TYPE_LIVE_FLV;
    }
    return playType;
}

- (void)reportPlay {
    if (self.reportTime == nil)
        return;
    int usedtime = -[self.reportTime timeIntervalSinceNow];
    if (self.isLive) {
        [DataReport report:@"superlive" param:@{@"usedtime":@(usedtime)}];
    } else {
        [DataReport report:@"supervod" param:@{@"usedtime":@(usedtime), @"fileid":@(self.playerModel.fileId?1:0)}];
    }
    self.reportTime = nil;
}

@end
