//
//  TXBasePlayerViewController.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//  本模块主要是介绍如何使用腾讯云点播播放器进行播放视频包括暂停和继续播放

#import "TXBasePlayerViewController.h"
#import "TXBasePlayerMacro.h"
#import "TXBasePlayerLocalized.h"
#import "UIView+TXAdditions.h"
#import "TXBasePlayerTopView.h"
#import "TXBasePlayerLogView.h"
#import "TXBasePlayerBottomView.h"
#import "TXScanQRController.h"
#import "TXBitrateView.h"
#import "TXConfigViewController.h"
#import <TXLiteAVSDK_Player/TXVodPlayer.h>
#import <TXLiteAVSDK_Player/TXLiveBase.h>
#import <TXLiteAVSDK_Player/TXPlayerGlobalSetting.h>
#import <Masonry/Masonry.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface TXBasePlayerViewController ()<TXBasePlayerTopViewDelegate, TXBasePlayerBottomViewDelegate, ScanQRDelegate, TXVodPlayListener, TXBitrateViewDelegate>

// config VC
@property (nonatomic, strong) TXConfigViewController *configVC;

// 承载播放器的容器View
@property (nonatomic, strong) UIView *videoPlayView;

// 点播播放器对象
@property (nonatomic, strong) TXVodPlayer *vodPlayer;

// 播放器配置
@property (nonatomic, strong) TXVodPlayConfig *vodConfig;

// 头部View
@property (nonatomic, strong) TXBasePlayerTopView *topView;

// logView
@property (nonatomic, strong) TXBasePlayerLogView *logView;

// 底部View
@property (nonatomic, strong) TXBasePlayerBottomView *bottomView;

// 加载视图
@property (nonatomic, strong) UIImageView *loadingImageView;

// 全屏按钮
@property (nonatomic, strong) UIButton *fullScreenBtn;

// 清晰度视图
@property (nonatomic, strong) TXBitrateView *bitrateView;

// 视频是否播放
@property (nonatomic, assign) BOOL playSwitch;

// 是否暂停状态
@property (nonatomic, assign) BOOL videoPause;

// 播放速率
@property (nonatomic, assign) float currentRate;

// 是否是图像铺满屏幕
@property (nonatomic, assign) BOOL renderFillScreen;

// 是否开启缓存
@property (nonatomic, assign) BOOL enableCache;

// 是否开始seek
@property (nonatomic, assign) BOOL startSeek;

// app是否被中断
@property (nonatomic, assign) BOOL appIsInterrupt;

// 是否全屏
@property (nonatomic, assign) BOOL isFullScreen;

// 记录竖屏下的frame
@property (nonatomic, assign) CGRect smallFrame;

@end

@implementation TXBasePlayerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // 设置导航栏左边的返回按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, TX_BasePlayer_BACK_BTN_WIDTH, TX_BasePlayer_BACK_BTN_HEIGHT)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@TX_BasePlayer_BACK_IMAGE_NAME] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[leftItem];

    // 设置导航栏标题
    self.title = TXBasePlayerLocalize(@"BASE_PLAYER-Module.Title");
    
    // 设置导航栏右侧帮助和设置按钮
    UIButton *buttonh = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonh setFrame:CGRectMake(0, 0, TX_BasePlayer_BACK_BTN_WIDTH, TX_BasePlayer_BACK_BTN_HEIGHT)];
    [buttonh setBackgroundImage:[UIImage imageNamed:@"help_small"] forState:UIControlStateNormal];
    [buttonh addTarget:self action:@selector(clickHelp) forControlEvents:UIControlEventTouchUpInside];
    [buttonh sizeToFit];
    UIBarButtonItem *rightItemh = [[UIBarButtonItem alloc] initWithCustomView:buttonh];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, TX_BasePlayer_BACK_BTN_WIDTH, TX_BasePlayer_BACK_BTN_HEIGHT)];
    [button setBackgroundImage:[UIImage imageNamed:@"play_setting"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickSetConfig) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[ rightItem, rightItemh ];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    // 移除self上的所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.playSwitch = NO;
    self.videoPause = NO;
    self.renderFillScreen = NO;
    self.enableCache = NO;
    self.appIsInterrupt = NO;
    self.isFullScreen = NO;
    self.currentRate = 1.f;
    
    // 初始化子View
    [self initChildView];
}

