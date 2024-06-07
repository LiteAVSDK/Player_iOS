//
//  DownloadViewController.m
//  TXLiteAVDemo_Enterprise
//
//  Created by annidyfeng on 2018/3/20.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "DownloadViewController.h"

#import "AppLocalized.h"
#import "TXVodDownloadManager.h"
#import "PlayerKitCommonHeaders.h"

@interface DownloadViewController () <TXVodDownloadDelegate>

@end

@implementation DownloadViewController {
    TXVodDownloadManager *  _manager;
    TXVodDownloadMediaInfo *_media;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_manager == nil) {
        _manager = [TXVodDownloadManager shareInstance];
        [_manager setDownloadPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/downloader"]];
    }
    _manager.delegate = self;

    //    _media = [_manager startDownloadUrl:@"http://1253131631.vod2.myqcloud.com/26f327f9vodgzp1253131631/f4bdff799031868222924043041/playlist.m3u8"];

    TXVodDownloadDataSource *dataSource = [TXVodDownloadDataSource new];
    dataSource.quality                  = TXVodQualityHD;
    dataSource.auth                     = ({
        TXPlayerAuthParams *auth = [TXPlayerAuthParams new];
        auth.appId               = 1252463788;
        auth.fileId              = @"4564972819220421305";
        auth;
    });
    //    _media = [_manager startDownload:dataSource];
    // TODO 原先一个入参，现修改为三个参数 by kakaayang
    _media = [_manager startDownloadUrl:
                           @"http://1251316161.vod2.myqcloud.com/45af1a62vodtransgzp1251316161/bdc8878d4564972819204191691/"
                           @"voddrm.token.dWluPTMzNzUxODE2Nzt0ZXJtX2lkPTEyMzQ1Njc4OTtwc2t5PWNYUHVYWkdpUWxub0hEemFTakt3VjJHcktEVW9nTzVRbi1JT3YqWVdESWdfZXh0PW51bGw.v.f12647.m3u8" resolution:-1 userName: nil];

    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [b1 setTitle:LivePlayerLocalize(@"SuperPlayerDemo.DownloadView.deletetask") forState:UIControlStateNormal];
    [b1 sizeToFit];
    [b1 addTarget:self action:@selector(deleteDownloadFile:) forControlEvents:UIControlEventTouchUpInside];
    b1.m_top(40).m_left(20);
    [self.view addSubview:b1];

    UIButton *b2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [b2 setTitle:LivePlayerLocalize(@"SuperPlayerDemo.DownloadView.stoptask") forState:UIControlStateNormal];
    [b2 sizeToFit];
    [b2 addTarget:self action:@selector(stopDownloadFile:) forControlEvents:UIControlEventTouchUpInside];
    b2.m_top(40).m_left(90);
    [self.view addSubview:b2];
}

- (void)deleteDownloadFile:(id)sender {
    [_manager deleteDownloadFile:_media.playPath];
}

- (void)stopDownloadFile:(id)sender {
    [_manager stopDownload:_media];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onDownloadStart:(TXVodDownloadMediaInfo *)mediaInfo;
{}
- (void)onDownloadProgress:(TXVodDownloadMediaInfo *)mediaInfo;
{ LocalizeReplace(LivePlayerLocalize(@"SuperPlayerDemo.DownloadView.progressxxspeedyy"), [NSString stringWithFormat:@"%f", mediaInfo.progress], [NSString stringWithFormat:@"%d", mediaInfo.speed]); }
- (void)onDownloadStop:(TXVodDownloadMediaInfo *)mediaInfo;
{}
- (void)onDownloadFinish:(TXVodDownloadMediaInfo *)mediaInfo;
{}
- (void)onDownloadError:(TXVodDownloadMediaInfo *)mediaInfo errorCode:(TXDownloadError)code errorMsg:(NSString *)msg;
{ NSLog(@"onDownloadError %@", msg); }

- (int)hlsKeyVerify:(TXVodDownloadMediaInfo *)media url:(NSString *)url data:(NSData *)data {
    return 1;
}
@end
