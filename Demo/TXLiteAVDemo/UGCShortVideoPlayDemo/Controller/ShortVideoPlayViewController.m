//
//  ShortVideoPlayViewController.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/18.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "ShortVideoPlayViewController.h"
#import "TXVideoListViewController.h"
#import <Masonry/Masonry.h>
#import "TXVideoPlayMem.h"
#import "TXPlayerCacheManager.h"
#import "ShortVideoMainViewController.h"

@interface ShortVideoPlayViewController()<UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)   UIScrollView                 *mainScrollView;

@property (nonatomic, strong)   TXVideoListViewController    *videoListVC;

@property (nonatomic, strong)   ShortVideoMainViewController *mainVC;

@property (nonatomic, strong)   NSArray                      *childVCs;

@end

@implementation ShortVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self addChildViewController:self.videoListVC];
    [self addChildViewController:self.mainVC];
    
    WEAKIFY(self);
    self.mainVC.videoDataBlock = ^(NSMutableArray * _Nonnull videoArray) {
        STRONGIFY(self);
        self.videoListVC.listArray = videoArray;
        [self.videoListVC reloadData];
    };
    
    self.childVCs = @[self.mainVC, self.videoListVC];
    [self.childVCs enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.mainScrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(idx * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
    self.videoListVC.selectedItemBlock = ^(NSInteger index) {
        STRONGIFY(self);
        [self.mainVC jumpToCellWithIndex:index];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.mainScrollView.contentOffset = CGPointMake(0, 0);
        });
    };
    
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
    
    // 根据传入的高度来计算整屏需要显示的个数
    if (self.videoCount == 0) {
        self.mainVC.videoCount = DEFAULT_VIDEO_COUNT_SCREEN;
    }
    
    
    if (self.isListLoop) {
        self.mainVC.playmode = TXVideoPlayModeListLoop;
    } else {
        self.mainVC.playmode = TXVideoPlayModeOneLoop;
    }

    if (self.playerCacheCount < DEFAULT_VIDEOPLAYER_CACHE_COUNT) {
        [TXPlayerCacheManager shareInstance].playerCacheCount = DEFAULT_VIDEOPLAYER_CACHE_COUNT;
    } else {
        [TXPlayerCacheManager shareInstance].playerCacheCount = self.playerCacheCount;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - 懒加载
- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [UIScrollView new];
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT);
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.bounces = NO; // 禁止边缘滑动
        _mainScrollView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _mainScrollView;
}

- (TXVideoListViewController *)videoListVC {
    if (!_videoListVC) {
        _videoListVC = [TXVideoListViewController new];
    }
    return _videoListVC;
}

- (ShortVideoMainViewController *)mainVC {
    if (!_mainVC) {
        _mainVC = [ShortVideoMainViewController new];
    }
    return _mainVC;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        [self.mainVC pause];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        [self.mainVC resume];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        [self.mainVC resume];
    }
}

@end
