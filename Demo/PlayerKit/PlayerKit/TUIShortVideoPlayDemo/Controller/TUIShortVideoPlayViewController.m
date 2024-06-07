
//  Copyright © 2023 Tencent. All rights reserved.
//

#import "TUIShortVideoPlayViewController.h"
#import "PlayerKitCommonHeaders.h"
#import "AppLocalized.h"
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
#import <TUIPlayerShortVideo/TUIPlayerShortVideo-umbrella.h>
#import "TUIShortVideoPlayerViewNavView.h"
#import "TUIShortVideoPlayerDataManager.h"
#import "TUIPlayerShortVideoControlView.h"
@interface TUIShortVideoPlayViewController ()<TUIShortVideoViewDelegate>
@property (nonatomic, strong) TUIShortVideoPlayerViewNavView *navView; ///nav
@property (nonatomic, strong) TUIShortVideoView *videoView; // 短视频VideoView
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isNavHidden; ///记录navBar状态
@end

@implementation TUIShortVideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.navView];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
    }];
    [self.videoView startLoading];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setData];
    });
    [SuperPlayerPIPShared  close];
    if (SuperPlayerWindowShared.isShowing) {
        [SuperPlayerWindowShared hide];
        SuperPlayerWindowShared.backController = nil;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isNavHidden = self.navigationController.navigationBar.hidden;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:self.isNavHidden animated:NO];
}
-(void)dealloc {
    [self.videoView destoryPlayer];
}
#pragma mark - setdata
- (void)setData {
    
    ///设置播放数据
    [self.videoView setShortVideoModels:[self video5]];
}

#pragma mark - TUIShortVideoViewDelegate
-(void)onReachLast {
    if (self.pageIndex == 1) {
        return;
    }
    //追加一组数据
    [self.videoView appendShortVideoModels:[self video4]];
    self.pageIndex++;
}
-(NSArray *)video5 {
    return [TUIShortVideoPlayerDataManager getVideo:@"video5"];
}
-(NSArray *)video4 {
    return [TUIShortVideoPlayerDataManager getVideo:@"video5"];
}
#pragma mark - lazyload
-(TUIShortVideoPlayerViewNavView *)navView {
    if (!_navView) {
        _navView = [[TUIShortVideoPlayerViewNavView alloc] init];
        __weak typeof(self) weakSelf = self;
        _navView.backBtnAction = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf.navigationController popViewControllerAnimated:NO];
            }
        };
    }
    return _navView;
}
- (TUIShortVideoView *)videoView {
    if (!_videoView) {
        TUIPlayerShortVideoUIManager *uiManager = [[TUIPlayerShortVideoUIManager alloc] init];
        [uiManager setControlViewClass: TUIPlayerShortVideoControlView.class];
        _videoView = [[TUIShortVideoView alloc] initWithUIManager:uiManager];
        _videoView.delegate = self;
        //[_videoView setPlaymode: TUIPlayModeListLoop];
    }
    return _videoView;
}
@end
