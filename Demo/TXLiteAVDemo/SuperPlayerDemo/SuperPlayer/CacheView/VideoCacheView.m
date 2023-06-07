//
//  VideoCacheView.m
//  Pods
//
//  Created by 路鹏 on 2022/2/17.
//  Copyright © 2022年 Tencent. All rights reserved.

#import "VideoCacheView.h"
#import <Masonry/Masonry.h>
#import "SuperPlayerHelpers.h"
#import "VideoCacheCell.h"
#import "ResolutionCell.h"
#import "SuperPlayerModelInternal.h"
#import "VideoCacheModel.h"
#import "ResolutionModel.h"
#import "TXVodDownloadManager.h"
#import "TXPlayerAuthParams.h"
#import "SuperPlayerView.h"
#import "VideoCacheListView.h"
#import "TXVodDownloadCenter.h"
#import "AppLocalized.h"

NSString * const VideoCacheCellIdentifier = @"VideoCacheCellIdentifier";
NSString * const ResolutionCellIdentifier = @"ResolutionCellIdentifier";

@interface VideoCacheView()<UITableViewDelegate, UITableViewDataSource, TXVodDownloadCenterDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView      *topView;

@property (nonatomic, strong) UILabel     *clarityLabel;

@property (nonatomic, strong) UILabel     *resolutionLabel;

@property (nonatomic, strong) UIButton    *chooseResoluBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton    *viewCacheListBtn;

@property (nonatomic, strong) NSMutableArray *videoArray;

@property (nonatomic, strong) NSMutableArray *resolutionArray;

@property (nonatomic, strong) UITableView  *resoluTableView;

@property (nonatomic, assign) BOOL isShowResolutionView;

@property (nonatomic, strong) NSString *currentResolutionStr;

@property (nonatomic, strong) NSMutableArray<SuperPlayerModel *> *models;

@property (nonatomic, strong) SuperPlayerModel *currentModel;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) TXVodDownloadCenter *manager;

@end

@implementation VideoCacheView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.videoArray = [NSMutableArray array];
        self.resolutionArray = [NSMutableArray array];
        self.models = [NSMutableArray array];
        self.isShowResolutionView = NO;
        [self setChildViews];
    }
    return self;
}

- (void)setChildViews {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:179.0/255.0];
    [self addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(0);
        make.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self.topView addSubview:self.clarityLabel];
    [self.clarityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(20);
        make.top.equalTo(self.topView);
        make.height.equalTo(self.topView);
        make.width.mas_equalTo(80);
    }];
    
    [self.topView addSubview:self.resolutionLabel];
    [self.resolutionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(20 + 85);
        make.top.equalTo(self.topView);
        make.height.equalTo(self.topView);
        make.width.mas_equalTo(30);
    }];
    
    [self.topView addSubview:self.chooseResoluBtn];
    [self.chooseResoluBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(20 + 85 + 30);
        make.top.equalTo(self.topView);
        make.height.equalTo(self.topView);
        make.width.mas_equalTo(20);
    }];
    
    [self addVideoTableView];
    
    [self addSubview:self.viewCacheListBtn];
    [self.viewCacheListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self).offset(-30);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(48);
    }];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] init];
    singleTap.delegate = self;
    [self addGestureRecognizer:singleTap];
}

- (void)setVideoModels:(NSArray *)models currentPlayingModel:(SuperPlayerModel *)currentModel {
    self.currentModel = currentModel;
    self.models = [models mutableCopy];
    if ([models containsObject:currentModel]) {
        self.currentIndex = [models indexOfObject:currentModel];
    }
    
    [self setResolutionArray:currentModel.playDefinitions currentResolution:currentModel.playingDefinition];
    [self updateVideoModel];
}

