//
//  TXPreDownloadAndPreloadingViewController.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//  本模块主要介绍如何使用腾讯云点播播放器利用预下载和预加载播放视频

#import "TXPreDownloadAndPreloadingViewController.h"
#import "TXPreDownloadAndPreloadingLocalized.h"
#import "TXPreDownloadAndPreloadingLayout.h"
#import "TXPreDownloadAndPreloadingResource.h"
#import "TXPreDownloadAndPreloadingColor.h"
#import <TXLiteAVSDK_Player/TXVodPlayer.h>
#import <TXLiteAVSDK_Player/TXPlayerGlobalSetting.h>
#import <TXLiteAVSDK_Player/TXVodPreloadManager.h>
#import <Masonry/Masonry.h>

@interface TXPreDownloadAndPreloadingViewController () <TXVodPlayListener, TXVodPreloadManagerDelegate>

// 承载播放器的容器View
@property (nonatomic, strong) UIView *videoPlayView;

// 第一个视频的点播播放器对象
@property (nonatomic, strong) TXVodPlayer *firstVodPlayer;

// 第二个视频的点播播放器对象
@property (nonatomic, strong) TXVodPlayer *secondVodPlayer;

// 开始播放按钮
@property (nonatomic, strong) UIButton *startBtn;

// 预加载视频是否加载完成
@property (nonatomic, assign) BOOL isPlayerPrePared;

// 预下载任务ID
@property (nonatomic, assign) int preDownloadTaskID;

@end

@implementation TXPreDownloadAndPreloadingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // 设置导航栏左边的返回按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, BACK_BTN_WIDTH, BACK_BTN_HEIGHT)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@BACK_IMAGE_NAME] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    // 设置导航栏标题
    self.title = PreDownloadAndPreloadingLocalize(@"PLAYER-API-Example.Function.PreDownloadAndPreloading.title");
    
    // 设置View的背景色
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *colors = @[(__bridge id)RGB(19.0, 41.0, 75.0).CGColor, (__bridge id)RGB(5.0, 12.0, 23.0).CGColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建初始视图
    [self createView];
    
    // 下载设置
    [self setDownloadConfig];
    
    // 预下载第一个视频
    [self preDownload];
}

- (void)createView {
    // 添加videoPlayView到父view上，并设置布局
    [self.view addSubview:self.videoPlayView];
    [self.videoPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(VIDEO_TOP_MARGIN);
        make.height.mas_equalTo(VIDEO_HEIGHT);
    }];
    
    // 添加startBtn到父view上，并设置布局
    [self.view addSubview:self.startBtn];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.videoPlayView).offset(BUTTON_MARGIN + VIDEO_TOP_MARGIN + VIDEO_HEIGHT);
        make.height.mas_equalTo(BUTTON_MARGIN);
        make.width.mas_equalTo(BUTTON_WIDTH);
    }];

}

- (void)setDownloadConfig {
    // 获取沙盒documents文件夹路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // 预下载文件夹路径
    NSString *preloadDataPath = [documentsDirectory stringByAppendingPathComponent:@PREDOWNLOAD_DATA_PATH];
    // 预下载文件夹不存在则重新创建文件夹
    if (![[NSFileManager defaultManager] fileExistsAtPath:preloadDataPath]) {
         [[NSFileManager defaultManager] createDirectoryAtPath:preloadDataPath
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:nil];
    }
    
    // 设置缓存路径
    [TXPlayerGlobalSetting setCacheFolderPath:preloadDataPath];
    // 设置播放引擎缓存大小
    [TXPlayerGlobalSetting setMaxCacheSize:MAX_CACHE_SIZE];
}

- (void)preDownload {
    // 启动预下载
    self.preDownloadTaskID = [[TXVodPreloadManager sharedManager] startPreload:@FIRST_VIDEO_URL preloadSize:MAX_CACHE_SIZE preferredResolution:VIDEO_RESOLUTION_720X1280 delegate:self];
}

