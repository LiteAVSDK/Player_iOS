//
//  PlayVodViewController.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2017/9/12.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "PlayVodViewController.h"
#import "TXAppInstance.h"
#import <mach/mach.h>
#import "PlayerKitCommonHeaders.h"
#import "TXAppInstance.h"
#import "TPScanQRController.h"
#import "TXConfigViewController.h"
// TODO: 需要在SDK代码内确认UGC_SMART宏用来约束什么，目前APP层没有用到该宏
//#ifndef UGC_SMART
#import "AppLogMgr.h"
//#endif
#import "AFNetworkReachabilityManager.h"
#import "AppLocalized.h"
#import "TXBitrateView.h"
#import "UIImage+TPAdditions.h"
#import "UIView+Additions.h"
#define TEST_MUTE 0

@interface PlayVodViewController () <UITextFieldDelegate, TXVodPlayListener, TPScanQRDelegate, TXBitrateViewDelegate>

@end

@implementation PlayVodViewController {
    BOOL      _bHWDec;
    UISlider *_playProgress;
    UISlider *_speedProgress;
    UILabel * _speedLabel;
    UILabel * _speedValue;
    UISlider *_playableProgress;
    UILabel * _playDuration;
    UILabel * _playStart;
    UIButton *_btnHWDec;

    long long _trackingTouchTS;
    BOOL      _startSeek;
    BOOL      _videoPause;

    UIImageView *_loadingImageView;
    BOOL         _appIsInterrupt;
    float        _sliderValue;
    long long    _startPlayTS;
    UIView *     mVideoContainer;
    NSString *   _playUrl;

    UILabel *_labProgress;
    UIButton *_mediaAssetsBtn;

    BOOL           _enableCache;
    TXBitrateView *_bitrateView;
    
    UIButton      *_fullScreenBtn;
    BOOL          _isFullScreen;
    CGRect        _smallFrame;
    UIView        *_coverView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)initUI {
    for (UIView *view in self.view.subviews) { [view removeFromSuperview]; }
    //    self.wantsFullScreenLayout = YES;
    self.title = V2Localize(@"MLVB.MainMenu.VodPlayer");
    
    UIButton *helpbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpbtn setFrame:CGRectMake(0, 0, 60, 25)];
    
    [helpbtn setBackgroundImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"help_small"] forState:UIControlStateNormal];
    [helpbtn addTarget:[TXAppInstance class] action:@selector(clickHelp:) forControlEvents:UIControlEventTouchUpInside];
    [helpbtn sizeToFit];
    UIBarButtonItem *rightItem              = [[UIBarButtonItem alloc] initWithCustomView:helpbtn];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 60, 25)];
    [button setBackgroundImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"play_setting"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickConfig) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem *rightItemh = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[rightItemh, rightItem];
    [self.view setBackgroundImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"background.jpg"]];
    _isFullScreen = NO;
    // remove all subview
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }

    CGSize size = [[UIScreen mainScreen] bounds].size;

    int icon_size = 40;

    _cover                 = [[UIView alloc] init];
    _cover.frame           = CGRectMake(10.0f, 55 + 2 * icon_size, size.width - 20, size.height - 75 - 3 * icon_size);
    _cover.backgroundColor = [UIColor whiteColor];
    _cover.alpha           = 0.5;
    _cover.hidden          = YES;
    [self.view addSubview:_cover];

    int     logheadH  = 65;
    CGFloat topOffset = [UIApplication sharedApplication].statusBarFrame.size.height;
    topOffset += self.navigationController.navigationBar.height + 5;
    if (@available(iOS 11.0, *)) {
        topOffset = [UIApplication sharedApplication].keyWindow.safeAreaInsets.top + 44;
    }
    _statusView                 = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 55 + 2 * icon_size, size.width - 20, logheadH)];
    _statusView.backgroundColor = [UIColor clearColor];
    _statusView.alpha           = 1;
    _statusView.textColor       = [UIColor blackColor];
    _statusView.editable        = NO;
    _statusView.hidden          = YES;
    [self.view addSubview:_statusView];

    _logViewEvt                 = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 55 + 2 * icon_size + logheadH, size.width - 20, size.height - 75 - 3 * icon_size - logheadH)];
    _logViewEvt.backgroundColor = [UIColor clearColor];
    _logViewEvt.alpha           = 1;
    _logViewEvt.textColor       = [UIColor blackColor];
    _logViewEvt.editable        = NO;
    _logViewEvt.hidden          = YES;
    [self.view addSubview:_logViewEvt];

    self.txtRtmpUrl = [[UITextField alloc] initWithFrame:CGRectMake(10, topOffset, size.width - 25 - icon_size, icon_size)];
    [self.txtRtmpUrl setBorderStyle:UITextBorderStyleRoundedRect];
    self.txtRtmpUrl.placeholder = playerLocalize(@"SuperPlayerDemo.OndemandPlayer.enterorscan");
    //    self.txtRtmpUrl.text = @"http://200024424.vod.myqcloud.com/200024424_709ae516bdf811e6ad39991f76a4df69.f20.mp4";
    self.txtRtmpUrl.text                   = @"http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/48d0f1f9387702299774251236/adp.10.m3u8";
    self.txtRtmpUrl.background             = [[TXAppInstance class] imageFromPlayerBundleNamed:@"Input_box"];
    self.txtRtmpUrl.alpha                  = 0.5;
    self.txtRtmpUrl.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.txtRtmpUrl.delegate               = self;
    [self.view addSubview:self.txtRtmpUrl];

    UIButton *btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
    btnScan.frame     = CGRectMake(size.width - 10 - icon_size, self.txtRtmpUrl.top, icon_size, icon_size);
    [btnScan setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"QR_code"] forState:UIControlStateNormal];
    [btnScan addTarget:self action:@selector(clickScan:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnScan];

    int icon_length = 9;

    int icon_gap = (size.width - icon_size * (icon_length - 1)) / icon_length;
    int hh       = [[UIScreen mainScreen] bounds].size.height - icon_size - 50;
    if (@available(iOS 11, *)) {
        hh -= [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    
    const CGFloat speed_y       = hh - 40;
    
    _mediaAssetsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mediaAssetsBtn.backgroundColor = [UIColor lightTextColor];
    _mediaAssetsBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, speed_y - 40, 100, 40);
    [_mediaAssetsBtn setTitle:playerLocalize(@"SuperPlayerDemo.OndemandPlayer.ondemand") forState:UIControlStateSelected];
    [_mediaAssetsBtn setTitle:playerLocalize(@"SuperPlayerDemo.OndemandPlayer.live") forState:UIControlStateNormal];
    _mediaAssetsBtn.selected = YES;
    [_mediaAssetsBtn addTarget:self action:@selector(clickMediaAsset:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_mediaAssetsBtn];
    
    _speedProgress              = [[UISlider alloc] initWithFrame:CGRectMake(70, speed_y, [[UIScreen mainScreen] bounds].size.width - 140, 30)];
    _speedProgress.minimumValue = -1.f;
    _speedProgress.maximumValue = 1.f;
    _speedProgress.value        = 0;
    [_speedProgress addTarget:self action:@selector(onSpeedSeek:) forControlEvents:UIControlEventValueChanged];
    [_speedProgress addTarget:self action:@selector(onSpeedEnd:) forControlEvents:UIControlEventTouchUpInside];
    [_speedProgress addTarget:self action:@selector(onSpeedOutSide:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:_speedProgress];

    _speedLabel       = [[UILabel alloc] init];
    _speedLabel.frame = CGRectMake(20, speed_y, 50, 30);
    [_speedLabel setText:V2Localize(@"Vod.playVod.Rate")];
    [_speedLabel setTextColor:[UIColor whiteColor]];
    _speedLabel.hidden = NO;
    [self.view addSubview:_speedLabel];

    _speedValue       = [[UILabel alloc] init];
    _speedValue.frame = CGRectMake(CGRectGetMaxX(_speedProgress.frame) + 10, speed_y, 50, 30);
    [_speedValue setText:[self getRateString:_speedProgress.value]];
    [_speedValue setTextColor:[UIColor whiteColor]];
    _speedValue.hidden = NO;
    [self.view addSubview:_speedValue];

    _playStart       = [[UILabel alloc] init];
    _playStart.frame = CGRectMake(20, hh, 50, 30);
    [_playStart setText:@"00:00"];
    [_playStart setTextColor:[UIColor whiteColor]];
    _playStart.hidden = YES;
    [self.view addSubview:_playStart];

    _playDuration       = [[UILabel alloc] init];
    _playDuration.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - 70, hh, 50, 30);
    [_playDuration setText:@"00:00"];
    [_playDuration setTextColor:[UIColor whiteColor]];
    _playDuration.hidden = YES;
    [self.view addSubview:_playDuration];

    _playableProgress              = [[UISlider alloc] initWithFrame:CGRectMake(70, hh - 1, [[UIScreen mainScreen] bounds].size.width - 132, 30)];
    _playableProgress.maximumValue = 0;
    _playableProgress.minimumValue = 0;
    _playableProgress.value        = 0;
    [_playableProgress setThumbImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(20, 10)] forState:UIControlStateNormal];
    [_playableProgress setMaximumTrackTintColor:[UIColor clearColor]];
    _playableProgress.userInteractionEnabled = NO;
    _playableProgress.hidden                 = YES;

    [self.view addSubview:_playableProgress];

    _playProgress              = [[UISlider alloc] initWithFrame:CGRectMake(70, hh, [[UIScreen mainScreen] bounds].size.width - 140, 30)];
    _playProgress.maximumValue = 0;
    _playProgress.minimumValue = 0;
    _playProgress.value        = 0;
    _playProgress.continuous   = NO;
    //    _playProgress.maximumTrackTintColor = UIColor.clearColor;
    [_playProgress addTarget:self action:@selector(onSeek:) forControlEvents:(UIControlEventValueChanged)];
    [_playProgress addTarget:self action:@selector(onSeekBegin:) forControlEvents:(UIControlEventTouchDown)];
    [_playProgress addTarget:self action:@selector(onDrag:) forControlEvents:UIControlEventTouchDragInside];
    _playProgress.hidden = YES;

    UIView *thumeView            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    thumeView.backgroundColor    = UIColor.whiteColor;
    thumeView.layer.cornerRadius = 10;
    UIImage *thumeImage          = thumeView.toImage;
    [_playProgress setThumbImage:thumeImage forState:UIControlStateNormal];

    [self.view addSubview:_playProgress];

    int btn_index = 0;
    _play_switch  = NO;
    _btnPlay      = [self createBottomBtnIndex:btn_index++ Icon:@"start" Action:@selector(clickPlay:) Gap:icon_gap Size:icon_size];

    _btnClose = [self createBottomBtnIndex:btn_index++ Icon:@"stop" Action:@selector(clickClose:) Gap:icon_gap Size:icon_size];

    _log_switch = NO;
    [self createBottomBtnIndex:btn_index++ Icon:@"log" Action:@selector(clickLog:) Gap:icon_gap Size:icon_size];

    [self createBottomBtnIndex:btn_index++ Icon:@"play_sound" Action:@selector(clickMute:) Gap:icon_gap Size:icon_size];

    _bHWDec   = NO;
    _btnHWDec = [self createBottomBtnIndex:btn_index++ Icon:@"quick2" Action:@selector(onClickHardware:) Gap:icon_gap Size:icon_size];

    _screenPortrait = NO;
    [self createBottomBtnIndex:btn_index++ Icon:@"portrait" Action:@selector(clickScreenOrientation:) Gap:icon_gap Size:icon_size];

    _renderFillScreen = NO;
    [self createBottomBtnIndex:btn_index++ Icon:@"fill" Action:@selector(clickRenderMode:) Gap:icon_gap Size:icon_size];

    [self createBottomBtnIndex:btn_index++ Icon:@"cache2" Action:@selector(cacheEnable:) Gap:icon_gap Size:icon_size];

    //    _helpBtn = [self createBottomBtnIndex:btn_index++ Icon:@"help.png" Action:@selector(onHelpBtnClicked:) Gap:icon_gap Size:icon_size];

    _txVodPlayer = [[TXVodPlayer alloc] init];
    //_txVodPlayerPreload = [[TXVodPlayer alloc] init];
    _videoPause      = NO;
    _trackingTouchTS = 0;

    _playStart.hidden        = NO;
    _playDuration.hidden     = NO;
    _playProgress.hidden     = NO;
    _playableProgress.hidden = NO;

    // loading imageview
    float           width   = 34;
    float           height  = 34;
    float           offsetX = (self.view.frame.size.width - width) / 2;
    float           offsetY = (self.view.frame.size.height - height) / 2;
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[[TXAppInstance class] imageFromPlayerBundleNamed:@"loading_image0.png"], [[TXAppInstance class] imageFromPlayerBundleNamed:@"loading_image1.png"], [[TXAppInstance class] imageFromPlayerBundleNamed:@"loading_image2.png"],
                                                                    [[TXAppInstance class] imageFromPlayerBundleNamed:@"loading_image3.png"], [[TXAppInstance class] imageFromPlayerBundleNamed:@"loading_image4.png"], [[TXAppInstance class] imageFromPlayerBundleNamed:@"loading_image5.png"],
                                                                    [[TXAppInstance class] imageFromPlayerBundleNamed:@"loading_image6.png"], [[TXAppInstance class] imageFromPlayerBundleNamed:@"loading_image7.png"], nil];
    _loadingImageView     = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, height)];
    _loadingImageView.animationImages   = array;
    _loadingImageView.animationDuration = 1;
    _loadingImageView.hidden            = YES;
    [self.view addSubview:_loadingImageView];

    CGRect VideoFrame = self.view.bounds;
    mVideoContainer   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VideoFrame.size.width, VideoFrame.size.height)];
    [self.view insertSubview:mVideoContainer atIndex:0];
    mVideoContainer.center = self.view.center;

    _bitrateView          = [[TXBitrateView alloc] initWithFrame:CGRectZero];
    _bitrateView.delegate = self;
    
    _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fullScreenBtn setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"fill"] forState:UIControlStateNormal];
    [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _fullScreenBtn.hidden = YES;
    [mVideoContainer addSubview:_fullScreenBtn];
    [_fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35);
        make.trailing.equalTo(mVideoContainer.mas_trailing).offset(-15);
        make.centerY.equalTo(mVideoContainer.mas_centerY).offset(70);
    }];
    
    [self.view addSubview:_bitrateView];
}

