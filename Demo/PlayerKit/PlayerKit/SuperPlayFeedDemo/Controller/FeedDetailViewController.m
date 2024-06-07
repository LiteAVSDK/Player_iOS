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
#import "PlayerKitCommonHeaders.h"
#import "AppLocalized.h"
#import "TXAppInstance.h"

@interface FeedDetailViewController ()<SuperPlayerDelegate,FeedDetailViewDelegate>

@property (nonatomic, strong) FeedDetailView    *detailView;

@end

@implementation FeedDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // 左侧返回按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(5, 0, 150, 35)];
    [leftbutton setBackgroundImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"back"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[leftItem];

    self.title = playerLocalize(@"SuperPlayerDemo.VideoFeeds.detailtitle");
    
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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view.mas_top);
        }
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    
}

- (void)backClick {
    [self.detailView destory];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - 懒加载
- (FeedDetailView *)detailView {
    if (!_detailView) {
        _detailView = [FeedDetailView new];
        _detailView.delegate = self;
    }
    return _detailView;
}

#pragma mark - setter
-(void)setDetailListData:(NSMutableArray *)detailListData {
    _detailListData = detailListData;
    [self.detailView setListData:detailListData];
}
-(void)setHeadModel:(FeedHeadModel *)headModel{
    _headModel = headModel;
    [self.detailView setModel:self.headModel];
}
-(void)setVideoModel:(FeedVideoModel *)videoModel{
    _videoModel = videoModel;
    [self.detailView setVideoModel:self.videoModel];
}
-(void)setSuperPlayView:(SuperPlayerView *)superPlayView {
    _superPlayView = superPlayView;
    [self.detailView setSuperPlayView:self.superPlayView];
    self.superPlayView.delegate = self;
}

#pragma mark - SuperPlayerDelegate
- (void)screenRotation:(BOOL)fullScreen {
    id delegate = [UIApplication sharedApplication].delegate;
    if (fullScreen) {
        [delegate setValue:@(UIInterfaceOrientationMaskLandscapeRight) forKey:@"interfaceOrientationMask"];
    } else {
        [delegate setValue:@(UIInterfaceOrientationMaskPortrait) forKey:@"interfaceOrientationMask"];
    }
    [self movSetNeedsUpdateOfSupportedInterfaceOrientations];
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
