// Copyright (c) 2024 Tencent. All rights reserved.

#import "TUIPlayerVideoModel.h"
#import "TUIPlayerVideoPreloadState.h"
NS_ASSUME_NONNULL_BEGIN

@interface TUIPlayerVideoModel (PreloadState)
/**
 * 设置预下载状态
 */
- (void)updateState:(TUIPlayerVideoPreloadState)state resolution:(long)resolution;
@end

NS_ASSUME_NONNULL_END
