//
//  MainViewController.m
//  RTMPiOSDemo
//
//  Created by rushanting on 2017/4/28.
//  Copyright © 2017年 tencent. All rights reserved.
//
#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "TCUtil.h"
#import "ColorMacro.h"
#import "MainTableViewCell.h"
#import "TXLiveBase.h"
#import "AppLocalized.h"
#import "TXConfigManager.h"

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

static NSString *const XiaoZhiBoAppStoreURLString  = @"http://itunes.apple.com/cn/app/id1132521667?mt=8";
static NSString *const XiaoShiPinAppStoreURLString = @"http://itunes.apple.com/cn/app/id1374099214?mt=8";
static NSString *const trtcAppStoreURLString       = @"http://itunes.apple.com/cn/app/id1400663224?mt=8";

@interface MainViewController () <
    UITableViewDelegate,
    UITableViewDataSource,
    UIPickerViewDataSource,
    UIPickerViewDelegate,
    UIAlertViewDelegate>
@property(nonatomic) NSMutableArray<CellInfo *> *cellInfos;
@property(nonatomic) NSArray<CellInfo *> *       addNewCellInfos;
@property(nonatomic) MainTableViewCell *         selectedCell;
@property(nonatomic) UITableView *               tableView;
@property(nonatomic) UIView *                    logUploadView;
@property(nonatomic) UIPickerView *              logPickerView;
@property(nonatomic) NSMutableArray *            logFilesArray;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[TXConfigManager shareInstance] setMenuActionTarget:self];
    [self loadCellInfos];
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)loadCellInfos {
    self.cellInfos = [[TXConfigManager shareInstance] getMenuConfig];
}

- (void)updateCellInfos {
    [self.cellInfos removeAllObjects];
    self.addNewCellInfos = nil;
    [self loadCellInfos];
    [self.tableView reloadData];
}

- (IBAction)userInfoButtonClick:(id)sender {

}

