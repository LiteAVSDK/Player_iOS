// Copyright (c) 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 视频文件预下载的状态
typedef NS_ENUM(NSUInteger, TUIPlayerVideoPreloadState) {
    TUIPlayerVideoPreloadStateNone     = 0,  // None
    TUIPlayerVideoPreloadStateStart    = 1 , // 开始预下载
    TUIPlayerVideoPreloadStateFinished = 2 , // 预下载成功
    TUIPlayerVideoPreloadStateFailed   = 3 , // 预下载失败
};


NS_ASSUME_NONNULL_END