- (UIButton *)createBottomBtnIndex:(int)index Icon:(NSString *)icon Action:(SEL)action Gap:(int)gap Size:(int)size {
    CGFloat y = self.view.height - size - 10;
    if (@available(iOS 11, *)) {
        y -= [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame     = CGRectMake((index + 1) * gap + index * size, y, size, size);
    if (icon) {
        [btn setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:icon] forState:UIControlStateNormal];
    }
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}

- (UIButton *)createBottomBtnIndexEx:(int)index Icon:(NSString *)icon Action:(SEL)action Gap:(int)gap Size:(int)size {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame     = CGRectMake((index + 1) * gap + index * size, [[UIScreen mainScreen] bounds].size.height - 2 * (size + 10), size, size);
    [btn setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:icon] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    return btn;
}

- (void)onSelectBitrateIndex {
    [_txVodPlayer setBitrateIndex:_bitrateView.selectedIndex];
    [_txVodPlayer setRate:[self getRate:self->_speedProgress.value]];
}

//在低系统（如7.1.2）可能收不到这个回调，请在onAppDidEnterBackGround和onAppWillEnterForeground里面处理打断逻辑
- (void)onAudioSessionEvent:(NSNotification *)notification {
    NSDictionary *                 info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        if (_play_switch == YES && _appIsInterrupt == NO) {
            _appIsInterrupt = YES;
        }
    }
}