- (void)insertPlayerView {
    // 将第一个视频的播放器插入到view视图上
    [self.firstVodPlayer setupVideoWidget:self.videoPlayView insertIndex:0];
}

- (void)startPlay {
    // 播放第一个视频: 如果将 isAutoPlay 设置为 YES， 那么 startPlay 调用会立刻开始视频的加载和播放
    self.firstVodPlayer.isAutoPlay = YES;
    // 开始播放视频前取消预下载
    [[TXVodPreloadManager sharedManager] stopPreload:self.preDownloadTaskID];
    [self.firstVodPlayer startVodPlay:@FIRST_VIDEO_URL];
    
    // 在播放第一个视频的同时，预加载第二个视频，做法是将 isAutoPlay 设置为 NO
    self.secondVodPlayer.isAutoPlay = NO;
    self.isPlayerPrePared = NO;
    [self.secondVodPlayer startVodPlay:@SECOND_VIDEO_URL];
}

#pragma mark - Click

- (void)startClick {
    // 播放器插入到view视图上
    [self insertPlayerView];

    // 开始播放视频
    [self startPlay];
}

// 导航栏返回按钮的点击事件处理
- (void)backClick {
    // 第一个视频还在播放时,退到上一层停止第一个视频的播放
    if (self.firstVodPlayer.isPlaying) {
        [self.firstVodPlayer stopPlay];
        [self.firstVodPlayer removeVideoWidget];
    }
    else {
        // 退到上一层，停止播放第二个视频
        [self.secondVodPlayer stopPlay];
        // 移除Video渲染View
        [self.secondVodPlayer removeVideoWidget];
    }
    self.firstVodPlayer = nil;
    self.secondVodPlayer = nil;

    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - TXVodPlayListener

-(void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param {
    // 第一个视频播放结束
    if (EvtID == PLAY_EVT_PLAY_END) {
        // 停止第一个视频的播放
        [self.firstVodPlayer stopPlay];
        if (_isPlayerPrePared) {
            // 将第二个视频的播放器插入到view视图
            [self.secondVodPlayer setupVideoWidget:self.videoPlayView insertIndex:0];
            // 播放第二个视频
            [self.secondVodPlayer resume];
        }
    }
    // 第二个视频加载完成
    else if (EvtID == PLAY_EVT_VOD_PLAY_PREPARED) {
        _isPlayerPrePared = YES;
    }
}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {}

- (void)onPlayer:(TXVodPlayer *)player pictureInPictureErrorDidOccur:(TX_VOD_PLAYER_PIP_ERROR_TYPE)errorType withParam:(NSDictionary *)param {}

- (void)onPlayer:(TXVodPlayer *)player pictureInPictureStateDidChange:(TX_VOD_PLAYER_PIP_STATE)pipState withParam:(NSDictionary *)param {}

#pragma mark - 懒加载

// 承载播放器的容器view
- (UIView *)videoPlayView {
    if (!_videoPlayView) {
        _videoPlayView = [[UIView alloc] init];
        _videoPlayView.backgroundColor = [UIColor blackColor];
    }
    return _videoPlayView;
}

// 播放第一个视频的播放器
- (TXVodPlayer *)firstVodPlayer {
    if (!_firstVodPlayer) {
        _firstVodPlayer = [[TXVodPlayer alloc] init];
        // 设置事件监听委托
        _firstVodPlayer.vodDelegate = self;
    }
    return _firstVodPlayer;
}

// 播放第二个视频的播放器
- (TXVodPlayer *)secondVodPlayer {
    if (!_secondVodPlayer) {
        _secondVodPlayer = [[TXVodPlayer alloc] init];
        // 设置事件监听委托
        _secondVodPlayer.vodDelegate = self;
    }
    return _secondVodPlayer;
}

// 播放预下载的视频的按钮
- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.backgroundColor = [UIColor blackColor];
        [_startBtn setTitle:PreDownloadAndPreloadingLocalize(@"PLAYER-API-Example.Function.PreDownloadAndPreloading.startBtn") forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

@end
