//
//  MoviePlayerViewController.m
//


#import "MoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
#import "SuperPlayer.h"
#import "ScanQRController.h"
#import "UIImage+Additions.h"
#import "ListVideoCell.h"
#import "TXPlayerAuthParams.h"
#import "TXVodPlayer.h"
#import "TCHttpUtil.h"
#import "MBProgressHUD.h"
#import "TXMoviePlayerNetApi.h"
#import "UIView+MMLayout.h"
#import "J2Obj.h"
#import "AppDelegate.h"
#import "SuperPlayerGuideView.h"
#import "AFNetworking.h"
#define LIST_VIDEO_CELL_ID @"LIST_VIDEO_CELL_ID"
#define LIST_LIVE_CELL_ID @"LIST_LIVE_CELL_ID"

__weak UITextField *appField;
__weak UITextField *fileidField;
__weak UITextField *urlField;

@interface MoviePlayerViewController () <SuperPlayerDelegate, ScanQRDelegate, UITableViewDelegate, UITableViewDataSource,TXMoviePlayerNetDelegate>
/** 播放器View的父视图*/
@property (nonatomic) UIView *playerFatherView;
@property (strong, nonatomic) SuperPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;   

@property (nonatomic, strong) UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (nonatomic, strong) UITextField *textView;

@property (nonatomic, strong) UITableView *vodListView; // 点播列表
@property (nonatomic, strong) UITableView *liveListView;

@property UIButton *vodBtn;    // 点播标签
@property UIButton *liveBtn;   // 直播标签

@property NSMutableArray *authParamArray;
@property NSMutableArray *vodDataSourceArray;
@property NSMutableArray *liveDataSourceArray;
@property TXMoviePlayerNetApi *getInfoNetApi;
@property MBProgressHUD *hud;
@property UIButton *addBtn;

@property SuperPlayerGuideView *guideView;

@property UIScrollView  *scrollView;    //视频列表滑动scrollview

@end

@implementation MoviePlayerViewController

- (instancetype)init {
    if (SuperPlayerWindowShared.backController) {
        [SuperPlayerWindowShared hide];
        return (MoviePlayerViewController *)SuperPlayerWindowShared.backController;
    } else {
        return [super init];
    }
}

- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

