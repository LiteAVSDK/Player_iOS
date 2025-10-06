//
//  MoviePlayerViewController.m
//

#import "MoviePlayerViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "PlayerKitCommonHeaders.h"
#import <MediaPlayer/MediaPlayer.h>

#import "AFNetworking.h"
#import "AppLocalized.h"
#import "CFDanmakuView.h"
#import "PlayerKitCommonHeaders.h"
#import "ListVideoCell.h"
#import "MBProgressHUD.h"
#import "TPScanQRController.h"
#import "SuperPlayerGuideView.h"
#import "TCHttpUtil.h"
#import "TXMoviePlayerNetApi.h"
#import "UGCUploadList.h"
#import "UIImageView+WebCache.h"
#import "VideoCacheView.h"
#import "TXAppInstance.h"

#define OFFLINE_VIDEOCATCHVIEW_HEIGHT 282

#define LIST_VIDEO_CELL_ID @"LIST_VIDEO_CELL_ID"
#define LIST_LIVE_CELL_ID  @"LIST_LIVE_CELL_ID"

#define VIP_VIDEO_DEFAULT_CELL_TITLE @"试看功能演示"
#define DYNAMIC_WATER_VIDEO_DEFAULT_CELL_TITLE @"动态水印演示"
#define COVER_DEFAULT_DEFAULT_TITLE  @"自定义封面"

#define COVER_DEFAULT_URL    @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/cc1e28208602268011087336518/MXUW1a5I9TsA.png"

#define VIDEO_LOOP_PLAY_DEFAULT_URL    @"http://1400155958.vod2.myqcloud.com/facd87c8vodcq1400155958/06622723387702299939461564/G5gEpcHlyaYA.png"
#define VIDEO_OFFLINE_CACHE_DEFAULT_URL    @"http://1400155958.vod2.myqcloud.com/facd87c8vodcq1400155958/0183245d387702299939234236/c7yiepstuHcA.png"

#define LOCAL_LIVE_COVERURL @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/66bc542f387702300661648850/0RyP1rZfkdQA.png"
#define LOCAL_LIVE_FLV_URL      @"http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv"
#define LOCAL_LIVE_RTMP_URL      @"rtmp://liteavapp.qcloud.com/live/liteavdemoplayerstreamid"
#define LOCAL_LIVE_WEBRTC_URL      @"webrtc://liteavapp.qcloud.com/live/liteavdemoplayerstreamid"
#define LOCAL_LIVE_HLS_URL      @"http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.m3u8"

#define MULTI_TRACK_VIDEO  @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/3a76d6ac387702303793151471/iP3rnDdxMH4A.mov";
#define MULTI_SUBTITLES_VIDEO @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/dc455d1d387702306937256938/mUAS0RDnhLwA.mp4";

#define TRACK_COVERURL @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/3a76d6ac387702303793151471/387702307093360124.png";
#define SUBTITLES_COVERURL @"http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/dc455d1d387702306937256938/coverBySnapshot_10_0.jpg";

#define DRM_COVER_URL @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/4ff64b01387702299774574470/387702304138941858.png"
#define DRM_VIDEO_URL @"https://1500017640.vod2.myqcloud.com/439767a2vodtranscq1500017640/30eb640e243791578648828779/adp.1434418.m3u8"
#define DRM_LICENSE @"https://fairplay.drm.vod-qcloud.com/fairplay/getlicense/v2?drmToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9~eyJ0eXBlIjoiRHJtVG9rZW4iLCJhcHBJZCI6MTUwMDAxNzY0MCwiZmlsZUlkIjoiMjQzNzkxNTc4NjQ4ODI4Nzc5IiwiY3VycmVudFRpbWVTdGFtcCI6MCwiZXhwaXJlVGltZVN0YW1wIjoyMTQ3NDgzNjQ3LCJyYW5kb20iOjAsIm92ZXJsYXlLZXkiOiIiLCJvdmVybGF5SXYiOiIiLCJjaXBoZXJlZE92ZXJsYXlLZXkiOiIiLCJjaXBoZXJlZE92ZXJsYXlJdiI6IiIsImtleUlkIjowLCJzdHJpY3RNb2RlIjowLCJwZXJzaXN0ZW50IjoiT04iLCJyZW50YWxEdXJhdGlvbiI6MCwiZm9yY2VMMVRyYWNrVHlwZXMiOm51bGx9~bTRTEni3j96XeRa17olRo6KT_dvSNrjJCZQ4b7Wb-qw"
#define DRM_CERTIFICATE @"https://cert.drm.vod-qcloud.com/cert/v1/816de426e6caa23d680a0198171aef89/fairplay.cer?updateTime=1673872343"


__weak UITextField *appField;
__weak UITextField *fileidField;
__weak UITextField *urlField;
__weak UITextField *psignField;
__weak UITextField *cacheField;

@interface MoviePlayerViewController () <SuperPlayerDelegate, TPScanQRDelegate, UITableViewDelegate, UITableViewDataSource, CFDanmakuDelegate>
/// The parent view of the player View
/// 播放器View的父视图
@property(nonatomic, strong) UIView *                 playerFatherView;
@property(strong, nonatomic) SuperPlayerView *playerView;
/// Whether it is playing when leaving the page
/// 离开页面时候是否在播放
@property(nonatomic, assign) BOOL           isPlaying;
@property(nonatomic, strong) UGCUploadList *ugcUplaodList;  // UGC 上传业务 & UGC upload business
@property(nonatomic, strong) UIView *       bottomView;
@property(weak, nonatomic) IBOutlet UIButton *backBtn;
@property(nonatomic, strong) UITextField *    textView;

@property(nonatomic, strong)UIBarButtonItem *navBackBtn;//返回 & return
@property(nonatomic, strong)UIBarButtonItem *navHelpBtn;//帮助 & help
@property(nonatomic, strong)UIBarButtonItem *navScanBtn;//扫码 & scan

@property(nonatomic, strong) UITableView *vodListView;
@property(nonatomic, strong) UITableView *liveListView;
@property(nonatomic, strong) UIButton *vodBtn;
@property(nonatomic, strong) UIButton *liveBtn;

@property(nonatomic, strong) NSMutableArray *authParamArray;
@property(nonatomic, strong) NSMutableArray *vodDataSourceArray;
@property(nonatomic, strong) NSMutableArray *liveDataSourceArray;
@property(nonatomic, strong) TXMoviePlayerNetApi *getInfoNetApi;
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) UIButton *addBtn;

@property(nonatomic, strong) SuperPlayerGuideView *guideView;
//Video list sliding scrollview
//视频列表滑动scrollview
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIButton *      playerBackBtn;
@property(nonatomic, strong) AFHTTPSessionManager *manager;
@property(nonatomic, strong) CFDanmakuView *danmakuView;
@property (nonatomic, strong) VideoCacheView *cacheView;

// list of currently playing videos, may be a single video, may be a group of videos
// 当前正在播放的视频列表，可能是单个视频，可能是一组视频
@property (nonatomic, strong) NSMutableArray *currentPlayVideoArray;
//When the playback is pulled up from the outside, stop automatically playing the VOD video
//从外部拉起播放时，停止自动播放VOD视频
@property(nonatomic, assign) BOOL stopAutoPlayVOD;
@property (nonatomic, assign) BOOL isAddLoopVideo;
@property (nonatomic, strong) NSMutableDictionary *cacheDic;

//记录Navigation Bar的状态
@property (nonatomic, assign) BOOL isNavigationBarHidden;

@end

