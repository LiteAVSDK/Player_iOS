//
//  TXSetSpeciResolutionViewController.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//  本模块主要介绍如何使用腾讯云点播播放器在启播时设置视频播放分辨率

#import "TXSetSpeciResolutionViewController.h"
#import "TXSetSpeciResolutionLocalized.h"
#import "TXSetSpeciResolutionLayout.h"
#import "TXSetSpeciResolutionResource.h"
#import "TXSetSpeciResolutionColor.h"
#import <TXLiteAVSDK_Player/TXVodPlayer.h>
#import <Masonry/Masonry.h>

@interface TXSetSpeciResolutionViewController ()

// 承载播放器的容器View
@property (nonatomic, strong) UIView *videoPlayView;

// 点播播放器对象s
@property (nonatomic, strong) TXVodPlayer *vodPlayer;

@end

@implementation TXSetSpeciResolutionViewController

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
    self.title = SetSpeciResolutionLocalize(@"PLAYER-API-Example.Function.SetSpeciResolution.title");
    
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
    
    // 播放器插入到view视图上
    [self insertPlayerView];
    
    // 设置播放器视频分辨率
    [self setResolution];
    
    // 开始播放视频
    [self startPlay];
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
}

- (void)insertPlayerView {
    // 创建Video渲染View,该控件承载着视频内容的展示。
    [self.vodPlayer setupVideoWidget:self.videoPlayView insertIndex:0];
}

- (void)setResolution {
    // 设置视频播放时分辨率
    self.vodPlayer.config.preferredResolution = RESOLUTION_FHD;
}

- (void)startPlay {
    // 开始播放视频，BASE_URL为视频URL
    [self.vodPlayer startVodPlay:@BASE_URL];
}

// 导航栏返回按钮的点击事件处理
- (void)backClick {
    if (self.vodPlayer.isPlaying) {
        // 退到上一层，需要停止播放
        [self.vodPlayer stopPlay];
    }
    if (self.vodPlayer) {
        // 移除Video渲染View
        [self.vodPlayer removeVideoWidget];
        self.vodPlayer = nil;
    }
    
    [self.navigationController popToRootViewControllerAnimated:NO];
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

// 视频播放器
- (TXVodPlayer *)vodPlayer {
    if (!_vodPlayer) {
        _vodPlayer = [[TXVodPlayer alloc] init];
    }
    return _vodPlayer;
}

@end
