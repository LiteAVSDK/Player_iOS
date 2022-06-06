//
//  FeedDetailViewController.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/11/4.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "FeedDetailView.h"
#import "FeedVideoPlayMem.h"
#import "SuperPlayer.h"

@interface FeedDetailViewController ()

@property (nonatomic, strong) FeedDetailView    *detailView;

@end

@implementation FeedDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // 左侧返回按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(5, 0, 150, 35)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[leftItem];

    self.title = @"视频详情";
    
    // 背景色
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *colors = @[(__bridge id)[UIColor colorWithRed:19.0 / 255.0 green:41.0 / 255.0 blue:75.0 / 255.0 alpha:1].CGColor,
                        (__bridge id)[UIColor colorWithRed:5.0 / 255.0 green:12.0 / 255.0 blue:23.0 / 255.0 alpha:1].CGColor];
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
    [self.view addSubview:self.detailView];
    [self.detailView setModel:self.headModel];
    [self.detailView setVideoModel:self.videoModel];
    [self.detailView setSuperPlayView:(SuperPlayerView *)self.superPlayView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.detailView setListData:self.detailListData];
    });
}

- (void)backClick {
    [self.detailView destory];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - 懒加载
- (FeedDetailView *)detailView {
    if (!_detailView) {
        _detailView = [FeedDetailView new];
        _detailView.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarAndStatusBarHeight);
    }
    return _detailView;
}

@end
