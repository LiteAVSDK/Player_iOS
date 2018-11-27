//
//  DownloadTableViewController.m
//  Example
//
//  Created by annidy on 2018/11/22.
//  Copyright © 2018年 annidy. All rights reserved.
//

#import "DownloadTableViewController.h"
#import "SuperPlayer.h"
#import "ScanQRController.h"
#import "ViewController.h"

static NSMutableDictionary<NSString *, TXVodDownloadMediaInfo *> *allDownloadInfo;
static NSMutableDictionary<NSString *, NSString *> *allDownloadMsg;
static NSMutableArray<NSString *> *allDownloadUrls;

@interface DownloadTableViewController ()<ScanQRDelegate, TXVodDownloadDelegate>

@end

@implementation DownloadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.editButtonItem.title = @"添加任务";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (!allDownloadInfo) {
        allDownloadInfo = @{}.mutableCopy;
    }
    if (!allDownloadMsg) {
        allDownloadMsg = @{}.mutableCopy;
    }
    if (!allDownloadUrls) {
        allDownloadUrls = @[].mutableCopy;
    }
    
    TXVodDownloadManager *downloader = [TXVodDownloadManager shareInstance];
    [downloader setDownloadPath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/TXDownload"]];
    downloader.delegate = self;
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    ScanQRController* vc = [[ScanQRController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)onScanResult:(NSString *)result
{
    if (result) {
        if ([allDownloadUrls containsObject:result]) {
            NSLog(@"重复添加");
            return;
        }
        [allDownloadUrls addObject:result];
        allDownloadMsg[result] = @"准备下载";
        [TXVodDownloadManager.shareInstance startDownloadUrl:result];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allDownloadUrls.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Id = @"dcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:Id];
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    // Configure the cell...
    NSString *url = allDownloadUrls[indexPath.row];
    cell.textLabel.text = url;
    TXVodDownloadMediaInfo *mediaInfo = allDownloadInfo[url];
    if (mediaInfo) {
        cell.detailTextLabel.text = [self formatDetailString:mediaInfo];
    } else {
        cell.detailTextLabel.text = allDownloadMsg[cell.textLabel.text];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *url = allDownloadUrls[indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    if ([allDownloadMsg[url] isEqualToString:@"下载完成"]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            TXVodDownloadMediaInfo *info = allDownloadInfo[url];
            ViewController *vc = [[ViewController alloc] init];
            vc.url = info.playPath;
            [self.view addSubview:vc.view];
            [self addChildViewController:vc];
        }]];
    } else if (allDownloadInfo[url] == nil) {
        [alert addAction:[UIAlertAction actionWithTitle:@"恢复下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            allDownloadInfo[url] = [TXVodDownloadManager.shareInstance startDownloadUrl:url];
        }]];
    } else {
        [alert addAction:[UIAlertAction actionWithTitle:@"停止下载" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            TXVodDownloadMediaInfo *info = allDownloadInfo[url];
            if (info) {
                [TXVodDownloadManager.shareInstance stopDownload:info];
            }
            allDownloadInfo[url] = nil;
            allDownloadMsg[url] = @"正在停止";
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"删除任务" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        TXVodDownloadMediaInfo *info = allDownloadInfo[url];
        if (info) {
            [TXVodDownloadManager.shareInstance stopDownload:info];
            [TXVodDownloadManager.shareInstance deleteDownloadFile:info.playPath];
        }
        allDownloadInfo[url] = nil;
        [allDownloadUrls removeObject:url];
        [tableView reloadData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSString *)formatDetailString:(TXVodDownloadMediaInfo *)mediaInfo
{
    float speed = mediaInfo.speed;
    NSString  *px;
    speed = speed / 1024;
    if (speed < 1024) {
        px = @"K/s";
    } else {
        speed = speed / 1024;
        px = @"M/s";
    }
    
    if (mediaInfo.progress >= 1)
        return @"下载完成";
    
    return [NSString stringWithFormat:@"下载 %d %%, 速度 %.2f %@", (int)(mediaInfo.progress * 100), speed, px];
}

/// 下载开始
- (void)onDownloadStart:(TXVodDownloadMediaInfo *)mediaInfo;
{
    allDownloadMsg[mediaInfo.url] = @"下载开始";
    allDownloadInfo[mediaInfo.url] = mediaInfo;
    [self.tableView reloadData];
}
/// 下载进度
- (void)onDownloadProgress:(TXVodDownloadMediaInfo *)mediaInfo;
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[allDownloadUrls indexOfObject:mediaInfo.url] inSection:0]];
    cell.detailTextLabel.text = [self formatDetailString:mediaInfo];
}
/// 下载停止
- (void)onDownloadStop:(TXVodDownloadMediaInfo *)mediaInfo;
{
    allDownloadMsg[mediaInfo.url] = @"下载停止";
    [self.tableView reloadData];
}
/// 下载完成
- (void)onDownloadFinish:(TXVodDownloadMediaInfo *)mediaInfo;
{
    allDownloadMsg[mediaInfo.url] = @"下载完成";
    [self.tableView reloadData];
}
/// 下载错误
- (void)onDownloadError:(TXVodDownloadMediaInfo *)mediaInfo errorCode:(TXDownloadError)code errorMsg:(NSString *)msg;
{
    allDownloadMsg[mediaInfo.url] = msg;
    allDownloadInfo[mediaInfo.url] = nil;
    [self.tableView reloadData];
}
/**
 * 下载HLS，遇到加密的文件，将解密key给外部校验
 * @param mediaInfo 下载对象
 * @param url Url地址
 * @prarm data 服务器返回
 * @return 0 - 校验正确，继续下载；否则校验失败，抛出下载错误（dk获取失败）
 */
- (int)hlsKeyVerify:(TXVodDownloadMediaInfo *)mediaInfo url:(NSString *)url data:(NSData *)data;
{
    return 0;
}
@end