- (void)setResolutionArray:(NSArray *)resolutionArray currentResolution:(NSString *)currentResolution {
    [self.resolutionArray removeAllObjects];
    for (int i = 0; i < resolutionArray.count; i++) {
        ResolutionModel *model = [[ResolutionModel alloc] init];
        NSArray *titlesArray = [resolutionArray[i] componentsSeparatedByString:@"（"];
        NSArray *resoluArray = [titlesArray.lastObject componentsSeparatedByString:@"）"];
        NSString *title = titlesArray.firstObject;
        model.resolution = title.length > 0 ? title : resoluArray.firstObject;
        if ([resolutionArray[i] isEqualToString:currentResolution]) {
            self.currentResolutionStr = currentResolution;
            self.resolutionLabel.text = model.resolution;
            model.isCurrentPlay = YES;
        }

        [self.resolutionArray addObject:model];
    }
}

#pragma mark - click
- (void)chooseResoluClick {
    if (self.isShowResolutionView) {
        [self removeResolutionTableView];
        [self addVideoTableView];
        [self.chooseResoluBtn setImage:SuperPlayerImage(@"videoCache_down") forState:UIControlStateNormal];
        [self.tableView reloadData];
    } else {
        [self removeVideoTableView];
        [self addResolutionTableView];
        [self.chooseResoluBtn setImage:SuperPlayerImage(@"videoCache_up") forState:UIControlStateNormal];
        [self.resoluTableView reloadData];
    }
    
    self.isShowResolutionView = !self.isShowResolutionView;
}

- (void)cacheListClick {
    SuperPlayerView *playerView = (SuperPlayerView *)self.superview;
    [playerView pause];

    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    VideoCacheListView *listView = [[VideoCacheListView alloc] init];
    // 背景色
    listView.backgroundColor = [UIColor whiteColor];
    NSArray *colors = @[(__bridge id)[UIColor colorWithRed:19.0 / 255.0 green:41.0 / 255.0 blue:75.0 / 255.0 alpha:1].CGColor,
                        (__bridge id)[UIColor colorWithRed:5.0 / 255.0 green:12.0 / 255.0 blue:23.0 / 255.0 alpha:1].CGColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = window.bounds;
    [listView.layer insertSublayer:gradientLayer atIndex:0];
    [window addSubview:listView];
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(ScreenHeight));
        make.center.equalTo(window);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeTranslation(self.frame.size.width + HomeIndicator_Height, 0);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - Private Method
- (TXVodDownloadMediaInfo *)getDownloadMediaInfo:(SuperPlayerModel *)model {
    TXVodDownloadMediaInfo *mediaInfo = [[TXVodDownloadMediaInfo alloc] init];
    TXVodDownloadDataSource *dataSource = [[TXVodDownloadDataSource alloc] init];
    dataSource.appId = (int)model.appId;
    dataSource.fileId = model.videoId.fileId;
    dataSource.pSign = model.videoId.psign;
    dataSource.quality = [self getCurrentQuality];
    mediaInfo.url = model.videoURL;
    mediaInfo.dataSource = dataSource;
    return [self.manager getDownloadMediaInfo:mediaInfo];
}

- (int)getCurrentQuality {
    __block int quality = TXVodQuality720P;
    __block NSString *title;
    [self.currentModel.multiVideoURLs enumerateObjectsUsingBlock:^(SuperPlayerUrl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.title containsString:self.currentResolutionStr]) {
            quality = obj.qualityIndex;
            title = obj.title;
            *stop = YES;
        }
    }];
    //根据分辨率指定清晰度
    NSArray *titlesArray = [title componentsSeparatedByString:@"（"];
    NSArray *resoluArray = [titlesArray.lastObject componentsSeparatedByString:@"P）"];
    NSString *resolution = resoluArray.firstObject;
    if(resolution.length > 0){
        quality = [resolution intValue];
    }
    return quality;
}