@implementation MoviePlayerViewController

- (instancetype)init {
    
    if (SuperPlayerWindowShared.backController &&
        [SuperPlayerWindowShared.backController isKindOfClass:MoviePlayerViewController.class]) {
        [SuperPlayerWindowShared hide];
        MoviePlayerViewController *playerViewCtrl = (MoviePlayerViewController *)SuperPlayerWindowShared.backController;
        playerViewCtrl.danmakuView.clipsToBounds  = NO;
        return playerViewCtrl;
    }
    if (SuperPlayerPIPShared.backController &&
        [SuperPlayerPIPShared.backController isKindOfClass:MoviePlayerViewController.class]){
        MoviePlayerViewController *playerViewCtrl = (MoviePlayerViewController *)SuperPlayerPIPShared.backController;
        return playerViewCtrl;
    }
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)addObservers {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(updateLockScreenInfo)
                   name:UIApplicationDidEnterBackgroundNotification
                 object:nil];
}

// Update the lock screen interface information
// 更新锁屏界面信息
- (void)updateLockScreenInfo {
    // 1. Get the lock screen center
    // 1.获取锁屏中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    // Initialize a dictionary to store music information
    // 初始化一个存放音乐信息的字典
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    // 2. Set the name
    // 2、设置名称
    if (self.playerView.playerModel.name.length > 0) {
        [playingInfoDict setObject:self.playerView.playerModel.name forKey:MPMediaItemPropertyTitle];
    }
    // 3. Set the picture of the cover
    // 3、设置封面的图片
    __block UIImage *image = [[TXAppInstance class] imageFromPlayerBundleNamed:@"TengXunYun_logo"];
    if (image) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(100, 100)
                                                                      requestHandler:^UIImage * _Nonnull(CGSize size) {
            return image;
        }];
        [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    }
    //Music information is assigned to the nowPlayingInfo property of the lock screen center
    //音乐信息赋值给获取锁屏中心的nowPlayingInfo属性
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
}

- (void)dealloc {
    NSLog(@"%@", LocalizeReplaceXX(LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.xxtherelease"), NSStringFromClass(self.class)));
    [_manager invalidateSessionCancelingTasks:YES resetSession:NO];
}

- (void)willMoveToParentViewController:(nullable UIViewController *)parent {
}
- (void)didMoveToParentViewController:(nullable UIViewController *)parent {
    if (parent == nil) {
        if (!SuperPlayerWindowShared.isShowing && !SuperPlayerPIPShared.isShowing) {
            [self.playerView resetPlayer];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///Do not display nav in full screen
    self.isNavigationBarHidden = [self.navigationController.navigationBar isHidden];
    ///全屏幕的时候不要显示nav
    if (self.playerView.isFullScreen == NO ){
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    if (self.videoURL != nil ){
        self.navigationItem.rightBarButtonItems = @[ self.navHelpBtn ];
    } else {
        self.navigationItem.rightBarButtonItems = @[ self.navScanBtn, self.navHelpBtn ];
    }
    self.navigationItem.leftBarButtonItems = @[ self.navBackBtn ];
    self.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.title");

    // guide view
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if (![df boolForKey:@"isShowGuide"]) {
        if (_guideView == nil) _guideView = [[SuperPlayerGuideView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:_guideView];
        [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_playerFatherView.mas_top);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        _playerView.isLockScreen        = YES;
        __weak SuperPlayerView *wplayer = _playerView;
        __weak __typeof(self)   wself   = self;
        _guideView.missHandler          = ^{
            wplayer.isLockScreen = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself showControlView:NO];

                [df setBool:YES forKey:@"isShowGuide"];
                [df synchronize];
            });
        };
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_isNavigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.videoURL) {
        [self clickVodList:nil];
    }
    
    if ([self.playerView.playerModel.name isEqualToString:playerLocalize(@"SuperPlayerDemo.MoviePlayer.videopreview")]) {
        [self.playerView showVipWatchView];
        if (self.playerView.isCanShowVipTipView) {
            [self.playerView showVipTipView];
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.addBtn.m_centerX().m_top(self.scrollView.mm_maxY);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 背景色
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
    
    _authParamArray      = [NSMutableArray new];
    _vodDataSourceArray  = [NSMutableArray new];
    _liveDataSourceArray = [NSMutableArray new];
    _currentPlayVideoArray = [NSMutableArray array];
    _cacheDic = [NSMutableDictionary dictionary];
    
    self.isAddLoopVideo = YES;
    
    [self addObservers];

    if (self.videoURL) {
        SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
        playerModel.videoURL          = self.videoURL;
        playerModel.isEnableCache     = NO;
        [self.playerView playWithModelNeedLicence:playerModel];
        [self.playerView.controlView setTitle:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.uploadvideo")];
        [_currentPlayVideoArray removeAllObjects];
        [_currentPlayVideoArray addObject:playerModel];
    }

    [self.view addSubview:self.playerFatherView];
    self.playerView.fatherView = self.playerFatherView;
    [self.view addSubview:self.vodBtn];
    [self.view addSubview:self.liveBtn];
    [self.view addSubview:self.scrollView];
    UIView *container = [UIView new];
    [self.scrollView addSubview:container];
    [container addSubview:self.liveListView];
    [container addSubview:self.vodListView];
    [self.view addSubview:self.addBtn];
    self.playerBackBtn = ((SPDefaultControlView *)self.playerView.controlView).backBtn;
    // 直接获取controlview，想怎样控制界面都行。记得在全屏事件里也要处理，不然内部可能会设其它状态
    //    self.playerBackBtn.hidden = YES;
    
    
    //layout
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(20 + self.navigationController.navigationBar.bounds.size.height);
        }
        make.leading.trailing.mas_equalTo(0);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f / 16.0f);
    }];
    CGFloat btnWidth = self.vodBtn.titleLabel.attributedText.size.width;
    [self.vodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playerFatherView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(-btnWidth);
    }];
    [self.liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playerFatherView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(btnWidth);
    }];

    // 视频列
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.vodBtn.mas_bottom).offset(5);
        make.left.mas_equalTo(0);
        make.leading.trailing.mas_equalTo(0);
        if (@available(iOS 11, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-30);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30);
        }
    }];
   
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(@(ScreenWidth * 2));
        make.height.equalTo(self.scrollView.mas_height);
    }];
    [self.vodListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.equalTo(@(ScreenWidth));
        make.bottom.mas_equalTo(container.mas_bottom);
    }];
    [self.liveListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(@(ScreenWidth));
        make.width.equalTo(@(ScreenWidth));
        make.bottom.mas_equalTo(container.mas_bottom);
    }];
    
    ///loaddata
    [self _refreshVODList];
    [self _refreshLiveList];

}

