//
//  VideoCacheListView.m
//  Pods
//
//  Created by 路鹏 on 2022/3/7.
//  Copyright © 2022年 Tencent. All rights reserved.

#import "VideoCacheListView.h"
#import "VideoCacheListCell.h"
#import "SuperPlayerHelpers.h"
#import "TXVodDownloadManager.h"
#import "VideoCacheListModel.h"
#import "SuperPlayerView.h"
#import "ScanQRController.h"
#import "TXVodDownloadCenter.h"
#import "SuperPlayer.h"
#import "MoviePlayerViewController.h"
#import <Masonry/Masonry.h>

#define OFFLINE_VIDEOCATCHVIEW_HEIGHT 282
NSString * const VideoCacheListCellIdentifier = @"VideoCacheListCellIdentifier";
@interface VideoCacheListView()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, ScanQRDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *helpBtn;

@property (nonatomic, strong) UIButton *scanBtn;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIImageView *centerImageView;

@property (nonatomic, strong) UILabel *centerLabel;

@property (nonatomic, strong) UITableView *videoTableView;

@property (nonatomic, strong) NSMutableArray *videoCacheArray;

@property (nonatomic, assign) NSInteger longPressIndex;

@property (nonatomic, strong) SuperPlayerView *superPlayerView;

@property (nonatomic, strong) ScanQRController *scanVC;

@property (nonatomic, assign) BOOL isScan;

@end

@implementation VideoCacheListView

- (instancetype)init {
    if (self = [super init]) {
        self.longPressIndex = -1;
        [self addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self).offset(kStatusBarHeight);
            make.height.mas_equalTo(44);
        }];

        [self.topView addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topView).offset(20);
            make.top.equalTo(self.topView).offset(7);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
        }];

        [self.topView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(36);
            make.width.mas_equalTo(100);
            make.center.equalTo(self.topView);
        }];

        [self.topView addSubview:self.scanBtn];
        [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topView).offset(-20);
            make.top.equalTo(self.topView).offset(7);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];

        [self.topView addSubview:self.helpBtn];
        [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topView).offset(-60);
            make.top.equalTo(self.topView).offset(7);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
        self.isScan = NO;
        [self getSupperPlayView];
        self.videoCacheArray = [NSMutableArray array];
        [self addCenterView];
    }
    return self;
}

- (void)addCenterView {
    NSArray<TXVodDownloadMediaInfo *> *array = [[[TXVodDownloadManager shareInstance] getDownloadMediaInfoList] mutableCopy];
    if (array.count <= 0) {
        // 显示centerview
        [self addSubview:self.centerView];
        [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-50);
            make.height.mas_equalTo(200);
            make.width.mas_equalTo(200);
        }];
        
        [self.centerView addSubview:self.centerImageView];
        [self.centerView addSubview:self.centerLabel];
    } else {
        [self addSubview:self.videoTableView];
        [self.videoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.top.equalTo(self).offset(kStatusBarHeight + 44 + 6);
        }];
        [self.videoCacheArray removeAllObjects];
        for (TXVodDownloadMediaInfo *info in array) {
            VideoCacheListModel *model = [[VideoCacheListModel alloc] init];
            model.mediaInfo = info;
            [self.videoCacheArray addObject:model];
        }
        
        [self.videoTableView reloadData];
    }
}

- (void)getSupperPlayView {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[SuperPlayerView class]]) {
            SuperPlayerView *superPlayerView = (SuperPlayerView *)view;
            self.superPlayerView = superPlayerView;
        }
    }
}

#pragma mark - 懒加载
- (UITableView *)videoTableView {
    if (!_videoTableView) {
        _videoTableView = [UITableView new];
        _videoTableView.scrollsToTop = NO;
        _videoTableView.backgroundColor = [UIColor clearColor];
        _videoTableView.delegate = self;
        _videoTableView.dataSource = self;
        _videoTableView.estimatedRowHeight = 0;
        _videoTableView.showsVerticalScrollIndicator = NO;
        _videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_videoTableView registerClass:[VideoCacheListCell class] forCellReuseIdentifier:VideoCacheListCellIdentifier];
        if (@available(iOS 11.0, *)) {
            _videoTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _videoTableView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"离线缓存";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)helpBtn {
    if (!_helpBtn) {
        _helpBtn = [[UIButton alloc] init];
        [_helpBtn setBackgroundImage:[UIImage imageNamed:@"help_small"] forState:UIControlStateNormal];
        [_helpBtn addTarget:self action:@selector(clickHelp) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpBtn;
}

- (UIButton *)scanBtn {
    if (!_scanBtn) {
        _scanBtn = [[UIButton alloc] init];
        [_scanBtn setBackgroundImage:[UIImage imageNamed:@"扫码"] forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(clickScan) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanBtn;
}

- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
    }
    return _centerView;
}

- (UIImageView *)centerImageView {
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] init];
        _centerImageView.frame = CGRectMake(25, 5, 150, 150);
        _centerImageView.image = SuperPlayerImage(@"cacheView_noData");
    }
    return _centerImageView;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.frame = CGRectMake(0, 150 + 5, 200, 25);
        _centerLabel.text = @"暂无数据";
        _centerLabel.font = [UIFont systemFontOfSize:16];
        _centerLabel.textColor = [UIColor colorWithRed:74.0/255.0 green:92.0/255.0 blue:130.0/255.0 alpha:1.0];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _centerLabel;
}