- (void)initUI {
    int     originX = 15;
    CGFloat width   = self.view.frame.size.width - 2 * originX;
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

    //大标题
    UILabel *lbHeadLine = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, width, 48)];
    lbHeadLine.text     = V2Localize(@"V2.Live.LinkMicNew.txvideoremote");
    lbHeadLine.textColor = UIColorFromRGB(0xffffff);
    lbHeadLine.font      = [UIFont systemFontOfSize:24];
    [lbHeadLine sizeToFit];
    [self.view addSubview:lbHeadLine];
    lbHeadLine.center = CGPointMake(lbHeadLine.superview.center.x, lbHeadLine.center.y);

    lbHeadLine.userInteractionEnabled  = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [lbHeadLine addGestureRecognizer:tapGesture];

    UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];  //提取SDK日志暗号!
    pressGesture.minimumPressDuration          = 2.0;
    pressGesture.numberOfTouchesRequired       = 1;
    [self.view addGestureRecognizer:pressGesture];

    // 用户个人信息按钮
    UIButton *userInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    userInfoButton.frame     = CGRectMake(20, 0, 32, 32);
    CGPoint center           = userInfoButton.center;
    center.y                 = lbHeadLine.center.y;
    userInfoButton.center    = center;
    [userInfoButton setImage:[UIImage imageNamed:@"ic_logout"] forState:UIControlStateNormal];
    [userInfoButton addTarget:self action:@selector(userInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //副标题
    UILabel * lbSubHead = [[UILabel alloc] initWithFrame:CGRectMake(originX, lbHeadLine.frame.origin.y + lbHeadLine.frame.size.height + 15, width, 30)];
    NSString *version   = [TXAppInfo appVersionWithBuild];
    NSString *sdkVersion = [TXLiveBase getSDKVersionStr];

    lbSubHead.text          = [NSString stringWithFormat:@"%@ v%@(%@)", V2Localize(@"V2.Live.LinkMicNew.txtoolpkg"), sdkVersion, version];
    lbSubHead.text          = [lbSubHead.text stringByAppendingFormat:@"\n%@", V2Localize(@"V2.Live.LinkMicNew.appusetoshowfunc")];
    lbSubHead.numberOfLines = 2;
    lbSubHead.textColor     = UIColor.grayColor;
    lbSubHead.textAlignment = NSTextAlignmentCenter;
    lbSubHead.font          = [UIFont systemFontOfSize:14];
    lbSubHead.textColor     = UIColorFromRGB(0x535353);

    //行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lbSubHead.text];
    NSMutableParagraphStyle *  paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment                    = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:7.5f];  //设置行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, lbSubHead.text.length)];
    lbSubHead.attributedText = attributedString;

    [lbSubHead sizeToFit];

    [self.view addSubview:lbSubHead];
    lbSubHead.userInteractionEnabled = YES;
    [lbSubHead addGestureRecognizer:tapGesture];
    lbSubHead.frame  = CGRectMake(lbSubHead.frame.origin.x, self.view.frame.size.height - lbSubHead.frame.size.height - 34, lbSubHead.frame.size.width, lbSubHead.frame.size.height);
    lbSubHead.center = CGPointMake(lbSubHead.superview.frame.size.width / 2, lbSubHead.center.y);

    //功能列表
    int tableviewY             = lbSubHead.frame.origin.y + lbSubHead.frame.size.height + 12;
    int bottomHeight           = lbSubHead.frame.size.height + 34;
    _tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(originX, tableviewY, width, self.view.frame.size.height - tableviewY - bottomHeight)];
    _tableView.backgroundColor = UIColor.clearColor;
    _tableView.delegate        = self;
    _tableView.dataSource      = self;

    [self.view addSubview:_tableView];
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, lbHeadLine.frame.origin.y + lbHeadLine.frame.size.height + 12, _tableView.frame.size.width, _tableView.superview.frame.size.height);
    _tableView.frame =
        CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.superview.frame.size.height - _tableView.frame.origin.y - bottomHeight - 20);

    UIView *view         = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _logUploadView                 = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2, self.view.bounds.size.width, self.view.bounds.size.height / 2)];
    _logUploadView.backgroundColor = [UIColor whiteColor];
    _logUploadView.hidden          = YES;

    _logPickerView            = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _logUploadView.frame.size.height * 0.8)];
    _logPickerView.dataSource = self;
    _logPickerView.delegate   = self;
    [_logUploadView addSubview:_logPickerView];

    UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    uploadButton.center    = CGPointMake(self.view.bounds.size.width / 2, _logUploadView.frame.size.height * 0.9);
    uploadButton.bounds    = CGRectMake(0, 0, self.view.bounds.size.width / 3, _logUploadView.frame.size.height * 0.2);
    [uploadButton setTitle:AppPortalLocalize(@"App.PortalViewController.sharelog") forState:UIControlStateNormal];
    [uploadButton addTarget:self action:@selector(onSharedUploadLog:) forControlEvents:UIControlEventTouchUpInside];
    [_logUploadView addSubview:uploadButton];

    [self.view addSubview:_logUploadView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellInfos.count < indexPath.row) return nil;

    static NSString *  cellIdentifier = @"MainViewCellIdentifier";
    MainTableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    CellInfo *cellInfo = _cellInfos[indexPath.row];

    [cell setCellData:cellInfo];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 ///第一次安装，网络没有授权会导致证书下载失败
    if ([TXLiveBase getLicenceInfo].length <= 0) {
        [[TXConfigManager shareInstance] setLicence];
    }
    if (!_logUploadView.hidden) {
        _logUploadView.hidden = YES;
    }

    if (_cellInfos.count < indexPath.row) return;

    MainTableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
    CellInfo *         cellInfo    = currentCell.cellData;

    if (cellInfo.subCells != nil) {
        [tableView beginUpdates];
        NSMutableArray *indexArray = [NSMutableArray new];
        if (self.addNewCellInfos) {
            NSUInteger deleteFrom = [_cellInfos indexOfObject:self.addNewCellInfos[0]];
            for (int i = 0; i < self.addNewCellInfos.count; i++) {
                [indexArray addObject:[NSIndexPath indexPathForRow:i + deleteFrom inSection:0]];
            }
            [tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
            [_cellInfos removeObjectsInArray:self.addNewCellInfos];
        }
        [tableView endUpdates];

        [tableView beginUpdates];
        if (!cellInfo.isUnFold) {
            self.selectedCell.highLight         = NO;
            self.selectedCell.cellData.isUnFold = NO;

            NSUInteger row = [_cellInfos indexOfObject:cellInfo] + 1;
            [indexArray removeAllObjects];
            for (int i = 0; i < cellInfo.subCells.count; i++) {
                [indexArray addObject:[NSIndexPath indexPathForRow:i + row inSection:0]];
            }
            [_cellInfos insertObjects:cellInfo.subCells atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row, cellInfo.subCells.count)]];
            [tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [tableView endUpdates];

        cellInfo.isUnFold     = !cellInfo.isUnFold;
        currentCell.highLight = cellInfo.isUnFold;
        self.selectedCell     = currentCell;
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
                [self hideSuperPlayer];
            }
            [self.navigationController pushViewController:controller animated:YES];
        }
    } else if (cellInfo.type == CellInfoTypeAction) {
        [cellInfo performAction];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellInfo *cellInfo = _cellInfos[indexPath.row];
    if (cellInfo.subCells != nil) {
        return 65;
    }
    return 51;
}