// 切换清晰度，需要更改是否缓存状态
- (void)updateVideoModel {
    [self.videoArray removeAllObjects];
    for (SuperPlayerModel *model in self.models) {
        VideoCacheModel *cacheModel = [[VideoCacheModel alloc] init];
        cacheModel.videoTitle = model.name;
        if (model == self.models[self.currentIndex] && model.playingDefinition == self.currentResolutionStr) {
            cacheModel.isCurrentPlay = YES;
        }
        
        if (model.mediaInfo) {
            cacheModel.isCache = YES;
        } else {
            TXVodDownloadMediaInfo *info = [self getDownloadMediaInfo:model];
            if (info) {
                cacheModel.isCache = YES;
            }
        }
        
        cacheModel.appId = (int)model.appId;
        cacheModel.fileId = model.videoId.fileId;
        cacheModel.pSign = model.videoId.psign;
        
        cacheModel.url = model.videoURL;

        [self.videoArray addObject:cacheModel];
    }

    // cacheModel1
    VideoCacheModel *cacheModel1 = [[VideoCacheModel alloc] init];
    TXPlayerDrmBuilder *drmBuilder1 = [[TXPlayerDrmBuilder alloc] init];
    drmBuilder1.deviceCertificateUrl = @"https://cert.drm.vod-qcloud.com/cert/v1/59ca267fdd87903b933cb845b844eda2/fairplay.cer";
    drmBuilder1.keyLicenseUrl = @"https://fairplay-test.drm.vod-qcloud.com/fairplay/getlicense/v2?drmToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9~eyJ0eXBlIjoiRHJtVG9rZW4iLCJhcHBJZCI6MTUwMDAxMzc4OCwiZmlsZUlkIjoiNTI4Nzg1MjEwOTg0ODE0NzI1MSIsImN1cnJlbnRUaW1lU3RhbXAiOjAsImV4cGlyZVRpbWVTdGFtcCI6MTk2MDk5NTE3MCwicmFuZG9tIjowLCJvdmVybGF5S2V5IjoiIiwib3ZlcmxheUl2IjoiIiwiY2lwaGVyZWRPdmVybGF5S2V5IjoiIiwiY2lwaGVyZWRPdmVybGF5SXYiOiIiLCJrZXlJZCI6MCwic3RyaWN0TW9kZSI6MCwicGVyc2lzdGVudCI6Ik9OIiwicmVudGFsRHVyYXRpb24iOjEwMDAwMH0~wbXINOOUyEoi3Qh5hIaISbD9gcv9QHGn89mjjHVcHPo";
    drmBuilder1.playUrl = @"https://1500013788.vod2.myqcloud.com/43953aebvodtranscq1500013788/986b43ec5287852109848147251/adp.153829.m3u8";
    cacheModel1.drmBuilder = drmBuilder1;
    cacheModel1.videoTitle = @"FairPlay HLS(license 长期有效)";
    [self.videoArray addObject:cacheModel1];
    
    // cacheModel2
    VideoCacheModel *cacheModel2 = [[VideoCacheModel alloc] init];
    TXPlayerDrmBuilder *drmBuilder2 = [[TXPlayerDrmBuilder alloc] init];
    drmBuilder2.deviceCertificateUrl = @"https://cert.drm.vod-qcloud.com/cert/v1/59ca267fdd87903b933cb845b844eda2/fairplay.cer";
    drmBuilder2.keyLicenseUrl = @"https://fairplay-test.drm.vod-qcloud.com/fairplay/getlicense/v2?drmToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9~eyJ0eXBlIjoiRHJtVG9rZW4iLCJhcHBJZCI6MTUwMDAxMzc4OCwiZmlsZUlkIjoiNTI4Nzg1MjEwOTg0OTE1NDY1OSIsImN1cnJlbnRUaW1lU3RhbXAiOjAsImV4cGlyZVRpbWVTdGFtcCI6Mjk2MDk5NTE3MCwicmFuZG9tIjowLCJvdmVybGF5S2V5IjoiIiwib3ZlcmxheUl2IjoiIiwiY2lwaGVyZWRPdmVybGF5S2V5IjoiIiwiY2lwaGVyZWRPdmVybGF5SXYiOiIiLCJrZXlJZCI6MCwic3RyaWN0TW9kZSI6MCwicGVyc2lzdGVudCI6Ik9OIiwicmVudGFsRHVyYXRpb24iOjYwMH0~Wnj6epGrf_drf9AOTGBfF1QOIEQVGN0A0_Hjty_kOUk";
    drmBuilder2.playUrl = @"https://1500013788.vod2.myqcloud.com/43953aebvodtranscq1500013788/e57605175287852109849154659/adp.153829.m3u8";
    cacheModel2.drmBuilder = drmBuilder2;
    cacheModel2.videoTitle = @"FairPlay HLS(license 有效期为10分钟)";
    [self.videoArray addObject:cacheModel2];

    [self.tableView reloadData];
}

