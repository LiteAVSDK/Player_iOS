//
//  MoviePlayerViewController.m
//

#import "MoviePlayerViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <Masonry/Masonry.h>
#import <MediaPlayer/MediaPlayer.h>

#import "AFNetworking.h"
#import "AppDelegate.h"
#import "AppLocalized.h"
#import "CFDanmakuView.h"
#import "J2Obj.h"
#import "ListVideoCell.h"
#import "MBProgressHUD.h"
#import "ScanQRController.h"
#import "SuperPlayer.h"
#import "SuperPlayerGuideView.h"
#import "TCHttpUtil.h"
#import "TXMoviePlayerNetApi.h"
#import "UGCUploadList.h"
#import "UIImageView+WebCache.h"
#import "UIView+MMLayout.h"
#import "AppLocalized.h"
#import "TXPlayerAuthParams.h"
#import "VideoCacheView.h"

#define OFFLINE_VIDEOCATCHVIEW_HEIGHT 282

#define LIST_VIDEO_CELL_ID @"LIST_VIDEO_CELL_ID"
#define LIST_LIVE_CELL_ID  @"LIST_LIVE_CELL_ID"

#define VIP_VIDEO_DEFAULT_CELL_TITLE @"试看功能演示"

#define DYNAMIC_WATER_VIDEO_DEFAULT_CELL_TITLE @"动态水印演示"

#define COVER_DEFAULT_DEFAULT_TITLE  @"自定义封面"
#define COVER_DEFAULT_URL    @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/cc1e28208602268011087336518/MXUW1a5I9TsA.png"

#define VIDEO_LOOP_PLAY_DEFAULT_TITLE @"视频列表轮播演示"
#define VIDEO_LOOP_PLAY_DEFAULT_URL    @"http://1400155958.vod2.myqcloud.com/facd87c8vodcq1400155958/06622723387702299939461564/G5gEpcHlyaYA.png"

#define VIDEO_OFFLINE_CACHE_DEFAULT_TITLE  @"离线缓存(全屏)演示"
#define VIDEO_OFFLINE_CACHE_DEFAULT_URL    @"http://1400155958.vod2.myqcloud.com/facd87c8vodcq1400155958/0183245d387702299939234236/c7yiepstuHcA.png"

#define LOCAL_LIVE_TITLE    @"测试视频"
#define LOCAL_LIVE_COVERURL @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/66bc542f387702300661648850/0RyP1rZfkdQA.png"
#define LOCAL_LIVE_URL      @"http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv"


__weak UITextField *appField;
__weak UITextField *fileidField;
__weak UITextField *urlField;
__weak UITextField *psignField;
__weak UITextField *cacheField;

@interface MoviePlayerViewController () <SuperPlayerDelegate, ScanQRDelegate, UITableViewDelegate, UITableViewDataSource, CFDanmakuDelegate>
/** 播放器View的父视图*/
@property(nonatomic, strong) UIView *                 playerFatherView;
@property(strong, nonatomic) SuperPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property(nonatomic, assign) BOOL           isPlaying;
@property(nonatomic, strong) UGCUploadList *ugcUplaodList;  ///< UGC 上传业务
@property(nonatomic, strong) UIView *       bottomView;
@property(weak, nonatomic) IBOutlet UIButton *backBtn;
@property(nonatomic, strong) UITextField *    textView;

@property(nonatomic, strong) UITableView *vodListView;  // 点播列表
@property(nonatomic, strong) UITableView *liveListView;

@property(nonatomic, strong) UIButton *vodBtn;   // 点播标签
@property(nonatomic, strong) UIButton *liveBtn;  // 直播标签

@property(nonatomic, strong) NSMutableArray *authParamArray;
@property(nonatomic, strong) NSMutableArray *vodDataSourceArray;
@property(nonatomic, strong) NSMutableArray *liveDataSourceArray;
@property(nonatomic, strong) TXMoviePlayerNetApi *getInfoNetApi;
@property(nonatomic, strong) MBProgressHUD *hud;
@property(nonatomic, strong) UIButton *addBtn;

@property(nonatomic, strong) SuperPlayerGuideView *guideView;

@property(nonatomic, strong) UIScrollView *scrollView;  //视频列表滑动scrollview

@property(nonatomic, strong) UIButton *                               playerBackBtn;
@property(nonatomic, strong) AFHTTPSessionManager *manager;

