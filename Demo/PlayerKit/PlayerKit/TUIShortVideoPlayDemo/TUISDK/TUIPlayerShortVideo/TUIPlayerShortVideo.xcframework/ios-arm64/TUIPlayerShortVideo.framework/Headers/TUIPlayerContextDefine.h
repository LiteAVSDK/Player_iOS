//  Copyright © 2024 Tencent. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * const TUIPlayerContext;

// 播放器进度,仅对点播有效,对应 @(NSTimeInterval)
FOUNDATION_EXPORT TUIPlayerContext TUIPlayerPlayBackTime;

NS_ASSUME_NONNULL_END
