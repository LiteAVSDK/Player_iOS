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
    model1.appId = 1252463788;
    model1.fileId = @"5285890781763144364";
    model1.duration = 60;
    model1.title = @"腾讯云介绍";
    model1.videoIntroduce = @"性能强大、安全、稳定的云产品，多年技术沉淀";
    model1.coverUrl = @"http://1252463788.vod2.myqcloud.com/95576ef5vodtransgzp1252463788/e1ab85305285890781763144364/1536584350_1812858038.100_0.jpg";
    model1.videoDesStr = @"腾讯多年技术沉淀，300+ 款产品共筑腾讯云产品矩阵，从基础设施到行业应用领域，腾讯云提供完善的产品体系，助力您的业务腾飞";
    [result addObject:model1];
    
    FeedVideoModel *model2 = [FeedVideoModel new];
    model2.appId = 1500005830;
    model2.fileId = @"8602268011437356984";
    model2.duration = 102;
    model2.title = @"2分钟带你认识云点播";
    model2.videoIntroduce = @"一站式VPaaS(Video Platform as a Service)解决方案";
    model2.coverUrl = @"http://1252463788.vod2.myqcloud.com/95576ef5vodtransgzp1252463788/e1ab85305285890781763144364/1536584350_1812858038.100_0.jpg";
    model2.videoDesStr = @"腾讯云点播（Video on Demand，VOD）基于腾讯多年技术积累与基础设施建设，为有音视频应用相关需求的客户提供包括音视频存储管理、音视频转码处理、音视频加速播放和音视频通信服务的一站式解决方案";
    [result addObject:model2];
    
    FeedVideoModel *model3 = [FeedVideoModel new];
    model3.appId = 1252463788;
    model3.fileId = @"4564972819219071679";
    model3.duration = 30;
    model3.title = @"小直播app-在线直播解决方案";
    model3.videoIntroduce = @"可以实现登录、注册、开播、房间列表、连麦互动、文字互动和弹幕消息等功能";
    model3.coverUrl = @"http://1252463788.vod2.myqcloud.com/e12fcc4dvodgzp1252463788/287432564564972819219071679/4564972819211741129.jpeg";
    model3.videoDesStr = @"基于云直播服务、即时通信（IM）和对象存储服务（COS）构建，并使用云服务器（CVM）提供简单的后台服务，实现多项直播功能";
    [result addObject:model3];
    
    FeedVideoModel *model4 = [FeedVideoModel new];
    model4.appId = 1400329073;
    model4.fileId = @"5285890800381567412";
    model4.duration = 54;
    model4.title = @"小视频app";
    model4.videoIntroduce = @"腾讯云短视频演示";
    model4.coverUrl = @"http://1400329073.vod2.myqcloud.com/ff439affvodcq1400329073/59c68fe75285890800381567412/5285890800770323326.jpg";
    model4.videoDesStr = @"短视频 （User Generated Short Video，UGSV）基于腾讯云强大的上传、存储、转码、分发的云点播能力，提供集成了采集、剪辑、拼接、特效、分享、播放等功能的客户端 SDK";
    [result addObject:model4];
    
    FeedVideoModel *model5 = [FeedVideoModel new];
    model5.appId = 1252463788;
    model5.fileId = @"4564972819219071668";
    model5.duration = 40;
    model5.title = @"小直播app主播连麦";
    model5.videoIntroduce = @"利用小直播app实现连麦互动、文字互动和弹幕消息等功能";
    model5.coverUrl = @"http://1252463788.vod2.myqcloud.com/e12fcc4dvodgzp1252463788/287432344564972819219071668/4564972819212551204.jpeg";
    model5.videoDesStr = @"基于云直播服务、即时通信（IM）和对象存储服务（COS）构建，并使用云服务器（CVM）提供简单的后台服务，实现多项直播功能";
    [result addObject:model5];
    
    FeedVideoModel *model6 = [FeedVideoModel new];
    model6.appId = 1400329073;
    model6.fileId = @"5285890800381530399";
    model6.duration = 49;
    model6.title = @"小直播app基础功能";
    model6.videoIntroduce = @"小直播直播美颜、观众评论点赞等基础功能";
    model6.coverUrl = @"http://1400329073.vod2.myqcloud.com/ff439affvodcq1400329073/598c6c8b5285890800381530399/5285890800770353759.jpeg";
    model6.videoDesStr = @"基于云直播服务、即时通信（IM）和对象存储服务（COS）构建，并使用云服务器（CVM）提供简单的后台服务，实现多项直播功能";
    [result addObject:model6];
    
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
