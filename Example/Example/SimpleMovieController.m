//
//  SimpleMovieController.m
//  Example
//
//  Created by annidyfeng on 2019/1/18.
//  Copyright © 2019年 annidy. All rights reserved.
//

#import "SimpleMovieController.h"
#import <SuperPlayer/SuperPlayer.h>
#import <MMLayout/UIView+MMLayout.h>
#import "Masonry.h"

@interface SimpleMovieController ()<SuperPlayerDelegate>
@property UIView *playerContainer;
@property SuperPlayerView *playerView;
@end

@implementation SimpleMovieController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.playerContainer = [[UIView alloc] init];
    self.playerContainer.backgroundColor = [UIColor blackColor];
    self.playerContainer.m_width(self.view.mm_w).m_height(self.view.mm_w*9.0f/16.0f);
    
    _playerView = [[SuperPlayerView alloc] init];
    // 设置父View
    _playerView.disableGesture = YES;
    
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    playerModel.videoURL = @"http://1253131631.vod2.myqcloud.com/26f327f9vodgzp1253131631/f4c0c9e59031868222924048327/f0.mp4";
    self.playerView.delegate = self;
    self.playerView.autoPlay = NO; // 如果想一进来播放，autoPlay设为YES
    self.playerView.fatherView = self.playerContainer;
    
    // 开始播放
    [_playerView playWithModel:playerModel];
    [self.view addSubview:self.playerContainer];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectZero];
    text.text = @"在这里放一些自己的逻辑……";
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