- (void)onAppDidEnterBackGround:(UIApplication *)app {
    if (_play_switch == YES) {
        if (!_videoPause) {
            [_txVodPlayer pause];
        }
    }
}

- (void)onAppWillEnterForeground:(UIApplication *)app {
    if (_play_switch == YES) {
        if (!_videoPause) {
            [_txVodPlayer resume];
        }
    }
}

- (void)onAppDidBecomeActive:(UIApplication *)app {
    if (_play_switch == YES && _appIsInterrupt == YES) {
        if (!_videoPause) {
            [_txVodPlayer resume];
        }
        _appIsInterrupt = NO;
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        [self stopPlay];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma-- example code bellow
- (void)clearLog {
    _tipsMsg = @"";
    _logMsg  = @"";
    [_statusView setText:@""];
    [_logViewEvt setText:@""];
    _startTime = [[NSDate date] timeIntervalSince1970] * 1000;
    _lastTime  = _startTime;
}

- (BOOL)startPlay {
    NSString *playUrl = self.txtRtmpUrl.text;

    [self clearLog];

    // arvinwu add. 增加播放按钮事件的时间打印。
    unsigned long long recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    int                mil        = recordTime % 1000;
    NSDateFormatter *  format     = [[NSDateFormatter alloc] init];
    format.dateFormat             = @"hh:mm:ss";
    NSString *time                = [format stringFromDate:[NSDate date]];
    NSString *log                 = [NSString stringWithFormat:@"[%@.%-3.3d] %@", time, mil,  playerLocalize(@"SuperPlayerDemo.OndemandPlayer.tapplaybutton")];

    NSString *ver = [TXLiveBase getSDKVersionStr];
    _logMsg       = [NSString stringWithFormat:@"liteav sdk version: %@\n%@", ver, log];
    [_logViewEvt setText:_logMsg];

    _bitrateView.selectedIndex = 0;
    _bitrateView.videoUrl = playUrl;
    if (_txVodPlayer != nil) {
        _txVodPlayer.vodDelegate = self;
        [_txVodPlayer setupVideoWidget:self->mVideoContainer insertIndex:0];
        [self setVodConfig];
        int result               = [_txVodPlayer startVodPlay:playUrl];
        if (result != 0) {
            NSLog(@"播放器启动失败");
            return NO;
        }
        [_txVodPlayer setRate:[self getRate:_speedProgress.value]];

        if (_screenPortrait) {
            [_txVodPlayer setRenderRotation:HOME_ORIENTATION_RIGHT];
        } else {
            [_txVodPlayer setRenderRotation:HOME_ORIENTATION_DOWN];
        }
        if (_renderFillScreen) {
            [_txVodPlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        } else {
            [_txVodPlayer setRenderMode:RENDER_MODE_FILL_EDGE];
        }

        [self startLoadingAnimation];

        _videoPause = NO;
        [_btnPlay setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"suspend"] forState:UIControlStateNormal];
        _play_switch = YES;
    }
    [self startLoadingAnimation];
    _startPlayTS = [[NSDate date] timeIntervalSince1970] * 1000;

    _playUrl = playUrl;

    return YES;
}

- (void)setVodConfig {
    if (_config == nil) {
        _config = [[TXVodPlayConfig alloc] init];
    }
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"vodConfig"];
    if (dic == nil) {
        if (_enableCache) {
            NSString *cacheFolderPath = [[NSSearchPathForDirectoriesInDomains
                                          (NSDocumentDirectory, NSUserDomainMask, YES)
                                          objectAtIndex:0]
                                         stringByAppendingString:@"/txcache"];
            [TXPlayerGlobalSetting setCacheFolderPath:cacheFolderPath];
        }
        
    } else {
        _config.smoothSwitchBitrate = [(NSNumber*)[dic objectForKey:@"accurateSeek"] boolValue];
        _config.autoRotate = [(NSNumber*)[dic objectForKey:@"smoothSwitch"] boolValue];
        _config.enableRenderProcess = [(NSNumber*)[dic objectForKey:@"renderProcess"] boolValue];
        
        _config.connectRetryCount = [[dic objectForKey:@"connectRetryCount"] intValue];
        _config.connectRetryInterval = [[dic objectForKey:@"connectRetryInterval"] intValue];
        _config.timeout = [[dic objectForKey:@"timeout"] integerValue];
        _config.progressInterval = [[dic objectForKey:@"progressInterval"] integerValue] / 1000;
        if (_enableCache) {
            NSString *cacheFolderPath = [[NSSearchPathForDirectoriesInDomains
                                          (NSDocumentDirectory, NSUserDomainMask, YES)
                                          objectAtIndex:0]
                                         stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"cacheFloderPath"]]];
            [TXPlayerGlobalSetting setCacheFolderPath:cacheFolderPath];
        }
        [TXPlayerGlobalSetting setMaxCacheSize:[[dic objectForKey:@"maxCacheSize"] integerValue]];
        _config.maxPreloadSize = [[dic objectForKey:@"maxPreloadSize"] intValue];
        _config.maxBufferSize = [[dic objectForKey:@"maxBufferSize"] intValue];
        _config.preferredResolution = [[dic objectForKey:@"preferredResolution"] longValue];
    }
    
    [_txVodPlayer setConfig:_config];
}