- (void)willMoveToParentViewController:(nullable UIViewController *)parent
{
    
}
- (void)didMoveToParentViewController:(nullable UIViewController *)parent
{
    if (parent == nil) {
        if (!SuperPlayerWindowShared.isShowing) {
            [self.playerView resetPlayer];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image=[UIImage imageNamed:@"背景"];
    [self.view insertSubview:imageView atIndex:0];
    

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 60, 25)];
    [button setBackgroundImage:[UIImage imageNamed:@"扫码"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickScan:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[rightItem];



    // 左侧
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    //修改按钮向右移动10pt
    [leftbutton setFrame:CGRectMake(0, 0, 60, 25)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    self.title = @"超级播放器";
    
    
    
    // guide view
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if (![df boolForKey:@"isShowGuide"]) {
        if (_guideView == nil)
            _guideView = [[SuperPlayerGuideView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:_guideView];
        [_guideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_playerFatherView.mas_top);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        _playerView.isLockScreen = YES;
        __weak SuperPlayerView *wplayer = _playerView;
        _guideView.missHandler = ^{
            wplayer.isLockScreen = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wplayer showControlView:NO];
                
                [df setBool:YES forKey:@"isShowGuide"];
                [df synchronize];
            });
        };
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.addBtn.m_centerX().m_top(self.scrollView.mm_maxY);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _authParamArray = [NSMutableArray new];
    _vodDataSourceArray = [NSMutableArray new];
    _liveDataSourceArray = [NSMutableArray new];
    

    
    self.playerFatherView = [[UIView alloc] init];
    self.playerFatherView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.mas_equalTo(20+self.navigationController.navigationBar.bounds.size.height);
        }
        make.leading.trailing.mas_equalTo(0);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    self.playerView.fatherView = self.playerFatherView;
    
    self.vodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.vodBtn];
    [self.vodBtn setTitle:@"点播列表" forState:UIControlStateNormal];
    [self.vodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.vodBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.vodBtn addTarget:self action:@selector(clickVodList:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.liveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.liveBtn];
    [self.liveBtn setTitle:@"直播列表" forState:UIControlStateNormal];
    [self.liveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.liveBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.liveBtn addTarget:self action:@selector(clickLiveList:) forControlEvents:UIControlEventTouchUpInside];
    [self.liveBtn setSelected:YES];
    
    CGFloat btnWidth = self.vodBtn.titleLabel.attributedText.size.width;
    [self.liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playerFatherView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(-btnWidth);
    }];
    [self.vodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playerFatherView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(btnWidth);
    }];
    
    
    // 视频列表
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;

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
        make.width.equalTo(@(ScreenWidth*2));
        make.height.equalTo(self.scrollView.mas_height);
    }];
    
    // 直播
    self.liveListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.liveListView.backgroundColor = [UIColor clearColor];
    [container addSubview:self.liveListView];
    [self.liveListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.equalTo(@(ScreenWidth));
        make.bottom.mas_equalTo(container.mas_bottom);
    }];
    self.liveListView.delegate = self;
    self.liveListView.dataSource = self;
    [self.liveListView registerClass:[ListVideoCell class] forCellReuseIdentifier:LIST_VIDEO_CELL_ID];
    [self.liveListView setSeparatorColor:[UIColor clearColor]];
    
    // 点播
    self.vodListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.vodListView.backgroundColor = [UIColor clearColor];
    [container addSubview:self.vodListView];
    [self.vodListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(@(ScreenWidth));
        make.width.equalTo(@(ScreenWidth));
        make.bottom.mas_equalTo(container.mas_bottom);
    }];
    self.vodListView.delegate = self;
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
    

    
    TXPlayerAuthParams *p = [TXPlayerAuthParams new];
    p.appId = 1252463788;
    p.fileId = @"5285890781763144364";
    [_authParamArray addObject:p];
    
    p = [TXPlayerAuthParams new];
    p.appId = 1252463788;
    p.fileId = @"4564972819220421305";
    [_authParamArray addObject:p];
    
    p = [TXPlayerAuthParams new];
    p.appId = 1252463788;
    p.fileId = @"4564972819219071568";
    [_authParamArray addObject:p];
    
    p = [TXPlayerAuthParams new];
    p.appId = 1252463788;
    p.fileId = @"4564972819219071668";
    [_authParamArray addObject:p];
    
    p = [TXPlayerAuthParams new];
    p.appId = 1252463788;
    p.fileId = @"4564972819219071679";
    [_authParamArray addObject:p];
        
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://xzb.qcloud.com/get_live_list" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [manager invalidateSessionCancelingTasks:YES];
        if ([J2Num([responseObject valueForKeyPath:@"code"]) intValue] != 200) {
            [self hudMessage:@"直播列表请求失败"];
            return;
        }
        NSMutableArray *allList = @[].mutableCopy;
        NSArray *list = J2Array([responseObject valueForKeyPath:@"data.list"]);
        for (id play in list) {
            ListVideoModel *m = [ListVideoModel new];
            m.appId = [J2Num([play valueForKeyPath:@"appId"]) intValue];
            m.coverUrl = J2Str([play valueForKey:@"coverUrl"]);
            m.title = J2Str([play valueForKeyPath:@"name"]);
            m.type = 1;
            NSArray *playUrl = J2Array([play valueForKeyPath:@"playUrl"]);
            for (id url in playUrl) {
                [m addHdUrl:J2Str([url valueForKeyPath:@"url"]) withTitle:J2Str([url valueForKeyPath:@"title"])];
            }
            
            [allList addObject:m];
        }
        _liveDataSourceArray = allList;
        [_liveListView reloadData];
        
        if (allList.count > 0) {
            [self.playerView playWithModel:[_liveDataSourceArray[0] getPlayerModel]];
            if (self.guideView) {
                [self.playerView showControlView:YES];
            }
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [manager invalidateSessionCancelingTasks:YES];
    }];
    
    [self getNextInfo];

}

// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    // if (SuperPlayerShared.isLandscape) {
    //    return UIStatusBarStyleDefault;
    // }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.playerView.isFullScreen;
}

#pragma mark - SuperPlayerDelegate

- (void)onPlayerBackAction {
    [self backClick];
}


#pragma mark - Getter

- (SuperPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[SuperPlayerView alloc] init];
        _playerView.fatherView = _playerFatherView;
        // 设置代理
        _playerView.delegate = self;
    }
    return _playerView;
}

- (void)onNetSuccess:(TXMoviePlayerNetApi *)obj
{
    ListVideoModel *m = [[ListVideoModel alloc] init];
    m.appId = obj.playInfo.appId;
    m.fileId = obj.playInfo.fileId;
    m.duration = obj.playInfo.duration;
    m.title = obj.playInfo.videoDescription?:obj.playInfo.name;
    m.coverUrl = obj.playInfo.coverUrl;
    [_vodDataSourceArray addObject:m];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_vodListView reloadData];
        [self getNextInfo];
    });
}

- (void)hudMessage:(NSString *)msg {
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    _hud.label.text = msg;
    _hud.mode = MBProgressHUDModeText;
    
    [_hud showAnimated:YES];
    [_hud hideAnimated:YES afterDelay:1];
}

- (void)onNetFailed:(TXMoviePlayerNetApi *)obj reason:(NSString *)reason code:(int)code {
    [self hudMessage:@"fileid请求失败"];
}

