//
//  ViewController.m
//  Example
//
//  Created by annidyfeng on 2018/9/11.
//  Copyright © 2018年 annidy. All rights reserved.
//

#import "ViewController.h"
#import <SuperPlayer/SuperPlayer.h>

@interface ViewController ()

@end

@implementation ViewController {
    SuperPlayerView *_playerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _playerView = [[SuperPlayerView alloc] init];
    // 设置父View
    _playerView.fatherView = self.view;
    
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    // 设置播放地址，直播、点播都可以
    playerModel.videoURL = @"http://200024424.vod.myqcloud.com/200024424_709ae516bdf811e6ad39991f76a4df69.f20.mp4";
    // 开始播放
    [_playerView playWithModel:playerModel];
}

@end