- (void)toastTip:(NSString *)toastInfo {
    
    SuperPlayerView *playerView = (SuperPlayerView *)self.superview;
    CGRect frameRC   = playerView.bounds;
    __block UITextView *toastView = [[UITextView alloc] init];
    
    [playerView addSubview:toastView];

    toastView.editable   = NO;
    toastView.selectable = NO;
    toastView.font = [UIFont systemFontOfSize:14];

    CGFloat height = [self heightForString:toastView andWidth:frameRC.size.height];
    CGFloat width = [self getWidthWithTitle:toastInfo font:toastView.font];
    CGFloat margin = (frameRC.size.width - width - 50) * 0.5;

    toastView.text            = toastInfo;
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.alpha           = 0.5;
    toastView.textAlignment = NSTextAlignmentCenter;
    toastView.textColor = [UIColor blackColor];
    
    [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self).offset(-VIP_TIPVIEW_DEFAULTX_BOTTOM);
        } else {
            make.bottom.equalTo(self).offset(-VIP_TIPVIEW_DEFAULT_BOTTOM);
        }
        make.height.mas_equalTo(height);
        make.left.equalTo(playerView).offset(margin);
        make.right.equalTo(playerView).offset(-margin);
    }];
   

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);

    dispatch_after(popTime, dispatch_get_main_queue(), ^() {
        [toastView removeFromSuperview];
        toastView = nil;
    });
}

- (float)heightForString:(UITextView *)textView andWidth:(float)width {
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    CGFloat width = label.frame.size.width;
    return ceil(width);
}

- (void)addResolutionTableView {
    [self addSubview:self.resoluTableView];
    [self.resoluTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(20 + 30 + 5);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
}

- (void)removeResolutionTableView {
    [self.resoluTableView removeFromSuperview];
    self.resoluTableView = nil;
}

- (void)addVideoTableView {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(20 + 30 + 5);
        make.bottom.equalTo(self).offset(-80);
        make.right.equalTo(self);
    }];
}

