//
//  MainViewController.m
//  RTMPiOSDemo
//
//  Created by rushanting on 2017/4/28.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "MainViewController.h"
#ifdef ENABLE_PUSH
#import "CameraPushViewController.h"
#endif
#if !defined(UGC) && !defined(PLAYER)
#import "PlayViewController.h"

//#ifndef DISABLE_VOD
//#import "DownloadViewController.h"
//#endif

#endif
#ifdef ENABLE_UGC
#import "UGCVideoEditWrapper.h"
#import "UGCVideoJoinWrapper.h"
#import "UGCVideoUploadWrapper.h"
#import "UGCRecordWrapper.h"
#endif

#if defined(ENABLE_PLAY) && !defined(DISABLE_VOD)
#import "SuperPlayer.h"
#endif

#ifdef ENABLE_TRTC
#import "TXLiteAVSDK.h"
#import "TXLiteAVDemo-Swift.h"
#endif

#import "ColorMacro.h"
#import "MainTableViewCell.h"

#ifndef ENABLE_TRTC
#import "TXLiveBase.h"
#endif

#if !defined(UGC) && !defined(PLAYER)
#import "TXLiteAVDemo-Swift.h"
#import <ImSDK/ImSDK.h>
#endif

#ifdef SMART
#import "GenerateTestUserSig.h"
#endif



#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

static NSString * const XiaoZhiBoAppStoreURLString = @"http://itunes.apple.com/cn/app/id1132521667?mt=8";
static NSString * const XiaoShiPinAppStoreURLString = @"http://itunes.apple.com/cn/app/id1374099214?mt=8";

@interface MainViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDataSource,
UIPickerViewDelegate,
UIAlertViewDelegate
>
#ifdef ENABLE_UGC
@property (strong, nonatomic) UGCRecordWrapper *ugcRecordWrapper;
@property (strong, nonatomic) UGCVideoUploadWrapper *ugcUploadWrapper;
@property (strong, nonatomic) UGCVideoJoinWrapper *ugcJoinWrapper;
@property (strong, nonatomic) UGCVideoEditWrapper *ugcEditWrapper;
#endif
@property (nonatomic) NSMutableArray<CellInfo*>* cellInfos;
@property (nonatomic) NSArray<CellInfo*>* addNewCellInfos;
@property (nonatomic) MainTableViewCell *selectedCell;
@property (nonatomic) UITableView* tableView;
@property (nonatomic) UIView*   logUploadView;
@property (nonatomic) UIPickerView* logPickerView;
@property (nonatomic) NSMutableArray* logFilesArray;

#ifdef ENABLE_TRTC
@property (nonatomic, strong) TRTCCallingContactViewController *videoCallVC;
@property (nonatomic, strong) TRTCLiveRoom *liveRoom;
@property (nonatomic, strong) TRTCVoiceRoom *voiceRoom;
#endif

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#ifdef ENABLE_UGC
    _ugcEditWrapper = [[UGCVideoEditWrapper alloc] initWithViewController:self theme:nil];
    _ugcJoinWrapper = [[UGCVideoJoinWrapper alloc] initWithViewController:self theme:nil];
    _ugcRecordWrapper = [[UGCRecordWrapper alloc] initWithViewController:self theme:nil];
    _ugcUploadWrapper = [[UGCVideoUploadWrapper alloc] initWithViewController:self theme:nil];
#endif
    
#ifdef ENABLE_TRTC
    _videoCallVC = [[TRTCCallingContactViewController alloc] init];
    _voiceRoom = [TRTCVoiceRoom sharedInstance];
    [[TRTCCalling shareInstance] addDelegate:_videoCallVC];
    

#endif

    [self initCellInfos];
    [self initUI];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
#ifdef SMART
    V2TIMSDKConfig *config = [[V2TIMSDKConfig alloc] init];
    [[V2TIMManager sharedInstance] initSDK:SDKAPPID config:config listener:nil];