- (void)stopPlay {
    _playUrl = @"";
    [self stopLoadingAnimation];
    if (_txVodPlayer != nil) {
        [_txVodPlayer stopPlay];
    }
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:nil];
}

#pragma - ui event response.
- (void)clickPlay:(UIButton *)sender {
    [SuperPlayerPIPShared  close];
    if (_play_switch == YES) {
        if (_videoPause) {
            [_txVodPlayer resume];
            [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"suspend"] forState:UIControlStateNormal];
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        } else {
            [_txVodPlayer pause];
            [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"start"] forState:UIControlStateNormal];
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        }
        _videoPause = !_videoPause;

    } else {
        if (![self startPlay]) {
            return;
        }

        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"suspend"] forState:UIControlStateNormal];
        _play_switch = YES;
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}

- (void)clickClose:(UIButton *)sender {
    _play_switch = NO;

    [self stopPlay];
    [_btnPlay setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"start"] forState:UIControlStateNormal];
    _playStart.text = @"00:00";
    [_playDuration setText:@"00:00"];
    [_playProgress setValue:0];
    [_playProgress setMaximumValue:0];
    [_playableProgress setValue:0];
    [_playableProgress setMaximumValue:0];
    _labProgress.text = @"";
}

- (void)clickLog:(UIButton *)sender {
    if (_log_switch == YES) {
        _statusView.hidden = YES;
        _logViewEvt.hidden = YES;
        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"log"] forState:UIControlStateNormal];
        _cover.hidden = YES;
        _log_switch   = NO;
    } else {
        _statusView.hidden = NO;
        _logViewEvt.hidden = NO;
        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"log2"] forState:UIControlStateNormal];
        _cover.hidden = NO;
        _log_switch   = YES;
    }

    [_txVodPlayer snapshot:^(UIImage *img) {
        img = nil;
    }];
}