- (void)removeVideoTableView {
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if ([tableView isEqual:self.tableView]) {
        count = self.videoArray.count;
    }
    
    if ([tableView isEqual:self.resoluTableView] ) {
        count = self.resolutionArray.count;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if ([tableView isEqual:self.tableView]) {
        height = 44;
    }
    
    if ([tableView isEqual:self.resoluTableView]) {
        height = 75;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    if ([tableView isEqual:self.tableView]) {
        VideoCacheCell *videoCacheCell = [tableView dequeueReusableCellWithIdentifier:VideoCacheCellIdentifier];
        
        if (!videoCacheCell) {
            videoCacheCell = [[VideoCacheCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VideoCacheCellIdentifier];
        }

        if (videoCacheCell) {
            videoCacheCell.cacheModel = self.videoArray[indexPath.row];
        }
        cell = videoCacheCell;
    }
    
    if ([tableView isEqual:self.resoluTableView]) {
        ResolutionCell *resoluCell = [tableView dequeueReusableCellWithIdentifier:ResolutionCellIdentifier];
        
        if (!resoluCell) {
            resoluCell = [[ResolutionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ResolutionCellIdentifier];
        }
        
        if (resoluCell) {
            resoluCell.resolutionModel = self.resolutionArray[indexPath.row];
        }
        cell = resoluCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.resoluTableView]) {
        
        ResolutionModel *model = self.resolutionArray[indexPath.row];
        self.currentResolutionStr = model.resolution;
        self.resolutionLabel.text = self.currentResolutionStr;
        self.isShowResolutionView = !self.isShowResolutionView;
        
        NSMutableArray *array = [NSMutableArray array];
        for (ResolutionModel *model in self.resolutionArray) {
            [array addObject:model.resolution];
        }
        [self setResolutionArray:array currentResolution:self.currentResolutionStr];
        
        [self removeResolutionTableView];
        [self addVideoTableView];
        [self.chooseResoluBtn setImage:SuperPlayerImage(@"videoCache_down") forState:UIControlStateNormal];
        
        [self updateVideoModel];
        
    }
    
    if ([tableView isEqual:self.tableView]) {
        // 去处理下载问题
        VideoCacheModel *model = self.videoArray[indexPath.row];
        if (!model.isCache) {
            model.isCache = YES;
            TXVodDownloadMediaInfo *mediaInfo = [[TXVodDownloadMediaInfo alloc] init];
            TXVodDownloadDataSource *dataSource = [[TXVodDownloadDataSource alloc] init];
            dataSource.appId = model.appId;
            dataSource.fileId = model.fileId;
            dataSource.pSign = model.pSign;
            dataSource.quality = [self getCurrentQuality];
            mediaInfo.dataSource = dataSource;
            // 启动下载
            if (!model.drmBuilder) {
                [self.manager startDownload:mediaInfo];
            } else {
                [self.manager startDownloadWithDRMBuilder:model.drmBuilder];
            }
        }
    }
}

#pragma mark - TXVodDownloadDelegate
/// 下载开始
- (void)onCenterDownloadStart:(TXVodDownloadMediaInfo *)mediaInfo {
    NSString *toastName = @"";
    // 判断当前开始下载的对应videoCacheModel里面那个视频
    for (VideoCacheModel *model in self.videoArray) {
        if ((model.appId == mediaInfo.dataSource.appId) && ([model.fileId isEqualToString:mediaInfo.dataSource.fileId])) {
            toastName = model.videoTitle;
            break;
        }
    }
    
    [self toastTip:[playerLocalize(@"SuperPlayerDemo.MoviePlayer.startdownloadvideo") stringByAppendingFormat:@"%@",toastName]];
    [self.tableView reloadData];
}

/// 下载完成
- (void)onCenterDownloadFinish:(TXVodDownloadMediaInfo *)mediaInfo {
    NSString *toastName = @"";
    // 判断当前开始下载的对应videoCacheModel里面那个视频
    for (VideoCacheModel *model in self.videoArray) {
        if ((model.appId == mediaInfo.dataSource.appId) && ([model.fileId isEqualToString:mediaInfo.dataSource.fileId])) {
            toastName = model.videoTitle;
            break;
        }
    }

    [self toastTip:[[NSString stringWithFormat:@"%@",toastName] stringByAppendingString:
                    playerLocalize(@"SuperPlayerDemo.MoviePlayer.videodownloadfinish")]];
}
/// 下载错误
- (void)onCenterDownloadError:(TXVodDownloadMediaInfo *)mediaInfo errorCode:(NSInteger)code errorMsg:(NSString *)msg {
    NSString *toastName = @"";
    // 判断当前开始下载的对应videoCacheModel里面那个视频
    for (VideoCacheModel *model in self.videoArray) {
        if ((model.appId == mediaInfo.dataSource.appId) && ([model.fileId isEqualToString:mediaInfo.dataSource.fileId])) {
            toastName = model.videoTitle;
            model.isCache = NO;
            break;
        }
    }
    
    if (code == TXDownloadNoFile) {
        [self toastTip:LocalizeReplaceXX(playerLocalize(@"SuperPlayerDemo.MoviePlayer.videoxxnotexist"), toastName)];
    } else {
        [self toastTip:LocalizeReplaceXX(playerLocalize(@"SuperPlayerDemo.MoviePlayer.downloadvideoxxfailure"), toastName)];
    }
}

- (void)onCenterDownloadProgress:(nonnull TXVodDownloadMediaInfo *)mediaInfo {
    
}


- (void)onCenterDownloadStop:(nonnull TXVodDownloadMediaInfo *)mediaInfo {
    
}



#pragma mark - 懒加载
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor clearColor];
        [_topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseResoluClick)]];
    }
    return _topView;
}