#pragma mark - Private Method
- (void)initChildView {
    
    // 设置View的背景图片
    [self.view setBackgroundImage:[UIImage imageNamed:@"background.jpg"]];
    
    // 添加视频播放的视图
    [self.view addSubview:self.videoPlayView];
    [self.videoPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 添加Log视图
    [self.view addSubview:self.logView];
    [self.logView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(TX_NavBarAndStatusBarHeight + 50);
        make.height.mas_equalTo(TX_SCREEN_HEIGHT - TX_NavBarAndStatusBarHeight - 50 - 130);
    }];
    
    // 添加头部视图
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(TX_NavBarAndStatusBarHeight);
        make.height.mas_equalTo(50);
    }];
    
    // 添加底部视图
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-TX_BottomSafeAreaHeight);
        make.height.mas_equalTo(130);
    }];
    
    // 添加全屏按钮
    [self.videoPlayView addSubview:self.fullScreenBtn];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.videoPlayView).offset(-20);
        make.bottom.equalTo(self.videoPlayView).offset(-(TX_BottomSafeAreaHeight + 130));
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    // 添加清晰度视图
    [self.view addSubview:self.bitrateView];
}

// 开始播放
- (BOOL)startPlay {
    // 从textField上获取视频url
    NSString *playUrl = self.topView.urlTextField.text;
    
    // 清空日志
    [self.logView clearLog];
    
    // arvinwu add. 增加播放按钮事件的时间打印。
    unsigned long long recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    int                mil        = recordTime % 1000;
    NSDateFormatter *  format     = [[NSDateFormatter alloc] init];
    format.dateFormat             = @"hh:mm:ss";
    NSString *time                = [format stringFromDate:[NSDate date]];
    NSString *log                 = [NSString stringWithFormat:@"[%@.%-3.3d] %@",time,mil,TXBasePlayerLocalize(@"BASE_PLAYER-Module.tapplaybutton")];

    NSString *ver = [TXLiveBase getSDKVersionStr];
    NSString *logMsg = [NSString stringWithFormat:@"liteav sdk version: %@\n%@", ver, log];
    [self.logView.logEventView setText:logMsg];
    
    self.bitrateView.selectedIndex = 0;
    self.bitrateView.videoUrl = playUrl;
    
    // 开始loading动画
    [self startLoadingAnimation];
    // 设置播放器配置
    [self setVodConfig];
    // 开始播放
    int result = [self.vodPlayer startVodPlay:playUrl];
    if (result != 0) {
        return NO;
    }
    
    // 设置初始速率
    [self.vodPlayer setRate:self.currentRate];
    
    // 设置画面的方向
    [self.vodPlayer setRenderRotation:HOME_ORIENTATION_DOWN];
    
    // 设置画面的裁剪模式
    if (self.renderFillScreen) {
        [self.vodPlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
    } else {
        [self.vodPlayer setRenderMode:RENDER_MODE_FILL_EDGE];
    }
    
    self.videoPause = NO;
    self.playSwitch = YES;
    
    return YES;
}

// 停止播放
- (void)stopPlay {
    [self stopLoadingAnimation];
    if (self.vodPlayer != nil) {
        [self.vodPlayer stopPlay];
    }
    
    self.fullScreenBtn.hidden = YES;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:nil];
}

// 设置播放器配置
- (void)setVodConfig {
    
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
        self.vodConfig.enableAccurateSeek = [(NSNumber*)[dic objectForKey:@"accurateSeek"] boolValue];
        self.vodConfig.smoothSwitchBitrate = [(NSNumber*)[dic objectForKey:@"smoothSwitch"] boolValue];
        self.vodConfig.autoRotate = [(NSNumber*)[dic objectForKey:@"rotatesAuto"] boolValue];
        self.vodConfig.enableRenderProcess = [(NSNumber*)[dic objectForKey:@"renderProcess"] boolValue];
        
        self.vodConfig.connectRetryCount = [[dic objectForKey:@"connectRetryCount"] intValue];
        self.vodConfig.connectRetryInterval = [[dic objectForKey:@"connectRetryInterval"] intValue];
        self.vodConfig.timeout = [[dic objectForKey:@"timeout"] integerValue];
        self.vodConfig.progressInterval = [[dic objectForKey:@"progressInterval"] integerValue] / 1000;
        if (_enableCache) {
            NSString *cacheFolderPath = [[NSSearchPathForDirectoriesInDomains
                                          (NSDocumentDirectory, NSUserDomainMask, YES)
                                          objectAtIndex:0]
                                         stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"cacheFloderPath"]]];
            [TXPlayerGlobalSetting setCacheFolderPath:cacheFolderPath];
        }
        [TXPlayerGlobalSetting setMaxCacheSize:[[dic objectForKey:@"maxCacheSize"] integerValue]];
        self.vodConfig.maxPreloadSize = [[dic objectForKey:@"maxPreloadSize"] intValue];
        self.vodConfig.maxBufferSize = [[dic objectForKey:@"maxBufferSize"] intValue];
        self.vodConfig.preferredResolution = [[dic objectForKey:@"preferredResolution"] longValue];
        self.vodConfig.mediaType = [[dic objectForKey:@"mediaType"] integerValue];
    }
    
    [self.vodPlayer setConfig:self.vodConfig];
}

