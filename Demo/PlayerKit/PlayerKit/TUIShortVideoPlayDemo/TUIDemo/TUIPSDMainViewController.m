//  Copyright (c) 2023 Tencent. All rights reserved.
//

#if __has_include(<tsr_client/TSRSdk.h>)
#import <tsr_client/TSRSdk.h>
#import <TXCMonetPlugin/TXCMonetPluginCommonDef.h>
#import <TXCMonetPlugin/TXCMonetPluginManager.h>
#endif
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
#import <TUIPlayerShortVideo/TUIPlayerContextDefine.h>
#import <TUIPlayerShortVideo/TUIPlayerShortVideo-umbrella.h>
#import "PlayerKitCommonHeaders.h"
#import "TUIPlayerConfigManager.h"
#import "TUIPlayerShortVideoControlView.h"
#import "TUIPADConfigManager.h"
#import "TUIPSControlCustomView.h"
#import "TUIPSControlLiveView.h"
#import "TUIPSControlView.h"
#import "TUIPSDLiteAVSDKHeader.h"
#import "TUIPSDLoadingView.h"
#import "TUIPSDMainViewController.h"
#import "TUIPSDSettingView.h"
#import "TUIPSDToolBar.h"
#import "TUIPSLoadingView.h"
#import "TUIPSupRefreshView.h"
#import "TUIPSVDCommonDefine.h"
#import "TUIPSVDResourceManager.h"
#import "UIView+TUIPSVD.h"

@interface TUIPSDMainViewController ()<
TUIShortVideoViewDelegate,
TUIShortVideoViewCustomCallbackDelegate,
TUIPSDToolBarDelegate,
TUIPullUpRefreshControlDelegate,
TUIPSDSettingViewDelegate>

@property (nonatomic, strong) UILabel *navTitleLabel;
@property (nonatomic, strong) UIButton *navBackButton;
@property (nonatomic, strong) TUIShortVideoView *videoView; // 短视频VideoView
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) TUIPSDToolBar *toolBar;
@property (nonatomic, strong) UIView *toolBarCoverView;
@property (nonatomic, strong) TUIPullUpRefreshControl *upRefresh;
@property (nonatomic, strong) TUIPSupRefreshView *upRefreshLoadingView;
@property (nonatomic, strong) UIButton *toolButton;
@property (nonatomic, assign) BOOL isEnteredLivePage;///是否已经进入直播详情

@end