- (void)clickScreenOrientation:(UIButton *)sender {
    
    _screenPortrait = !_screenPortrait;

    if (_screenPortrait) {
        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"landscape"] forState:UIControlStateNormal];
        [self showFullScreen];
    } else {
        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"portrait"] forState:UIControlStateNormal];
        [self dismissFullScreen];
    }
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _isFullScreen = !_isFullScreen;
    if (_isFullScreen) {
        [self showFullScreen];
    } else {
        [self dismissFullScreen];
    }
}

- (void)showFullScreen {
    mVideoContainer.backgroundColor = [UIColor blackColor];
    _isFullScreen = YES;
    [_fullScreenBtn setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"adjust"] forState:UIControlStateNormal];
    _fullScreenBtn.hidden = NO;
    _smallFrame = mVideoContainer.frame;
    CGRect rectInWindow = [mVideoContainer convertRect:mVideoContainer.bounds toView:[UIApplication sharedApplication].keyWindow];
    [mVideoContainer removeFromSuperview];
    mVideoContainer.frame = rectInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:mVideoContainer];

    [UIView animateWithDuration:0.2 animations:^{
        self->mVideoContainer.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self->mVideoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self->mVideoContainer.superview);
            make.width.mas_equalTo(self->mVideoContainer.superview.mas_height);
            make.height.mas_equalTo(self->mVideoContainer.superview.mas_width);
        }];
        
        [self->_fullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(35);
            make.trailing.equalTo(self->mVideoContainer.mas_trailing).offset(-15);
            make.bottom.equalTo(self->mVideoContainer.mas_bottom).offset(-20);
        }];
        
        [self->mVideoContainer.superview setNeedsDisplay];
    } completion:^(BOOL finished) {
        [self->mVideoContainer setNeedsLayout];
    }];
    [_txVodPlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
}