#pragma mark - click
- (void)backClick {
    [self.superPlayerView resume];
    [self removeFromSuperview];
}

- (void)clickHelp {
    NSURL * helpUrl = [NSURL URLWithString:@"https://cloud.tencent.com/document/product/454/18871"];
    UIApplication *myApp   = [UIApplication sharedApplication];
    if ([myApp canOpenURL:helpUrl]) {
        [myApp openURL:helpUrl];
    }
}

- (void)clickScan {
    self.scanVC = [[ScanQRController alloc] init];
    self.scanVC.delegate = self;
    [self addSubview:self.scanVC.view];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [longPress locationInView:self.videoTableView];
        NSIndexPath *indexPath = [self.videoTableView indexPathForRowAtPoint:point];
        if (indexPath != nil) {
            NSInteger indexNum = indexPath.row;
            self.longPressIndex = indexNum;
        }
        
        [self longPressDelete];
    }
}

// 弹窗方法
- (void)longPressDelete {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定删除视频吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)showToastViewisSuccess:(BOOL)isSuccess {
    __block UIView *toastView = [[UIView alloc] init];
    toastView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:179.0/255.0];
    
    [self addSubview:toastView];
    [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(150);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake((150 - 35) * 0.5, 35, 35, 35);
    [toastView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 150 - 35 - 25, 150, 25);
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [toastView addSubview:label];
    
    if (isSuccess) {
        label.text = @"删除成功";
        imageView.image = SuperPlayerImage(@"videoCache_success");
    } else {
        label.text = @"删除失败";
        imageView.image = SuperPlayerImage(@"videoCache_fail");
    }
   

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);

    dispatch_after(popTime, dispatch_get_main_queue(), ^() {
        [toastView removeFromSuperview];
        toastView = nil;
    });
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoCacheArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCacheListCell *cell = [[VideoCacheListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VideoCacheListCellIdentifier];
    
    if (cell) {
        cell.model = self.videoCacheArray[indexPath.row];
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.7;
    [cell addGestureRecognizer:longPress];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoCacheListCell *cell = [self.videoTableView cellForRowAtIndexPath:indexPath];
    TXVodDownloadMediaInfo *model = cell.model.mediaInfo;

    if (model.downloadState == 0 || model.downloadState == 1) {  // 缓存中,点击后缓存暂停
        VideoCacheListCell *cell = [self.videoTableView cellForRowAtIndexPath:indexPath];
        [cell stopDownload];
    } else if (model.downloadState == 2 || model.downloadState == 3) { // 暂停缓存，点击后缓存中
        VideoCacheListCell *cell = [self.videoTableView cellForRowAtIndexPath:indexPath];
        [cell startDownload];
    } else {
        [self playWithModel:[cell getSuperPlayModel]];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"点击了确定按钮");
        if (self.longPressIndex >= 0) {
            VideoCacheListModel *model = self.videoCacheArray[self.longPressIndex];
            BOOL isSuccess = [[TXVodDownloadManager shareInstance] deleteDownloadFile:model.mediaInfo.playPath];
            [[TXVodDownloadManager shareInstance] deleteDownloadMediaInfo:model.mediaInfo];
            [self showToastViewisSuccess:isSuccess];
            if (isSuccess) {
                [self.videoCacheArray removeObjectAtIndex:self.longPressIndex];
                [self.videoTableView reloadData];
                
                if (self.videoCacheArray.count <= 0) {
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^() {
                        [self addCenterView];
                    });
                }
            }
        }
    } else {
        NSLog(@"点击了取消按钮");
    }
}

#pragma mark - ScanQrDelegate
- (void)onScanResult:(NSString *)result {
    self.scanVC = nil;
    SuperPlayerModel *model  = [SuperPlayerModel new];
    if ([result hasPrefix:@"txsuperplayer://"]) {
        [self fillModel:model withURL:result];
    } else if ([result hasPrefix:@"https://playvideo.qcloud.com/getplayinfo/v4"]) {
        if (![self fillModel:model withURL:result]) {
            model.videoURL = result;
        }
    } else if ([self isURLTypeV4vodplayProtocol:result]) {
        //仅支持普通URL传参方式
        [self fillModel:model withURL:result];
    } else if ([result hasPrefix:@"rtmp"] || ([result hasPrefix:@"http"] && [result hasSuffix:@".flv"])) {
        model.videoURL = result;
    } else {
        model.videoURL = result;
    }

    model.name = @"SuperPlayerDemo.MoviePlayer.newVideo";
    model.action = 0;
    self.isScan = YES;
    [self playWithModel:model];
}