@implementation TUIPSDMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *colors           = @[
        (__bridge id)[UIColor colorWithRed:19.0 / 255.0 green:41.0 / 255.0 blue:75.0 / 255.0 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:5.0 / 255.0 green:12.0 / 255.0 blue:23.0 / 255.0 alpha:1].CGColor
    ];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors           = colors;
    gradientLayer.startPoint       = CGPointMake(0, 0);
    gradientLayer.endPoint         = CGPointMake(1, 1);
    gradientLayer.frame            = self.view.bounds;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.navTitleLabel];
    [self.view addSubview:self.navBackButton];
    [self.view addSubview:self.toolButton];
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.toolBarCoverView];
    [self.navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(8);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.navBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navTitleLabel.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(3);
        make.height.equalTo(@(35));
        make.width.equalTo(@(50));
    }];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(0);
        /// 这里宽高建议采用固定的，以防止横屏状态下的位置错乱问题
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        make.height.equalTo(@([UIScreen mainScreen].bounds.size.height));
    }];
    [self.toolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(32));
        make.height.equalTo(@(100));
        make.left.equalTo(self.view.mas_left).offset(0);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoView.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.videoView.mas_bottom);
    }];
    [self.view layoutIfNeeded];
    [self.toolButton tuipsvd_setCornerRadius:45 forCorner:UIRectCornerTopRight|UIRectCornerBottomRight];
    
    
    self.toolBar.hidden = YES;
    [self.videoView startLoading];
    
    [self setConfig];
    [self setVideos];
    // [self.videoView didScrollToCellWithIndex:4 animated: NO];
    ///Add pull-down refresh like this if necessary
    self.videoView.refreshControl = self.refreshControl;
    
    
    
    [[NSNotificationCenter defaultCenter ] addObserver:self
                                              selector:@selector(containerVCWillEnterForeground)
                                                  name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter ] addObserver:self
                                              selector:@selector(containerVCDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [TXLiveBase setLogLevel:0];
#if __has_include(<tsr_client/TSRSdk.h>)
    ///  超分
    [[TXCMonetPluginManager sharedManager] setAppInfo:@"1252463788" authId:75 algorithmType:TXCMPAlgorithmType_Standard];
#endif
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
-(void)dealloc {
    NSLog(@"");
}
- (void)customBackAction {
    [self.videoView destoryPlayer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void )setVideos {
//     [self.videoView setShortVideoModels:[self video_1080p]];
//    [self.videoView setShortVideoModels:[self audio]];
    [self.videoView setShortVideoModels:[self video5]];
//    [self.videoView setShortVideoModels:[self video4]];
    self.pageIndex = 1;
}

- (void)setConfig {
    TUIPlayerConfig *config = [TUIPlayerConfig new];
    config.enableLog = YES;
    [[TUIPlayerCore shareInstance] setPlayerConfig:config];
    [TXPlayerGlobalSetting setLicenseFlexibleValid:YES];
}

#pragma mark - TUIShortVideoViewDelegate
- (void)scrollViewDidScrollContentOffset:(CGPoint)contentOffset {
    NSLog(@"TUI:scrollViewDidScrollContentOffset:contentOffset:%f",contentOffset.y);
}
/**
 * When staying in the current video, this method will be triggered. Here, you can obtain information about the currently fluctuating video and index the video array, and then process your related business here
 */
-(void)scrollToVideoIndex:(NSInteger)videoIndex
               videoModel:(TUIPlayerVideoModel *)videoModel {
    TUIPlayerVideoModel *model2 = [[TUIPlayerVideoModel alloc] init];
    model2.appId = 1300145571;
    model2.fileId = @"3701925922033792548";
    model2.pSign = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6MTMwMDE0NTU3MSwiZmlsZUlkIjoiMzcwMTkyNTkyMjAzMzc5MjU0OCIsImN1cnJlbnRUaW1lU3RhbXAiOjE3MTI5MDQzNzcsImNvbnRlbnRJbmZvIjp7ImF1ZGlvVmlkZW9UeXBlIjoiT3JpZ2luYWwifSwiZXhwaXJlVGltZVN0YW1wIjoxNzMyNzIzMjAwLCJ1cmxBY2Nlc3NJbmZvIjp7ImRvbWFpbiI6IjEzMDAxNDU1NzEudm9kMi5teXFjbG91ZC5jb20iLCJzY2hlbWUiOiJIVFRQIn19.m2Ei1Ne8Wo60wluasKQumYszC7HJCOhjaZg-TCdD5YU";
      
    TUIPlayerVideoModel *model3 = [[TUIPlayerVideoModel alloc] init];
    model3.appId = 1300145571;
    model3.fileId = @"3701925922033792548";
    model3.pSign = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6MTMwMDE0NTU3MSwiZmlsZUlkIjoiMzcwMTkyNTkyMjAzMzc5MjU0OCIsImN1cnJlbnRUaW1lU3RhbXAiOjE3MTI5MDQzNzcsImNvbnRlbnRJbmZvIjp7ImF1ZGlvVmlkZW9UeXBlIjoiT3JpZ2luYWwifSwiZXhwaXJlVGltZVN0YW1wIjoxNzMyNzIzMjAwLCJ1cmxBY2Nlc3NJbmZvIjp7ImRvbWFpbiI6IjEzMDAxNDU1NzEudm9kMi5teXFjbG91ZC5jb20iLCJzY2hlbWUiOiJIVFRQIn19.m2Ei1Ne8Wo60wluasKQumYszC7HJCOhjaZg-TCdD5YU";
// NOTE:在add和replace多个数据操作的时候如果传入两个相同指针的model（例如两个model2)会有一些[小问题]
// 小问题：在用model获取player时会选择第二个model导致一次跳两个。以下是复现代码
#if 0
    [[self.videoView getDataManager] addRangeData:@[model2,model3] startIndex:videoIndex];
    [[self.videoView getDataManager] replaceRangeData:@[model2,model3] startIndex:videoIndex];
#endif
    NSLog(@"TUI:videoIndex:%ld videoModel:%@",(long)videoIndex,videoModel);
}

- (void)shortVideoView:(TUIShortVideoView *)shortVideoView
      willDefocusVideo:(TUIPlayerDataModel *)video
               context:(NSDictionary<TUIPlayerContext, id> *)context {
    if (![shortVideoView isEqual:self.videoView]) {
        return;
    }
    NSTimeInterval playBackTime = [[context objectForKey:TUIPlayerPlayBackTime] doubleValue];
    NSLog(@"Will defocus video, progress：%lf", playBackTime);
}

- (void)shortVideoView:(TUIShortVideoView *)shortVideoView
        playerDidReady:(TUITXVodPlayer *)player
            videoModel:(TUIPlayerVideoModel *)videoModel {
    if (![shortVideoView isEqual:self.videoView]) {
        return;
    }
    player.loop = YES;
    [player setStartTime:0.0];
}

-(void)onReachLast {
    //追加一组数据，维护index关系，继续添加数据，这里只做一组展示
    /**
     * Add a set of data, maintain the index relationship, and continue to add data. Only one set will be displayed here
     */
    if (self.pageIndex == 1) {
        //TX [self.videoView appendShortVideoModels:[self video_1080p_2]];
        [self.videoView appendShortVideoModels:[self video4]];
        self.pageIndex++;
    }
}
///Player status callback
-(void)currentVideo:(TUIPlayerVideoModel *)videoModel
      statusChanged:(TUITXVodPlayerStatus)status{
    if (status == TUITXVodPlayerStatusPlaying) {
        self.toolBar.resolutionArray = self.videoView.currentPlayerSupportedBitrates;
        self.toolBar.currentIndex = self.videoView.bitrateIndex;
    }
}
///Progress callback for playing video
- (void)currentVideo:(TUIPlayerVideoModel *)videoModel
         currentTime:(float)currentTime
           totalTime:(float)totalTime
            progress:(float)progress{
    /// do something
}
///Network status for playing video
-(void)onNetStatus:(TUIPlayerVideoModel *)videoModel withParam:(NSDictionary *)param {
    /// do something
}
///Video preload callback
- (void)videoPreLoadStateWithModel:(nonnull TUIPlayerVideoModel *)videoModel {
    /// do something
    NSLog(@"");
}
#pragma mark - TUIShortVideoViewCustomCallbackDelegate
-(void)customCallbackEvent:(id)info {
    if ([info isEqual:@"resolutionAction"]) {
        [self resolutionButtonAction];
    }
    if ([info isEqual:@"EnteredLivePage:YES"]) {
        self.isEnteredLivePage = YES;
    }
    if ([info isEqual:@"EnteredLivePage:NO"]) {
        self.isEnteredLivePage = NO;
    }
}
#pragma mark - TUIPSDToolBarDelegate
- (void)switchWithResolution:(long)resolution index:(NSInteger)index {
    [self.videoView switchResolution:resolution index:index];
}
- (void)preloadPause:(BOOL)isPause {
    if (isPause == YES) {
        [self.videoView pausePreload];
    } else {
        [self.videoView resumePreload];
    }
}
#pragma mark - TUIPullUpRefreshControlDelegate
- (void)scrollViewDidScrollContentOffsetY:(CGFloat)y {
    [self.upRefreshLoadingView scrollViewDidScrollContentOffsetY:y];
}
- (void)beginRefreshing {
    [self.upRefreshLoadingView beginRefreshing];
}
- (void)endRefreshing {
    [self.upRefreshLoadingView endRefreshing];
}
#pragma mark - data
-(NSArray *)video4 {
    return [[TUIPlayerConfigManager shareInstance] getVideo:@"video4"];
    
}
-(NSArray *)video5 {
    return [[TUIPlayerConfigManager shareInstance] getVideo:@"video5"];
    
}
-(NSArray *)video6 {
    return [[TUIPlayerConfigManager shareInstance] getVideo:@"video6"];
    
}
-(NSArray *)video7 {
    return [[TUIPlayerConfigManager shareInstance] getVideo:@"video7"];
    
}
-(NSArray *)video8 {
    return [[TUIPlayerConfigManager shareInstance] getVideo:@"video8"];
    
}
-(NSArray *)video_720p {
    return [[TUIPlayerConfigManager shareInstance] getVideo:@"720p"];
    
}
-(NSArray *)video_1080p {
    return [[TUIPlayerConfigManager shareInstance] getVideo:@"1080p"];
    
}
-(NSArray *)video_1080p_2 {
    return [[TUIPlayerConfigManager shareInstance] getVideo:@"1080p-2"];
    
}
-(NSArray *)audio {
    return [[TUIPlayerConfigManager shareInstance] getVideo:@"audio"];
}
#pragma mark - 懒加载
- (UILabel *)navTitleLabel {
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc] init];
        _navTitleLabel.textColor = [UIColor whiteColor];
        _navTitleLabel.text = @"Short Video";
    }
    return _navTitleLabel;
}
- (UIButton *)navBackButton {
    if (!_navBackButton) {
        _navBackButton = [[UIButton alloc] init];
        [_navBackButton setImage:[TUIPSVDResourceManager assetImageWithName:@"tuipsvd_back"] forState:UIControlStateNormal];
        [_navBackButton addTarget:self action:@selector(customBackAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBackButton;
}
- (TUIShortVideoView *)videoView {
    if (!_videoView) {
        ///设置自定义UI
        TUIPlayerShortVideoUIManager *uiManager = [[TUIPlayerShortVideoUIManager alloc] init];
        ///Set custom UI
//        [uiManager setControlViewClass: TUIPSControlView.class];
//        [uiManager setControlViewClass: TUIPSControlCustomView.class viewType:TUI_ITEM_VIEW_TYPE_CUSTOM];
//        [uiManager setControlViewClass: TUIPSControlLiveView.class viewType:TUI_ITEM_VIEW_TYPE_LIVE];
//        [uiManager setLoadingView:[[TUIPSLoadingView alloc] init]];
        // Default UI
        [uiManager setControlViewClass: TUIPlayerShortVideoControlView.class];
        [uiManager setControlViewClass: TUIPSControlLiveView.class viewType:TUI_ITEM_VIEW_TYPE_LIVE];
        [uiManager setControlViewClass: TUIPSControlCustomView.class viewType:TUI_ITEM_VIEW_TYPE_CUSTOM];
        [uiManager setLoadingView:[[TUIPSDLoadingView alloc] init]];
        
        _videoView = [[TUIShortVideoView alloc] initWithUIManager:uiManager];
        _videoView.delegate = self;
        _videoView.customCallbackDelegate = self;
        //_videoView.isAutoPlay = NO;
        
        // Set your playback strategy
        TUIPlayerVodStrategyModel *model = [[TUIPlayerVodStrategyModel alloc] init];
        model.mPreloadConcurrentCount = 2;
        model.preDownloadSize = 1;
        model.enableAutoBitrate = NO;
        model.enableLastPrePlay = YES;
        
        TUIPADConfigManager *configManager = [TUIPADConfigManager sharedManager];
        NSString *resumeModel = configManager.vodResumeMode;
        if ([resumeModel isEqualToString:@"NONE"]) {
            model.mResumeModel = 0;
        } else if ([resumeModel isEqualToString:@"LAST"]) {
            model.mResumeModel = 1;
        } else if ([resumeModel isEqualToString:@"PLAYED"]) {
            model.mResumeModel = 2;
        }
        NSString *audioNormalization = configManager.vodAudioNormalization;
        if ([audioNormalization isEqualToString:@"OFF"]) {
            model.audioNormalization = AUDIO_NORMALIZATION_OFF;
        } else if ([audioNormalization isEqualToString:@"STANDARD"]) {
            model.audioNormalization = AUDIO_NORMALIZATION_STANDARD;
        } else if ([audioNormalization isEqualToString:@"LOW"]) {
            model.audioNormalization = AUDIO_NORMALIZATION_LOW;
        } else if ([audioNormalization isEqualToString:@"HIGH"]) {
            model.audioNormalization = AUDIO_NORMALIZATION_HIGH;
        }
        ///超分
        NSString *superResolutionType = configManager.vodSuperResolutionType;
        if ([superResolutionType isEqualToString:@"OFF"]) {
            model.superResolutionType = TUI_SuperResolution_NONE;
        } else if ([superResolutionType isEqualToString:@"TSR"]){
            model.superResolutionType = TUI_SuperResolution_TSR;
        }
        
        NSString *loopModel = configManager.vodLoopMode;
        //[@"ONE_LOOP",@"LIST_LOOP",@"CUSTOM_LOOP"]
        if ([loopModel isEqualToString:@"ONE_LOOP"]) {
            [self.videoView setPlaymode:0];
        } else if ([loopModel isEqualToString:@"LIST_LOOP"]) {
            [self.videoView setPlaymode:1];
        } else if ([loopModel isEqualToString:@"CUSTOM_LOOP"]) {
            [self.videoView setPlaymode:2];
        }
        ///rendMode
        NSString *rendMode = configManager.vodRenderMode;
        if ([rendMode isEqualToString:@"FILL_EDGE"]) {
            model.mRenderMode = TUI_RENDER_MODE_FILL_EDGE;
        } else if ([rendMode isEqualToString:@"FILL_SCREEN"]) {
            model.mRenderMode = TUI_RENDER_MODE_FILL_SCREEN;
        }
        
        // 字幕样式
        TXPlayerSubtitleRenderModel *subtitleRenderModel = [[TXPlayerSubtitleRenderModel alloc] init];
        subtitleRenderModel.canvasWidth = 1920;  // 字幕渲染画布的宽
        subtitleRenderModel.canvasHeight = 1080;  // 字幕渲染画布的高
        subtitleRenderModel.fontSize = 30;
        subtitleRenderModel.fontColor = 0xFFFF0000;
        subtitleRenderModel.verticalMargin = 0.5;
        model.subtitleRenderModel = subtitleRenderModel;
        model.headers = @{@"aaa":@"xxxx"};
        [_videoView setShortVideoStrategyModel:model];
        
        // live strategy
        TUIPlayerLiveStrategyModel *liveStrateyModel = [[TUIPlayerLiveStrategyModel alloc] init];
        liveStrateyModel.enableLastPrePlay = YES;
        
        NSString *pip = configManager.livePip;
        if ([pip isEqualToString:@"ON"]) {
            liveStrateyModel.enablePictureInPicture = YES;
        } else if ([pip isEqualToString:@"OFF"]) {
            liveStrateyModel.enablePictureInPicture = NO;
        }
        
        NSString *liveRendMode = configManager.liveRendMode;
        if ([liveRendMode isEqualToString:@"Fill"]) {
            liveStrateyModel.mRenderMode = V2TXLiveFillModeFill;
        } else if ([liveRendMode isEqualToString:@"Fit"]) {
            liveStrateyModel.mRenderMode = V2TXLiveFillModeFit;
        } else if ([liveRendMode isEqualToString:@"ScaleFill"]) {
            liveStrateyModel.mRenderMode = V2TXLiveFillModeScaleFill;
        }
        
        [_videoView setShortVideoLiveStrategyModel:liveStrateyModel];
        
        _videoView.pullUpRefreshControl = self.upRefresh;
        _videoView.scrollEnabled = YES;
      
    }
    return _videoView;
}
-(UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        _refreshControl.tintColor = [UIColor redColor];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Pull down to refresh"];
        UIFont *font = [UIFont boldSystemFontOfSize:20.0];
        UIColor *textColor = [UIColor redColor];
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, attributedString.length)];
        
        _refreshControl.attributedTitle = attributedString;
        /// Add a listener for the refresh event
        [_refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (TUIPullUpRefreshControl *)upRefresh {
    if (!_upRefresh){
        _upRefresh = [[TUIPullUpRefreshControl alloc] init];
        _upRefresh.loadingView = self.upRefreshLoadingView;
        _upRefresh.loadingViewSize = CGSizeMake(100, 80);
        [_upRefresh addTarget:self action:@selector(upRefreshAction)];
        _upRefresh.delegate = self;
    }
    return _upRefresh;
}
- (TUIPSupRefreshView *)upRefreshLoadingView {
    if (!_upRefreshLoadingView) {
        _upRefreshLoadingView = [[TUIPSupRefreshView alloc] init];
    }
    return _upRefreshLoadingView;
}

- (TUIPSDToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[TUIPSDToolBar alloc] init];
        _toolBar.delegate = self;
    }
    return _toolBar;
}
- (UIView *)toolBarCoverView {
    if (!_toolBarCoverView) {
        _toolBarCoverView = [[UIView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toolBarCoverViewTapped:)];

        // 将 UITapGestureRecognizer 添加到你的 UIView
        _toolBarCoverView.userInteractionEnabled = YES;
        [_toolBarCoverView addGestureRecognizer:tapGesture];
    }
    return _toolBarCoverView;
}
- (UIButton *)toolButton {
    if (!_toolButton) {
        _toolButton = [[UIButton alloc] init];
        [_toolButton setBackgroundColor:TUIPSVD_COLOR_BLACK];
        [_toolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_toolButton setImage:[TUIPSVDResourceManager assetImageWithName:@"tuipsvd_settings"] forState:UIControlStateNormal];
        [_toolButton addTarget:self action:@selector(toolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolButton;
}
- (void)toolButtonClick:(UIButton *)button{
    button.hidden = YES;
    [[TUIPSDSettingView sharedInstance] show:self.view delegate:self];
}
#pragma mark - TUIPSDSettingViewDelegate
- (void)confirmActionVodResumeModel:(NSString *)resumeModel
                          loopModel:(NSString *)loopModel
                 audioNormalization:(nonnull NSString *)audioNormalization
                superResolutionType:(nonnull NSString *)superResolutionType
                           rendMode:(nonnull NSString *)rendMode{
    //[@"NONE",@"LAST",@"PLAYED"]
    if ([resumeModel isEqualToString:@"NONE"]) {
        [self.videoView.getVodStrategyManager setResumeModel:0];
    } else if ([resumeModel isEqualToString:@"LAST"]) {
        [self.videoView.getVodStrategyManager setResumeModel:1];
    } else if ([resumeModel isEqualToString:@"PLAYED"]) {
        [self.videoView.getVodStrategyManager setResumeModel:2];
    }
    
    if ([audioNormalization isEqualToString:@"OFF"]) {
        [self.videoView.getVodStrategyManager setAudioNormalization:AUDIO_NORMALIZATION_OFF];
    } else if ([audioNormalization isEqualToString:@"STANDARD"]) {
        [self.videoView.getVodStrategyManager setAudioNormalization:AUDIO_NORMALIZATION_STANDARD];
    } else if ([audioNormalization isEqualToString:@"LOW"]) {
        [self.videoView.getVodStrategyManager setAudioNormalization:AUDIO_NORMALIZATION_LOW];
    } else if ([audioNormalization isEqualToString:@"HIGH"]) {
        [self.videoView.getVodStrategyManager setAudioNormalization:AUDIO_NORMALIZATION_HIGH];
    }
    ///超分
    if ([superResolutionType isEqualToString:@"OFF"]) {
        [self.videoView.getVodStrategyManager setSuperResolutionType:TUI_SuperResolution_NONE];
    } else if ([superResolutionType isEqualToString:@"TSR"]){
        [self.videoView.getVodStrategyManager setSuperResolutionType:TUI_SuperResolution_TSR];
    }
    
    //[@"ONE_LOOP",@"LIST_LOOP",@"CUSTOM_LOOP"]
    if ([loopModel isEqualToString:@"ONE_LOOP"]) {
        [self.videoView setPlaymode:0];
    } else if ([loopModel isEqualToString:@"LIST_LOOP"]) {
        [self.videoView setPlaymode:1];
    } else if ([loopModel isEqualToString:@"CUSTOM_LOOP"]) {
        [self.videoView setPlaymode:2];
    }
    ///rendMode
    if ([rendMode isEqualToString:@"FILL_EDGE"]) {
        [self.videoView.getVodStrategyManager setRenderMode:TUI_RENDER_MODE_FILL_EDGE];
    } else if ([rendMode isEqualToString:@"FILL_SCREEN"]) {
        [self.videoView.getVodStrategyManager setRenderMode:TUI_RENDER_MODE_FILL_SCREEN];
    }
    
    
}
- (void)confirmActionLivePip:(NSString *)pip
                    rendMode:(NSString *)rendMode {
    if ([pip isEqualToString:@"ON"]) {
        [self.videoView.getLiveStrategyManager setEnablePictureInPicture:YES];
    } else if ([pip isEqualToString:@"OFF"]) {
        [self.videoView.getLiveStrategyManager setEnablePictureInPicture:NO];
    }
    
    if ([rendMode isEqualToString:@"Fill"]) {
        [self.videoView.getLiveStrategyManager setRenderMode:V2TXLiveFillModeFill];
    } else if ([rendMode isEqualToString:@"Fit"]) {
        [self.videoView.getLiveStrategyManager setRenderMode:V2TXLiveFillModeFit];
    } else if ([rendMode isEqualToString:@"ScaleFill"]) {
        [self.videoView.getLiveStrategyManager setRenderMode:V2TXLiveFillModeScaleFill];
    }
}
- (void)addButtonClickAction:(NSArray *)params {
    NSArray *array = params;
    TUIShortVideoDataManager *dataManager = [self.videoView getDataManager];
    
    NSString *type = array[0];
    if ([type isEqualToString:@"-"]) {
        NSInteger loc = [array[1] integerValue];
        NSInteger len = [array[2] integerValue];
        TUIPlayerDataModel *model = dataManager.currentModel;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i <= len; i++) {
            [arr addObject:[model copy]];
        }
        [dataManager addRangeData:arr startIndex:loc];
    } else {
        if (array.count == 2) { ///
            TUIPlayerDataModel *model = [dataManager.currentModel copy];
            NSInteger index = [array[1] integerValue];
            [dataManager addData:model index:index];
        } else {
            TUIPlayerDataModel *model = dataManager.currentModel;
            for (int i = 1; i < array.count; i++) {
                NSInteger index = [array[i] integerValue];
                [dataManager addData:[model copy] index:index];
            }
        }
    }
}
- (void)removeButtonClickAction:(NSArray *)params {
    NSArray *array = params;
    TUIShortVideoDataManager *dataManager = [self.videoView getDataManager];
    
    NSString *type = array[0];
    if ([type isEqualToString:@"-"]) {
        NSInteger loc = [array[1] integerValue];
        NSInteger len = [array[2] integerValue];
        NSRange range = NSMakeRange(loc , len);
        [dataManager removeRangeData:range];
    } else {
        if (array.count == 2) { ///
            NSInteger index = [array[1] integerValue];
            [dataManager removeData:index];
        } else {
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 1; i < array.count; i++) {
                NSInteger index = [array[i] integerValue];
                [array addObject:[NSNumber numberWithInteger:index]];
            }
            [dataManager removeDataByIndex:array];
        }
    }
}
- (void)replaceButtonClickAction:(NSArray *)params {
    NSArray *array = params;
    TUIShortVideoDataManager *dataManager = [self.videoView getDataManager];
    
    NSString *type = array[0];
    if ([type isEqualToString:@"-"]) {
        NSInteger loc = [array[1] integerValue];
        NSInteger len = [array[2] integerValue];
        TUIPlayerDataModel *model = dataManager.currentModel;
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i <= len; i++) {
            [arr addObject:model];
        }
        [dataManager replaceRangeData:arr startIndex:loc];
    } else {
        TUIPlayerDataModel *model = dataManager.currentModel;
        if (array.count == 2) { ///
            NSInteger index = [array[1] integerValue];
            [dataManager replaceData:[model copy] index:index];
        } else {
            for (int i = 1; i < array.count; i++) {
                NSInteger index = [array[i] integerValue];
                [dataManager replaceData:[model copy] index:index];
            }
        }
    }
}
- (void)closeAction {
    self.toolButton.hidden = NO;
}
- (void)test {
    NSLog(@"AAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    [self.videoView switchResolution:540 index:1];
    TUIShortVideoDataManager *dataManager = [self.videoView getDataManager];
    
    [dataManager removeData:2];
    
    TUIPlayerDataModel *model_0 = [[TUIPlayerDataModel alloc] init];
    NSDictionary *extr_0 = @{
        @"adTitile":@"0",
        @"adDes":@"XXX"
    };
    model_0.extInfo = extr_0;
    TUIPlayerDataModel *model_1 = [[TUIPlayerDataModel alloc] init];
    NSDictionary *extr_1 = @{
        @"adTitile":@"1",
        @"adDes":@"XXX"
    };
    model_1.extInfo = extr_1;
    
    TUIPlayerDataModel *model_3 = [[TUIPlayerDataModel alloc] init];
    
    TUIPlayerVideoModel *model2 = [[TUIPlayerVideoModel alloc] init];
    model2.appId = 1300145571;
    model2.fileId = @"3701925922033792548";
    model2.pSign = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6MTMwMDE0NTU3MSwiZmlsZUlkIjoiMzcwMTkyNTkyMjAzMzc5MjU0OCIsImN1cnJlbnRUaW1lU3RhbXAiOjE3MTI5MDQzNzcsImNvbnRlbnRJbmZvIjp7ImF1ZGlvVmlkZW9UeXBlIjoiT3JpZ2luYWwifSwiZXhwaXJlVGltZVN0YW1wIjoxNzMyNzIzMjAwLCJ1cmxBY2Nlc3NJbmZvIjp7ImRvbWFpbiI6IjEzMDAxNDU1NzEudm9kMi5teXFjbG91ZC5jb20iLCJzY2hlbWUiOiJIVFRQIn19.m2Ei1Ne8Wo60wluasKQumYszC7HJCOhjaZg-TCdD5YU";
    
    TUIPlayerLiveModel *model_4 = [[TUIPlayerLiveModel alloc] init];
    model_4.liveUrl = @"http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv";
    model_4.coverPictureUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/66bc542f387702300661648850/0RyP1rZfkdQA.png";
    NSDictionary *extr_4 = @{
        @"name":@"@Mars",
        @"liveTitile":@"This is a live broadcast interface(FLV)",
        @"liveDes":@"This is a live broadcast interface This is a live broadcast interface This is a live broadcast interface"
    };
    model_4.extInfo = extr_4;
    
//    [self.videoView setShortVideoModels: self.video5];
    /// 1、删除
    //[dataManager removeData:4];
    //[dataManager removeRangeData:NSMakeRange(0, 2)];
    //[dataManager removeDataByIndex:@[@(2),@(4)]];
    
    /// 2、添加
   ///[dataManager  addData:model_4 index:1];
   //[dataManager  addRangeData:@[model_0,model_1] startIndex:0];
    ///3、替换
   //[dataManager replaceData:model2 index:1];
   // [dataManager replaceRangeData:@[model2,[model2 copy]] startIndex:0];
}
#pragma mark - private methods
- (void)refreshData {
    [self.videoView.refreshControl beginRefreshing];
    /// Perform the operation of refreshing data here
    
    ///After the refresh is completed, call the endRefreshing method to stop refreshing
    [self.videoView.refreshControl endRefreshing];
}

- (void)upRefreshAction {
    [self.videoView.pullUpRefreshControl beginRefreshing];
    /// Perform the operation of refreshing data here
    
    ///After the refresh is completed, call the endRefreshing method to stop refreshing
    [self.videoView.pullUpRefreshControl endRefreshing];
}

- (void)resolutionButtonAction {
    if (self.toolBar.isShow == NO) {
        [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.view);
            make.right.equalTo(self.view.mas_right).offset(-80);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
        self.toolBar.isShow = YES;
        self.toolBar.hidden = NO;
        self.toolBarCoverView.hidden = NO;
        [self.toolBarCoverView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.view);
            make.right.equalTo(self.toolBar.mas_left);
        }];
    } else {
        [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.view);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
        self.toolBar.isShow = NO;
        self.toolBar.hidden = YES;
        self.toolBarCoverView.hidden = YES;
    }
}

- (void)toolBarCoverViewTapped:(UITapGestureRecognizer *)gesture {
    self.toolBarCoverView.hidden = YES;
    [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    self.toolBar.isShow = NO;
    self.toolBar.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Foreground & Background

- (void)containerVCWillEnterForeground {
    if ([self.videoView.getLiveStrategyManager enablePictureInPicture] == YES) {
        return;
    }
    if (self.isEnteredLivePage == YES) {
        return;
    }

    [self.videoView resume];
}

- (void)containerVCDidEnterBackground {
    if ([self.videoView.getLiveStrategyManager enablePictureInPicture] == YES) {
        return;
    }
    if (self.isEnteredLivePage == YES) {
        return;
    }
    
    [self.videoView pause];
}
@end