#endif
#ifdef ENABLE_TRTC
    [self setupIMOnDidAppear];
#endif
}

- (IBAction)logout:(id)sender {
    #if !defined(UGC) && !defined(PLAYER)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[ProfileManager shared] removeLoginCache];
        [[AppUtils shared] showLoginController];
        [[V2TIMManager sharedInstance] logout:^{
            
        } fail:^(int code, NSString *msg) {
            
        }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    #endif
}

- (void)initCellInfos
{
    _cellInfos = [NSMutableArray new];
    CellInfo* cellInfo = nil;
    __weak __typeof(self) weakSelf = self;
#if defined(ENABLE_PUSH)
    cellInfo = [CellInfo new];
    cellInfo.title = @"移动直播";
    cellInfo.iconName = @"main_room_live";
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
    // 移动直播相关入口
//     NSArray* liveRoomCellInfos = ({
        NSMutableArray *subCells = [NSMutableArray new];
        CellInfo* scellInfo;
    
        scellInfo = [CellInfo cellInfoWithTitle:@"MLVBLiveRoom"
                       controllerClassName:@"LiveRoomListViewController"];
        [subCells addObject:scellInfo];
        
#ifdef ENABLE_PUSH
        scellInfo = [CellInfo cellInfoWithTitle:@"摄像头推流"
                       controllerClassName:@"CameraPushViewController"];
        [subCells addObject:scellInfo];
        
#endif
        
#if !defined(UGC) && !defined(PLAYER)
        scellInfo = [CellInfo cellInfoWithTitle:@"直播拉流"
                       controllerClassName:@"PlayViewController"];
        [subCells addObject:scellInfo];
#endif
        
#if defined(ENABLE_PUSH)
        scellInfo = [CellInfo cellInfoWithTitle:@"录屏直播"
                              controllerClassName:@"ScreenPushViewController"];
        [subCells addObject:scellInfo];
#endif
        
        scellInfo = [CellInfo cellInfoWithTitle:@"小直播" actionBlock:^{
            // 打开小直播AppStore
            [[UIApplication sharedApplication]
             openURL:[NSURL URLWithString:XiaoZhiBoAppStoreURLString]];
        }];
        [subCells addObject:scellInfo];
        
        subCells;
    });
//    [_cellInfos addObjectsFromArray:liveRoomCellInfos];
#endif

#if defined(ENABLE_PLAY) && !defined(DISABLE_VOD)
    cellInfo = [CellInfo new];
    cellInfo.title = @"播放器";
    cellInfo.iconName = @"main_composite";
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
//    NSArray* playerCellInfos = ({
        NSMutableArray *subCells = [NSMutableArray new];
        CellInfo* scellInfo;
        scellInfo = [CellInfo cellInfoWithTitle:@"超级播放器"
                       controllerClassName:@"MoviePlayerViewController"];
        [subCells addObject:scellInfo];
        subCells;
    });
//    [_cellInfos addObjectsFromArray:playerCellInfos];
#endif
    
#ifdef ENABLE_UGC
    cellInfo = [CellInfo new];
    cellInfo.title = @"短视频";
    cellInfo.iconName = @"main_room_video";
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
//    NSArray* videoCellInfos = ({
        NSMutableArray *subCells = [NSMutableArray new];
        CellInfo* scellInfo;
        
        scellInfo = [CellInfo cellInfoWithTitle:@"视频录制" actionBlock:^{
            [weakSelf.ugcRecordWrapper showRecordEntryController];
        }];
        [subCells addObject:scellInfo];
        
#ifndef UGC_SMART        
        scellInfo = [CellInfo cellInfoWithTitle:@"特效编辑" actionBlock:^{
            [weakSelf.ugcEditWrapper showEditEntryControllerWithType:UGCKitMediaTypeVideo];
        }];
        [subCells addObject:scellInfo];
        
        scellInfo = [CellInfo cellInfoWithTitle:@"视频拼接" actionBlock:^{
            [weakSelf.ugcJoinWrapper showVideoJoinEntryController];
        }];
        [subCells addObject:scellInfo];
        
        scellInfo = [CellInfo cellInfoWithTitle:@"图片转场" actionBlock:^{
            [weakSelf.ugcEditWrapper showEditEntryControllerWithType:UGCKitMediaTypePhoto];
        }];
        [subCells addObject:scellInfo];
