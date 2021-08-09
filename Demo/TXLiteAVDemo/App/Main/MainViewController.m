//
//  MainViewController.m
//  RTMPiOSDemo
//
//  Created by rushanting on 2017/4/28.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "MainViewController.h"
#import "TCUtil.h"

#import "MBProgressHUD.h"
#ifdef ENABLE_PUSH
#import "CameraPushViewController.h"
#import "LebLauncherViewController.h"
#endif
#if !defined(UGC) && !defined(PLAYER) && !defined(ENABLE_INTERNATIONAL)
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
#import "TRTCLiveEnterViewController.h"
#import "TRTCCallingEnterViewController.h"
#import "TRTCSpeedTestViewController.h"
#endif

#import "ColorMacro.h"
#import "MainTableViewCell.h"

#ifndef ENABLE_TRTC
#ifdef LIVE
#import "V2TXLivePremier.h"
#else
#import "TXLiveBase.h"
#endif
#endif

#if !defined(UGC) && !defined(PLAYER)
#import "TXLiteAVDemo-Swift.h"
#import <ImSDK/ImSDK.h>
#import "GenerateTestUserSig.h"
#endif

#import "AppLocalized.h"



#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

static NSString * const XiaoZhiBoAppStoreURLString = @"http://itunes.apple.com/cn/app/id1132521667?mt=8";
static NSString * const XiaoShiPinAppStoreURLString = @"http://itunes.apple.com/cn/app/id1374099214?mt=8";
static NSString * const trtcAppStoreURLString = @"http://itunes.apple.com/cn/app/id1400663224?mt=8";


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
//@property (nonatomic, strong) TRTCCallingContactViewController *videoCallVC;
//@property (nonatomic, strong) TRTCLiveRoom *liveRoom;
//@property (nonatomic, strong) TRTCVoiceRoom *voiceRoom;
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
    //    _videoCallVC = [[TRTCCallingContactViewController alloc] init];
    //    _voiceRoom = [TRTCVoiceRoom sharedInstance];
    //    [[TRTCCalling shareInstance] addDelegate:_videoCallVC];
    
    
#endif
    
#if !defined(UGC) && !defined(PLAYER)
    V2TIMSDKConfig *config = [[V2TIMSDKConfig alloc] init];
    [[V2TIMManager sharedInstance] initSDK:SDKAPPID config:config listener:nil];
#endif
    
#if defined(ENTERPRISE) || defined(PROFESSIONAL)
    [self createEnterpriseCellInfos];
#endif
    
#ifdef ENABLE_INTERNATIONAL
    [self createInternationalCellInfos];
#endif
    
#ifdef LIVE
    [self createLiveCellInfos];
#endif
    
#ifdef PLAYER
    [self createPlayerCellInfos];
#endif
    
#ifdef SMART
    [self createSmartCellInfos];
#endif
    
#ifdef TRTC
    [self createTRTCCellInfos];
#endif
    
#ifdef UGC
    [self createUGCCellInfos];
#endif
    [self initUI];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)userInfoButtonClick:(id)sender {
}