- (void)hideSuperPlayer {
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)pressRecognizer {
    if (pressRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long Press");
        NSArray *      paths       = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *     logDoc      = [NSString stringWithFormat:@"%@%@", paths[0], @"/log"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *      fileArray   = [fileManager contentsOfDirectoryAtPath:logDoc error:nil];
        fileArray                  = [fileArray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
            NSString *file1 = (NSString *)obj1;
            NSString *file2 = (NSString *)obj2;
            return [file1 compare:file2] == NSOrderedDescending;
        }];
        self.logFilesArray         = [NSMutableArray new];
        for (NSString *logName in fileArray) {
            if ([logName hasSuffix:@"xlog"] || [logName hasSuffix:@"clog"]) {
                [self.logFilesArray addObject:logName];
            }
        }

        _logUploadView.alpha  = 0.1;
        UIView *logUploadView = _logUploadView;
        [UIView animateWithDuration:0.5
                         animations:^{
                             logUploadView.hidden = NO;
                             logUploadView.alpha  = 1;
                         }];
        [_logPickerView reloadAllComponents];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer {
    if (!_logUploadView.hidden) {
        _logUploadView.hidden = YES;
    }
}

- (void)onSharedUploadLog:(UIButton *)sender {
    NSInteger row = [_logPickerView selectedRowInComponent:0];
    if (row < self.logFilesArray.count) {
        NSArray *                 paths         = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *                logDoc        = [NSString stringWithFormat:@"%@%@", paths[0], @"/log"];
        NSString *                logPath       = [logDoc stringByAppendingPathComponent:self.logFilesArray[row]];
        NSURL *                   shareobj      = [NSURL fileURLWithPath:logPath];
        UIActivityViewController *activityView  = [[UIActivityViewController alloc] initWithActivityItems:@[ shareobj ] applicationActivities:nil];
        UIView *                  logUploadView = _logUploadView;
        [self presentViewController:activityView
                           animated:YES
                         completion:^{
                             logUploadView.hidden = YES;
                         }];
    }
}
#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.logFilesArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row < self.logFilesArray.count) {
        return (NSString *)self.logFilesArray[row];
    }

    return nil;
}

- (void)showXiaoZhiBoAppStore {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:XiaoZhiBoAppStoreURLString]];
}

- (void)showXiaoShiPinAppStore {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:XiaoShiPinAppStoreURLString]];
}

- (void)showTrtcAppStore {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trtcAppStoreURLString]];
}

#pragma mark -WeChatTools
-(void)pushWeChatTools:(NSString *)controllerType {
}

- (void)showWeChatToolsRtmpRoom {
    [self pushWeChatTools:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)]];
}

- (void)showWeChatToolsTrtcRoom {
    [self pushWeChatTools:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)]];
}

- (void)showWeChatToolsTrtc {
    [self pushWeChatTools:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)]];
}

- (void)showWeChatToolsRtmp {
    [self pushWeChatTools:[NSString stringWithFormat:@"%@",NSStringFromSelector(_cmd)]];
}
@end
