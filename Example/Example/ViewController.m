//
//  ViewController.m
//  Example
//
//  Created by annidyfeng on 2018/9/11.
//  Copyright © 2018年 annidy. All rights reserved.
//

#import "ViewController.h"
#import <SuperPlayer/SuperPlayer.h>
#import <MMLayout/UIView+MMLayout.h>
#import "Masonry.h"

@interface ViewController () <UIGestureRecognizerDelegate,SuperPlayerDelegate>
@property UIView *backView;
@property UIView *playerContainer;
@property SuperPlayerView *playerView;
@property CGPoint startPoint;
@property CGPoint originPoint;

@end

@implementation ViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.backView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.backView];
    self.view.backgroundColor = RGBA(0, 0, 0, 1);
   
    self.playerContainer = [[UIView alloc] init];
    self.playerContainer.backgroundColor = [UIColor blackColor];
    [self.backView addSubview:self.playerContainer];
    self.backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.playerContainer.mm_fill();
    
    _playerView = [[SuperPlayerView alloc] init];
    // 设置父View
    _playerView.disableGesture = YES;

    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    playerModel.videoURL = self.url?:@"http://1253131631.vod2.myqcloud.com/26f327f9vodgzp1253131631/f4c0c9e59031868222924048327/f0.mp4";

    self.playerView.fatherView = self.playerContainer;
    self.playerView.delegate = self;

     // 开始播放
    [_playerView playWithModel:playerModel];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesWindow:)];
    panRecognizer.delegate = self;
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelaysTouchesBegan:YES];
    [panRecognizer setDelaysTouchesEnded:YES];
    [panRecognizer setCancelsTouchesInView:YES];
    [self.view addGestureRecognizer:panRecognizer];
    
    self.view.userInteractionEnabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.playerView resetPlayer];
}

- (void)panGesWindow:(UIPanGestureRecognizer *)pan
{
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startPoint = [pan translationInView:self.view];
        self.originPoint = self.playerContainer.frame.origin;
        
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan translationInView:self.view];
        float dx = point.x - self.startPoint.x;
        float dy = point.y - self.startPoint.y;
        
        int progressIndex = (int)dx;
        int moveIndex = (int)dy;



        
        CGFloat alpha = 1- (sqrt(dx*dx+dy*dy) / 500.0);
        if (alpha < 0) alpha = 0;
        if (alpha > 1) alpha = 1;
        self.view.backgroundColor = RGBA(0, 0, 0, alpha);
        
        self.backView.mm_left(progressIndex).mm_top(moveIndex);
        self.backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, alpha/2+0.5, alpha/2+0.5);
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {

        CGFloat alpha;
        [self.view.backgroundColor getWhite:nil alpha:&alpha];
            if (alpha < 0.1) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.backView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                } completion:^(BOOL finished) {
                    [self.playerView resetPlayer];
                    [self.view removeFromSuperview];
                }];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    self.backView.transform = CGAffineTransformIdentity;
                    self.backView.mm_left(0).mm_top(0);
                    self.view.backgroundColor = RGBA(0, 0, 0, 1);
                }];
            }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (void)superPlayerBackAction:(SuperPlayerView *)player
{
    [self.playerView resetPlayer];
    [self.view removeFromSuperview];
}
@end
