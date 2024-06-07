//
//  DownloadCallback.h
//  Pods
//
//  Created by 路鹏 on 2022/3/15.
//  Copyright © 2022年 Tencent. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TXVodDownloadMediaInfo;

typedef NS_ENUM(NSInteger, VodDownloadState) {
    VodDownloadStateStart = 0,
    VodDownloadStateProgress = 1,
    VodDownloadStateStop = 2,
    VodDownloadStateFinish = 3,
};

typedef void (^onDownloadSuccess)(TXVodDownloadMediaInfo *mediaInfo, VodDownloadState state);
typedef void (^onDownloadError)(TXVodDownloadMediaInfo *mediaInfo, NSInteger errCode, NSString *errorMsg);

@interface DownloadCallback : NSObject

@property (nonatomic, copy) onDownloadSuccess downloadSuccess;

@property (nonatomic, copy) onDownloadError downloadError;

@end

NS_ASSUME_NONNULL_END