#endif
        scellInfo = [CellInfo cellInfoWithTitle:@"视频上传" actionBlock:^{
            [weakSelf.ugcUploadWrapper showVideoUploadEntryController];
        }];
        [subCells addObject:scellInfo];

        scellInfo = [CellInfo cellInfoWithTitle:@"小视频" actionBlock:^{
            //打开小视频AppStore
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:XiaoShiPinAppStoreURLString]];
        }];
        [subCells addObject:scellInfo];
        
        subCells;
    });
//    [_cellInfos addObjectsFromArray:videoCellInfos];
#endif
    
    
#if defined(ENABLE_TRTC)
    cellInfo = [CellInfo new];
    cellInfo.title = @"实时音视频 TRTC";
    cellInfo.iconName = @"main_room_multi";
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
//    NSArray* TRTCCellInfos = ({
        NSMutableArray *subCells = [NSMutableArray new];
        CellInfo* scellInfo;
        scellInfo = [CellInfo cellInfoWithTitle:@"多人视频会议" actionBlock:^{
            TRTCMeetingNewViewController *vc = [[TRTCMeetingNewViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [subCells addObject:scellInfo];
        scellInfo = [CellInfo cellInfoWithTitle:@"语音聊天室"
                        controllerCreationBlock:^UIViewController * _Nonnull{
            NSString *userID = [[ProfileManager shared] curUserID];
            NSString *userSig = [[ProfileManager shared] curUserSig];
            [self.voiceRoom login:SDKAPPID userId:userID userSig:userSig callback:^(int32_t code, NSString * _Nonnull error) {
                NSLog(@"voice room 登录信息%ld, %@", (long)code, error);
            }];
            LoginResultModel *curUser = [[ProfileManager shared] curUserModel];
            [self.voiceRoom setSelfProfile:curUser.name avatarURL:curUser.avatar callback:^(int32_t code, NSString * _Nonnull message) {
                NSLog(@"live room profile信息：%ld, %@", (long)code, message);

            }];
            TRTCVoiceRoomEnteryControl *container = [[TRTCVoiceRoomEnteryControl alloc] initWithSdkAppId:SDKAPPID userId:userID];
            UIViewController* enterViewController = [container makeEntranceViewController];
            return enterViewController;
        }];
        [subCells addObject:scellInfo];
        scellInfo = [CellInfo cellInfoWithTitle:@"视频互动直播" controllerCreationBlock:^UIViewController * _Nonnull{
            weakSelf.liveRoom = [TRTCLiveRoom shareInstance];
            NSString *userID = [[ProfileManager shared] curUserID];
            NSString *userSig = [[ProfileManager shared] curUserSig];
            TRTCLiveRoomConfig *config = [[TRTCLiveRoomConfig alloc] init];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"liveRoomConfig_useCDNFirst"] != nil) {
                config.useCDNFirst = [[[NSUserDefaults standardUserDefaults] objectForKey:@"liveRoomConfig_useCDNFirst"] boolValue];
            }
            
            if (config.useCDNFirst && [[NSUserDefaults standardUserDefaults] objectForKey:@"liveRoomConfig_cndPlayDomain"] != nil) {
                config.cdnPlayDomain = [[NSUserDefaults standardUserDefaults] objectForKey:@"liveRoomConfig_cndPlayDomain"];
            }
            
            [self.liveRoom loginWithSdkAppID:SDKAPPID userID:userID userSig:userSig config:config callback:^(int code, NSString * error) {
                NSLog(@"live room 登录信息：%ld, %@", (long)code, error);
            }];
          
            LoginResultModel *curUser = [[ProfileManager shared] curUserModel];
            [self.liveRoom setSelfProfileWithName:curUser.name avatarURL:curUser.avatar callback:^(int code, NSString * error) {
                NSLog(@"live room profile信息：%ld, %@", (long)code, error);
            }];
           
            return [[LiveRoomMainViewController alloc] initWithLiveRoom:weakSelf.liveRoom];
        }];
        [subCells addObject:scellInfo];
        scellInfo = [CellInfo cellInfoWithTitle:@"语音通话"
                   controllerCreationBlock:^UIViewController * _Nonnull{
            weakSelf.videoCallVC.title = @"语音通话";
            weakSelf.videoCallVC.callType = CallType_Audio;
            return weakSelf.videoCallVC;
        }];
        [subCells addObject:scellInfo];
        scellInfo = [CellInfo cellInfoWithTitle:@"视频通话" controllerCreationBlock:^UIViewController * _Nonnull{
            weakSelf.videoCallVC.title = @"视频通话";
            weakSelf.videoCallVC.callType = CallType_Video;
            return weakSelf.videoCallVC;
        }];
        [subCells addObject:scellInfo];
       

       
        subCells;
    });
