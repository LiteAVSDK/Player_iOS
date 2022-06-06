//
//  FeedPlayViewController.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "FeedPlayViewController.h"
#import "FeedDetailViewController.h"
#import "SuperFeedPlayView.h"
#import "FeedVideoPlayMem.h"
#import <Masonry/Masonry.h>

#import "FeedVideoModel.h"

@interface FeedPlayViewController ()<SuperFeedPlayViewDelegate, CAAnimationDelegate>

@property (nonatomic, strong) SuperFeedPlayView *feedPlayView;

@property (nonatomic, assign) BOOL              isPushToDetail;

@property (nonatomic, strong) UIView            *superPlayView;

@end

@implementation FeedPlayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // 左侧返回按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 60, 25)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[leftItem];

    self.title = @"Feed流播放";
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isPushToDetail) {
        [self.feedPlayView addSuperPlayView:self.superPlayView];
        self.isPushToDetail = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.feedPlayView];
    
    // 初始化feedPlayView的子组件
    [self.feedPlayView initChildView];
    
    [self.feedPlayView setFeedData:[self loadTestData] isCleanData:YES];
}

#pragma mark - click
- (void)backClick {
    [self.feedPlayView removeVideo];
    self.feedPlayView = nil;
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - SuperFeedPlayViewDelegate
- (void)refreshNewFeedData {
    [self.feedPlayView finishRefresh];
    [self.feedPlayView setFeedData:[self getRandomArrFrome:[self loadTestData]] isCleanData:YES];
}

- (void)loadNewFeedDataWithPage:(NSInteger)page {
    [self.feedPlayView finishLoadMore];
    [self.feedPlayView setFeedData:[self getRandomArrFrome:[self loadTestData]] isCleanData:NO];
}

- (void)showFeedDetailViewWithHeadModel:(FeedHeadModel *)model videoModel:(FeedVideoModel *)videoModel playView:(UIView *)superPlayView {
    self.isPushToDetail = YES;
    self.superPlayView = superPlayView;
    
    FeedDetailViewController *detailVC = [[FeedDetailViewController alloc] init];
    detailVC.headModel = model;
    detailVC.superPlayView = superPlayView;
    detailVC.detailListData = [self loadTestData];
    detailVC.videoModel = videoModel;
    [self.navigationController pushViewController:detailVC animated:NO];
}

#pragma mark - 懒加载
- (SuperFeedPlayView *)feedPlayView {
    if (!_feedPlayView) {
        _feedPlayView = [[SuperFeedPlayView alloc] init];
        _feedPlayView.frame = CGRectMake(0, kNavBarAndStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarAndStatusBarHeight);
        _feedPlayView.delegate = self;
    }
    return _feedPlayView;
}

#pragma mark - 测试数据
- (NSMutableArray *)loadTestData {
    NSMutableArray *result = [NSMutableArray array];
    
    FeedVideoModel *model1 = [FeedVideoModel new];
    model1.appId = 1500005830;
    model1.fileId = @"387702299774251236";
    model1.duration = 42;
    model1.title = @"腾讯云音视频成就";
    model1.videoIntroduce = @"自2018年以来，腾讯云音视频取得“四连冠";
    model1.coverUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/48d0f1f9387702299774251236/387702299947979020.png";
    model1.videoDesStr = @"在TRTC、音视频编解码、RT-ONE音视频融合网络、腾讯云视立方音视频终端等做出杰出成绩";
    [result addObject:model1];
    
    FeedVideoModel *model2 = [FeedVideoModel new];
    model2.appId = 1500005830;
    model2.fileId = @"387702299774544650";
    model2.duration = 65;
    model2.title = @"腾讯云音视频——稳";
    model2.videoIntroduce = @"腾讯云音视频就是稳，根本不会卡";
    model2.coverUrl = @"http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/4fc009be387702299774544650/coverBySnapshot/coverBySnapshot_10_0.jpg";
    model2.videoDesStr = @"超21年技术沉淀，“三合一”RT-ONE音视频通信网络，腾讯云音视频就是稳";
    [result addObject:model2];
    
    FeedVideoModel *model3 = [FeedVideoModel new];
    model3.appId = 1500005830;
    model3.fileId = @"387702299774644824";
    model3.duration = 57;
    model3.title = @"腾讯云音视频——真";
    model3.videoIntroduce = @"腾讯云音视频就是真";
    model3.coverUrl = @"http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/52153a82387702299774644824/coverBySnapshot/coverBySnapshot_10_0.jpg";
    model3.videoDesStr = @"试听效果真，场景还原真，互动体验真，腾讯云音视频就是真";
    [result addObject:model3];
    
    FeedVideoModel *model4 = [FeedVideoModel new];
    model4.appId = 1500005830;
    model4.fileId = @"387702299774211080";
    model4.duration = 51;
    model4.title = @"腾讯云音视频——全";
    model4.videoIntroduce = @"腾讯云视立方解决方案就是全";
    model4.coverUrl = @"http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/48888812387702299774211080/coverBySnapshot/coverBySnapshot_10_0.jpg";
    model4.videoDesStr = @"产品矩阵全，解决方案全，场景覆盖全，腾讯云音视频就是全";
    [result addObject:model4];
    
    FeedVideoModel *model5 = [FeedVideoModel new];
    model5.appId = 1500005830;
    model5.fileId = @"387702299774545556";
    model5.duration = 94;
    model5.title = @"腾讯云业务介绍";
    model5.videoIntroduce = @"腾讯云，值得信赖的产业数据化助手";
    model5.coverUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/4fc091e4387702299774545556/387702299947278317.png";
    model5.videoDesStr = @"腾讯云与您共建数字新基建，助力数字经济新发展";
    [result addObject:model5];
    
    FeedVideoModel *model6 = [FeedVideoModel new];
    model6.appId = 1500005830;
    model6.fileId = @"387702299774574470";
    model6.duration = 78;
    model6.title = @"数字是什么";
    model6.videoIntroduce = @"在未来，你关注的数字是什么？";
    model6.coverUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/4ff64b01387702299774574470/387702299947750409.png";
    model6.videoDesStr = @"在未来，数字创造数字，腾讯云，值得信赖的产业数据化助手";
    [result addObject:model6];
    
    FeedVideoModel *model7 = [FeedVideoModel new];
    model7.appId = 1500005830;
    model7.fileId = @"387702299774253670";
    model7.duration = 113;
    model7.title = @"化繁为简，以小建大";
    model7.videoIntroduce = @"腾讯云提出“化繁为简，以小建大”的品牌理念";
    model7.coverUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/48d21c3d387702299774253670/387702299947604155.png";
    model7.videoDesStr = @"繁复的数字化过程“简单化”，用小巧的模块助力企业实现“大梦想”";
    [result addObject:model7];
    
    FeedVideoModel *model8 = [FeedVideoModel new];
    model8.appId = 1500005830;
    model8.fileId = @"387702299774390972";
    model8.duration = 133;
    model8.title = @"腾讯云音视频";
    model8.videoIntroduce = @"开启全真互联新时代";
    model8.coverUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/4b6e0e84387702299774390972/387702299947629622.png";
    model8.videoDesStr = @"腾讯云音视频提供坚实的Paas能力，和亿万用户共创共赢";
    [result addObject:model8];
    
    return result;
}

-(NSMutableArray*)getRandomArrFrome:(NSArray*)arr {
    NSMutableArray *newArr = [NSMutableArray new];
    while (newArr.count != arr.count) {
        //生成随机数
        int x =arc4random() % arr.count;
        id obj = arr[x];
        if (![newArr containsObject:obj]) {
            [newArr addObject:obj];
        }
    }
    return newArr;
}


@end
