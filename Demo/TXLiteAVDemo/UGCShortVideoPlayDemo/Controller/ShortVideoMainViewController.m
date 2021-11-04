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

@interface ShortVideoMainViewController ()

@property (nonatomic, strong)   SuperShortVideoView   *videoView;

@property (nonatomic, strong)   NSMutableArray        *videosArray;

@end

@implementation ShortVideoMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.videoView];

    WEAKIFY(self);
    [self.videoView.viewModel refreshNewListWithsuccess:^(NSArray * _Nonnull list) {
        STRONGIFY(self);
        [self.videosArray addObjectsFromArray:list];
        if (self.videoDataBlock) {
            self.videoDataBlock(self.videosArray);
        }
        [self showVideoView];
    } failure:^(NSError * _Nonnull error) {

    }];

    [self.videoView showLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.videoView resume];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.videoView resume];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
        [self.videoView setModels:self.videosArray viewCount:kTXDefaultVideoCountOfScreen];
    });
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
