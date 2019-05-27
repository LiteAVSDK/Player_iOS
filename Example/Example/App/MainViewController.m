//
//  AppDelegate.m
//  Example
//
//  Created by annidyfeng on 2018/9/11.
//  Copyright © 2018年 annidy. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import <SuperPlayer/SuperPlayer.h>
#import <MMLayout/UIView+MMLayout.h>
#import "TXWeiboListViewController.h"
#import "ViewController.h"
#import "DownloadTableViewController.h"

#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height


@interface MainViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDataSource,
UIPickerViewDelegate,
UIAlertViewDelegate
>

@property (nonatomic) NSMutableArray<CellInfo*>* cellInfos;
@property (nonatomic) NSArray<CellInfo*>* addNewCellInfos;
@property (nonatomic) MainTableViewCell *selectedCell;
@property (nonatomic) UITableView* tableView;
@property (nonatomic) UIView*   logUploadView;
@property (nonatomic) UIPickerView* logPickerView;
@property (nonatomic) NSMutableArray* logFilesArray;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCellInfos];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)initCellInfos
{
    _cellInfos = [NSMutableArray new];
    CellInfo* cellInfo = nil;
    

    cellInfo = [CellInfo new];
    cellInfo.title = @"播放器";
    cellInfo.iconName = @"composite";
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray new];
        CellInfo* scellInfo;
        scellInfo = [CellInfo new];
        scellInfo.title = @"超级播放器";
        scellInfo.navigateToController = @"MoviePlayerViewController";
        [subCells addObject:scellInfo];
        
        
        scellInfo = [CellInfo new];
        scellInfo.title = @"列表播放";
        scellInfo.navigateToController = @"TXWeiboListViewController";
        [subCells addObject:scellInfo];
        
//        scellInfo = [CellInfo new];
//        scellInfo.title = @"全屏模式";
//        scellInfo.navigateToController = @"ViewController";
//        [subCells addObject:scellInfo];
        
        scellInfo = [CellInfo new];
        scellInfo.title = @"展示模式";
        scellInfo.navigateToController = @"SimpleMovieController";
        [subCells addObject:scellInfo];
        
        scellInfo = [CellInfo new];
        scellInfo.title = @"DRM";
        scellInfo.navigateToController = @"DrmPlayViewController";
        [subCells addObject:scellInfo];
        
        scellInfo = [CellInfo new];
        scellInfo.title = @"循环播放";
        scellInfo.navigateToController = @"LoopPlayViewController";
        [subCells addObject:scellInfo];
        
        subCells;
    
    });
    
    cellInfo = [CellInfo new];
    cellInfo.title = @"其他功能";
    cellInfo.iconName = @"composite";
    [_cellInfos addObject:cellInfo];
    cellInfo.subCells = ({
        NSMutableArray *subCells = [NSMutableArray new];
        CellInfo* scellInfo;
        scellInfo = [CellInfo new];
        scellInfo.title = @"HLS下载";
        scellInfo.navigateToController = @"DownloadTableViewController";
        [subCells addObject:scellInfo];
        
        subCells;
        
    });
}

- (void)initUI
{
    int originX = 15;
    CGFloat width = self.view.frame.size.width - 2 * originX;
    
    self.view.backgroundColor = RGBA(0x0d,0x0d,0x0d,1);
    
    //大标题
    UILabel* lbHeadLine = [[UILabel alloc] initWithFrame:CGRectMake(originX, 50, width, 48)];
    lbHeadLine.text = @"超级播放器";
    lbHeadLine.textColor = RGBA(0xff, 0xff, 0xff, 1);
    lbHeadLine.font = [UIFont systemFontOfSize:24];
    [lbHeadLine sizeToFit];
    [self.view addSubview:lbHeadLine];
    lbHeadLine.mm_center().mm_top(50);
    
    lbHeadLine.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [lbHeadLine addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer* pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)]; //提取SDK日志暗号!
    pressGesture.minimumPressDuration = 2.0;
    pressGesture.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:pressGesture];
    
    
    //副标题
    UILabel* lbSubHead = [[UILabel alloc] initWithFrame:CGRectMake(originX, lbHeadLine.frame.origin.y + lbHeadLine.frame.size.height + 15, width, 30)];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    lbSubHead.text = [NSString stringWithFormat:@"超级播放器 v%@", version];
    lbSubHead.text = [lbSubHead.text stringByAppendingString:@"\n本APP用于展示腾讯视频云终端产品的各类功能"];
    lbSubHead.numberOfLines = 2;
    lbSubHead.textColor = UIColor.grayColor;
    lbSubHead.textAlignment = NSTextAlignmentCenter;
    lbSubHead.font = [UIFont systemFontOfSize:14];
    lbSubHead.textColor = RGBA(0x53, 0x53, 0x53, 1);
    
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
    lbSubHead.mm_bottom(34).mm__centerX(self.view.mm_centerX);
    
    
    //功能列表
    int tableviewY = lbSubHead.frame.origin.y + lbSubHead.frame.size.height + 30;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(originX, tableviewY, width, self.view.frame.size.height - tableviewY)];
    _tableView.backgroundColor = UIColor.clearColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.mm_top(lbHeadLine.mm_maxY+12).mm_flexToBottom(0);
    
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
    
    if ([cellInfo.navigateToController isEqualToString:@"ViewController"]) {
        ViewController *c = [[ViewController alloc] init];
        [self.view addSubview:c.view];
        [self addChildViewController:c];
    } else {
        NSString* controllerClassName = cellInfo.navigateToController;
        Class controllerClass = NSClassFromString(controllerClassName);
        id controller = [[controllerClass alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
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


- (void)handleLongPress:(UILongPressGestureRecognizer *)pressRecognizer
{
    if (pressRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long Press");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *logDoc = [NSString stringWithFormat:@"%@%@", paths[0], @"/log"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray* fileArray = [fileManager contentsOfDirectoryAtPath:logDoc error:nil];
        self.logFilesArray = [NSMutableArray new];
        for (NSString* logName in fileArray) {
            if ([logName hasSuffix:@"xlog"]) {
                [self.logFilesArray addObject:logName];
            }
        }
        
        _logUploadView.alpha = 0.1;
        [UIView animateWithDuration:0.5 animations:^{
            _logUploadView.hidden = NO;
            _logUploadView.alpha = 1;
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
        [self presentViewController:activityView animated:YES completion:^{
            _logUploadView.hidden = YES;
        }];
    }
}

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
