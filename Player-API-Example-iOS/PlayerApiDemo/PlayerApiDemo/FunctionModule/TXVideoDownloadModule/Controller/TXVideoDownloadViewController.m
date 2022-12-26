//
//  TXVideoDownloadViewController.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//  本模块

#import "TXVideoDownloadViewController.h"
#import "TXVideoDownloadMacro.h"
#import "TXVideoDownloadLocalized.h"
#import <TXLiteAVSDK_Player/TXVodPlayer.h>
#import <TXLiteAVSDK_Player/TXVodDownloadManager.h>
#import <Masonry/Masonry.h>

@interface TXVideoDownloadViewController ()<TXVodDownloadDelegate>

// 承载播放器的容器View
@property (nonatomic, strong) UIView *videoPlayView;

// 开始下载按钮
@property (nonatomic, strong) UIButton *startDownloadBtn;

// 停止下载按钮
@property (nonatomic, strong) UIButton *stopDownloadBtn;

// 视频下载的进度视图
@property (nonatomic, strong) UIProgressView *downloadProgressView;

// 点播播放器对象
@property (nonatomic, strong) TXVodPlayer *vodPlayer;

// 视频下载Manager
@property (nonatomic, strong) TXVodDownloadManager *downloadManager;

// 视频信息
@property (nonatomic, strong) TXVodDownloadMediaInfo *mediaInfo;

// 提示控件
@property (nonatomic, strong) UIActivityIndicatorView *downloadLoadingView;

@property (nonatomic, assign) BOOL isDownload;

@end

@implementation TXVideoDownloadViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // 设置导航栏左边的返回按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 60, 25)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@TX_Download_BACK_IMAGE_NAME] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    // 设置导航栏标题
    self.title = TXVideoDownloadLocalize(@"TX_VIDEO_DOWNLOAD-Module.Title");
    
    // 设置View的背景色
    self.view.backgroundColor = TX_WhiteColor;
    NSArray *colors = @[(__bridge id)TX_RGBA(19, 41, 75, 1).CGColor,
                        (__bridge id)TX_RGBA(5, 12, 23, 1).CGColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建初始化视图
    [self initChildView];
    
    // 播放器插入到view视图上
    [self insertPlayerView];
    
    // 初始化下载器，并设置路径
    [self setUpDownloadManager];

}

#pragma mark - Private Method

- (void)initChildView {
    
    // 添加videoPlayView到父view上，并设置布局
    [self.view addSubview:self.videoPlayView];
    [self.videoPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(TX_NavBarAndStatusBarHeight);
        make.height.mas_equalTo(TX_VIDEO_HEIGHT);
    }];
    
    // 添加downloadProgressView到父view上，并设置布局
    [self.view addSubview:self.downloadProgressView];
    [self.downloadProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(TX_Progress_Margin);
        make.right.equalTo(self.view).offset(-TX_Progress_Margin);
        make.height.mas_equalTo(TX_Progress_HEIGHT);
        make.top.equalTo(self.videoPlayView).offset(TX_VIDEO_HEIGHT + TX_Progress_Margin);
    }];
    
    // 添加startDownloadBtn到父view上，并设置布局
    [self.view addSubview:self.startDownloadBtn];
    [self.startDownloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(TX_BUTTON_MARGIN);
        make.top.equalTo(self.downloadProgressView).offset(TX_BUTTON_MARGIN + TX_Progress_HEIGHT);
        make.height.mas_equalTo(TX_BUTTON_MARGIN);
        make.width.mas_equalTo(TX_BUTTON_WIDTH);
    }];
    
    // 添加stopDownloadBtn到父view上，并设置布局
    [self.view addSubview:self.stopDownloadBtn];
    [self.stopDownloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-TX_BUTTON_MARGIN);
        make.top.equalTo(self.downloadProgressView).offset(TX_BUTTON_MARGIN + TX_Progress_HEIGHT);
        make.height.mas_equalTo(TX_BUTTON_MARGIN);
        make.width.mas_equalTo(TX_BUTTON_WIDTH);
    }];
}