#if defined(ENTERPRISE) || defined(PROFESSIONAL)
- (void)createEnterpriseCellInfos {
    _cellInfos = [NSMutableArray array];
    CellInfo *cellInfo = nil;
    
    cellInfo = [[CellInfo alloc] init];
    cellInfo.title = V2Localize(@"V2.Live.LinkMicNew.title");
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray array];
        CellInfo *subCellInfo;
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.pushcamera") controllerClassName:@"CameraStartPushViewController"];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.pushscreen") controllerClassName:@"ScreenPushViewController"];
        [subCells addObject:subCellInfo];

        if ([TCUtil getDEBUGSwitch]) {
            subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"V2.Live.LinkMicNew.coanchornew") controllerClassName:@"V2MainViewController"];
            [subCells addObject:subCellInfo];
            
            subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.coanchoringold") controllerClassName:@"LiveRoomListViewController"];
            [subCells addObject:subCellInfo];
        }
        
        subCells;
    });
    
    cellInfo = [[CellInfo alloc] init];
    cellInfo.title = V2Localize(@"MLVB.MainMenu.Livebroadcast");
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray array];
        CellInfo *subCellInfo;
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.Standardlivebroadcast") controllerClassName:@"PlayViewController"];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.lebLauncher.title") controllerClassName:@"LebLauncherViewController"];
        [subCells addObject:subCellInfo];
        if ([TCUtil getDEBUGSwitch]) {
            subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.RTCLauncher.title") controllerClassName:@"RTCLauncherViewController"];
            [subCells addObject:subCellInfo];
        }
        subCells;
    });
    
    cellInfo = [[CellInfo alloc] init];
    cellInfo.title = V2Localize(@"TRTC.MainMenu.trtc");
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray array];
        CellInfo *subCellInfo;
        
        subCellInfo = [CellInfo cellInfoWithTitle:TRTCLocalize(@"Demo.TRTC.Live.trtcSpeedTest") controllerCreationBlock:^UIViewController * _Nonnull{
            TRTCSpeedTestViewController* speedTestVC = [[TRTCSpeedTestViewController alloc] init];
            speedTestVC.title = TRTCLocalize(@"Demo.TRTC.Live.trtcSpeedTest");
            return speedTestVC;
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:TRTCLocalize(@"Demo.TRTC.Live.trtcLive") controllerCreationBlock:^UIViewController * _Nonnull{
            TRTCLiveEnterViewController* entranceVC = [[TRTCLiveEnterViewController alloc] init];
            entranceVC.title = TRTCLocalize(@"Demo.TRTC.Live.trtcLive");
            return entranceVC;
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo =  [CellInfo cellInfoWithTitle:TRTCLocalize(@"Demo.TRTC.Live.trtcCalling") controllerCreationBlock:^UIViewController * _Nonnull{
            TRTCCallingEnterViewController* entranceVC = [[TRTCCallingEnterViewController alloc] init];
            entranceVC.title = TRTCLocalize(@"Demo.TRTC.Live.trtcCalling");
            return entranceVC;
        }];
        [subCells addObject:subCellInfo];
        
        subCells;
    });
    
    __weak __typeof(self)weakSelf = self;
    cellInfo = [[CellInfo alloc] init];
    cellInfo.title = V2Localize(@"MLVB.MainMenu.UGSV");
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray array];
        CellInfo *subCellInfo;
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.Shooting") actionBlock:^{
            [weakSelf.ugcRecordWrapper showRecordEntryController];
        }];
        [subCells addObject:subCellInfo];

        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.SpecialEffects") actionBlock:^{
            [weakSelf.ugcEditWrapper showEditEntryControllerWithType:UGCKitMediaTypeVideo];
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.VideoSplicing") actionBlock:^{
            [weakSelf.ugcJoinWrapper showVideoJoinEntryController];
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.ImageTransition") actionBlock:^{
            [weakSelf.ugcEditWrapper showEditEntryControllerWithType:UGCKitMediaTypePhoto];
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.VideoUpload") actionBlock:^{
            [weakSelf.ugcUploadWrapper showVideoUploadEntryController];
        }];
        [subCells addObject:subCellInfo];
        
        subCells;
    });
    
    cellInfo = [[CellInfo alloc] init];
    cellInfo.title = V2Localize(@"MLVB.MainMenu.Player");
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray array];
        CellInfo *subCellInfo;
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.SuperPlayer") controllerClassName:@"MoviePlayerViewController"];
        [subCells addObject:subCellInfo];
        if ([TCUtil getDEBUGSwitch]) {
            subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.VodPlayer") controllerClassName:@"PlayVodViewController"];
            [subCells addObject:subCellInfo];
        }
        subCells;
    });
    
    cellInfo = [[CellInfo alloc] init];
    cellInfo.title = V2Localize(@"MLVB.MainMenu.Scene");
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray array];
        CellInfo *subCellInfo;
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.LVBLite") actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:XiaoZhiBoAppStoreURLString]];
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.UGSVApp") actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:XiaoShiPinAppStoreURLString]];
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.TRTCAPP") actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trtcAppStoreURLString]];
        }];
        [subCells addObject:subCellInfo];
        
        subCells;
    });
}
#endif