#pragma mark - lazyload
- (UIBarButtonItem *)navBackBtn {
    if (!_navBackBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 60, 25)];
        [button setBackgroundImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"返回"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        _navBackBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _navBackBtn;
}
- (UIBarButtonItem *)navHelpBtn {
    if (!_navHelpBtn) {
        UIButton *buttonh = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonh.tag       = Help_超级播放器;
        [buttonh setFrame:CGRectMake(0, 0, 60, 25)];
        [buttonh setBackgroundImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"help_small"] forState:UIControlStateNormal];
        [buttonh addTarget:[TXAppInstance class] action:@selector(clickHelp:) forControlEvents:UIControlEventTouchUpInside];
        [buttonh sizeToFit];
        _navHelpBtn = [[UIBarButtonItem alloc] initWithCustomView:buttonh];
    }
    return _navHelpBtn;
}
- (UIBarButtonItem *)navScanBtn {
    if (!_navScanBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 60, 25)];
        [button setBackgroundImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"扫码"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickScan:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        _navScanBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _navScanBtn;
}
- (UIView *)playerFatherView {
    if (!_playerFatherView) {
        _playerFatherView = [[UIView alloc] init];
        _playerFatherView.backgroundColor = [UIColor blackColor];
    }
    return _playerFatherView;
}
- (SuperPlayerView *)playerView {
    if (!_playerView) {
        _playerView            = [[SuperPlayerView alloc] init];
        _playerView.fatherView = self.playerFatherView;
        _playerView.disableGesture = YES;
        // 设置代理
        _playerView.delegate = self;
        _playerView.disableVolumControl = YES;
        // demo的时移域名，请根据您项目实际情况修改这里
        _playerView.playerConfig.playShiftDomain = @"liteavapp.timeshift.qcloud.com";
        [self setupDanmakuData];
    }
    return _playerView;
}

