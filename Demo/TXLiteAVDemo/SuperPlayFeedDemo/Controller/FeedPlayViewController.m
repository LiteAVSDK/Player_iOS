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
#import <SDWebImage/SDImageCache.h>
#import "FeedVideoModel.h"
#import "FeedRequestUtil.h"
#import "AppLocalized.h"

@interface FeedPlayViewController ()<SuperFeedPlayViewDelegate, CAAnimationDelegate>

@property (nonatomic, strong) SuperFeedPlayView *feedPlayView;

@property (nonatomic, assign) BOOL              isPushToDetail;

@property (nonatomic, strong) UIView            *superPlayView;

@property (nonatomic, assign) BOOL              isDash;

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

    self.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.title");
    
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
}

#pragma mark - click
- (void)backClick {
    [self.feedPlayView removeVideo];
    self.feedPlayView = nil;
    [[SDImageCache sharedImageCache] clearMemory];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - SuperFeedPlayViewDelegate
- (void)refreshNewFeedData {
    __weak typeof(self) weakSelf = self;
    [self loadTestDataWithsuccess:^(NSMutableArray *list) {
        [weakSelf.feedPlayView finishRefresh];
        [weakSelf.feedPlayView setFeedData:[weakSelf getRandomArrFrome:list] isCleanData:YES];
    }];
}

- (void)loadNewFeedDataWithPage:(NSInteger)page {
    __weak typeof(self) weakSelf = self;
    [self loadTestDataWithsuccess:^(NSMutableArray *list) {
        [weakSelf.feedPlayView finishLoadMore];
        [weakSelf.feedPlayView setFeedData:[weakSelf getRandomArrFrome:list] isCleanData:NO];
    }];
}

- (void)showFeedDetailViewWithHeadModel:(FeedHeadModel *)model videoModel:(FeedVideoModel *)videoModel playView:(UIView *)superPlayView {
    self.isPushToDetail = YES;
    self.superPlayView = superPlayView;
    
    __block FeedDetailViewController *detailVC = [[FeedDetailViewController alloc] init];
    detailVC.headModel = model;
    detailVC.superPlayView = superPlayView;
    [self loadTestDataWithsuccess:^(NSMutableArray *list) {
        detailVC.detailListData = list;
    }];
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
- (void)loadTestDataWithsuccess:(void(^)(NSMutableArray *list))success {
    NSMutableArray *result = [self loadVideoResources];
    if (self.isDash) {
        success(result);
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_group_t downloadVideoGroup = dispatch_group_create();
            [result enumerateObjectsUsingBlock:^(FeedVideoModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                dispatch_group_enter(downloadVideoGroup);
                [FeedRequestUtil getPlayInfo:(int)obj.appId
                                      fileId:obj.fileId
                                       psign:obj.pSign
                                  completion:^(NSMutableDictionary * _Nonnull dic, NSError * _Nonnull error) {
                    obj.videoURL = [dic objectForKey:@"videoUrl"];
                    obj.multiVideoURLs = [dic objectForKey:@"multiVideoURLs"];
                    dispatch_group_leave(downloadVideoGroup);
                }];
            }];
            
            dispatch_group_notify(downloadVideoGroup, dispatch_get_main_queue(), ^{
                if (success && result.count > 0) {
                    success(result);
                }
            });
        });
    }
}