- (UILabel *)clarityLabel {
    if (!_clarityLabel) {
        _clarityLabel = [[UILabel alloc] init];
        _clarityLabel.text = playerLocalize(@"SuperPlayerDemo.MoviePlayer.currentquality");
        _clarityLabel.font = [UIFont systemFontOfSize:14];
        _clarityLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:244.0/255.0 blue:255.0/255.0 alpha:1.0];
        _clarityLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _clarityLabel;
}

- (UILabel *)resolutionLabel {
    if (!_resolutionLabel) {
        _resolutionLabel = [[UILabel alloc] init];
        _resolutionLabel.font = [UIFont systemFontOfSize:14];
        _resolutionLabel.textColor = [UIColor colorWithRed:0/255.0 green:110.0/255.0 blue:255.0/255.0 alpha:1.0];
        _resolutionLabel.textAlignment = NSTextAlignmentLeft;
        [_resolutionLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseResoluClick)]];
    }
    return _resolutionLabel;
}

- (UIButton *)chooseResoluBtn {
    if (!_chooseResoluBtn) {
        _chooseResoluBtn = [[UIButton alloc] init];
        [_chooseResoluBtn setImage:SuperPlayerImage(@"videoCache_down") forState:UIControlStateNormal];
        [_chooseResoluBtn addTarget:self action:@selector(chooseResoluClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseResoluBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.scrollsToTop = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[VideoCacheCell class] forCellReuseIdentifier:VideoCacheCellIdentifier];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (UITableView *)resoluTableView {
    if (!_resoluTableView) {
        _resoluTableView = [UITableView new];
        _resoluTableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.66];
        _resoluTableView.scrollsToTop = NO;
        _resoluTableView.delegate = self;
        _resoluTableView.dataSource = self;
        _resoluTableView.estimatedRowHeight = 0;
        _resoluTableView.showsVerticalScrollIndicator = NO;
        _resoluTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ResolutionCell class] forCellReuseIdentifier:ResolutionCellIdentifier];
        if (@available(iOS 11.0, *)) {
            _resoluTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _resoluTableView;
}

- (UIButton *)viewCacheListBtn {
    if (!_viewCacheListBtn) {
        _viewCacheListBtn = [[UIButton alloc] init];
        [_viewCacheListBtn setTitle:playerLocalize(@"SuperPlayerDemo.MoviePlayer.viewingcachelist") forState:UIControlStateNormal];
        [_viewCacheListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _viewCacheListBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:98.0/255.0 blue:227.0/255.0 alpha:1.0];
        _viewCacheListBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _viewCacheListBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_viewCacheListBtn addTarget:self action:@selector(cacheListClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewCacheListBtn;
}

- (TXVodDownloadCenter *)manager {
    if (!_manager) {
        _manager = [TXVodDownloadCenter sharedInstance];
        _manager.delegate = self;
        // 设置下载存储路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *cachesDir = [paths objectAtIndex:0];
        NSString *path = [NSString stringWithFormat:@"%@/videoCache",cachesDir];
        [_manager setDownloadPath:path];
    }
    return _manager;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
        return NO;
    }
    
    return YES;
}

@end
