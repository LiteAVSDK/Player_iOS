//
//  ShortVideoMainViewController.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/9/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "ShortVideoMainViewController.h"
#import "SuperShortVideoView.h"
#import "TXVideoPlayMem.h"
#import "TXVideoViewModel.h"
#import "SDImageCache.h"
#import "PlayerKitCommonHeaders.h"
@interface ShortVideoMainViewController ()

@property (nonatomic, strong)   SuperShortVideoView   *videoView;

@property (nonatomic, strong)   NSMutableArray        *videosArray;

@property (nonatomic, assign)   BOOL                  isLoadVideo;
@property (nonatomic, assign) BOOL isNavHidden; ///记录navBar状态
@end

@implementation ShortVideoMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // SDImageCache设置内存大小
    [SDImageCache sharedImageCache].config.maxMemoryCost = 20 * 1024 * 1024;
    
    self.isLoadVideo = NO;
    [self.view addSubview:self.videoView];
    [self.videoView showLoading];
    
    [self loadVideoData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isNavHidden = self.navigationController.navigationBar.hidden;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.videoView resume];
    [SuperPlayerPIPShared  close];
    if (SuperPlayerWindowShared.isShowing) {
        [SuperPlayerWindowShared hide];
        SuperPlayerWindowShared.backController = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.videoView resume];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:self.isNavHidden animated:NO];
    // 停止播放
    [self.videoView pause];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.videoView pause];
    [self.videoView destoryPlayer];
    [self.videoView removeFromSuperview];
    self.videoView = nil;
}

- (void)setPlaymode:(TXVideoPlayMode)playmode {
    self.videoView.playmode = playmode;
}

#pragma mark - Public Method
- (void)pause {
    [self.videoView pause];
}

- (void)resume {
    [self.videoView resume];
}

- (void)jumpToCellWithIndex:(NSInteger)index {
    [self.videoView jumpToCellWithIndex:index];
}

#pragma mark - Private Method
- (void)showVideoView {
    WEAKIFY(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        STRONGIFY(self);
        // 判断是否需要显示遮罩层
        BOOL isShowedGuideView = [[NSUserDefaults standardUserDefaults] objectForKey:@"isShowedGuideView"];
        if (!isShowedGuideView) {
            [self.videoView showGuideView];
        }
        [self.videoView setModels:self.videosArray viewCount:DEFAULT_VIDEO_COUNT_SCREEN];
    });
}

// 加载HLS视频资源
- (void)loadHLSVideoData {
    NSData *listData = [[NSUserDefaults standardUserDefaults] objectForKey:SHORT_VIDEO_CACHE_DATA_KEY];
    NSArray <TXVideoModel *> *list = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
    if (list.count > 0) {
        [self.videosArray removeAllObjects];
        [self.videosArray addObjectsFromArray:list];
        if (self.videoDataBlock) {
            self.videoDataBlock(self.videosArray);
        }
        [self showVideoView];
        self.isLoadVideo = YES;
    }
    
    WEAKIFY(self);
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        [self.videoView.viewModel refreshNewListWithsuccess:^(NSArray * _Nonnull list) {
            STRONGIFY(self);
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:list];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:SHORT_VIDEO_CACHE_DATA_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.videosArray addObjectsFromArray:list];
            
            if (!self.isLoadVideo) {
                [self showVideoView];
                if (self.videoDataBlock) {
                    self.videoDataBlock(self.videosArray);
                }
            }
        } failure:^(NSError * _Nonnull error) {
            if (!self.isLoadVideo) {
                [self.videoView showNoNetView];
            }
        }];
    });
}

// 加载dash视频资源
- (void)loadDashVideoData {
    NSMutableArray *array = [NSMutableArray array];
    
    TXVideoModel *model1 = [[TXVideoModel alloc] init];
    model1.videourl = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.20.mpd";
    model1.duration = @"90";
    [array addObject:model1];
    
    TXVideoModel *model2 = [[TXVideoModel alloc] init];
    model2.videourl = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.22.mpd";
    model2.duration = @"90";
    [array addObject:model2];
    
    TXVideoModel *model3 = [[TXVideoModel alloc] init];
    model3.videourl = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.1163819.mpd";
    model3.duration = @"90";
    [array addObject:model3];
    
    TXVideoModel *model4 = [[TXVideoModel alloc] init];
    model4.videourl = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.1163820.mpd";
    model4.duration = @"90";
    [array addObject:model4];
    
    TXVideoModel *model5 = [[TXVideoModel alloc] init];
    model5.videourl = @"http://1500004424.vod2.myqcloud.com/4383a13evodtranscq1500004424/baff45348602268011141077324/adp.9101.mpd";
    model5.duration = @"90";
    [array addObject:model5];
    
    TXVideoModel *model6 = [[TXVideoModel alloc] init];
    model6.videourl = @"https://bitmovin-a.akamaihd.net/content/MI201109210084_1/mpds/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.mpd";
    model6.duration = @"210";
    [array addObject:model6];
    
    TXVideoModel *model7 = [[TXVideoModel alloc] init];
    model7.videourl = @"https://dash.akamaized.net/dash264/TestCases/2c/qualcomm/1/MultiResMPEG2.mpd";
    model7.duration = @"654";
    [array addObject:model7];
    
    TXVideoModel *model8 = [[TXVideoModel alloc] init];
    model8.videourl = @"https://dash.akamaized.net/akamai/bbb_30fps/bbb_30fps.mpd";
    model8.duration = @"634";
    [array addObject:model8];
    
    TXVideoModel *model9 = [[TXVideoModel alloc] init];
    model9.videourl = @"https://dash.akamaized.net/akamai/test/caption_test/ElephantsDream/elephants_dream_480p_heaac5_1_https.mpd";
    model9.duration = @"653";
    [array addObject:model9];
    
    [self.videosArray removeAllObjects];
    [self.videosArray addObjectsFromArray:array];
    
    if (!self.isLoadVideo) {
        [self showVideoView];
        if (self.videoDataBlock) {
            self.videoDataBlock(self.videosArray);
        }
    }
}

- (void)loadVideoData {
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"vodConfig"];
    if (userDic == nil || userDic.count <= 0) {
        return [self loadHLSVideoData];
    } else {
        int resource = [[userDic objectForKey:@"resources"] intValue];
        if (resource == 0) {
            return [self loadHLSVideoData];
        } else {
            return [self loadDashVideoData];
        }
    }
}

#pragma mark - 懒加载
- (SuperShortVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[SuperShortVideoView alloc] initWithViewController:self];
        _videoView.frame = self.view.bounds;
    }
    return _videoView;
}

- (NSMutableArray *)videosArray {
    if (!_videosArray) {
        _videosArray = [NSMutableArray array];
    }
    return _videosArray;
}

@end
