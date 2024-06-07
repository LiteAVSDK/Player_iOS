//
//  TXVodDownloadCenter.h
//  Pods
//
//  Created by 路鹏 on 2022/3/15.
//  Copyright © 2022年 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import "DownloadCallback.h"
@class TXPlayerDrmBuilder;

NS_ASSUME_NONNULL_BEGIN

@class TXVodDownloadMediaInfo;

/// Download callback
/// 下载回调
@protocol TXVodDownloadCenterDelegate <NSObject>
/// Download starts
/// 下载开始
- (void)onCenterDownloadStart:(TXVodDownloadMediaInfo *)mediaInfo;
/// Download progress
/// 下载进度
- (void)onCenterDownloadProgress:(TXVodDownloadMediaInfo *)mediaInfo;
/// Download stopped
/// 下载停止
- (void)onCenterDownloadStop:(TXVodDownloadMediaInfo *)mediaInfo;
/// Download completed
/// 下载完成
- (void)onCenterDownloadFinish:(TXVodDownloadMediaInfo *)mediaInfo;
/// Download error
/// 下载错误
- (void)onCenterDownloadError:(TXVodDownloadMediaInfo *)mediaInfo errorCode:(NSInteger)code errorMsg:(NSString *)msg;

@end

@interface TXVodDownloadCenter : NSObject

@property (nonatomic, weak) id<TXVodDownloadCenterDelegate> delegate;

/// Singleton, will not be released after creation
/// 单例，创建后不会释放
+ (TXVodDownloadCenter *)sharedInstance;

- (void)registerListener:(DownloadCallback *)callback info:(TXVodDownloadMediaInfo *)mediaInfo;

- (void)unRegisterListener:(TXVodDownloadMediaInfo *)mediaInfo;

- (void)deleteAllListener;

- (void)startDownload:(TXVodDownloadMediaInfo *)mediaInfo;

- (void)startDownloadWithDRMBuilder:(TXPlayerDrmBuilder *)drmBuilder;

- (void)stopDownload:(TXVodDownloadMediaInfo *)mediaInfo;

- (void)setDownloadPath:(NSString *)path;

- (TXVodDownloadMediaInfo *)getDownloadMediaInfo:(TXVodDownloadMediaInfo *)info;

@end

NS_ASSUME_NONNULL_END