- (void)insertPlayerView {
    // 创建Video渲染View,该控件承载着视频内容的展示。
    [self.vodPlayer setupVideoWidget:self.videoPlayView insertIndex:0];
}

- (void)setUpDownloadManager {
    // 初始化视频下载器
    self.downloadManager = [TXVodDownloadManager shareInstance];
    
    // 设置视频下载器的代理
    self.downloadManager.delegate = self;
    
    // 设置视频下载的路径
    [self.downloadManager setDownloadPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@TX_Download_Path]];
}

- (void)startPlayWithUrl:(NSString *)url {
    // 开始播放视频
    [self.vodPlayer startVodPlay:url];
}

// 展示提示控件带文字
- (void)setDownloadLoadingViewWithText:(NSString *)text {
    
    // 根据文字和特定字体大小计算宽度
    CGFloat width=[(NSString *)text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 21)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:
                                                               [UIFont systemFontOfSize:TX_LOADING_FONT_SIZE]}
                                                 context:nil].size.width;
    
    // 计算提示控件在frame
    CGFloat x = (TX_SCREEN_WIDTH - (width + TX_LOADING_WIDTH_MARGIN)) / 2;
    CGFloat y = (TX_SCREEN_HEIGHT / 2) - TX_LOADING_HEIGHT;
    CGFloat w = width + TX_LOADING_WIDTH_MARGIN;
    CGFloat h = TX_LOADING_HEIGHT * 2;
    
    self.downloadLoadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x,y,w,h)];
    self.downloadLoadingView.backgroundColor = TX_BlackColor;
    self.downloadLoadingView.layer.cornerRadius = 10;
    self.downloadLoadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    // 设置提示文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(
                                                               TX_LOADING_LABEL_MARGIN,
                                                               TX_LOADING_LABEL_MARGIN + TX_LOADING_HEIGHT,
                                                               width,
                                                               TX_LOADING_LABEL_HEIGHT)];
    label.text = text;
    label.font = [UIFont systemFontOfSize:TX_LOADING_FONT_SIZE];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = TX_WhiteColor;
    
    // 将提示控件添加到父view上
    [self.downloadLoadingView addSubview:label];
    [self.view addSubview:self.downloadLoadingView];
}

void tx_downloadModule_dispatch_to_main_queue(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
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

// 开始下载
- (void)startDownloadVideoClick {
    // 如果正在下载，return
    if (self.isDownload) {
        return;
    }
    
    // 提示框显示
    [self setDownloadLoadingViewWithText:TXVideoDownloadLocalize(@"TX_VIDEO_DOWNLOAD-Module.StartDownload")];
    
    // 开始菊花动画
    [self.downloadLoadingView startAnimating];
    
    // 开始下载
    [self.downloadManager startDownload:@TX_Download_UserName url:@TX_Download_URL];
}

- (void)stopDownloadVideoClick {
    
    // 停止下载
    [self.downloadManager stopDownload:self.mediaInfo];
}

#pragma mark - TXVodDownloadDelegate

/// 下载开始
- (void)onDownloadStart:(TXVodDownloadMediaInfo *)mediaInfo {
    
    // 停止动画
    TX_WEAKIFY(self);
    tx_downloadModule_dispatch_to_main_queue(^{
        TX_STRONGIFY(self);
        [self.downloadLoadingView stopAnimating];
    });
    
    // 赋值视频信息
    self.mediaInfo = mediaInfo;
    self.isDownload = YES;
}

/// 下载进度
- (void)onDownloadProgress:(TXVodDownloadMediaInfo *)mediaInfo {
    
    // 主线程更新进度条
    TX_WEAKIFY(self);
    tx_downloadModule_dispatch_to_main_queue(^{
        TX_STRONGIFY(self);
        self.downloadProgressView.progress = mediaInfo.progress;
    });
}

/// 下载停止
- (void)onDownloadStop:(TXVodDownloadMediaInfo *)mediaInfo {
    self.isDownload = NO;
    
    // 显示提示框
    TX_WEAKIFY(self);
    tx_downloadModule_dispatch_to_main_queue(^{
        TX_STRONGIFY(self);
        [self setDownloadLoadingViewWithText:TXVideoDownloadLocalize(@"TX_VIDEO_DOWNLOAD-Module.DownloadIsStop")];
    });
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        TX_STRONGIFY(self);
        [self.downloadLoadingView stopAnimating];
    });
}