- (NSMutableArray *)loadVideoData {
    self.isDash = NO;
    NSMutableArray *result = [NSMutableArray array];
    
    FeedVideoModel *model1 = [FeedVideoModel new];
    model1.appId = 1500005830;
    model1.fileId = @"387702299774251236";
    model1.duration = 42;
    model1.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.excellence");
    model1.videoIntroduce = playerLocalize(@"SuperPlayerDemo.VideoFeeds.excellenceintroduce");
    model1.coverUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/48d0f1f9387702299774251236/387702299947979020.png";
    model1.videoDesStr = playerLocalize(@"SuperPlayerDemo.VideoFeeds.excellencedetail");
    [result addObject:model1];
    
    FeedVideoModel *model2 = [FeedVideoModel new];
    model2.appId = 1500005830;
    model2.fileId = @"387702299774544650";
    model2.duration = 65;
    model2.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.smooth");
    model2.videoIntroduce = playerLocalize(@"SuperPlayerDemo.VideoFeeds.smoothintroduce");
    model2.coverUrl = @"http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/4fc009be387702299774544650/coverBySnapshot/coverBySnapshot_10_0.jpg";
    model2.videoDesStr = playerLocalize(@"SuperPlayerDemo.VideoFeeds.smoothdetail");
    [result addObject:model2];
    
    FeedVideoModel *model3 = [FeedVideoModel new];
    model3.appId = 1500005830;
    model3.fileId = @"387702299774644824";
    model3.duration = 57;
    model3.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.real");
    model3.videoIntroduce = playerLocalize(@"SuperPlayerDemo.VideoFeeds.realintroduce");
    model3.coverUrl = @"http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/52153a82387702299774644824/coverBySnapshot/coverBySnapshot_10_0.jpg";
    model3.videoDesStr = playerLocalize(@"SuperPlayerDemo.VideoFeeds.realdetail");
    [result addObject:model3];
    
    FeedVideoModel *model4 = [FeedVideoModel new];
    model4.appId = 1500005830;
    model4.fileId = @"387702299774211080";
    model4.duration = 51;
    model4.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.versatile");
    model4.videoIntroduce = playerLocalize(@"SuperPlayerDemo.VideoFeeds.versatileintroduce");
    model4.coverUrl = @"http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/48888812387702299774211080/coverBySnapshot/coverBySnapshot_10_0.jpg";
    model4.videoDesStr = playerLocalize(@"SuperPlayerDemo.VideoFeeds.versatiledetail");
    [result addObject:model4];
    
    FeedVideoModel *model5 = [FeedVideoModel new];
    model5.appId = 1500005830;
    model5.fileId = @"387702299774545556";
    model5.duration = 94;
    model5.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.gettoknow");
    model5.videoIntroduce = playerLocalize(@"SuperPlayerDemo.VideoFeeds.gettoknowintroduce");
    model5.coverUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/4fc091e4387702299774545556/387702299947278317.png";
    model5.videoDesStr = playerLocalize(@"SuperPlayerDemo.VideoFeeds.gettoknowdetail");
    [result addObject:model5];
    
    FeedVideoModel *model6 = [FeedVideoModel new];
    model6.appId = 1500005830;
    model6.fileId = @"387702299774574470";
    model6.duration = 78;
    model6.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.digitization");
    model6.videoIntroduce = playerLocalize(@"SuperPlayerDemo.VideoFeeds.digitizationintroduce");
    model6.coverUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/4ff64b01387702299774574470/387702299947750409.png";
    model6.videoDesStr = playerLocalize(@"SuperPlayerDemo.VideoFeeds.digitizationdetail");
    [result addObject:model6];
    
    FeedVideoModel *model7 = [FeedVideoModel new];
    model7.appId = 1500005830;
    model7.fileId = @"387702299774253670";
    model7.duration = 113;
    model7.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.simplerandlighter");
    model7.videoIntroduce = playerLocalize(@"SuperPlayerDemo.VideoFeeds.simplerandlighterintroduce");
    model7.coverUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/48d21c3d387702299774253670/387702299947604155.png";
    model7.videoDesStr = playerLocalize(@"SuperPlayerDemo.VideoFeeds.simplerandlighterdetail");
    [result addObject:model7];
    
    FeedVideoModel *model8 = [FeedVideoModel new];
    model8.appId = 1500005830;
    model8.fileId = @"387702299774390972";
    model8.duration = 133;
    model8.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.tencentcloudAV");
    model8.videoIntroduce = playerLocalize(@"SuperPlayerDemo.VideoFeeds.tencentcloudAVintroduce");
    model8.coverUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/4b6e0e84387702299774390972/387702299947629622.png";
    model8.videoDesStr = playerLocalize(@"SuperPlayerDemo.VideoFeeds.tencentcloudAVdetail");
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

// Dash测试视频资源
- (NSMutableArray *)loadDashVideo {
    self.isDash = YES;
    NSMutableArray *result = [NSMutableArray array];
    
    FeedVideoModel *model1 = [FeedVideoModel new];
    model1.videoURL = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.20.mpd";
    model1.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.asingle.morebitrate");
    [result addObject:model1];
    
    FeedVideoModel *model2 = [FeedVideoModel new];
    model2.videoURL = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.22.mpd";
    model2.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.asingle.morebitrate");
    [result addObject:model2];
    
    FeedVideoModel *model3 = [FeedVideoModel new];
    model3.videoURL = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.1163819.mpd";
    model3.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.asingle.morebitrate");
    [result addObject:model3];
    
    FeedVideoModel *model4 = [FeedVideoModel new];
    model4.videoURL = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.1163820.mpd";
    model4.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.asingle.morebitrate");
    [result addObject:model4];
    
    FeedVideoModel *model5 = [FeedVideoModel new];
    model5.videoURL = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.9101.mpd";
    model5.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.DRMwidevine");
    [result addObject:model5];
    
    FeedVideoModel *model6 = [FeedVideoModel new];
    model6.videoURL = @"https://bitmovin-a.akamaihd.net/content/MI201109210084_1/mpds/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.mpd";
    model6.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.numberbased");
    [result addObject:model6];
    
    FeedVideoModel *model7 = [FeedVideoModel new];
    model7.videoURL = @"https://dash.akamaized.net/dash264/TestCases/2c/qualcomm/1/MultiResMPEG2.mpd";
    model7.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.timebased");
    [result addObject:model7];
    
    FeedVideoModel *model8 = [FeedVideoModel new];
    model8.videoURL = @"https://dash.akamaized.net/akamai/bbb_30fps/bbb_30fps.mpd";
    model8.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.30fps");
    [result addObject:model8];
    
    FeedVideoModel *model9 = [FeedVideoModel new];
    model9.videoURL = @"https://dash.akamaized.net/akamai/test/caption_test/ElephantsDream/elephants_dream_480p_heaac5_1_https.mpd";
    model9.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.withsubtitle");
    [result addObject:model9];
    
    return result;
}

- (NSMutableArray *)loadVideoResources {
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"vodConfig"];
    if (userDic == nil || userDic.count <= 0) {
        return [self loadVideoData];
    } else {
        int resource = [[userDic objectForKey:@"resources"] intValue];
        if (resource == 0) {
            return [self loadVideoData];
        } else {
            return [self loadDashVideo];
        }
    }
}

@end