- (void)getNextInfo {
    if (_authParamArray.count == 0)
        return;
    TXPlayerAuthParams *p = [_authParamArray objectAtIndex:0];
    [_authParamArray removeObject:p];
    
    if (self.getInfoNetApi == nil) {
        self.getInfoNetApi = [[TXMoviePlayerNetApi alloc] init];
        self.getInfoNetApi.delegate = self;
        self.getInfoNetApi.https = NO;
    }
    [self.getInfoNetApi getplayinfo:p.appId
                             fileId:p.fileId
                             timeout:p.timeout
                                  us:p.us
                               exper:p.exper
                                sign:p.sign];
}

#pragma mark - Action

- (IBAction)backClick {
    
    // player加到控制器上，只有一个player时候
    // 状态条的方向旋转的方向,来判断当前屏幕的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 是竖屏时候响应关
    if (orientation == UIInterfaceOrientationPortrait && SuperPlayerGlobleConfigShared.enableFloatWindow &&
        (self.playerView.state == StatePlaying)) {
        [SuperPlayerWindowShared setSuperPlayer:self.playerView];
        [SuperPlayerWindowShared show];
        SuperPlayerWindowShared.backController = self;
    } else {
        [self.playerView resetPlayer];  //非常重要
        SuperPlayerWindowShared.backController = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) clickScan:(UIButton*) btn
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SuperPlayerShowScanTips"];
    
    ScanQRController* vc = [[ScanQRController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)onScanResult:(NSString *)result
{
    self.textView.text = result;
    SuperPlayerModel *model = [SuperPlayerModel new];
    model.title            = @"这是新播放的视频";
    model.videoURL         = result;
    
    
    [self.playerView playWithModel:model];
    
    ListVideoModel *m = [ListVideoModel new];
    m.url = result;
    m.type = self.playerView.isLive;
    if (self.playerView.isLive) {
        m.title = [NSString stringWithFormat:@"视频%lu",_liveDataSourceArray.count+1];
        [_liveDataSourceArray addObject:m];
        [_liveListView reloadData];
    } else {
        m.title = [NSString stringWithFormat:@"视频%lu",_vodDataSourceArray.count+1];
        [_vodDataSourceArray addObject:m];
        [_vodListView reloadData];
    }
    
}

- (void)onAddClick:(UIButton *)btn
{
    UIAlertController *control = [UIAlertController alertControllerWithTitle:@"添加视频" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    if (self.vodBtn.selected) {
        [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入appid";
            appField = textField;
        }];
        
        [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入fileid";
            fileidField = textField;
        }];
    } else {
        [control addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入直播url";
            urlField = textField;
        }];
    }
    
    BOOL isLock = self.playerView.isLockScreen;
    self.playerView.isLockScreen = YES;
    [control addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.vodBtn.selected) {
            TXPlayerAuthParams *p = [TXPlayerAuthParams new];
            p.appId = [appField.text intValue];
            p.fileId = fileidField.text;
            [_authParamArray addObject:p];
            
            [self getNextInfo];
        } else {
            if (urlField.text.length == 0) {
                [self hudMessage:@"请输入正确的播放地址"];
                return;
            }
            
            ListVideoModel *m = [ListVideoModel new];
            m.url = urlField.text;
            m.title = [NSString stringWithFormat:@"视频%lu",_liveDataSourceArray.count+1];
            m.type = 1;
            [_liveDataSourceArray addObject:m];
            [_liveListView reloadData];
        }
        
        self.playerView.isLockScreen = isLock;
    }]];
     
    [control addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.playerView.isLockScreen = isLock;
    }]];
    
    [self.navigationController presentViewController:control animated:YES completion:nil];
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return 78;
}

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
    NSInteger row = indexPath.row;
    ListVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:LIST_VIDEO_CELL_ID];
    
    ListVideoModel *param;
    if (tableView == self.vodListView) {
        param = [_vodDataSourceArray objectAtIndex:row];
    } else {
        param = [_liveDataSourceArray objectAtIndex:row];
    }
    [cell setDataSource:param];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListVideoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [self.playerView playWithModel:[cell getPlayerModel]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return NO;
}


#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView == self.scrollView) {
    CGPoint p = [scrollView contentOffset];
        if (p.x >= ScreenWidth) {
            [self.vodBtn setSelected:YES];
            [self.liveBtn setSelected:NO];
        } else {
            [self.vodBtn setSelected:NO];
            [self.liveBtn setSelected:YES];
        }
    }
}

- (void)clickVodList:(id)sender {
    [self.vodBtn setSelected:YES];
    [self.liveBtn setSelected:NO];
    [self.scrollView scrollRectToVisible:CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollView.mm_h) animated:YES];
}

- (void)clickLiveList:(id)sender {
    [self.vodBtn setSelected:NO];
    [self.liveBtn setSelected:YES];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, ScreenWidth, self.scrollView.mm_h) animated:YES];
}

@end
