//
//  TXControlPanelViewController.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//  本模块主要是介绍如何在锁屏界面显示控制中心和控制控制中心

#import "TXControlPanelViewController.h"
#import "TXControlPanelMacro.h"
#import "TXControlPanelLocalized.h"
#import <TXLiteAVSDK_Player/TXVodPlayer.h>
#import <Masonry/Masonry.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TXControlPanelViewController ()

// 承载播放器的容器View
@property (nonatomic, strong) UIView *videoPlayView;

// 点播播放器对象
@property (nonatomic, strong) TXVodPlayer *vodPlayer;

@end

@implementation TXControlPanelViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // 开始接受控制台事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // 创建远程控制
    [self createRemoteCommandCenter];
    
    // 设置导航栏左边的返回按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, TX_ControlPanel_BACK_BTN_WIDTH, TX_ControlPanel_BACK_BTN_HEIGHT)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@TX_ControlPanel_BACK_IMAGE_NAME] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[leftItem];

    // 设置导航栏标题
    self.title = TXControlPanelLocalize(@"TX_CONTROL_PANEL-Module.Title");

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
    
    // 初始化子View
    [self initChildView];
    
    // 添加进入锁屏界面的监听
    [self addObservers];
    
    // 开始播放
    [self startPlay];
}

- (void)initChildView {
    
    // 添加videoPlayView到父view上，并设置布局
    [self.view addSubview:self.videoPlayView];
    [self.videoPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(TX_ControlPanel_VIDEO_TOP_MARGIN);
        make.height.mas_equalTo(TX_ControlPanel_VIDEO_HEIGHT);
    }];
}

- (void)addObservers {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(updateLockScreenInfo)
                   name:UIApplicationDidEnterBackgroundNotification
                 object:nil];
}

- (void)startPlay {
    // 创建Video渲染View,该控件承载着视频内容的展示。
    [self.vodPlayer setupVideoWidget:self.videoPlayView insertIndex:0];
    
    // 开始播放视频，BASE_URL为视频URL
    [self.vodPlayer startVodPlay:@TX_ControlPanel_URL];
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

#pragma mark - 更新锁屏界面信息
- (void)updateLockScreenInfo {
    // 1.获取锁屏中心
    
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    // 初始化一个存放音乐信息的字典
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    
    // 2、设置名称
    // 2.1、设置歌曲名
    [playingInfoDict setObject:TXControlPanelLocalize(@"TX_CONTROL_PANEL-Module.Property.Title") forKey:MPMediaItemPropertyTitle];
    
    // 2.2、设置专辑名
    [playingInfoDict setObject:TXControlPanelLocalize(@"TX_CONTROL_PANEL-Module.Album.Title") forKey:MPMediaItemPropertyAlbumTitle];
    
    // 3、设置封面的图片
    __block UIImage *image = [UIImage imageNamed:@TX_ControlPanel_Logo];
    if (image) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:
                                       CGSizeMake(TX_ControlPanel_Image_Width, TX_ControlPanel_Image_Height)
                                                                      requestHandler:^UIImage * _Nonnull(CGSize size) {
            return image;
        }];
        [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    }
    
    // 4、设置歌曲的时长和已经消耗的时间
    
    // 当前视频的总时长
    float durationTime = self.vodPlayer.duration;

    // 已经播放的时长
    float playBackTime = self.vodPlayer.currentPlaybackTime;
        
    [playingInfoDict setObject:@(durationTime) forKey:MPMediaItemPropertyPlaybackDuration];
    
    [playingInfoDict setObject:@(playBackTime) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    // 5、音乐信息赋值给获取锁屏中心的nowPlayingInfo属性
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
}

#pragma mark - 远程控制
- (void)createRemoteCommandCenter {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // 暂停控制
    MPRemoteCommand *pauseCommand = [commandCenter pauseCommand];
    [pauseCommand setEnabled:YES];
    [pauseCommand addTarget:self action:@selector(remotePauseEvent)];
    
    // 播放控制
    MPRemoteCommand *playCommand = [commandCenter playCommand];
    [playCommand setEnabled:YES];
    [playCommand addTarget:self action:@selector(remotePlayEvent)];
    
    // 快进控制
    MPRemoteCommand *nextCommand = [commandCenter nextTrackCommand];
    [nextCommand setEnabled:YES];
    [nextCommand addTarget:self action:@selector(remoteNextEvent)];
    
    // 快退控制
    MPRemoteCommand *previousCommand = [commandCenter previousTrackCommand];
    [previousCommand setEnabled:YES];
    [previousCommand addTarget:self action:@selector(remotePreviousEvent)];
    
    // 进度条控制
    if(@available(iOS 9.1, *)) {
        MPRemoteCommand *changePlaybackPositionCommand = [commandCenter changePlaybackPositionCommand];
        [changePlaybackPositionCommand setEnabled:YES];
        [changePlaybackPositionCommand addTarget:self action:@selector(remoteChangePlaybackPosition:)];
    }
}

#pragma mark - 控制Click
// 暂停
- (MPRemoteCommandHandlerStatus)remotePauseEvent {
    [self.vodPlayer pause];
    [self updateLockScreenInfo];
    return MPRemoteCommandHandlerStatusSuccess;
}

// 播放
- (MPRemoteCommandHandlerStatus)remotePlayEvent {
    [self.vodPlayer resume];
    [self updateLockScreenInfo];
    return MPRemoteCommandHandlerStatusSuccess;
}

// 快进
- (MPRemoteCommandHandlerStatus)remoteNextEvent {
    float currentPlayTime = self.vodPlayer.currentPlaybackTime;
    float nextTime = currentPlayTime + TX_ControlPanel_Default_Seek;
    if (nextTime >= self.vodPlayer.duration) {
        nextTime = self.vodPlayer.duration;
    }
    [self.vodPlayer seek:nextTime];
    [self updateLockScreenInfo];
    return MPRemoteCommandHandlerStatusSuccess;
}

// 快退
- (MPRemoteCommandHandlerStatus)remotePreviousEvent {
    float currentPlayTime = self.vodPlayer.currentPlaybackTime;
    float preTime = currentPlayTime - TX_ControlPanel_Default_Seek;
    if (preTime <= 0) {
        preTime = 0;
    }
    [self.vodPlayer seek:preTime];
    [self updateLockScreenInfo];
    return MPRemoteCommandHandlerStatusSuccess;
}

// 跳跃
- (MPRemoteCommandHandlerStatus)remoteChangePlaybackPosition:(MPRemoteCommand*)command{
    //跳跃操作
    [self updateLockScreenInfo];
    return MPRemoteCommandHandlerStatusSuccess;
}

#pragma mark - 懒加载

- (UIView *)videoPlayView {
    if (!_videoPlayView) {
        _videoPlayView = [[UIView alloc] init];
        _videoPlayView.backgroundColor = TX_BlackColor;
    }
    return _videoPlayView;
}

- (TXVodPlayer *)vodPlayer {
    if (!_vodPlayer) {
        _vodPlayer = [[TXVodPlayer alloc] init];
    }
    return _vodPlayer;
}

#pragma mark - dealloc

- (void)dealloc {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self removeCommandCenterTargets];
}

// 移除远程控制
- (void)removeCommandCenterTargets {
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [[commandCenter playCommand] removeTarget:self];
    [[commandCenter pauseCommand] removeTarget:self];
    [[commandCenter nextTrackCommand] removeTarget:self];
    [[commandCenter previousTrackCommand] removeTarget:self];
    
    if(@available(iOS 9.1, *)) {
        [commandCenter.changePlaybackPositionCommand removeTarget:self];
    }
}

@end