- (void)dismissFullScreen {
    mVideoContainer.backgroundColor = [UIColor clearColor];
    [_fullScreenBtn setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"fill"] forState:UIControlStateNormal];
    _fullScreenBtn.hidden = YES;
    [mVideoContainer removeFromSuperview];
    mVideoContainer.frame = _smallFrame;
    [self.view addSubview:mVideoContainer];

    [UIView animateWithDuration:0.2 animations:^{
        self->mVideoContainer.transform = CGAffineTransformMakeRotation(0);

        [self->mVideoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self->mVideoContainer.superview);
            make.leading.trailing.mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
        }];
        
        [self->_fullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(35);
            make.trailing.equalTo(self->mVideoContainer.mas_trailing).offset(-15);
            make.centerY.equalTo(self->mVideoContainer.mas_centerY).offset(70);
        }];
        
        [self->mVideoContainer.superview setNeedsDisplay];
    } completion:^(BOOL finished) {
        [self->mVideoContainer setNeedsLayout];
    }];
    [self.view insertSubview:mVideoContainer atIndex:0];
    [_txVodPlayer setRenderMode:RENDER_MODE_FILL_EDGE];
    _screenPortrait = NO;
    _renderFillScreen = NO;
}

- (void)clickRenderMode:(UIButton *)sender {
    _renderFillScreen = !_renderFillScreen;

    if (_renderFillScreen) {
        _fullScreenBtn.hidden = YES;
        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"adjust"] forState:UIControlStateNormal];
        [_txVodPlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
    } else {
        _fullScreenBtn.hidden = NO;
        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"fill"] forState:UIControlStateNormal];
        [_txVodPlayer setRenderMode:RENDER_MODE_FILL_EDGE];
    }
}

- (void)clickMute:(UIButton *)sender {
    if (sender.isSelected) {
        [_txVodPlayer setMute:NO];
        [sender setSelected:NO];
        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"play_sound"] forState:UIControlStateNormal];
    } else {
        [_txVodPlayer setMute:YES];
        [sender setSelected:YES];
        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"play_mute"] forState:UIControlStateNormal];
    }
}

- (void)clickMediaAsset:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
}

- (void)onClickHardware:(UIButton *)sender {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [self toastTip:playerLocalize(@"SuperPlayerDemo.OndemandPlayer.supporthardware")];
        return;
    }

    if (_play_switch == YES) {
        [self stopPlay];
    }

    _txVodPlayer.enableHWAcceleration = !_bHWDec;

    _bHWDec = _txVodPlayer.enableHWAcceleration;

    if (_bHWDec) {
        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"quick"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"quick2"] forState:UIControlStateNormal];
    }

    if (_play_switch == YES) {
        if (_bHWDec) {
            [self toastTip:playerLocalize(@"SuperPlayerDemo.OndemandPlayer.switchharddecode")];
        } else {
            [self toastTip:playerLocalize(@"SuperPlayerDemo.OndemandPlayer.switchsoftdecode")];
        }
        [self startPlay];
    }
}

- (void)onHelpBtnClicked:(UIButton *)sender {
    NSURL *        helpURL = [NSURL URLWithString:@"https://cloud.tencent.com/document/product/454/12147"];
    UIApplication *myApp   = [UIApplication sharedApplication];
    if ([myApp canOpenURL:helpURL]) {
        [myApp openURL:helpURL];
    }
}

- (void)clickScan:(UIButton *)btn {
    TPScanQRController *vc = [[TPScanQRController alloc] init];
    vc.delegate          = self;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)clickConfig {
    TXConfigViewController *configVC = [[TXConfigViewController alloc] init];
    [self.navigationController pushViewController:configVC animated:NO];
}

#pragma-- UISlider - play seek
- (void)onSeek:(UISlider *)slider {
    [_txVodPlayer resume];
    [_txVodPlayer seek:_sliderValue];
    _trackingTouchTS = [[NSDate date] timeIntervalSince1970] * 1000;
    _startSeek       = NO;
    NSLog(@"vod seek drag end");
}

- (void)onSpeedSeek:(UISlider *)slider {
    [_speedValue setText:[self getRateString:slider.value]];
}

- (void)onSpeedEnd:(UISlider *)slider {
    [_txVodPlayer setRate:[self getRate:slider.value]];
}