//    [_cellInfos addObjectsFromArray:TRTCCellInfos];
#endif
//
//    if ([cellInfo.subCells count] > 0) {
//        [_cellInfos addObject:cellInfo];
//    }
}

- (void)initUI
{
    int originX = 15;
    CGFloat width = self.view.frame.size.width - 2 * originX;
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
    
    //大标题
    UILabel* lbHeadLine = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, width, 48)];
    lbHeadLine.text = @"腾讯视频云";
    lbHeadLine.textColor = UIColorFromRGB(0xffffff);
    lbHeadLine.font = [UIFont systemFontOfSize:24];
    [lbHeadLine sizeToFit];
    [self.view addSubview:lbHeadLine];
    lbHeadLine.center = CGPointMake(lbHeadLine.superview.center.x, lbHeadLine.center.y);
    
    lbHeadLine.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [lbHeadLine addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer* pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)]; //提取SDK日志暗号!
    pressGesture.minimumPressDuration = 2.0;
    pressGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:pressGesture];
    
    // 退出登录按钮
    UIButton* logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(20, 0, 32, 32);
    CGPoint center = logoutButton.center;
    center.y = lbHeadLine.center.y;
    logoutButton.center = center;
    [logoutButton setImage:[UIImage imageNamed:@"ic_logout"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
#if !defined(UGC) && !defined(PLAYER)
    [self.view addSubview:logoutButton];
#endif
   
    
    //副标题
    UILabel* lbSubHead = [[UILabel alloc] initWithFrame:CGRectMake(originX, lbHeadLine.frame.origin.y + lbHeadLine.frame.size.height + 15, width, 30)];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *sdkVersion = [TXLiveBase getSDKVersionStr];
    lbSubHead.text = [NSString stringWithFormat:@"视频云工具包 v%@(%@)", sdkVersion, version];
    lbSubHead.text = [lbSubHead.text stringByAppendingString:@"\n本APP用于展示腾讯视频云终端产品的各类功能"];
    lbSubHead.numberOfLines = 2;
    lbSubHead.textColor = UIColor.grayColor;
    lbSubHead.textAlignment = NSTextAlignmentCenter;
    lbSubHead.font = [UIFont systemFontOfSize:14];
    lbSubHead.textColor = UIColorFromRGB(0x535353);
    
    //行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lbSubHead.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:7.5f];//设置行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lbSubHead.text.length)];
    lbSubHead.attributedText = attributedString;
    
    [lbSubHead sizeToFit];
    
    [self.view addSubview:lbSubHead];
    lbSubHead.userInteractionEnabled = YES;
    [lbSubHead addGestureRecognizer:tapGesture];
    lbSubHead.frame = CGRectMake(lbSubHead.frame.origin.x, self.view.frame.size.height-lbSubHead.frame.size.height-34, lbSubHead.frame.size.width, lbSubHead.frame.size.height);
    lbSubHead.center = CGPointMake(lbSubHead.superview.frame.size.width/2, lbSubHead.center.y);
    
    //功能列表
    int tableviewY = lbSubHead.frame.origin.y + lbSubHead.frame.size.height + 12;
    int bottomHeight = lbSubHead.frame.size.height + 34;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(originX, tableviewY, width, self.view.frame.size.height - tableviewY - bottomHeight)];
    _tableView.backgroundColor = UIColor.clearColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, lbHeadLine.frame.origin.y+lbHeadLine.frame.size.height+12, _tableView.frame.size.width, _tableView.superview.frame.size.height);
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.superview.frame.size.height-_tableView.frame.origin.y - bottomHeight - 20);
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _logUploadView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2, self.view.bounds.size.width, self.view.bounds.size.height / 2)];
    _logUploadView.backgroundColor = [UIColor whiteColor];
    _logUploadView.hidden = YES;
    
    _logPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _logUploadView.frame.size.height * 0.8)];
    _logPickerView.dataSource = self;
    _logPickerView.delegate = self;
    [_logUploadView addSubview:_logPickerView];
    
    UIButton* uploadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    uploadButton.center = CGPointMake(self.view.bounds.size.width / 2, _logUploadView.frame.size.height * 0.9);
    uploadButton.bounds = CGRectMake(0, 0, self.view.bounds.size.width / 3, _logUploadView.frame.size.height * 0.2);
    [uploadButton setTitle:@"分享上传日志" forState:UIControlStateNormal];
    [uploadButton addTarget:self action:@selector(onSharedUploadLog:) forControlEvents:UIControlEventTouchUpInside];
    [_logUploadView addSubview:uploadButton];
    
    [self.view addSubview:_logUploadView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellInfos.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellInfos.count < indexPath.row)
        return nil;
    
    static NSString* cellIdentifier = @"MainViewCellIdentifier";
    MainTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    CellInfo* cellInfo = _cellInfos[indexPath.row];
    
    [cell setCellData:cellInfo];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_logUploadView.hidden) {
        _logUploadView.hidden = YES;
    }
    
    if (_cellInfos.count < indexPath.row)
        return ;
    
    MainTableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    CellInfo* cellInfo = currentCell.cellData;
    
    if (cellInfo.subCells != nil) {
        [tableView beginUpdates];
        NSMutableArray *indexArray = [NSMutableArray new];
        if (self.addNewCellInfos) {
            NSUInteger deleteFrom = [_cellInfos indexOfObject:self.addNewCellInfos[0]];
            for (int i = 0; i < self.addNewCellInfos.count; i++) {
                [indexArray addObject:[NSIndexPath indexPathForRow:i+deleteFrom inSection:0]];
            }
            [tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
            [_cellInfos removeObjectsInArray:self.addNewCellInfos];
        }
        [tableView endUpdates];
        
        [tableView beginUpdates];
        if (!cellInfo.isUnFold) {
            self.selectedCell.highLight = NO;
            self.selectedCell.cellData.isUnFold = NO;
            
            NSUInteger row = [_cellInfos indexOfObject:cellInfo]+1;
            [indexArray removeAllObjects];
            for (int i = 0; i < cellInfo.subCells.count; i++) {
                [indexArray addObject:[NSIndexPath indexPathForRow:i+row inSection:0]];
            }
            [_cellInfos insertObjects:cellInfo.subCells atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row, cellInfo.subCells.count)]];
            [tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [tableView endUpdates];
        
        cellInfo.isUnFold = !cellInfo.isUnFold;
        currentCell.highLight = cellInfo.isUnFold;
        self.selectedCell = currentCell;
        if (cellInfo.isUnFold) {
            self.addNewCellInfos = cellInfo.subCells;
        } else {
            self.addNewCellInfos = nil;
        }
        return;
    }

    if (cellInfo.type == CellInfoTypeEntry) {
        UIViewController *controller = [cellInfo createEntryController];
        if (controller) {
            if (![controller isKindOfClass:NSClassFromString(@"MoviePlayerViewController")]) {
                [self _hideSuperPlayer];
            }
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (cellInfo.type == CellInfoTypeAction) {
        [cellInfo performAction];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellInfo* cellInfo = _cellInfos[indexPath.row];
    if (cellInfo.subCells != nil) {
        return 65;
    }
    return 51;
}

#if defined(ENABLE_PLAY) && !defined(DISABLE_VOD)
- (void)_hideSuperPlayer {
    if (SuperPlayerWindowShared.isShowing) {
        [SuperPlayerWindowShared hide];
        [SuperPlayerWindowShared.superPlayer resetPlayer];
        SuperPlayerWindowShared.backController = nil;
    }
}
#else
- (void)_hideSuperPlayer {}
#endif

- (void)handleLongPress:(UILongPressGestureRecognizer *)pressRecognizer
{
    if (pressRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long Press");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *logDoc = [NSString stringWithFormat:@"%@%@", paths[0], @"/log"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray* fileArray = [fileManager contentsOfDirectoryAtPath:logDoc error:nil];
        fileArray = [fileArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString* file1 = (NSString*)obj1;
            NSString* file2 = (NSString*)obj2;
            return [file1 compare:file2] == NSOrderedDescending;
        }];
        self.logFilesArray = [NSMutableArray new];
        for (NSString* logName in fileArray) {
            if ([logName hasSuffix:@"xlog"]) {
                [self.logFilesArray addObject:logName];
            }
        }
        
        _logUploadView.alpha = 0.1;
        UIView *logUploadView = _logUploadView;
        [UIView animateWithDuration:0.5 animations:^{
            logUploadView.hidden = NO;
            logUploadView.alpha = 1;
        }];
        [_logPickerView reloadAllComponents];
    }
}

- (void)handleTap:(UITapGestureRecognizer*)tapRecognizer
{
    if (!_logUploadView.hidden) {
        _logUploadView.hidden = YES;
    }
}

- (void)onSharedUploadLog:(UIButton*)sender
{
    NSInteger row = [_logPickerView selectedRowInComponent:0];
    if (row < self.logFilesArray.count) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *logDoc = [NSString stringWithFormat:@"%@%@", paths[0], @"/log"];
        NSString* logPath = [logDoc stringByAppendingPathComponent:self.logFilesArray[row]];
        NSURL *shareobj = [NSURL fileURLWithPath:logPath];
        UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[shareobj] applicationActivities:nil];
        UIView *logUploadView = _logUploadView;
        [self presentViewController:activityView animated:YES completion:^{
            logUploadView.hidden = YES;
        }];
    }
}
#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.logFilesArray.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row < self.logFilesArray.count) {
        return (NSString*)self.logFilesArray[row];
    }
    
    return nil;
}

#pragma mark - TRTC相关
#ifdef ENABLE_TRTC
- (void)setupIMOnDidAppear {
    NSString *userID = [[ProfileManager shared] curUserID];
    NSString *userSig = [[ProfileManager shared] curUserSig];
    
    if (![[[V2TIMManager sharedInstance] getLoginUser] isEqual:userID]) {
        [[ProfileManager shared] IMLoginWithUserSig:userSig success:^{
            [[TRTCCalling shareInstance] login:SDKAPPID user:userID userSig:userSig success:^{
                NSLog(@"Calling login success.");
            } failed:^(int code, NSString * _Nonnull des) {
                NSLog(@"Calling login failed.");
            }];
            [[TRTCMeeting sharedInstance] login:SDKAPPID userId:userID userSig:userSig callback:^(NSInteger code, NSString *message) {
                
            }];
        } failed:^(NSString * error) {
            
        }];
    }
}

#endif

@end