#ifdef ENABLE_INTERNATIONAL
- (void)createInternationalCellInfos {
    _cellInfos = [NSMutableArray array];
    CellInfo *cellInfo = nil;
    
    cellInfo = [[CellInfo alloc] init];
    cellInfo.title = V2Localize(@"V2.Live.LinkMicNew.title");
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray array];
        CellInfo *subCellInfo;
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"V2.Live.LinkMicNew.coanchornew") controllerClassName:@"V2MainViewController"];
        [subCells addObject:subCellInfo];
        subCells;
    });
}
#endif

#ifdef LIVE
- (void)createLiveCellInfos {
    _cellInfos = [NSMutableArray array];
    CellInfo *cellInfo = nil;
    
    cellInfo = [[CellInfo alloc] init];
    cellInfo.title = V2Localize(@"V2.Live.LinkMicNew.title");
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray array];
        CellInfo *subCellInfo;
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.pushcamera") controllerClassName:@"CameraStartPushViewController"];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.pushscreen") controllerClassName:@"ScreenPushViewController"];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.Standardlivebroadcast") controllerClassName:@"PlayViewController"];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.lebLauncher.title") controllerClassName:@"LebLauncherViewController"];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"V2.Live.LinkMicNew.coanchornew") controllerClassName:@"V2MainViewController"];
        [subCells addObject:subCellInfo];
        
        subCells;
    });
}
#endif

#ifdef PLAYER
- (void)createPlayerCellInfos {
    _cellInfos = [NSMutableArray array];
    CellInfo *cellInfo = nil;
    cellInfo = [[CellInfo alloc] init];
    cellInfo.title = V2Localize(@"MLVB.MainMenu.Player");
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray array];
        CellInfo *subCellInfo;
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.SuperPlayer") controllerClassName:@"MoviePlayerViewController"];
        [subCells addObject:subCellInfo];
        subCells;
    });
}
#endif

#ifdef SMART
- (void)createSmartCellInfos {
    _cellInfos = [NSMutableArray array];
    CellInfo *cellInfo = nil;
    
    cellInfo = [[CellInfo alloc] init];
    cellInfo.title = V2Localize(@"V2.Live.LinkMicNew.title");
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray array];
        CellInfo *subCellInfo;
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.pushcamera") controllerClassName:@"CameraStartPushViewController"];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.Standardlivebroadcast") controllerClassName:@"PlayViewController"];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.coanchoringold") controllerClassName:@"LiveRoomListViewController"];
        [subCells addObject:subCellInfo];

        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.LVBLite") actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:XiaoZhiBoAppStoreURLString]];
        }];
        [subCells addObject:subCellInfo];
       
        subCells;
    });
}

#endif

#ifdef TRTC
- (void)createTRTCCellInfos {
    _cellInfos = [NSMutableArray array];
    CellInfo *cellInfo = nil;
    
    cellInfo = [[CellInfo alloc] init];
    cellInfo.title = V2Localize(@"TRTC.MainMenu.trtc");
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray array];
        CellInfo *subCellInfo;
        
        subCellInfo = [CellInfo cellInfoWithTitle:TRTCLocalize(@"Demo.TRTC.Live.trtcSpeedTest") controllerCreationBlock:^UIViewController * _Nonnull{
            TRTCSpeedTestViewController* speedTestVC = [[TRTCSpeedTestViewController alloc] init];
            speedTestVC.title = TRTCLocalize(@"Demo.TRTC.Live.trtcSpeedTest");
            return speedTestVC;
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:TRTCLocalize(@"Demo.TRTC.Live.trtcLive") controllerCreationBlock:^UIViewController * _Nonnull{
            TRTCLiveEnterViewController* entranceVC = [[TRTCLiveEnterViewController alloc] init];
            entranceVC.title = TRTCLocalize(@"Demo.TRTC.Live.trtcLive");
            return entranceVC;
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo =  [CellInfo cellInfoWithTitle:TRTCLocalize(@"Demo.TRTC.Live.trtcCalling") controllerCreationBlock:^UIViewController * _Nonnull{
            TRTCCallingEnterViewController* entranceVC = [[TRTCCallingEnterViewController alloc] init];
            entranceVC.title = TRTCLocalize(@"Demo.TRTC.Live.trtcCalling");
            return entranceVC;
        }];
        [subCells addObject:subCellInfo];
        
        subCells;
    });
}
#endif

