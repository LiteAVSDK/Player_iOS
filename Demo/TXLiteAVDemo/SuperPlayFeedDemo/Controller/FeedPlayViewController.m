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
#import "AppDelegate.h"
@interface FeedPlayViewController ()<SuperFeedPlayViewDelegate, CAAnimationDelegate>

@property (nonatomic, strong) SuperFeedPlayView *feedPlayView;

@property (nonatomic, assign) BOOL              isPushToDetail;
/// 是否进入全屏
@property (nonatomic, assign) BOOL              isPushToFullScreen;

@property (nonatomic, strong) UIView            *superPlayView;

@property (nonatomic, assign) BOOL              isDash;
///背景色
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
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
    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];
    self.gradientLayer.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isPushToDetail) {
        [self.feedPlayView addSuperPlayView:self.superPlayView];
        self.isPushToDetail = NO;
    }
    if (self.isPushToFullScreen) {
        [self.feedPlayView addSuperPlayView:self.superPlayView];
        self.isPushToFullScreen = NO;
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.feedPlayView];
    [self.feedPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view.mas_top);
        }
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self refreshNewFeedData];
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

- (void)showFeedDetailViewWithHeadModel:(FeedHeadModel *)model
                             videoModel:(FeedVideoModel *)videoModel
                               playView:(SuperPlayerView *)superPlayView {
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
- (void)showFullScreenViewWithPlayView:(SuperPlayerView *)superPlayerView {
    self.isPushToFullScreen = YES;
    self.superPlayView = superPlayerView;
    FeedBaseFullScreenViewController *vc = [FeedBaseFullScreenViewController new];
    vc.playerView = superPlayerView;
    [self.navigationController pushViewController:vc animated:NO];
   
}
#pragma mark - 懒加载
- (SuperFeedPlayView *)feedPlayView {
    if (!_feedPlayView) {
        _feedPlayView = [[SuperFeedPlayView alloc] init];
        _feedPlayView.delegate = self;
    }
    return _feedPlayView;
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        NSArray *colors = @[(__bridge id)[UIColor colorWithRed:19.0 / 255.0 green:41.0 / 255.0 blue:75.0 / 255.0 alpha:1].CGColor,
                            (__bridge id)[UIColor colorWithRed:5.0 / 255.0 green:12.0 / 255.0 blue:23.0 / 255.0 alpha:1].CGColor];
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = colors;
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 1);
    }
    return _gradientLayer;
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
    model1.duration = 90;
    [result addObject:model1];
    
    FeedVideoModel *model2 = [FeedVideoModel new];
    model2.videoURL = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.22.mpd";
    model2.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.asingle.morebitrate");
    model2.duration = 90;
    [result addObject:model2];
    
    FeedVideoModel *model3 = [FeedVideoModel new];
    model3.videoURL = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.1163819.mpd";
    model3.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.asingle.morebitrate");
    model3.duration = 90;
    [result addObject:model3];
    
    FeedVideoModel *model4 = [FeedVideoModel new];
    model4.videoURL = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.1163820.mpd";
    model4.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.asingle.morebitrate");
    model4.duration = 90;
    [result addObject:model4];
    
    FeedVideoModel *model5 = [FeedVideoModel new];
    model5.videoURL = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.9101.mpd";
    model5.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.DRMwidevine");
    model5.duration = 90;
    [result addObject:model5];
    
    FeedVideoModel *model6 = [FeedVideoModel new];
    model6.videoURL = @"https://bitmovin-a.akamaihd.net/content/MI201109210084_1/mpds/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.mpd";
    model6.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.numberbased");
    model6.duration = 210;
    [result addObject:model6];
    
    FeedVideoModel *model7 = [FeedVideoModel new];
    model7.videoURL = @"https://dash.akamaized.net/dash264/TestCases/2c/qualcomm/1/MultiResMPEG2.mpd";
    model7.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.timebased");
    model7.duration = 654;
    [result addObject:model7];
    
    FeedVideoModel *model8 = [FeedVideoModel new];
    model8.videoURL = @"https://dash.akamaized.net/akamai/bbb_30fps/bbb_30fps.mpd";
    model8.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.30fps");
    model8.duration = 634;
    [result addObject:model8];
    
    FeedVideoModel *model9 = [FeedVideoModel new];
    model9.videoURL = @"https://dash.akamaized.net/akamai/test/caption_test/ElephantsDream/elephants_dream_480p_heaac5_1_https.mpd";
    model9.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.dash.withsubtitle");
    model9.duration = 653;
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

///全屏窗口
@interface FeedBaseFullScreenViewController()<SuperPlayerDelegate>
///视频窗口父view
@property (nonatomic, strong) UIView *faterView;
@end

@implementation FeedBaseFullScreenViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *delegate  = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
    [self movRotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    [self movSetNeedsUpdateOfSupportedInterfaceOrientations];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *delegate  = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    [self movRotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
    [self movSetNeedsUpdateOfSupportedInterfaceOrientations];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.faterView];
    [self.faterView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
        }
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}
- (UIView *)faterView {
    if(!_faterView){
        _faterView = [UIView new];
        _faterView.backgroundColor = UIColor.blackColor;
    }
    return _faterView;
}

- (void)setPlayerView:(SuperPlayerView *)playerView {
    _playerView = playerView;
    _playerView.delegate = self;
    _playerView.fatherView = self.faterView;
    [self.faterView addSubview:playerView];
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.faterView);
    }];
}

///SuperPlayerDelegate
-(void)backHookAction{
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (BOOL)movRotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
#ifdef __IPHONE_16_0
    if (@available(iOS 16.0, *)) {
        [self setNeedsUpdateOfSupportedInterfaceOrientations];
        __block BOOL result = YES;
        UIInterfaceOrientationMask mask = 1 << interfaceOrientation;
        UIWindow *window = self.view.window ?: UIApplication.sharedApplication.delegate.window;
        [window.windowScene requestGeometryUpdateWithPreferences:
         [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:mask] errorHandler:^(NSError * _Nonnull error) {
            if (error) {
                result = NO;
            }
        }];
        return result;
    }  else {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            NSNumber *orientationUnknown = @(UIInterfaceOrientationUnknown);
            [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:interfaceOrientation] forKey:@"orientation"];
        }
        /// 延时一下调用，否则无法横屏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [UIViewController attemptRotationToDeviceOrientation];
        });
        
        return YES;
    }
#else
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        NSNumber *orientationUnknown = @(UIInterfaceOrientationUnknown);
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:interfaceOrientation] forKey:@"orientation"];
    }
    [UIViewController attemptRotationToDeviceOrientation];
    return YES;
#endif
}
- (void)movSetNeedsUpdateOfSupportedInterfaceOrientations {

if (@available(iOS 16.0, *)) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000
    [self setNeedsUpdateOfSupportedInterfaceOrientations];
#else
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        SEL supportedInterfaceSelector = NSSelectorFromString(@"setNeedsUpdateOfSupportedInterfaceOrientations");
        [self performSelector:supportedInterfaceSelector];
#pragma clang diagnostic pop
    
#endif
    });
    
}

}

@end

