//
//  DrmPlayViewController.m
//  Example
//
//  Created by annidyfeng on 2019/3/1.
//  Copyright © 2019年 annidy. All rights reserved.
//

#import "DrmPlayViewController.h"
#import <SuperPlayer/SuperPlayer.h>
#import <SuperPlayer/UIView+MMLayout.h>
#import "Masonry.h"

@interface DrmPlayViewController ()<SuperPlayerDelegate>
@property UIView *playerContainer;
@property SuperPlayerView *playerView;
@end

@implementation DrmPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.playerContainer = [[UIView alloc] init];
    self.playerContainer.backgroundColor = [UIColor blackColor];
    self.playerContainer.m_width(self.view.mm_w).m_height(self.view.mm_w*9.0f/16.0f);
    
    _playerView = [[SuperPlayerView alloc] init];
    // 设置父View
    _playerView.disableGesture = YES;
    
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    SuperPlayerVideoId *video = [[SuperPlayerVideoId alloc] init];
    video.appId = 1253039488;
    video.fileId = @"5285890786273319635";
    video.playDefinition = @"10";
    video.version = FileIdV3;
    playerModel.videoId = video;
    
    self.playerView.delegate = self;
    self.playerView.fatherView = self.playerContainer;
    
    // 开始播放
    [_playerView playWithModel:playerModel];
    [self.view addSubview:self.playerContainer];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectZero];
    text.text = @"getplayinfo v3加密视频";
    text.m_sizeToFit().m_top(_playerContainer.mm_maxY+20);
    [self.view addSubview:text];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)superPlayerBackAction:(SuperPlayerView *)player {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didMoveToParentViewController:(nullable UIViewController *)parent
{
    if (parent == nil) {
        [self.playerView resetPlayer];
    }
}

@end