- (UIButton *)vodBtn{
    if (!_vodBtn) {
        _vodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vodBtn setTitle:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.ondemandlist") forState:UIControlStateNormal];
        [_vodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_vodBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        [_vodBtn addTarget:self action:@selector(clickVodList:) forControlEvents:UIControlEventTouchUpInside];
        [_vodBtn setSelected:YES];
    }
    return _vodBtn;
}
-(UIButton *)liveBtn {
    if (!_liveBtn) {
        _liveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_liveBtn setTitle:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.livelist") forState:UIControlStateNormal];
        [_liveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_liveBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        [_liveBtn addTarget:self action:@selector(clickLiveList:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liveBtn;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView                                = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.pagingEnabled                  = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate                       = self;
        if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    
    return _scrollView;
}
- (UITableView *)liveListView {
    if (!_liveListView) {
        _liveListView                 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _liveListView.backgroundColor = [UIColor clearColor];
        _liveListView.delegate   = self;
        _liveListView.dataSource = self;
        [_liveListView registerClass:[ListVideoCell class] forCellReuseIdentifier:LIST_VIDEO_CELL_ID];
        [_liveListView setSeparatorColor:[UIColor clearColor]];
    }
    return _liveListView;
}
-(UITableView *)vodListView {
    if (!_vodListView) {
        _vodListView                 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _vodListView.backgroundColor = [UIColor clearColor];
        _vodListView.delegate   = self;
        _vodListView.dataSource = self;
        [_vodListView registerClass:[ListVideoCell class] forCellReuseIdentifier:LIST_VIDEO_CELL_ID];
        [_vodListView setSeparatorColor:[UIColor clearColor]];
    }
    return _vodListView;
}
-(UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"addp"] forState:UIControlStateNormal];
        [_addBtn sizeToFit];
        [_addBtn addTarget:self action:@selector(onAddClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}
#pragma mark - dataload
- (void)_refreshVODList {
    if (nil == self.videoURL) {
        NSMutableArray *videoArray = [NSMutableArray array];
        TXPlayerAuthParams *p = [[TXPlayerAuthParams alloc] init];
        p.appId               = 1500005830;
        p.fileId              = @"387702299774251236";
        [videoArray addObject:p];
        [_authParamArray addObject:videoArray];
        
        videoArray = [NSMutableArray array];
        p        = [[TXPlayerAuthParams alloc] init];
        p.appId  = 1500005830;
        p.fileId = @"387702299774390972";
        [videoArray addObject:p];
        [_authParamArray addObject:videoArray];
        
        ///ghost water
        videoArray = [NSMutableArray array];
        p        = [[TXPlayerAuthParams alloc] init];
        p.appId  = 1500006438;
        p.fileId = @"387702307847129127";
        p.sign = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBJZCI6MTUwMDAwNjQzOCwiZmlsZUlkIjoiMzg3NzAyMzA3ODQ3MTI5MTI3IiwiY29udGVudEluZm8iOnsiYXVkaW9WaWRlb1R5cGUiOiJSYXdBZGFwdGl2ZSIsInJhd0FkYXB0aXZlRGVmaW5pdGlvbiI6MTB9LCJjdXJyZW50VGltZVN0YW1wIjoxNjg2ODgzMzYwLCJnaG9zdFdhdGVybWFya0luZm8iOnsidGV4dCI6Imdob3N0IGlzIHdhdGNoaW5nIn19.0G2o4P5xVZ7zFlFUgBLntfX03iGxK9ntD_AONClUUno";
        [videoArray addObject:p];
        [_authParamArray addObject:videoArray];
        
        videoArray = [NSMutableArray array];
        p        = [[TXPlayerAuthParams alloc] init];
        p.appId  = 1500005830;
        p.fileId = @"387702299774253670";
        [videoArray addObject:p];
        [_authParamArray addObject:videoArray];
        
        videoArray = [NSMutableArray array];
        p        = [[TXPlayerAuthParams alloc] init];
        p.appId  = 1500005830;
        p.fileId = @"387702299774574470";
        [videoArray addObject:p];
        [_authParamArray addObject:videoArray];
        
        videoArray = [NSMutableArray array];
        p        = [[TXPlayerAuthParams alloc] init];
        p.appId  = 1500005830;
        p.fileId = @"387702299774545556";
        [videoArray addObject:p];
        [_authParamArray addObject:videoArray];
        
        videoArray = [NSMutableArray array];
        p        = [[TXPlayerAuthParams alloc] init];
        p.appId  = 1500005830;
        p.fileId = @"8602268011437356984";
        [videoArray addObject:p];
        [_authParamArray addObject:videoArray];
        
        videoArray = [NSMutableArray array];
        p        = [[TXPlayerAuthParams alloc] init];
        p.appId  = 1252463788;
        p.fileId = @"5285890781763144364";
        [videoArray addObject:p];
        [_authParamArray addObject:videoArray];
        
        videoArray = [NSMutableArray array];
        p        = [[TXPlayerAuthParams alloc] init];
        p.appId  = 1500005830;
        p.fileId = @"243791578431393746";
        [videoArray addObject:p];
        [_authParamArray addObject:videoArray];
        
        videoArray = [NSMutableArray array];
        TXMoviePlayInfoResponse *trackInfoResponse = [[TXMoviePlayInfoResponse alloc] init];
        trackInfoResponse.name = playerLocalize(@"SuperPlayerDemo.MoviePlayer.multitrackvideo");
        trackInfoResponse.videoUrl = MULTI_TRACK_VIDEO;
        trackInfoResponse.isCache = NO;
        trackInfoResponse.coverUrl = TRACK_COVERURL;
        [videoArray addObject:trackInfoResponse];
        [_authParamArray addObject:videoArray];
        
        videoArray = [NSMutableArray array];
        TXMoviePlayInfoResponse *subtitleInfoResponse = [[TXMoviePlayInfoResponse alloc] init];
        subtitleInfoResponse.name = playerLocalize(@"SuperPlayerDemo.MoviePlayer.multisubtitledvideo");
        subtitleInfoResponse.videoUrl = MULTI_SUBTITLES_VIDEO;
        subtitleInfoResponse.isCache = NO;
        subtitleInfoResponse.coverUrl = SUBTITLES_COVERURL;
        [videoArray addObject:subtitleInfoResponse];
        [_authParamArray addObject:videoArray];
        
        videoArray = [NSMutableArray array];
        TXMoviePlayInfoResponse *drmInfoResponse = [[TXMoviePlayInfoResponse alloc] init];
        drmInfoResponse.name = playerLocalize(@"SuperPlayerDemo.MoviePlayer.drmplay");
        drmInfoResponse.drmBuilder = [[TXPlayerDrmBuilder alloc] initWithDeviceCertificateUrl:DRM_CERTIFICATE licenseUrl:DRM_LICENSE videoUrl:DRM_VIDEO_URL];
        drmInfoResponse.coverUrl = DRM_COVER_URL;
        drmInfoResponse.isCache = YES;
        [videoArray addObject:drmInfoResponse];
        [_authParamArray addObject:videoArray];
        
        // 增加轮播视频源
        [self loadVideoListData];
        // 增加离线缓存视频源
        [self loadOfflineVideoListData];
        [self getNextInfoIsCache:NO];
    } else {
        __weak __typeof(self) wself = self;
        [self.ugcUplaodList
            fetchList:^(ListVideoModel *model) {
                __strong __typeof(wself) self = wself;
                NSMutableArray *videoArray = [NSMutableArray array];
                [videoArray addObject:model];
                [self.vodDataSourceArray addObject:videoArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [wself.vodListView reloadData];
                });

                if (self.vodDataSourceArray.count == 1 && nil == self.videoURL) {
                    [self.playerView.controlView setTitle:[self.vodDataSourceArray[0] title]];
                    [self.playerView playWithModelNeedLicence:[self.vodDataSourceArray[0] getPlayerModel]];
                    [self showControlView:YES];
                    [self->_currentPlayVideoArray removeAllObjects];
                    [self->_currentPlayVideoArray addObject:[self.vodDataSourceArray[0] getPlayerModel]];
                }
            }
            completion:^(int code, NSString *_Nonnull message) {
                if (code != 0) {
                    NSLog(@"%@", LocalizeReplaceXX(LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.getvideoerrorxx"), [NSString stringWithFormat:@"%@", message]));
                }
            }];
    }
}

- (void)loadVideoListData {
    NSMutableArray *videoArray = [NSMutableArray array];
    TXPlayerAuthParams *p = [[TXPlayerAuthParams alloc] init];
    p.appId               = 1500005830;
    p.fileId              = @"387702299774211080";
    [videoArray addObject:p];
    
    p = [[TXPlayerAuthParams alloc] init];
    p.appId               = 1500005830;
    p.fileId              = @"387702299774644824";
    [videoArray addObject:p];
    
    p = [[TXPlayerAuthParams alloc] init];
    p.appId               = 1500005830;
    p.fileId              = @"387702299774544650";
    [videoArray addObject:p];
    
    [_authParamArray addObject:videoArray];
}

- (void)loadOfflineVideoListData {
    NSMutableArray *videoArray = [NSMutableArray array];
    TXPlayerAuthParams *p = [[TXPlayerAuthParams alloc] init];
    p.appId               = 1500005830;
    p.fileId              = @"387702299773851453";
    [videoArray addObject:p];
    
    p = [[TXPlayerAuthParams alloc] init];
    p.appId               = 1500005830;
    p.fileId              = @"387702299774155981";
    [videoArray addObject:p];
    
    p = [[TXPlayerAuthParams alloc] init];
    p.appId               = 1500005830;
    p.fileId              = @"387702299773830943";
    [videoArray addObject:p];
    
    p = [[TXPlayerAuthParams alloc] init];
    p.appId               = 1500005830;
    p.fileId              = @"387702299773823860";
    [videoArray addObject:p];
    
    p = [[TXPlayerAuthParams alloc] init];
    p.appId               = 1500005830;
    p.fileId              = @"387702299774156604";
    [videoArray addObject:p];
    
    [_authParamArray addObject:videoArray];
}

- (void)_refreshLiveList {
    // Refresh Video list
    BOOL mUseLocalLiveData = true;
    NSMutableArray *allList = @[].mutableCopy;
    if (mUseLocalLiveData) {
        ListVideoModel *flvModel = [ListVideoModel new];
        flvModel.url = LOCAL_LIVE_FLV_URL;
        flvModel.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.flv_live_video");
        flvModel.coverUrl = LOCAL_LIVE_COVERURL;
        flvModel.type = 1;
        [allList addObject:flvModel];
        
        ListVideoModel *rtmpModel = [ListVideoModel new];
        rtmpModel.url = LOCAL_LIVE_RTMP_URL;
        rtmpModel.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.rtmp_live_video");
        rtmpModel.coverUrl = LOCAL_LIVE_COVERURL;
        rtmpModel.type = 1;
        [allList addObject:rtmpModel];
        
        
        ListVideoModel *webrtcModel = [ListVideoModel new];
        webrtcModel.url = LOCAL_LIVE_WEBRTC_URL;
        webrtcModel.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.webrtc_live_video");
        webrtcModel.coverUrl = LOCAL_LIVE_COVERURL;
        webrtcModel.type = 1;
        [allList addObject:webrtcModel];
        
        ListVideoModel *hlsModel = [ListVideoModel new];
        hlsModel.url = LOCAL_LIVE_HLS_URL;
        hlsModel.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.hls_live_video");
        hlsModel.coverUrl = LOCAL_LIVE_COVERURL;
        hlsModel.type = 1;
        [allList addObject:hlsModel];
        
        self.liveDataSourceArray = allList;
        [self.liveListView reloadData];
    } else {
        AFHTTPSessionManager *manager  = self.manager;
        __weak __typeof(self) weakSelf = self;
        [manager GET:@"http://xzb.qcloud.com/get_live_list2"
            parameters:nil
               headers:nil
              progress:nil
               success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
                   __strong __typeof(weakSelf) self = weakSelf;
                   if ([J2Num([responseObject valueForKeyPath:@"code"]) intValue] != 200) {
                       [self hudMessage:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.getlivelisterror")];
                       return;
                   }
                   NSArray *       list    = J2Array([responseObject valueForKeyPath:@"data.list"]);
                   for (id play in list) {
                       ListVideoModel *m = [ListVideoModel new];
                       m.appId           = [J2Num([play valueForKeyPath:@"appId"]) intValue];
                       m.coverUrl        = J2Str([play valueForKey:@"coverUrl"]);
                       m.title           = J2Str([play valueForKeyPath:@"name"]);
                       m.type            = 1;
                       NSArray *playUrl  = J2Array([play valueForKeyPath:@"playUrl"]);
                       for (id url in playUrl) {
                           [m addHdUrl:J2Str([url valueForKeyPath:@"url"]) withTitle:J2Str([url valueForKeyPath:@"title"])];
                       }

                       [allList addObject:m];
                   }
                   self.liveDataSourceArray = allList;
                   [self.liveListView reloadData];
               }
               failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error){

               }];
    }
    
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.playerView.isFullScreen;
}

#pragma mark - SuperPlayerDelegate

- (void)superPlayerBackAction:(SuperPlayerView *)player {
    [self backClick];
}

- (void)superPlayerDidStart:(SuperPlayerView *)player {
    if (!player.playerModel.isEnableCache) {
        return;
    }
    
    if (!_cacheView.hidden) {
        return;
    }
    
    if (_cacheView) {
        [_cacheView setVideoModels:_currentPlayVideoArray currentPlayingModel:player.playerModel];
    }
}

- (void)superPlayerFullScreenChanged:(SuperPlayerView *)player {
    [[UIApplication sharedApplication] setStatusBarHidden:player.isFullScreen];
    [self.playerView showVipWatchView];
    [player hideVipTipView];
    if (player.isCanShowVipTipView) {
        [player showVipTipView];
    }
    
    if (!player.isFullScreen) {
        _cacheView.hidden = YES;
    }
}

- (void)superPlayerDidEnd:(SuperPlayerView *)player {
    if (!_cacheView.hidden) {
        [UIView animateWithDuration:1.0 animations:^{
            self->_cacheView.transform = CGAffineTransformMakeTranslation(self->_cacheView.frame.size.width + HomeIndicator_Height, 0);
        } completion:^(BOOL finished) {
            if (finished) {
                self->_cacheView.hidden = YES;
            }
        }];
    }
}

- (void)singleTapClick {
    if (!_cacheView.hidden) {
        [UIView animateWithDuration:1.0 animations:^{
            self->_cacheView.transform = CGAffineTransformMakeTranslation(self->_cacheView.frame.size.width + HomeIndicator_Height, 0);
        } completion:^(BOOL finished) {
            if (finished) {
                self->_cacheView.hidden = YES;
            }
        }];
    }
}
- (void)lockScreen:(BOOL)lock {
    
}
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

#pragma mark - Getter
- (UGCUploadList *)ugcUplaodList {
    if (!_ugcUplaodList) {
        _ugcUplaodList = [[UGCUploadList alloc] init];
    }
    return _ugcUplaodList;
}





- (void)onNetSuccess:(NSArray *)videoArray {
    NSArray *modelArray = [self getVideoModelWithVideoArray:videoArray];
    [_vodDataSourceArray addObject:modelArray];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.vodListView reloadData];
    });
    
    if (_vodDataSourceArray.count == 1 && !self.stopAutoPlayVOD) {
        NSArray *array = [[[self.vodDataSourceArray[0] firstObject] title] componentsSeparatedByString:@"."];
        [self.playerView.controlView setTitle:array.firstObject];
        [self.playerView playWithModelNeedLicence:[[self.vodDataSourceArray[0] firstObject] getPlayerModel]];
        [self showControlView:YES];
        [self->_currentPlayVideoArray removeAllObjects];
        [self->_currentPlayVideoArray addObject:[[self.vodDataSourceArray[0] firstObject] getPlayerModel]];
    }
    
    [self getNextInfoIsCache:NO];
}

- (NSArray *)getVideoModelWithVideoArray:(NSArray *)videoArray {
    NSMutableArray *modelArray = [NSMutableArray array];
    for (TXMoviePlayInfoResponse *playInfo in videoArray) {
        ListVideoModel *m = [[ListVideoModel alloc] init];
        m.appId           = playInfo.appId;
        m.fileId          = playInfo.fileId;
        m.duration        = playInfo.duration;
        NSArray *array = [playInfo.name componentsSeparatedByString:@"."];
        m.title           = playInfo.videoDescription.length > 0 ? playInfo.videoDescription : array.firstObject;
        m.isEnableCache   = playInfo.isCache;
        m.url             = playInfo.videoUrl;
        m.drmBuilder = playInfo.drmBuilder;
        if (!m.title || [m.title isEqualToString:@""]) {
            if (playInfo.name && playInfo.name.length >0) {
                m.title = playInfo.name;
            } else {
                m.title = [NSString stringWithFormat:@"%@%@", LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.video"), playInfo.fileId];
            }
        }
        
        if ([m.fileId isEqualToString:@"387702299774251236"]) {
            m.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.tencentcloudaudiovideo");
        }
        
        if ([m.fileId isEqualToString:@"387702299774253670"]) {
            m.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.simplerandlighter");
        }
        
        if ([m.fileId isEqualToString:@"387702299774574470"]) {
            m.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.whatisdigitization");
        }
        
        if ([m.title containsString:VIP_VIDEO_DEFAULT_CELL_TITLE]) {
            m.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.videopreview");
        }
        
        if ([m.title containsString:DYNAMIC_WATER_VIDEO_DEFAULT_CELL_TITLE]) {
            m.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.dynamicwatermarking");
            DynamicWaterModel *model = [[DynamicWaterModel alloc] init];
            model.dynamicWatermarkTip = @"shipinyun";
            model.textFont = 30;
            model.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
            m.dynamicWaterModel = model;
        }
        
        ///ghost water
        if ([m.fileId isEqualToString:@"387702307847129127"]) {
            m.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.ghostwatermarking");
        }
        
        if ([m.title isEqualToString:playerLocalize(@"SuperPlayerDemo.MoviePlayer.multisubtitledvideo")]) {
            
            NSMutableArray *subtitlesArray = [NSMutableArray array];
            
            // 添加需要挂载的字幕
            PlayerSubtitles *subtitleModel = [[PlayerSubtitles alloc] init];
            subtitleModel.subtitlesUrl = @"https://mediacloud-76607.gzc.vod.tencent-cloud.com/DemoResource/TED-CN.srt";
            subtitleModel.subtitlesName = @"ex-cn-srt";
            subtitleModel.subtitlesType = 0;
            [subtitlesArray addObject:subtitleModel];
            
            subtitleModel = [PlayerSubtitles new];
            subtitleModel.subtitlesUrl = @"https://mediacloud-76607.gzc.vod.tencent-cloud.com/DemoResource/TED-EN.vtt";
            subtitleModel.subtitlesName = @"ex-en-vtt";
            subtitleModel.subtitlesType = 1;
            [subtitlesArray addObject:subtitleModel];
            
            subtitleModel = [PlayerSubtitles new];
            subtitleModel.subtitlesUrl = @"https://mediacloud-76607.gzc.vod.tencent-cloud.com/DemoResource/TED-IN.srt";
            subtitleModel.subtitlesName = @"ex-in-srt";
            subtitleModel.subtitlesType = 0;
            [subtitlesArray addObject:subtitleModel];
            
            m.subtitlesArray = subtitlesArray;
        }
        
        m.coverUrl = playInfo.coverUrl;
        m.psign = playInfo.pSign;
        if ([m.title containsString:COVER_DEFAULT_DEFAULT_TITLE]) {
            m.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.customthumbnail");
            m.playAction = 1;
            m.customCoverUrl = COVER_DEFAULT_URL;
        } else {
            m.playAction = 0;
        }
        
        if (!self.isAddLoopVideo && videoArray.count > 1) {
            m.isEnableCache = YES;
        }
        
        [modelArray addObject:m];
    }
    
    if (modelArray.count > 1 && self.isAddLoopVideo) {
        [modelArray addObject:playerLocalize(@"SuperPlayerDemo.MoviePlayer.videoplaylist")];
        self.isAddLoopVideo = NO;
    } else if (modelArray.count > 1 && !self.isAddLoopVideo) {
        [modelArray addObject:playerLocalize(@"SuperPlayerDemo.MoviePlayer.downloadforofflineplayback")];
    }
    
    return modelArray;
}

- (void)hudMessage:(NSString *)msg {
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    _hud.label.text = msg;
    _hud.mode       = MBProgressHUDModeText;

    [_hud showAnimated:YES];
    [_hud hideAnimated:YES afterDelay:1];
}

- (void)onNetFailed:(TXMoviePlayerNetApi *)obj reason:(NSString *)reason code:(int)code {
    [self hudMessage:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.fileidrequesterror")];
}

- (void)getNextInfoIsCache:(BOOL)isCache {
    if (_authParamArray.count == 0) return;
    NSMutableArray *videoArray = [_authParamArray objectAtIndex:0];
    if (videoArray.count == 0) return;
    [_authParamArray removeObject:videoArray];

    if (self.getInfoNetApi == nil) {
        self.getInfoNetApi = [[TXMoviePlayerNetApi alloc] init];
        //        self.getInfoNetApi.delegate = self;
        self.getInfoNetApi.https = NO;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    if ([videoArray.firstObject isKindOfClass:[TXMoviePlayInfoResponse class]]) {
        for (TXMoviePlayInfoResponse *resp in videoArray) {
            [resultArray addObject:resp];
        }
        [self onNetSuccess:resultArray];
    } else {
        dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(serialQueue, ^{
            dispatch_semaphore_t sem = dispatch_semaphore_create(0);
            for (TXPlayerAuthParams *p in videoArray) {
                __weak __typeof(self) wself = self;
                [self.getInfoNetApi getplayinfo:p.appId
                                         fileId:p.fileId
                                          psign:p.sign
                                     completion:^(TXMoviePlayInfoResponse *resp, NSError *error) {
                                         if (error) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [wself hudMessage:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.fileidrequesterror")];
                                             });
                                         } else {
                                             resp.isCache = isCache;
                                             [resultArray addObject:resp];
                                         }
                                         dispatch_semaphore_signal(sem);
                                     }];
                dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (resultArray.count > 0) {
                    [self onNetSuccess:resultArray];
                }
            });
        });
    }
}

#pragma mark - 从其他APP拉起播放
- (void)startPlayVideoFromLaunchInfo:(NSDictionary *)launchInfo complete:(void (^)(BOOL succ))complete {
    BOOL success = NO;
    if (launchInfo) {
        self.stopAutoPlayVOD          = YES;
        NSMutableDictionary *dataInfo = launchInfo.mutableCopy;
        id                   dataObj  = [self _safeParseJsonStr:dataInfo[@"data"]];
        if ([dataObj isKindOfClass:[NSDictionary class]]) {
            [dataInfo addEntriesFromDictionary:dataObj];
        }
        
        SuperPlayerModel *playerModel = dataInfo[@"playerModel"];
        BOOL isEnableCache = playerModel.isEnableCache;
        if (playerModel) {
            if (isEnableCache) {
                SPDefaultControlView *defaultControlView = (SPDefaultControlView *)self.playerView.controlView;
                [defaultControlView.offlineBtn addTarget:self action:@selector(cacheViewShow) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [self playModel:playerModel];
            success = YES;
        } else {
            NSString *appId  = dataInfo[@"appId"];
            NSString *fileId = dataInfo[@"fileId"];
            NSString *psign  = dataInfo[@"psign"];
            
            if (appId && fileId && psign) {
                SuperPlayerModel *model = [SuperPlayerModel new];
                model.appId             = [appId longLongValue];
                model.videoId           = [[SuperPlayerVideoId alloc] init];
                model.videoId.fileId    = fileId;
                model.videoId.psign     = psign;
                model.isEnableCache     = NO;
                [self playModel:model];
                success = YES;
            } else {
                NSLog(@"%@", LocalizeReplaceThreeCharacter(LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.lackofparameterxxyyzz"), [NSString stringWithFormat:@"%@", appId],
                                                           [NSString stringWithFormat:@"%@", fileId], [NSString stringWithFormat:@"%@", psign]));
            }
        }
    }
    if (complete) {
        complete(success);
    }
}

#pragma mark - Action

- (IBAction)backClick {
    // player加到控制器上，只有一个player时候
    // 状态条的方向旋转的方向,来判断当前屏幕的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 是竖屏时候响应关
    if (orientation == UIInterfaceOrientationPortrait && (self.playerView.state == StatePlaying)) {
        self.danmakuView.clipsToBounds = YES;
        if (self.playerView.isPipStart == NO){
            [SuperPlayerWindowShared setSuperPlayer:self.playerView];
            [SuperPlayerWindowShared show];
            SuperPlayerWindowShared.backController = self;
        }
        if (self.playerView.isCanShowVipTipView) {
            [self.playerView showVipTipView];
        }
    } else {
        [self.playerView resetPlayer];  //非常重要
        SuperPlayerWindowShared.backController = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickStyle:(UIButton *)btn {
    if ([self.playerView.controlView isKindOfClass:[SPDefaultControlView class]]) {
        self.playerView.controlView = [[SPWeiboControlView alloc] init];
        [self hudMessage:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.changetoweibostyle")];
    } else if ([self.playerView.controlView isKindOfClass:[SPWeiboControlView class]]) {
        self.playerView.controlView = [[SPDefaultControlView alloc] init];
        [self hudMessage:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.changetonormalstyle")];
    }
}

- (void)clickScan:(UIButton *)btn {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SuperPlayerShowScanTips"];

    TPScanQRController *vc = [[TPScanQRController alloc] init];
    vc.delegate          = self;
    [self.navigationController pushViewController:vc animated:NO];
    self.playerView.isLockScreen = YES;
}

- (int)_getIntFromDict:(NSDictionary *)dictionary key:(NSString *)key {
    NSString *value = dictionary[key];
    if (value) {
        return [value intValue];
    }
    return -1;
}

- (BOOL)_fillModel:(SuperPlayerModel *)model withURL:(NSString *)result {
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
        NSDictionary *paramDict = [self _getParamsFromUrlStr:result];
        model.appId             = [paramDict[@"appId"] integerValue];
        model.videoId           = [[SuperPlayerVideoId alloc] init];
        model.videoId.fileId    = paramDict[@"fileId"];
        model.videoId.psign     = paramDict[@"psign"];
        return YES;
    } else if ([result hasPrefix:@"liteav://com.tencent.liteav.demo"]) {
        NSMutableDictionary *paramDict = [self _getParamsFromUrlStr:result].mutableCopy;
        if ([paramDict[@"protocol"] isEqualToString:@"v4vodplay"]) {
            NSDictionary *dataObj = [self _safeParseJsonStr:paramDict[@"data"]];
            if (dataObj) {
                [paramDict addEntriesFromDictionary:dataObj];
            }
        }
        model.appId          = [paramDict[@"appId"] integerValue];
        model.videoId        = [[SuperPlayerVideoId alloc] init];
        model.videoId.fileId = paramDict[@"fileId"];
        model.videoId.psign  = paramDict[@"psign"];
        return YES;
    } else if ([self _isURLTypeV4vodplayProtocol:result]) {
        NSDictionary *paramDict = [self _getParamsFromUrlStr:result];
        model.appId             = [paramDict[@"appId"] integerValue];
        model.videoId           = [[SuperPlayerVideoId alloc] init];
        model.videoId.fileId    = paramDict[@"fileId"];
        model.videoId.psign     = paramDict[@"psign"];
        return YES;
    }
    return NO;
}

- (NSDictionary *)_getParamsFromUrlStr:(NSString *)result {
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

- (id)_safeParseJsonStr:(NSString *)jsonStr {
    if ([jsonStr isKindOfClass:[NSString class]]) {
        NSData *data = [[jsonStr stringByRemovingPercentEncoding] dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        }
    }
    return nil;
}

- (void)onScanResult:(NSString *)result {
    self.textView.text       = result;
    SuperPlayerModel *model  = [SuperPlayerModel new];
    BOOL              isLive = self.playerView.isLive;
    if ([result hasPrefix:@"txsuperplayer://"] || [result hasPrefix:@"liteav://"]) {
        [self _fillModel:model withURL:result];
        isLive = NO;
    } else if ([result hasPrefix:@"https://playvideo.qcloud.com/getplayinfo/v4"]) {
        if ([self _fillModel:model withURL:result]) {
            isLive = NO;
        } else {
            model.videoURL = result;
            isLive = YES;
        }
    } else if ([self _isURLTypeV4vodplayProtocol:result]) {
        //仅支持普通URL传参方式
        [self _fillModel:model withURL:result];
        isLive = NO;
    } else if ([result hasPrefix:@"rtmp"] || ([result hasPrefix:@"http"] && [result hasSuffix:@".flv"]) || [result hasPrefix:@"webrtc"]) {
        model.videoURL = result;
        isLive         = YES;
    } else {
        model.videoURL = result;
        isLive = NO;
    }
    model.name = [NSString stringWithFormat:@"%@%lu", LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.video"), (unsigned long)_vodDataSourceArray.count + 1];
    model.isEnableCache = NO;
    [self playModel:model];

    ListVideoModel *m = [ListVideoModel new];
    m.url             = result;
    m.type            = self.playerView.isLive;
    if (isLive) {
        m.title = [NSString stringWithFormat:@"%@%lu", LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.video"), (unsigned long)_liveDataSourceArray.count + 1];
        [_liveDataSourceArray addObject:m];
        [_liveListView reloadData];
        [self clickLiveList:self.liveBtn];
    } else {
        if (model.videoId) {
            [m setModel:model];
        }
        m.title = [NSString stringWithFormat:@"%@%lu", LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.video"), (unsigned long)_vodDataSourceArray.count + 1];
        NSMutableArray *videoArray = [NSMutableArray array];
        [videoArray addObject:m];
        [_vodDataSourceArray addObject:videoArray];
        [_vodListView reloadData];
        [self clickVodList:self.vodBtn];
    }
    self.playerView.isLockScreen = NO;
}

- (void)cancelScanQR {
    self.playerView.isLockScreen = NO;
}

- (BOOL)_isURLTypeV4vodplayProtocol:(NSString *)result {
    if ([result hasPrefix:@"https://"] || [result hasPrefix:@"http://"]) {
        NSDictionary *urlParams = [self _getParamsFromUrlStr:result];
        return [[urlParams objectForKey:@"protocol"] isEqualToString:@"v4vodplay"];
    }
    return NO;
}

- (void)playModel:(SuperPlayerModel *)model {
    [self.playerView hideVipTipView];
    [self.playerView hideVipWatchView];
    self.playerView.isCanShowVipTipView = NO;
    [self.playerView.controlView setTitle:model.name.length > 0 ? model.name : LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.newplayvideo")];
    [self.playerView.coverImageView setImage:nil];
    [self.playerView playWithModelNeedLicence:model];
    
    if (model.isEnableCache) {
        [self->_currentPlayVideoArray removeAllObjects];
        [self->_currentPlayVideoArray addObject:model];
    }
}

#pragma mark - -

- (void)onAddClick:(UIButton *)btn {
    UIAlertController *control = [UIAlertController alertControllerWithTitle:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.addvideo") message:@"" preferredStyle:UIAlertControllerStyleAlert];

    if (self.vodBtn.selected) {
        [control addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
            textField.placeholder = LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.enterappid");
            appField              = textField;
        }];

        [control addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
            textField.placeholder = LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.enterfileid");
            fileidField           = textField;
        }];
        
        [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.enterlivepsign");
            psignField = textField;
        }];
        
        [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.enterStartCache");
            cacheField = textField;
        }];
    } else {
        [control addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
            textField.placeholder = LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.enterliveurl");
            urlField              = textField;
        }];
    }

    BOOL isLock                  = self.playerView.isLockScreen;
    self.playerView.isLockScreen = YES;
    [control addAction:[UIAlertAction actionWithTitle:LivePlayerLocalize(@"LiveLinkMicDemoOld.RoomList.determine")
                                                style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction *_Nonnull action) {
                                                  if (self.vodBtn.selected) {
                                                      TXPlayerAuthParams *p = [TXPlayerAuthParams new];
                                                      p.appId               = [appField.text intValue];
                                                      p.fileId              = fileidField.text;
                                                      if (psignField.text.length > 0) {
                                                          p.sign = psignField.text;
                                                      }
                                                      NSMutableArray *videoArray = [NSMutableArray array];
                                                      [videoArray addObject:p];
                                                      [self.authParamArray addObject:videoArray];
                                                      
                                                      if ([cacheField.text isEqualToString:@"1"]) {
                                                          [self getNextInfoIsCache:YES];
                                                      } else {
                                                          [self getNextInfoIsCache:NO];
                                                      }
                                                      
                                                  } else {
                                                      if (urlField.text.length == 0) {
                                                          [self hudMessage:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.enterplayeraddress")];
                                                          return;
                                                      }

                                                      ListVideoModel *m = [ListVideoModel new];
                                                      m.url             = urlField.text;
                                                      m.title           = [NSString
                                                          stringWithFormat:@"%@%lu", LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.video"), (unsigned long)self.liveDataSourceArray.count + 1];
                                                      m.type            = 1;
                                                    
                                                      [self.liveDataSourceArray addObject:m];
                                                      [self.liveListView reloadData];
                                                  }

                                                  self.playerView.isLockScreen = isLock;
                                              }]];

    [control addAction:[UIAlertAction actionWithTitle:LivePlayerLocalize(@"LivePusherDemo.PushSetting.cancel")
                                                style:UIAlertActionStyleCancel
                                              handler:^(UIAlertAction *_Nonnull action) {
                                                  self.playerView.isLockScreen = isLock;
                                              }]];

    [self.navigationController presentViewController:control animated:YES completion:nil];
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{ return 78; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (tableView == self.vodListView) {
        return _vodDataSourceArray.count;
    } else {
        return _liveDataSourceArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger      row  = indexPath.row;
    ListVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:LIST_VIDEO_CELL_ID];

    ListVideoModel *param;
    if (tableView == self.vodListView) {
        NSArray *modelArray = [_vodDataSourceArray objectAtIndex:row];
        if (modelArray.count > 1 && [modelArray.lastObject isEqualToString:playerLocalize(@"SuperPlayerDemo.MoviePlayer.videoplaylist")]) {
            param = [ListVideoModel new];
            param.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.videoplaylist");
            param.coverUrl = VIDEO_LOOP_PLAY_DEFAULT_URL;
        } else if (modelArray.count > 1 && [modelArray.lastObject isEqualToString:
                                            playerLocalize(@"SuperPlayerDemo.MoviePlayer.downloadforofflineplayback")]) {
            param = [ListVideoModel new];
            param.title = playerLocalize(@"SuperPlayerDemo.MoviePlayer.downloadforofflineplayback");
            param.coverUrl = VIDEO_OFFLINE_CACHE_DEFAULT_URL;
        } else {
            param = [modelArray firstObject];
        }
    } else {
        param = [_liveDataSourceArray objectAtIndex:row];
    }
    
    [cell setDataSource:param];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SPDefaultControlView *defaultControlView = (SPDefaultControlView *)self.playerView.controlView;
    if (tableView == self.liveListView) {
        defaultControlView.disablePipBtn = YES;
    } else {
        defaultControlView.disablePipBtn = NO;
    }
    ListVideoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.playerView hideVipTipView];
    [self.playerView hideVipWatchView];
    self.playerView.isCanShowVipTipView = NO;
    [self.playerView removeVideo];
    if (cell) {
        if ([[cell getSource].title containsString:playerLocalize(@"SuperPlayerDemo.MoviePlayer.videopreview")]) {
            [self.playerView showVipTipView];
            defaultControlView.disablePipBtn = YES;
        }
        
        if ([[cell getSource].title containsString:playerLocalize(@"SuperPlayerDemo.MoviePlayer.videoplaylist")]) {
            // 模型转换
            NSMutableArray *videoModelArray = self.vodDataSourceArray[indexPath.row];
            
            NSMutableArray *videoList = [NSMutableArray array];
            for (int i = 0; i < videoModelArray.count - 1; i++) {
                ListVideoModel *model = videoModelArray[i];
                [videoList addObject:[model getPlayerModel]];
            }
            [self.playerView playWithModelListNeedLicence:videoList isLoopPlayList:YES startIndex:0];
            [self->_currentPlayVideoArray removeAllObjects];
            [self->_currentPlayVideoArray addObjectsFromArray:videoList];
        } else if ([[cell getSource].title containsString:
                    playerLocalize(@"SuperPlayerDemo.MoviePlayer.downloadforofflineplayback")]) {
            // 模型转换
            NSMutableArray *videoModelArray = self.vodDataSourceArray[indexPath.row];
            NSMutableArray *videoList = [NSMutableArray array];
            for (int i = 0; i < videoModelArray.count - 1; i++) {
                ListVideoModel *model = videoModelArray[i];
                [videoList addObject:[model getPlayerModel]];
            }
            [self.playerView playWithModelListNeedLicence:videoList isLoopPlayList:YES startIndex:0];
            [self->_currentPlayVideoArray removeAllObjects];
            [self->_currentPlayVideoArray addObjectsFromArray:videoList];
            [self setVideoCacheData];
        } else {
            SuperPlayerModel *model = [cell getPlayerModel];
            [self.playerView.controlView setTitle:[cell getSource].title];
            [self.playerView playWithModelNeedLicence:model];
            [self->_currentPlayVideoArray removeAllObjects];
            [self->_currentPlayVideoArray addObject:model];
            if ([cell getSource].isEnableCache) {
                [self setVideoCacheData];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return NO;
}

#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]
#define font         [UIFont systemFontOfSize:15]

- (void)setupDanmakuData {
    NSBundle *playerBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"]];
    NSString *danmakufile   = [playerBundle pathForResource:@"danmakufile" ofType:nil];
    NSArray * danmakusDicts = [NSArray arrayWithContentsOfFile:danmakufile];

    NSMutableArray *danmakus = [NSMutableArray array];
    for (NSDictionary *dict in danmakusDicts) {
        CFDanmaku *                danmaku    = [[CFDanmaku alloc] init];
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:dict[@"m"] attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : kRandomColor}];

        NSString *emotionName = [NSString stringWithFormat:@"smile_%u", arc4random_uniform(90)];
        UIImage * emotion     = [UIImage imageNamed:emotionName];
        if (nil != emotion) {
            NSTextAttachment *attachment    = [[NSTextAttachment alloc] init];
            attachment.image                = emotion;
            attachment.bounds               = CGRectMake(0, -font.lineHeight * 0.3, font.lineHeight * 1.5, font.lineHeight * 1.5);
            NSAttributedString *emotionAttr = [NSAttributedString attributedStringWithAttachment:attachment];
            [contentStr appendAttributedString:emotionAttr];
        }

        danmaku.contentStr = contentStr;

        NSString *attributesStr = dict[@"p"];
        NSArray * attarsArray   = [attributesStr componentsSeparatedByString:@","];
        danmaku.timePoint       = [[attarsArray firstObject] doubleValue] / 1000;
        danmaku.position        = [attarsArray[1] integerValue];
        [danmakus addObject:danmaku];
    }

    _danmakuView                    = [[CFDanmakuView alloc] initWithFrame:CGRectZero];
    _danmakuView.duration           = 6.5;
    _danmakuView.centerDuration     = 2.5;
    _danmakuView.lineHeight         = 25;
    _danmakuView.maxShowLineCount   = 15;
    _danmakuView.maxCenterLineCount = 5;
    [_danmakuView prepareDanmakus:danmakus];

    _danmakuView.delegate = self;
    [self.playerView addSubview:_danmakuView];

    [_danmakuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerView);
        make.bottom.equalTo(self.playerView);
        make.left.equalTo(self.playerView);
        make.right.equalTo(self.playerView);
    }];

    SPDefaultControlView *defaultControlView = (SPDefaultControlView *)self.playerView.controlView;
    [defaultControlView.danmakuBtn addTarget:self action:@selector(danmakuShow:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showControlView:(BOOL)isShow {
    if (isShow) {
        self.playerView.controlView.hidden = NO;
    } else {
        self.playerView.controlView.hidden = YES;
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView == self.scrollView) {
        CGPoint p = [scrollView contentOffset];
        if (p.x >= ScreenWidth) {
            [self.liveBtn setSelected:YES];
            [self.vodBtn setSelected:NO];
        } else {
            [self.liveBtn setSelected:NO];
            [self.vodBtn setSelected:YES];
        }
    }
}

- (void)clickVodList:(id)sender {
    [self.vodBtn setSelected:YES];
    [self.liveBtn setSelected:NO];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, ScreenWidth, self.scrollView.mm_h) animated:YES];
    [self showControlView:YES];
    [self.playerView.controlView setEnableFadeAction:YES];
}

- (void)clickLiveList:(id)sender {
    [self.vodBtn setSelected:NO];
    [self.liveBtn setSelected:YES];
    [self.scrollView scrollRectToVisible:CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollView.mm_h) animated:YES];
    [self showControlView:NO];
    [self.playerView.controlView setEnableFadeAction:NO];
}

#pragma mark - 弹幕

static NSTimeInterval danmaku_start_time;  // 测试用的，因为demo里的直播时间可能非常大，本地的测试弹幕时间很短

- (NSTimeInterval)danmakuViewGetPlayTime:(CFDanmakuView *)danmakuView {
    if (_playerView.isLive) {
        return self.playerView.playCurrentTime - danmaku_start_time;
    }
    return self.playerView.playCurrentTime;
}

- (BOOL)danmakuViewIsBuffering:(CFDanmakuView *)danmakuView {
    return self.playerView.state != StatePlaying;
}

- (void)danmakuShow:(UIButton *)btn {
    if (btn.selected) {
        [_danmakuView start];
        _danmakuView.hidden = NO;
        danmaku_start_time  = self.playerView.playCurrentTime;
    } else {
        [_danmakuView pause];
        _danmakuView.hidden = YES;
    }
}

#pragma mark - 离线缓存

- (void)setVideoCacheData {
    _cacheView = [[VideoCacheView alloc] initWithFrame:CGRectZero];
    _cacheView.hidden = YES;
    [self.playerView addSubview:_cacheView];

    [_cacheView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerView);
        make.bottom.equalTo(self.playerView);
        make.right.equalTo(self.playerView).offset(OFFLINE_VIDEOCATCHVIEW_HEIGHT + HomeIndicator_Height);
        make.width.mas_equalTo(OFFLINE_VIDEOCATCHVIEW_HEIGHT);
    }];

    SPDefaultControlView *defaultControlView = (SPDefaultControlView *)self.playerView.controlView;
    [defaultControlView.offlineBtn addTarget:self action:@selector(cacheViewShow) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cacheViewShow {
    [self.cacheView refreshData];
    [UIView animateWithDuration:1.0 animations:^{
        self->_cacheView.transform = CGAffineTransformMakeTranslation(-(OFFLINE_VIDEOCATCHVIEW_HEIGHT + HomeIndicator_Height), 0);
    }];
    
    _cacheView.hidden = NO;
}

@end