/// 下载完成
- (void)onDownloadFinish:(TXVodDownloadMediaInfo *)mediaInfo {
    self.mediaInfo = mediaInfo;
    self.isDownload = NO;
    
    // 显示提示框
    TX_WEAKIFY(self);
    tx_downloadModule_dispatch_to_main_queue(^{
        TX_STRONGIFY(self);
        [self setDownloadLoadingViewWithText:TXVideoDownloadLocalize(@"TX_VIDEO_DOWNLOAD-Module.DownloadIsFinish")];
    });
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(1 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        TX_STRONGIFY(self);
        [self.downloadLoadingView stopAnimating];
        
        // 下载完成后播放下载的视频
        [self startPlayWithUrl:mediaInfo.playPath];
    });
}

/// 下载错误
- (void)onDownloadError:(TXVodDownloadMediaInfo *)mediaInfo errorCode:(TXDownloadError)code errorMsg:(NSString *)msg {
    
    // 显示提示框
    TX_WEAKIFY(self);
    tx_downloadModule_dispatch_to_main_queue(^{
        TX_STRONGIFY(self);
        [self setDownloadLoadingViewWithText:TXVideoDownloadLocalize(@"TX_VIDEO_DOWNLOAD-Module.DownloadIsError")];
    });
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(1 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        TX_STRONGIFY(self);
        [self.downloadLoadingView stopAnimating];
    });
}

/// 下载HLS，遇到加密的文件，将解密key给外部校验
- (int)hlsKeyVerify:(TXVodDownloadMediaInfo *)mediaInfo url:(NSString *)url data:(NSData *)data {
    return 0;
}

#pragma mark - 懒加载

// 承载播放器的容器view
- (UIView *)videoPlayView {
    if (!_videoPlayView) {
        _videoPlayView = [[UIView alloc] init];
        _videoPlayView.backgroundColor = [UIColor blackColor];
    }
    return _videoPlayView;
}

// 开始下载视频
- (UIButton *)startDownloadBtn {
    if (!_startDownloadBtn) {
        _startDownloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startDownloadBtn.backgroundColor = TX_BlackColor;
        [_startDownloadBtn setTitle:TXVideoDownloadLocalize(@"TX_VIDEO_DOWNLOAD-Module.StartDownload") forState:UIControlStateNormal];
        [_startDownloadBtn setTitleColor:TX_WhiteColor forState:UIControlStateNormal];
        [_startDownloadBtn addTarget:self action:@selector(startDownloadVideoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startDownloadBtn;
}

// 停止下载视频
- (UIButton *)stopDownloadBtn {
    if (!_stopDownloadBtn) {
        _stopDownloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopDownloadBtn.backgroundColor = TX_BlackColor;
        [_stopDownloadBtn setTitle:TXVideoDownloadLocalize(@"TX_VIDEO_DOWNLOAD-Module.StopDownload") forState:UIControlStateNormal];
        [_stopDownloadBtn setTitleColor:TX_WhiteColor forState:UIControlStateNormal];
        [_stopDownloadBtn addTarget:self action:@selector(stopDownloadVideoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopDownloadBtn;
}

// 视频下载进度条
- (UIProgressView *)downloadProgressView {
    if (!_downloadProgressView) {
        _downloadProgressView = [[UIProgressView alloc] init];
        [_downloadProgressView setProgress:0 animated:YES];
    }
    return _downloadProgressView;
}

// 视频播放器
- (TXVodPlayer *)vodPlayer {
    if (!_vodPlayer) {
        _vodPlayer = [[TXVodPlayer alloc] init];
    }
    return _vodPlayer;
}

@end