// 开始loading动画
- (void)startLoadingAnimation {
    if (self.loadingImageView != nil) {
        self.loadingImageView.hidden = NO;
        [self.loadingImageView startAnimating];
    }
}

// 结束loading动画
- (void)stopLoadingAnimation {
    if (self.loadingImageView != nil) {
        self.loadingImageView.hidden = YES;
        [self.loadingImageView stopAnimating];
    }
}

// 全屏展示
- (void)showFullScreen {
    self.isFullScreen = YES;
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"shrinkscreen"] forState:UIControlStateNormal];
    self.smallFrame = self.videoPlayView.frame;
    CGRect rectInWindow = [self.videoPlayView convertRect:self.videoPlayView.bounds toView:[UIApplication sharedApplication].keyWindow];
    [self.videoPlayView removeFromSuperview];
    self.videoPlayView.frame = rectInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:self.videoPlayView];

    [UIView animateWithDuration:0.2 animations:^{
        self.videoPlayView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.videoPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.videoPlayView.superview);
            make.width.mas_equalTo(self.videoPlayView.superview.mas_height);
            make.height.mas_equalTo(self.videoPlayView.superview.mas_width);
        }];
        
        [self->_fullScreenBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(40);
            make.trailing.equalTo(self.videoPlayView.mas_trailing).offset(-15);
            make.bottom.equalTo(self.videoPlayView.mas_bottom).offset(-20);
        }];
        
        [self.videoPlayView.superview setNeedsDisplay];
    } completion:^(BOOL finished) {
        [self.videoPlayView setNeedsLayout];
    }];
    
    [self.vodPlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
}

// 退出全屏
- (void)dismissFullScreen {
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"fill"] forState:UIControlStateNormal];
    [self.videoPlayView removeFromSuperview];
    self.videoPlayView.frame = self.smallFrame;
    [self.view addSubview:self.videoPlayView];

    [UIView animateWithDuration:0.2 animations:^{
        self.videoPlayView.transform = CGAffineTransformMakeRotation(0);

        [self.videoPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.videoPlayView.superview);
            make.leading.trailing.mas_equalTo(0);
            make.top.bottom.mas_equalTo(0);
        }];
        
        [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.videoPlayView).offset(-20);
            make.bottom.equalTo(self.videoPlayView).offset(-(TX_BottomSafeAreaHeight + 130));
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
        }];

        [self.videoPlayView.superview setNeedsDisplay];
    } completion:^(BOOL finished) {
        [self.videoPlayView setNeedsLayout];
    }];
    
    [self.view insertSubview:self.videoPlayView atIndex:0];
    [self.vodPlayer setRenderMode:RENDER_MODE_FILL_EDGE];
    _renderFillScreen = NO;
}

#pragma mark - Click

// 导航栏返回按钮的点击事件处理
- (void)backClick {
    
    // 退到上一层，需要停止播放
    [self.vodPlayer stopPlay];
    
    // 移除Video渲染View
    [self.vodPlayer removeVideoWidget];
    self.vodPlayer = nil;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
}

// 帮助事件
- (void)clickHelp {
    NSURL * helpUrl = [NSURL URLWithString:@"https://cloud.tencent.com/document/product/454/18871"];
    UIApplication *myApp   = [UIApplication sharedApplication];
    if ([myApp canOpenURL:helpUrl]) {
        [myApp openURL:helpUrl options:@{} completionHandler:nil];
    }
}

