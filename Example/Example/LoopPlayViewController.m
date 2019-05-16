//
//  LoopPlayViewController.m
//  Example
//
//  Created by annidyfeng on 2019/4/1.
//  Copyright © 2019年 annidy. All rights reserved.
//

#import "LoopPlayViewController.h"
#import <SuperPlayer/SuperPlayer.h>
#import <MMLayout/UIView+MMLayout.h>
#import "Masonry.h"

@interface LoopPlayViewController ()
@property UIView *playerContainer;
@property SuperPlayerView *playerView;
@end

@implementation LoopPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.playerContainer = [[UIView alloc] init];
    self.playerContainer.backgroundColor = [UIColor blackColor];
    self.playerContainer.mm_width(self.view.mm_w).mm_height(self.view.mm_w*9.0f/16.0f);
    
    _playerView = [[SuperPlayerView alloc] init];
    // 设置父View
    _playerView.disableGesture = YES;
    
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    playerModel.videoURL = @"http://1253131631.vod2.myqcloud.com/26f327f9vodgzp1253131631/083e16be5285890786960843377/VX00lLxTJGsA.mp4";
    self.playerView.delegate = self;
    self.playerView.loop = YES;
    self.playerView.fatherView = self.playerContainer;
    
    // 开始播放
    [_playerView playWithModel:playerModel];
    [self.view addSubview:self.playerContainer];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectZero];
    text.text = @"循环播放不卡顿";
    text.mm_sizeToFit().mm_top(_playerContainer.mm_maxY+20);
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