- (void)onSpeedOutSide:(UISlider *)slider {
    [_txVodPlayer setRate:[self getRate:slider.value]];
}

- (void)onSeekBegin:(UISlider *)slider {
    _startSeek = YES;
    NSLog(@"vod seek drag begin");
}

- (void)onDrag:(UISlider *)slider {
    float progress    = slider.value;
    int   intProgress = progress + 0.5;
    _playStart.text   = [NSString stringWithFormat:@"%02d:%02d", (int)(intProgress / 60), (int)(intProgress % 60)];
    _sliderValue      = slider.value;
}

#pragma-- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.txtRtmpUrl resignFirstResponder];
    _vCacheStrategy.hidden = YES;
}

#pragma mark-- ScanQRDelegate
- (void)onScanResult:(NSString *)result {
    self.txtRtmpUrl.text = result;
    [self startPlay];
}

- (void)cacheEnable:(id)sender {
    _enableCache = !_enableCache;
    if (_enableCache) {
        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"cache"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"cache2"] forState:UIControlStateNormal];
    }
}

/**
   @method 获取指定宽度width的字符串在UITextView上的高度
   @param textView 待计算的UITextView
   @param width 限制字符串显示区域的宽度
   @result float 返回的高度
 */
- (float)heightForString:(UITextView *)textView andWidth:(float)width {
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void)toastTip:(NSString *)toastInfo {
    CGRect frameRC   = [[UIScreen mainScreen] bounds];
    frameRC.origin.y = frameRC.size.height - 110;
    frameRC.size.height -= 110;
    __block UITextView *toastView = [[UITextView alloc] init];

    toastView.editable   = NO;
    toastView.selectable = NO;

    frameRC.size.height = [self heightForString:toastView andWidth:frameRC.size.width];

    toastView.frame = frameRC;

    toastView.text            = toastInfo;
    toastView.textColor = [UIColor blackColor];
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.alpha           = 0.5;

    [self.view addSubview:toastView];

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);

    dispatch_after(popTime, dispatch_get_main_queue(), ^() {
        [toastView removeFromSuperview];
        toastView = nil;
    });
}

#pragma## #TXLivePlayListener
- (void)appendLog:(NSString *)evt time:(NSDate *)date mills:(int)mil {
    if (evt == nil) {
        return;
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat       = @"hh:mm:ss";
    NSString *time          = [format stringFromDate:date];
    NSString *log           = [NSString stringWithFormat:@"[%@.%-3.3d] %@", time, mil, evt];
    if (_logMsg == nil) {
        _logMsg = @"";
    }
    _logMsg = [NSString stringWithFormat:@"%@\n%@", _logMsg, log];
    [_logViewEvt setText:_logMsg];
}

- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
    NSDictionary *dict = param;
    dispatch_async(dispatch_get_main_queue(), ^{

        if (EvtID == PLAY_EVT_VOD_LOADING_END || EvtID == PLAY_EVT_VOD_PLAY_PREPARED) {
            [self stopLoadingAnimation];
        }

        if (EvtID == PLAY_EVT_PLAY_BEGIN) {
            [self stopLoadingAnimation];
            //#ifndef UGC_SMART
            long long playDelay = [[NSDate date] timeIntervalSince1970] * 1000 - self->_startPlayTS;
            AppDemoLog(@"AutoMonitor:PlayFirstRender,cost=%lld", playDelay);
            //#endif
            NSArray *supportedBitrates = [self->_txVodPlayer supportedBitrates];
            self->_bitrateView.dataSource    = supportedBitrates;
            self->_bitrateView.center        = CGPointMake(self.view.width - self->_bitrateView.width / 2, self.view.height / 2);
        } else if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            [self detailProgresswithParam:dict];
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_EVT_PLAY_END || EvtID == PLAY_ERR_FILE_NOT_FOUND || EvtID == PLAY_ERR_HLS_KEY || EvtID == PLAY_ERR_GET_PLAYINFO_FAIL) {
            self->_play_switch = NO;
            [self->_btnPlay setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"start"] forState:UIControlStateNormal];
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            self->_videoPause = NO;

            if (EvtID == PLAY_ERR_NET_DISCONNECT) {
                NSString *Msg = (NSString *)[dict valueForKey:EVT_MSG];
                [self toastTip:Msg];
            }
            [self stopLoadingAnimation];
        } else if (EvtID == PLAY_EVT_PLAY_LOADING) {
            [self startLoadingAnimation];
        } else if (EvtID == PLAY_EVT_CONNECT_SUCC) {
            [self detailConnectSuccessClick];
        } else if (EvtID == PLAY_EVT_CHANGE_ROTATION) {
            return;
        }
        //        NSLog(@"evt:%d,%@", EvtID, dict);
        long long time = [(NSNumber *)[dict valueForKey:EVT_TIME] longLongValue];
        int       mil  = time % 1000;
        NSDate *  date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
        NSString *Msg  = (NSString *)[dict valueForKey:EVT_MSG];
        [self appendLog:Msg time:date mills:mil];
    });
}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {
    NSDictionary *dict = param;

    dispatch_async(dispatch_get_main_queue(), ^{
        int       netspeed       = [(NSNumber *)[dict valueForKey:NET_STATUS_NET_SPEED] intValue];
        int       vbitrate       = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_BITRATE] intValue];
        int       abitrate       = [(NSNumber *)[dict valueForKey:NET_STATUS_AUDIO_BITRATE] intValue];
        int       cachesize      = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_CACHE] intValue];
        int       dropsize       = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_DROP] intValue];
        int       jitter         = [(NSNumber *)[dict valueForKey:NET_STATUS_NET_JITTER] intValue];
        int       fps            = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_FPS] intValue];
        int       width          = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_WIDTH] intValue];
        int       height         = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_HEIGHT] intValue];
        float     cpu_app_usage  = [(NSNumber *)[dict valueForKey:NET_STATUS_CPU_USAGE] floatValue];
        float     cpu_sys_usage  = [(NSNumber *)[dict valueForKey:NET_STATUS_CPU_USAGE_D] floatValue];
        NSString *serverIP       = [dict valueForKey:NET_STATUS_SERVER_IP];
        int       codecCacheSize = [(NSNumber *)[dict valueForKey:NET_STATUS_AUDIO_CACHE] intValue];
        int       nCodecDropCnt  = [(NSNumber *)[dict valueForKey:NET_STATUS_AUDIO_DROP] intValue];
        int       nCahcedSize    = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_CACHE] intValue] / 1000;

        NSString *log =
            [NSString stringWithFormat:@"CPU:%.1f%%|%.1f%%\tRES:%d*%d\tSPD:%dkb/s\nJITT:%d\tFPS:%d\tARA:%dkb/s\nQUE:%d|%d\tDRP:%d|%d\tVRA:%dkb/s\nSVR:%@\t\tCAH:%d kb", cpu_app_usage * 100,
                                       cpu_sys_usage * 100, width, height, netspeed, jitter, fps, abitrate, codecCacheSize, cachesize, nCodecDropCnt, dropsize, vbitrate, serverIP, nCahcedSize];
        [self->_statusView setText:log];
        //#ifndef UGC_SMART
        AppDemoLogOnlyFile(@"Current status, VideoBitrate:%d, AudioBitrate:%d, FPS:%d, RES:%d*%d, netspeed:%d", vbitrate, abitrate, fps, width, height, netspeed);
        //#endif
    });
}