- (void)cancelScanQR {
    self.scanVC = nil;
}

- (BOOL)fillModel:(SuperPlayerModel *)model withURL:(NSString *)result {
    NSURLComponents *components = [NSURLComponents componentsWithString:result];
    if ([components.host isEqualToString:@"playvideo.qcloud.com"]) {
        NSArray *pathComponents = [components.path componentsSeparatedByString:@"/"];
        if (pathComponents.count != 5) {
            return NO;
        }
        NSString *appID  = pathComponents[3];
        NSString *fileID = pathComponents[4];

        NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:components.queryItems.count];
        for (NSURLQueryItem *item in components.queryItems) {
            if (item.value) {
                paramDict[item.name] = item.value;
            }
        }
        model.appId          = [appID integerValue];
        model.videoId        = [[SuperPlayerVideoId alloc] init];
        model.videoId.fileId = fileID;
        model.videoId.psign  = paramDict[@"psign"];
        return YES;
    } else if ([components.host isEqualToString:@"play_vod"]) {
        NSDictionary *paramDict = [self getParamsFromUrlStr:result];
        model.appId             = [paramDict[@"appId"] integerValue];
        model.videoId           = [[SuperPlayerVideoId alloc] init];
        model.videoId.fileId    = paramDict[@"fileId"];
        model.videoId.psign     = paramDict[@"psign"];
        return YES;
    } else if ([result hasPrefix:@"liteav://com.tencent.liteav.demo"]) {
        NSMutableDictionary *paramDict = [self getParamsFromUrlStr:result].mutableCopy;
        if ([paramDict[@"protocol"] isEqualToString:@"v4vodplay"]) {
            NSDictionary *dataObj = [self safeParseJsonStr:paramDict[@"data"]];
            if (dataObj) {
                [paramDict addEntriesFromDictionary:dataObj];
            }
        }
        model.appId          = [paramDict[@"appId"] integerValue];
        model.videoId        = [[SuperPlayerVideoId alloc] init];
        model.videoId.fileId = paramDict[@"fileId"];
        model.videoId.psign  = paramDict[@"psign"];
        return YES;
    } else if ([self isURLTypeV4vodplayProtocol:result]) {
        NSDictionary *paramDict = [self getParamsFromUrlStr:result];
        model.appId             = [paramDict[@"appId"] integerValue];
        model.videoId           = [[SuperPlayerVideoId alloc] init];
        model.videoId.fileId    = paramDict[@"fileId"];
        model.videoId.psign     = paramDict[@"psign"];
        return YES;
    }
    return NO;
}

- (NSDictionary *)getParamsFromUrlStr:(NSString *)result {
    NSString *           escapResult = [result stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLComponents *    components  = [[NSURLComponents alloc] initWithString:escapResult];
    NSMutableDictionary *paramDict   = [NSMutableDictionary dictionaryWithCapacity:components.queryItems.count];
    for (NSURLQueryItem *item in components.queryItems) {
        if (item.value) {
            paramDict[item.name] = item.value;
        }
    }
    return paramDict.copy;
}

- (id)safeParseJsonStr:(NSString *)jsonStr {
    if ([jsonStr isKindOfClass:[NSString class]]) {
        NSData *data = [[jsonStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        }
    }
    return nil;
}

- (BOOL)isURLTypeV4vodplayProtocol:(NSString *)result {
    if ([result hasPrefix:@"https://"] || [result hasPrefix:@"http://"]) {
        NSDictionary *urlParams = [self getParamsFromUrlStr:result];
        return [[urlParams objectForKey:@"protocol"] isEqualToString:@"v4vodplay"];
    }
    return NO;
}

- (void)playWithModel:(SuperPlayerModel *)model {
    [self.superPlayerView hideVipTipView];
    [self.superPlayerView hideVipWatchView];
    self.superPlayerView.isCanShowVipTipView = NO;
    [self.superPlayerView.coverImageView setImage:nil];
    
    [self.superPlayerView.controlView setTitle:model.name];
    model.isEnableCache = !self.isScan;
    UIViewController *vc = [self currentViewController];
    if (vc && [vc isKindOfClass:NSClassFromString(@"MoviePlayerViewController")]) {
        MoviePlayerViewController *playerController = (MoviePlayerViewController *)vc;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:model forKey:@"playerModel"];
        [playerController startPlayVideoFromLaunchInfo:dic complete:^(BOOL succ) {
            if (succ) {
                [self removeFromSuperview];
            }
        }];
    }
}

- (UIViewController *)currentViewController {
    return [self currentViewControllerWithRootViewController:[self getKeyWindow].rootViewController];
}

//获取KeyWindow
- (UIWindow *)getKeyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                        break;
                    }
                }
            }
        }
    }
    else {
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}

- (UIViewController*)currentViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self currentViewControllerWithRootViewController:presentedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self currentViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self currentViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else {
        return rootViewController;
    }
}

- (void)dealloc {
    [[TXVodDownloadCenter sharedInstance] deleteAllListener];
}
@end
