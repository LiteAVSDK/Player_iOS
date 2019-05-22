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
@property BOOL isAutoPaused;
@end

@implementation SimpleMovieController

- (NSString *)playUrl
{
    NSArray *url = @[@"http://1253131631.vod2.myqcloud.com/26f327f9vodgzp1253131631/f4c0c9e59031868222924048327/f0.mp4",
                     @"http://videoqiniu.laosiji.com/ZySuZqFj6MCC2a7uZsPTVzUzdBI=/Fi21D9NWMQqOrhqMbXlxdkRzitXa",
                     @"http://videoqiniu.laosiji.com/e6CRXo2_u_xJP6gOzJU6h6s8new=/Fg2fmesGFjdSeixACoikpFCOLUAK",
                    @"http://videoqiniu.laosiji.com/yohZP1E1q5Q-2_3UC7R-75sI2rE=/FgN7rui4MHgwiOrVgeUN8USFKIa2",
                    @"http://videoqiniu.laosiji.com/ybopElHe9eMNUgJSNqS8T35laqA=/ls15Xy3JyLy5lQ8naVpZAkpjMdGR",
                    @"http://videoqiniu.laosiji.com/ybopElHe9eMNUgJSNqS8T35laqA=/lnLE8Vlt0ThWELqdxT1KRzsd9PrL",
                    @"http://videoqiniu.laosiji.com/yohZP1E1q5Q-2_3UC7R-75sI2rE=/FiNXH9j7hJwfhy3NGt5a8JLB7oaG",
                    @"http://videoqiniu.laosiji.com/CehCoPRgYLCC2gwwNW32k7HxOk8=/lpeifLE_XpjLBE4NVZVGiaU3SA1N",
                    @"http://videoqiniu.laosiji.com/ybopElHe9eMNUgJSNqS8T35laqA=/lpXiRxWPwmlDLejKarTs5_7JnLCR",
                    @"http://videoqiniu.laosiji.com/ybopElHe9eMNUgJSNqS8T35laqA=/ln7ViwIoteWzOuUpBsImuYmQa_Xy",
                    @"http://videoqiniu.laosiji.com/CehCoPRgYLCC2gwwNW32k7HxOk8=/lmGIjRO7EuCKZW65zy-4HYc8uEiy",
                    @"http://videoqiniu.laosiji.com/ybopElHe9eMNUgJSNqS8T35laqA=/lmsi_n0BERbvf_clpkM686hURB3F"];
    
    return url[self.index % url.count];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = [NSString stringWithFormat:@"页面 %d", self.index];
    

    self.playerContainer = [[UIView alloc] init];
    self.playerContainer.backgroundColor = [UIColor blackColor];
    self.playerContainer.mm_width(self.view.mm_w).mm_height(self.view.mm_w*9.0f/16.0f);
    
    _playerView = [[SuperPlayerView alloc] init];
    // 设置父View
    _playerView.disableGesture = YES;
    
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    playerModel.videoURL = [self playUrl];
    self.playerView.delegate = self;
    self.playerView.fatherView = self.playerContainer;
    
    // 开始播放
    [_playerView playWithModel:playerModel];
    [self.view addSubview:self.playerContainer];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"打开新页面" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openVc:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.mm_sizeToFit().mm_vstack(40);
}

- (BOOL)prefersStatusBarHidden {
    return NO;
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

- (void)viewDidAppear:(BOOL)animated
{
    if (self.isAutoPaused) {
        [self.playerView resume];
        self.isAutoPaused = NO;
    }
}

- (void)openVc:(id)sender
{
    SimpleMovieController *vc = [SimpleMovieController new];
    vc.index = self.index+1;
    if (self.playerView.state == StatePlaying || self.playerView.state == StateBuffering) {
        [self.playerView pause];
        self.isAutoPaused = YES;
    } else {
        self.isAutoPaused = NO;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
@end