// 跳转播放器配置页事件
- (void)clickSetConfig {
    TXConfigViewController *configVC = [[TXConfigViewController alloc] init];
    [self.navigationController pushViewController:configVC animated:NO];
}

// 全屏事件
- (void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    self.isFullScreen = !self.isFullScreen;
    if (self.isFullScreen) {
        [self showFullScreen];
    } else {
        [self dismissFullScreen];
    }
}

#pragma mark-- ScanQRDelegate
// 扫码成功的回调
- (void)onScanResult:(NSString *)result {
    // 同步扫码结果
    self.topView.urlTextField.text = result;
    // 开始播放
    BOOL ret = [self startPlay];
    
    if (ret) {
        [self.bottomView updateStartPlayBtnStateSelected:YES];
    } else {
        [self.bottomView updateStartPlayBtnStateSelected:NO];
    }
}

#pragma mark - TXBasePlayerTopViewDelegate

- (void)onScanClick {
    TXScanQRController *vc = [[TXScanQRController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - TXBasePlayerBottomViewDelegate

// 开始seek的事件
- (void)onSeekBegin {
    // seek开始,改变状态
    self.startSeek = YES;
}

// 时长seek结束的事件
- (void)onSeekEndWithSlideValue:(float)slideValue {
    // seek结束,改变状态
    self.startSeek = NO;
    [self.vodPlayer seek:slideValue];
}

// 速率seek结束的事件
- (void)onSpeedEndWithSlideValue:(float)slideValue {
    [self.vodPlayer setRate:slideValue];
}

// 速率seek outside的事件
- (void)onSpeedOutSideWithSlideValue:(float)slideValue {
    [self.vodPlayer setRate:slideValue];
}

// 开始播放或者暂停的事件
- (void)onStartPlaySwitch:(BOOL)isSelected {
    if (self.playSwitch) {
        if (self.videoPause) {
            [self.vodPlayer resume];
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        } else {
            [self.vodPlayer pause];
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        }
        self.videoPause = !self.videoPause;
    } else {
        if (![self startPlay]) {
            [self.bottomView updateStartPlayBtnStateSelected:NO];
            return;
        }
        self.playSwitch = YES;
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}

// 停止播放的事件
- (void)onStopPlayClick {
    self.playSwitch = NO;
    // 停止播放
    [self stopPlay];
    
    // 重置底部View状态
    [self.bottomView resetBottomProgressViewState];
}

// 开日志开启与否的事件
- (void)onLogSwitch:(BOOL)isOpenLog {
    if (isOpenLog) {
        self.logView.hidden = NO;
    } else {
        self.logView.hidden = YES;
    }
}

// 是否静音的事件
- (void)onMuteSwitch:(BOOL)isMute {
    if (isMute) {
        [self.vodPlayer setMute:YES];
    } else {
        [self.vodPlayer setMute:NO];
    }
}

// 软硬解切换的事件
- (void)onHardWareSwitch:(BOOL)bHWDec {
    // 低于8.0版本不支持
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [self toastTip:TXBasePlayerLocalize(@"BASE_PLAYER-Module.supporthardware")];
        return;
    }
    
    if (self.playSwitch == YES) {
        [self stopPlay];
    }
    
    // 是否开启硬件加速
    self.vodPlayer.enableHWAcceleration = bHWDec;

    if (self.playSwitch == YES) {
        if (bHWDec) {
            [self toastTip:TXBasePlayerLocalize(@"BASE_PLAYER-Module.switchharddecode")];
        } else {
            [self toastTip:TXBasePlayerLocalize(@"BASE_PLAYER-Module.switchsoftdecode")];
        }
        [self startPlay];
    }
}

// 填充模式切换的事件
- (void)onRenderModeSwitch:(BOOL)isFillScreen {
    _renderFillScreen = !_renderFillScreen;

    if (_renderFillScreen) {
        [self.vodPlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
    } else {
        [self.vodPlayer setRenderMode:RENDER_MODE_FILL_EDGE];
    }
}

// 是否开启缓存的事件
- (void)onCacheSwitch:(BOOL)isCache {
    self.enableCache = isCache;
}

#pragma mark - TXBitrateViewDelegate

// 点击分辨率的事件,切换分辨率
- (void)onSelectBitrateIndex {
    // 切换分辨率
    [self.vodPlayer setBitrateIndex:_bitrateView.selectedIndex];
    
    // 同步速率
    [self.vodPlayer setRate:self.currentRate];
}

#pragma mark - 轻提示

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

#pragma mark - Notification Click
//在低系统（如7.1.2）可能收不到这个回调，请在onAppDidEnterBackGround和onAppWillEnterForeground里面处理打断逻辑
- (void)onAudioSessionEvent:(NSNotification *)notification {
    NSDictionary * info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        if (self.playSwitch == YES && self.appIsInterrupt == NO) {
            self.appIsInterrupt = YES;
        }
    }
}

// 应用进入后台
- (void)onAppDidEnterBackGround:(UIApplication *)app {
    if (self.playSwitch == YES) {
        if (!self.videoPause) {
            [self.vodPlayer pause];
        }
    }
}

// 应用将进入前台
- (void)onAppWillEnterForeground:(UIApplication *)app {
    if (self.playSwitch == YES) {
        if (!self.videoPause) {
            [self.vodPlayer resume];
        }
    }
}

// 应用已经在前台
- (void)onAppDidBecomeActive:(UIApplication *)app {
    if (self.playSwitch == YES && self.appIsInterrupt == YES) {
        if (!self.videoPause) {
            [self.vodPlayer resume];
        }
        self.appIsInterrupt = NO;
    }
}

#pragma mark - TXVodPlayListener
- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
    NSDictionary *dict = param;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) { // 视频第一帧
            // 设置Video渲染View,
            [self.vodPlayer setupVideoWidget:self.videoPlayView insertIndex:0];
        } else if (EvtID == PLAY_EVT_VOD_LOADING_END || EvtID == PLAY_EVT_VOD_PLAY_PREPARED) { // 事件是预加载状态或者loading结束事件
            // 停止loading动画
            [self stopLoadingAnimation];
        } else if (EvtID == PLAY_EVT_PLAY_BEGIN) { // 开始播放事件
            self.fullScreenBtn.hidden = NO;
            // 停止loading动画
            [self stopLoadingAnimation];
            NSArray *supportedBitrates = [self.vodPlayer supportedBitrates];
            self.bitrateView.dataSource    = supportedBitrates;
            self.bitrateView.center        = CGPointMake(self.view.frame.size.width - self.bitrateView.frame.size.width / 2, self.view.frame.size.height / 2);
        } else if (EvtID == PLAY_EVT_PLAY_PROGRESS) { // 视频播放进度事件
            [self detailProgresswithParam:dict];
        } else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_EVT_PLAY_END || EvtID == PLAY_ERR_FILE_NOT_FOUND || EvtID == PLAY_ERR_HLS_KEY || EvtID == PLAY_ERR_GET_PLAYINFO_FAIL) { // 链接失败、播放结束等事件
            self.playSwitch = NO;
            [self.bottomView updateStartPlayBtnStateSelected:YES];
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            self.videoPause = NO;
            
            // 网络链接失败的事件
            if (EvtID == PLAY_ERR_NET_DISCONNECT) {
                NSString *Msg = (NSString *)[dict valueForKey:EVT_MSG];
                [self toastTip:Msg];
            }
            // 停止loading动画
            [self stopLoadingAnimation];
        } else if (EvtID == PLAY_EVT_PLAY_LOADING) { // 视频加载中的事件
            [self startLoadingAnimation];
        } else if (EvtID == PLAY_EVT_CONNECT_SUCC) { // 视频链接成功的事件
            [self detailConnectSuccessClick];
        }
        
        // 更新到日志View上
        long long time = [(NSNumber *)[dict valueForKey:EVT_TIME] longLongValue];
        int       mil  = time % 1000;
        NSDate *  date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
        NSString *Msg  = (NSString *)[dict valueForKey:EVT_MSG];
        if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
            if(!player.isPlaying){
                Msg = nil;
            }
            else{
                float progress = [dict[EVT_PLAY_PROGRESS] floatValue];
                Msg = (NSString *)[NSString stringWithFormat:@"%@: %.2f s", Msg, progress];
                time = [[NSDate date] timeIntervalSince1970] * 1000;
                mil = time % 1000;
                date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
            }
        }

        [self.logView appendLog:Msg time:date mills:mil];
    });
}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {
    NSDictionary *dict = param;
    
    // 获取网络状态的数据
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
        [self.logView.logStatusView setText:log];
    });
}