@property(nonatomic, strong) CFDanmakuView *danmakuView;

@property (nonatomic, strong) VideoCacheView *cacheView;

// 当前正在播放的视频列表，可能是单个视频，可能是一组视频
@property (nonatomic, strong) NSMutableArray *currentPlayVideoArray;

@property(nonatomic, assign) BOOL stopAutoPlayVOD;  //从外部拉起播放时，停止自动播放VOD视频

@property (nonatomic, assign) BOOL isAddLoopVideo;

@property (nonatomic, strong) NSMutableDictionary *cacheDic;

@end

@implementation MoviePlayerViewController

- (instancetype)init {
    if (SuperPlayerWindowShared.backController) {
        [SuperPlayerWindowShared hide];
        MoviePlayerViewController *playerViewCtrl = (MoviePlayerViewController *)SuperPlayerWindowShared.backController;
        playerViewCtrl.danmakuView.clipsToBounds  = NO;
        return playerViewCtrl;
    } else {
        if (self = [super init]) {
            _manager = [AFHTTPSessionManager manager];
        }
        return self;
    }
}

- (void)addObservers {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(updateLockScreenInfo)
                   name:UIApplicationDidEnterBackgroundNotification
                 object:nil];
}

// 更新锁屏界面信息
- (void)updateLockScreenInfo {
    // 1.获取锁屏中心
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    // 初始化一个存放音乐信息的字典
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    
    // 2、设置名称
    if (self.playerView.playerModel.name.length > 0) {
        [playingInfoDict setObject:self.playerView.playerModel.name forKey:MPMediaItemPropertyTitle];
    }
    
    // 3、设置封面的图片
    UIImage *image = [UIImage imageNamed:@"TengXunYun_logo"];
    if (image) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [playingInfoDict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    }
    
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
        if (!SuperPlayerWindowShared.isShowing) {
            [self.playerView resetPlayer];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image        = [UIImage imageNamed:@"背景"];
    [self.view insertSubview:imageView atIndex:0];

    // 右侧
    UIButton *buttonh = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonh.tag       = Help_超级播放器;
    [buttonh setFrame:CGRectMake(0, 0, 60, 25)];
    [buttonh setBackgroundImage:[UIImage imageNamed:@"help_small"] forState:UIControlStateNormal];
    [buttonh addTarget:[[UIApplication sharedApplication] delegate] action:@selector(clickHelp:) forControlEvents:UIControlEventTouchUpInside];
    [buttonh sizeToFit];
    UIBarButtonItem *rightItemh = [[UIBarButtonItem alloc] initWithCustomView:buttonh];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 60, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"扫码"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickScan:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.hidden                           = self.videoURL != nil;
    UIBarButtonItem *rightItem              = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[ rightItem, rightItemh ];

    // 左侧
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    //修改按钮向右移动10pt
    [leftbutton setFrame:CGRectMake(0, 0, 60, 25)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton sizeToFit];
    UIBarButtonItem *leftItem              = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[ leftItem ];

    self.title = @"超级播放器";

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.videoURL) {
        [self clickVodList:nil];
    }
    
    if ([self.playerView.playerModel.name isEqualToString:VIP_VIDEO_DEFAULT_CELL_TITLE]) {
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
        [self.playerView playWithModel:playerModel];
        [self.playerView.controlView setTitle:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.uploadvideo")];
        [_currentPlayVideoArray removeAllObjects];
        [_currentPlayVideoArray addObject:playerModel];
    }

    [self.view addSubview:self.playerFatherView];
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
    self.playerView.fatherView = self.playerFatherView;

    self.vodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.vodBtn];
    [self.vodBtn setTitle:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.ondemandlist") forState:UIControlStateNormal];
    [self.vodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.vodBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.vodBtn addTarget:self action:@selector(clickVodList:) forControlEvents:UIControlEventTouchUpInside];

    self.liveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.liveBtn];
    [self.liveBtn setTitle:LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.livelist") forState:UIControlStateNormal];
    [self.liveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.liveBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.liveBtn addTarget:self action:@selector(clickLiveList:) forControlEvents:UIControlEventTouchUpInside];
    [self.vodBtn setSelected:YES];

    CGFloat btnWidth = self.vodBtn.titleLabel.attributedText.size.width;
    [self.vodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playerFatherView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(-btnWidth);
    }];
    [self.liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playerFatherView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(btnWidth);
    }];

    // 视频列表
    self.scrollView                                = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.pagingEnabled                  = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate                       = self;

    [self.view addSubview:self.scrollView];
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
    UIView *container = [UIView new];
    [self.scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(@(ScreenWidth * 2));
        make.height.equalTo(self.scrollView.mas_height);
    }];

    // 直播
    self.liveListView                 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.liveListView.backgroundColor = [UIColor clearColor];
    [container addSubview:self.liveListView];
    [self.liveListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(@(ScreenWidth));
        make.width.equalTo(@(ScreenWidth));
        make.bottom.mas_equalTo(container.mas_bottom);
    }];
    self.liveListView.delegate   = self;
    self.liveListView.dataSource = self;
    [self.liveListView registerClass:[ListVideoCell class] forCellReuseIdentifier:LIST_VIDEO_CELL_ID];
    [self.liveListView setSeparatorColor:[UIColor clearColor]];

    // 点播
    self.vodListView                 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.vodListView.backgroundColor = [UIColor clearColor];
    [container addSubview:self.vodListView];
    [self.vodListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.equalTo(@(ScreenWidth));
        make.bottom.mas_equalTo(container.mas_bottom);
    }];
    self.vodListView.delegate   = self;
    self.vodListView.dataSource = self;
    [self.vodListView registerClass:[ListVideoCell class] forCellReuseIdentifier:LIST_VIDEO_CELL_ID];
    [self.vodListView setSeparatorColor:[UIColor clearColor]];

    // 定义一个button
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"addp"] forState:UIControlStateNormal];
    [self.view addSubview:addButton];
    [addButton sizeToFit];
    [addButton addTarget:self action:@selector(onAddClick:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = addButton;

    [self _refreshVODList];

    [self _refreshLiveList];

    self.playerBackBtn = ((SPDefaultControlView *)self.playerView.controlView).backBtn;
    // 直接获取controlview，想怎样控制界面都行。记得在全屏事件里也要处理，不然内部可能会设其它状态
    //    self.playerBackBtn.hidden = YES;
}

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
                    [self.playerView playWithModel:[self.vodDataSourceArray[0] getPlayerModel]];
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
        ListVideoModel *model = [ListVideoModel new];
        model.url = LOCAL_LIVE_URL;
        model.title = LOCAL_LIVE_TITLE;
        model.coverUrl = LOCAL_LIVE_COVERURL;
        model.type = 1;
        [allList addObject:model];
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

#pragma mark - Getter
- (UGCUploadList *)ugcUplaodList {
    if (!_ugcUplaodList) {
        _ugcUplaodList = [[UGCUploadList alloc] init];
    }
    return _ugcUplaodList;
}

- (SuperPlayerView *)playerView {
    if (!_playerView) {
        _playerView            = [[SuperPlayerView alloc] init];
        _playerView.fatherView = _playerFatherView;
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

- (UIView *)playerFatherView {
    if (!_playerFatherView) {
        _playerFatherView = [[UIView alloc] init];
        _playerFatherView.backgroundColor = [UIColor blackColor];
    }
    return _playerFatherView;
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
        [self.playerView playWithModel:[[self.vodDataSourceArray[0] firstObject] getPlayerModel]];
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
        if (!m.title || [m.title isEqualToString:@""]) {
            if (playInfo.name && playInfo.name.length >0) {
                m.title = playInfo.name;
            } else {
                m.title = [NSString stringWithFormat:@"%@%@", LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.video"), playInfo.fileId];
            }
        }
        
        if ([m.title containsString:DYNAMIC_WATER_VIDEO_DEFAULT_CELL_TITLE]) {
            m.title = DYNAMIC_WATER_VIDEO_DEFAULT_CELL_TITLE;
            DynamicWaterModel *model = [[DynamicWaterModel alloc] init];
            model.dynamicWatermarkTip = @"shipinyun";
            model.textFont = 30;
            model.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
            m.dynamicWaterModel = model;
        }
        
        m.coverUrl = playInfo.coverUrl;
        m.psign = playInfo.pSign;
        if ([m.title containsString:COVER_DEFAULT_DEFAULT_TITLE]) {
            m.title = COVER_DEFAULT_DEFAULT_TITLE;
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
        [modelArray addObject:VIDEO_LOOP_PLAY_DEFAULT_TITLE];
        self.isAddLoopVideo = NO;
    } else if (modelArray.count > 1 && !self.isAddLoopVideo) {
        [modelArray addObject:VIDEO_OFFLINE_CACHE_DEFAULT_TITLE];
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
        [SuperPlayerWindowShared setSuperPlayer:self.playerView];
        [SuperPlayerWindowShared show];
        SuperPlayerWindowShared.backController = self;
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

    ScanQRController *vc = [[ScanQRController alloc] init];
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
        }
    } else if ([self _isURLTypeV4vodplayProtocol:result]) {
        //仅支持普通URL传参方式
        [self _fillModel:model withURL:result];
        isLive = NO;
    } else if ([result hasPrefix:@"rtmp"] || ([result hasPrefix:@"http"] && [result hasSuffix:@".flv"])) {
        model.videoURL = result;
        isLive         = YES;
    } else {
        model.videoURL = result;
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
    } else {
        if (model.videoId) {
            [m setModel:model];
        }
        m.title = [NSString stringWithFormat:@"%@%lu", LivePlayerLocalize(@"SuperPlayerDemo.MoviePlayer.video"), (unsigned long)_vodDataSourceArray.count + 1];
        NSMutableArray *videoArray = [NSMutableArray array];
        [videoArray addObject:m];
        [_vodDataSourceArray addObject:videoArray];
        [_vodListView reloadData];
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
    [self.playerView playWithModel:model];
    
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
        if (modelArray.count > 1 && [modelArray.lastObject isEqualToString:VIDEO_LOOP_PLAY_DEFAULT_TITLE]) {
            param = [ListVideoModel new];
            param.title = VIDEO_LOOP_PLAY_DEFAULT_TITLE;
            param.coverUrl = VIDEO_LOOP_PLAY_DEFAULT_URL;
        } else if (modelArray.count > 1 && [modelArray.lastObject isEqualToString:VIDEO_OFFLINE_CACHE_DEFAULT_TITLE]) {
            param = [ListVideoModel new];
            param.title = VIDEO_OFFLINE_CACHE_DEFAULT_TITLE;
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
        if ([[cell getSource].title containsString:VIP_VIDEO_DEFAULT_CELL_TITLE]) {
            [self.playerView showVipTipView];
        }
        
        if ([[cell getSource].title containsString:VIDEO_LOOP_PLAY_DEFAULT_TITLE]) {
            // 模型转换
            NSMutableArray *videoModelArray = self.vodDataSourceArray[indexPath.row];
            
            NSMutableArray *videoList = [NSMutableArray array];
            for (int i = 0; i < videoModelArray.count - 1; i++) {
                ListVideoModel *model = videoModelArray[i];
                [videoList addObject:[model getPlayerModel]];
            }
            [self.playerView playWithModelList:videoList isLoopPlayList:YES startIndex:0];
            [self->_currentPlayVideoArray removeAllObjects];
            [self->_currentPlayVideoArray addObjectsFromArray:videoList];
        } else if ([[cell getSource].title containsString:VIDEO_OFFLINE_CACHE_DEFAULT_TITLE]) {
            // 模型转换
            NSMutableArray *videoModelArray = self.vodDataSourceArray[indexPath.row];
            NSMutableArray *videoList = [NSMutableArray array];
            for (int i = 0; i < videoModelArray.count - 1; i++) {
                ListVideoModel *model = videoModelArray[i];
                [videoList addObject:[model getPlayerModel]];
            }
            [self.playerView playWithModelList:videoList isLoopPlayList:YES startIndex:0];
            [self->_currentPlayVideoArray removeAllObjects];
            [self->_currentPlayVideoArray addObjectsFromArray:videoList];
            [self setVideoCacheData];
        } else {
            SuperPlayerModel *model = [cell getPlayerModel];
            [self.playerView.controlView setTitle:[cell getSource].title];
            [self.playerView playWithModel:model];
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
    NSString *danmakufile   = [[NSBundle mainBundle] pathForResource:@"danmakufile" ofType:nil];
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
}

- (void)clickLiveList:(id)sender {
    [self.vodBtn setSelected:NO];
    [self.liveBtn setSelected:YES];
    [self.scrollView scrollRectToVisible:CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollView.mm_h) animated:YES];
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
    [UIView animateWithDuration:1.0 animations:^{
        self->_cacheView.transform = CGAffineTransformMakeTranslation(-(OFFLINE_VIDEOCATCHVIEW_HEIGHT + HomeIndicator_Height), 0);
    }];
    
    _cacheView.hidden = NO;
}

@end