- (void)detailProgresswithParam:(NSDictionary *)dict {
    if (self->_startSeek) {
        return;
    }

    float progress = [dict[EVT_PLAY_PROGRESS] floatValue];
    float duration = [dict[EVT_PLAY_DURATION] floatValue];
    
    int intProgress = progress + 0.5;
    self->_playStart.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intProgress / 60), (int)(intProgress % 60)];
    [self->_playProgress setValue:progress];

    int intDuration = duration + 0.5;
    if (duration >= 0 && self->_playProgress.maximumValue != duration) {
        [self->_playProgress setMaximumValue:duration];
        [self->_playableProgress setMaximumValue:duration];
        self->_playDuration.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
    }
    [self->_playableProgress setValue:[dict[EVT_PLAYABLE_DURATION] floatValue]];
    
    if (progress < duration) {
        [_btnPlay setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"suspend"] forState:UIControlStateNormal];
        _play_switch = YES;
    }
}

- (void)detailConnectSuccessClick {
    BOOL isWifi = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
    if (!isWifi) {
        __weak __typeof(self) weakSelf = self;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (self->_playUrl.length == 0) {
                return;
            }
            if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:playerLocalize(@"SuperPlayerDemo.OndemandPlayer.switchtowifi")
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:playerLocalize(@"SuperPlayerDemo.OndemandPlayer.true")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                            [weakSelf startPlay];
                                                        }]];
                [alert addAction:[UIAlertAction actionWithTitle:playerLocalize(@"SuperPlayerDemo.OndemandPlayer.false")
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                        }]];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

- (void)startLoadingAnimation {
    if (_loadingImageView != nil) {
        _loadingImageView.hidden = NO;
        [_loadingImageView startAnimating];
    }
}

- (void)stopLoadingAnimation {
    if (_loadingImageView != nil) {
        _loadingImageView.hidden = YES;
        [_loadingImageView stopAnimating];
    }
}

- (BOOL)onPlayerPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    return NO;
}

- (float)getRate:(float)rate {
    rate = rate * 100.f / 100.f;
    if (rate >= 0.f) {
        return (1.f + rate);
    } else {
        return (1.f + rate / 2);
    }
}

- (NSString *)getRateString:(float)rate {
    return [NSString stringWithFormat:@"%.2f", [self getRate:rate]];
}

@end