#pragma mark - 处理视频回调事件的私有方法
// 处理进度的方法
- (void)detailProgresswithParam:(NSDictionary *)dict {
    // 如果是正在拖拽，return
    if (self.startSeek) {
        return;
    }
    
    // 获取当前播放时长和总时长
    float progress = [dict[EVT_PLAY_PROGRESS] floatValue];
    float duration = [dict[EVT_PLAY_DURATION] floatValue];
    
    if (progress == 0 && duration == 0) {
        return;
    }
    
    // 显示控件
    self.bottomView.playableProgress.hidden = NO;
    self.bottomView.playProgress.hidden = NO;
    
    // 计算播放时长和进度
    int intProgress = progress + 0.5;
    self.bottomView.playableLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intProgress / 60), (int)(intProgress % 60)];
    [self.bottomView.playProgress setValue:progress];
    
    int intDuration = duration + 0.5;
    if (duration > 0 && self.bottomView.playProgress.maximumValue != duration) {
        [self.bottomView.playProgress setMaximumValue:duration];
        [self.bottomView.playableProgress setMaximumValue:duration];
        self.bottomView.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
    }
    
    // 设置可播放的进度
    [self.bottomView.playableProgress setValue:[dict[EVT_PLAYABLE_DURATION] floatValue]];
}

