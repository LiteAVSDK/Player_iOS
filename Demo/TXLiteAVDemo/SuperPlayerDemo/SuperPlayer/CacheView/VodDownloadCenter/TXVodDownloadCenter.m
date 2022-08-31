//
//  TXVodDownloadCenter.m
//  Pods
//
//  Created by 路鹏 on 2022/3/15.
//  Copyright © 2022年 Tencent. All rights reserved.

#import "TXVodDownloadCenter.h"
#import "TXVodDownloadManager.h"

@interface TXVodDownloadCenter()<TXVodDownloadDelegate>

@property (nonatomic, strong) TXVodDownloadManager *manager;

@property (nonatomic, strong) NSMutableDictionary *listenerDic;

@end

@implementation TXVodDownloadCenter

#pragma mark - Public Method
+ (TXVodDownloadCenter *)sharedInstance {
    static TXVodDownloadCenter *downloadCenterSharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        downloadCenterSharedInstance = [[self alloc] init];
    });
    return downloadCenterSharedInstance;
}

// 注意：该"init"每次运行只启动一次，注意不要将重复调用的方法写在里面
- (id)init {
    self = [super init];
    if (self) {
        self.listenerDic = [NSMutableDictionary dictionary];
        self.manager = [TXVodDownloadManager shareInstance];
        self.manager.delegate = self;
    }
    return self;
}

- (void)registerListener:(DownloadCallback *)callback info:(TXVodDownloadMediaInfo *)mediaInfo {
    [self.listenerDic setObject:callback forKey:mediaInfo.playPath];
}

- (void)unRegisterListener:(TXVodDownloadMediaInfo *)mediaInfo {
    [self.listenerDic removeObjectForKey:mediaInfo.playPath];
}

- (void)deleteAllListener {
    [self.listenerDic removeAllObjects];
}

- (void)startDownload:(TXVodDownloadMediaInfo *)mediaInfo {
    [self.manager startDownload:mediaInfo.dataSource];
}

- (void)stopDownload:(TXVodDownloadMediaInfo *)mediaInfo {
    [self.manager stopDownload:mediaInfo];
}

- (void)setDownloadPath:(NSString *)path {
    [self.manager setDownloadPath:path];
}

- (TXVodDownloadMediaInfo *)getDownloadMediaInfo:(TXVodDownloadMediaInfo *)info {
    return [self.manager getDownloadMediaInfo:info];
}

#pragma mark - TXVodDownloadDelegate
/// 下载开始
- (void)onDownloadStart:(TXVodDownloadMediaInfo *)mediaInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCenterDownloadStart:)]) {
        [self.delegate onCenterDownloadStart:mediaInfo];
    }
    
    [self.listenerDic enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, DownloadCallback  *_Nonnull callback, BOOL * _Nonnull stop) {
        if ([mediaInfo.playPath isEqualToString:key]) {
            callback.downloadSuccess(mediaInfo, 0);
        }
    }];
}
/// 下载进度
- (void)onDownloadProgress:(TXVodDownloadMediaInfo *)mediaInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCenterDownloadProgress:)]) {
        [self.delegate onCenterDownloadProgress:mediaInfo];
    }
    
    [self.listenerDic enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, DownloadCallback  *_Nonnull callback, BOOL * _Nonnull stop) {
        if ([mediaInfo.playPath isEqualToString:key]) {
            callback.downloadSuccess(mediaInfo, 1);
        }
    }];
}
/// 下载停止
- (void)onDownloadStop:(TXVodDownloadMediaInfo *)mediaInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCenterDownloadStop:)]) {
        [self.delegate onCenterDownloadStop:mediaInfo];
    }
    
    [self.listenerDic enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, DownloadCallback  *_Nonnull callback, BOOL * _Nonnull stop) {
        if ([mediaInfo.playPath isEqualToString:key]) {
            callback.downloadSuccess(mediaInfo, 2);
        }
    }];
}
/// 下载完成
- (void)onDownloadFinish:(TXVodDownloadMediaInfo *)mediaInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCenterDownloadFinish:)]) {
        [self.delegate onCenterDownloadFinish:mediaInfo];
    }
    
    [self.listenerDic enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, DownloadCallback  *_Nonnull callback, BOOL * _Nonnull stop) {
        if ([mediaInfo.playPath isEqualToString:key]) {
            callback.downloadSuccess(mediaInfo, 3);
        }
    }];
}
/// 下载错误
- (void)onDownloadError:(TXVodDownloadMediaInfo *)mediaInfo errorCode:(TXDownloadError)code errorMsg:(NSString *)msg {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onDownloadError:errorCode:errorMsg:)]) {
        [self.delegate onCenterDownloadError:mediaInfo errorCode:code errorMsg:msg];
    }
    
    [self.listenerDic enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, DownloadCallback  *_Nonnull callback, BOOL * _Nonnull stop) {
        if ([mediaInfo.playPath isEqualToString:key]) {
            callback.downloadError(mediaInfo, code, msg);
        }
    }];
}

- (int)hlsKeyVerify:(TXVodDownloadMediaInfo *)mediaInfo url:(NSString *)url data:(NSData *)data {
    return 0;
}

@end