#ifdef UGC
- (void)createUGCCellInfos {
    _cellInfos = [NSMutableArray array];
    CellInfo *cellInfo = nil;
    
    __weak __typeof(self)weakSelf = self;
    cellInfo = [[CellInfo alloc] init];
    cellInfo.title = V2Localize(@"MLVB.MainMenu.UGSV");
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray array];
        CellInfo *subCellInfo;
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.Shooting") actionBlock:^{
            [weakSelf.ugcRecordWrapper showRecordEntryController];
        }];
        [subCells addObject:subCellInfo];

        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.SpecialEffects") actionBlock:^{
            [weakSelf.ugcEditWrapper showEditEntryControllerWithType:UGCKitMediaTypeVideo];
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.VideoSplicing") actionBlock:^{
            [weakSelf.ugcJoinWrapper showVideoJoinEntryController];
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.ImageTransition") actionBlock:^{
            [weakSelf.ugcEditWrapper showEditEntryControllerWithType:UGCKitMediaTypePhoto];
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.VideoUpload") actionBlock:^{
            [weakSelf.ugcUploadWrapper showVideoUploadEntryController];
        }];
        [subCells addObject:subCellInfo];
        
        subCellInfo = [CellInfo cellInfoWithTitle:V2Localize(@"MLVB.MainMenu.UGSVApp") actionBlock:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:XiaoShiPinAppStoreURLString]];
        }];
        [subCells addObject:subCellInfo];
        
        subCells;
    });
}
#endif



- (void)initUI {
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
    lbHeadLine.text = V2Localize(@"V2.Live.LinkMicNew.txvideoremote");
#if defined(ENTERPRISE) || defined(PROFESSIONAL)
    UITapGestureRecognizer *tapFive = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDebugAction)];
    tapFive.numberOfTapsRequired = 5;
    [lbHeadLine addGestureRecognizer:tapFive];
#endif
    
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
    
    // 用户个人信息按钮
    UIButton* userInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userInfoButton.frame = CGRectMake(20, 0, 32, 32);
    CGPoint center = userInfoButton.center;
    center.y = lbHeadLine.center.y;
    userInfoButton.center = center;
    [userInfoButton setImage:[UIImage imageNamed:@"ic_logout"] forState:UIControlStateNormal];
    [userInfoButton addTarget:self action:@selector(userInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
#if !defined(UGC) && !defined(PLAYER)
    [self.view addSubview:userInfoButton];
#endif
    
    
    //副标题
    UILabel* lbSubHead = [[UILabel alloc] initWithFrame:CGRectMake(originX, lbHeadLine.frame.origin.y + lbHeadLine.frame.size.height + 15, width, 30)];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
#ifdef LIVE
    NSString *sdkVersion = [V2TXLivePremier getSDKVersionStr];
#else
    NSString *sdkVersion = [TXLiveBase getSDKVersionStr];
#endif
    
    lbSubHead.text = [NSString stringWithFormat:@"%@ v%@(%@)", V2Localize(@"V2.Live.LinkMicNew.txtoolpkg"), sdkVersion, version];
    lbSubHead.text = [lbSubHead.text stringByAppendingFormat:@"\n%@", V2Localize(@"V2.Live.LinkMicNew.appusetoshowfunc")];
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
    [uploadButton setTitle:AppPortalLocalize(@"App.PortalViewController.sharelog") forState:UIControlStateNormal];
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

#if defined(ENTERPRISE) || defined(PROFESSIONAL)
- (void)tapDebugAction {
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    int debugSwitch = [TCUtil getDEBUGSwitch];
    if (debugSwitch) {
        hud.label.text = @"DEBUG模式已关";
    } else {
        hud.label.text = @"DEBUG模式已开";
    }
    [TCUtil changeDEBUGSwitch];
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:2];
    
    [_cellInfos removeAllObjects];
    self.addNewCellInfos = nil;
    [self createEnterpriseCellInfos];
    [self.tableView reloadData];
}
#endif

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

@end