- (void)detailConnectSuccessClick {
    BOOL isWifi = [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
    if (!isWifi) {
        __weak __typeof(self) weakSelf = self;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (self.topView.urlTextField.text.length == 0) {
                return;
            }
            if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:TXBasePlayerLocalize(@"BASE_PLAYER-Module.switchtowifi")
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:TXBasePlayerLocalize(@"BASE_PLAYER-Module.true")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                            [weakSelf startPlay];
                                                        }]];
                [alert addAction:[UIAlertAction actionWithTitle:TXBasePlayerLocalize(@"BASE_PLAYER-Module.false")
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                        }]];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark - 懒加载

- (UIView *)videoPlayView {
    if (!_videoPlayView) {
        _videoPlayView = [[UIView alloc] init];
        _videoPlayView.center = self.view.center;
    }
    return _videoPlayView;
}

- (TXVodPlayer *)vodPlayer {
    if (!_vodPlayer) {
        _vodPlayer = [[TXVodPlayer alloc] init];
        _vodPlayer.vodDelegate = self;
    }
    return _vodPlayer;
}

- (TXBasePlayerTopView *)topView {
    if (!_topView) {
        _topView = [[TXBasePlayerTopView alloc] init];
        _topView.delegate = self;
    }
    return _topView;
}

- (TXBasePlayerLogView *)logView {
    if (!_logView) {
        _logView = [[TXBasePlayerLogView alloc] init];
        _logView.hidden = YES;
    }
    return _logView;
}

- (TXBasePlayerBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[TXBasePlayerBottomView alloc] init];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        float           width   = 34;
        float           height  = 34;
        float           offsetX = (TX_SCREEN_WIDTH - width) / 2;
        float           offsetY = (TX_SCREEN_HEIGHT - height) / 2;
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                                 [UIImage imageNamed:@"loading_image0.png"],
                                 [UIImage imageNamed:@"loading_image1.png"],
                                 [UIImage imageNamed:@"loading_image2.png"],
                                 [UIImage imageNamed:@"loading_image3.png"],
                                 [UIImage imageNamed:@"loading_image4.png"],
                                 [UIImage imageNamed:@"loading_image5.png"],
                                 [UIImage imageNamed:@"loading_image6.png"],
                                 [UIImage imageNamed:@"loading_image7.png"], nil];
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY, width, height)];
        _loadingImageView.animationImages   = array;
        _loadingImageView.animationDuration = 1;
        _loadingImageView.hidden            = YES;
    }
    return _loadingImageView;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _fullScreenBtn.hidden = YES;
    }
    return _fullScreenBtn;
}

- (TXVodPlayConfig *)vodConfig {
    if (!_vodConfig) {
        _vodConfig = [[TXVodPlayConfig alloc] init];
    }
    return _vodConfig;
}

- (TXBitrateView *)bitrateView {
    if (!_bitrateView) {
        _bitrateView = [[TXBitrateView alloc] initWithFrame:CGRectZero];
        _bitrateView.delegate = self;
    }
    return _bitrateView;
}

- (TXConfigViewController *)configVC {
    if (!_configVC) {
        _configVC = [[TXConfigViewController alloc] init];
    }
    return _configVC;
}

@end
