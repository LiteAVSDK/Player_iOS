//
//  TXPlayerCacheManager.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/24.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXVideoPlayer.h"
#import "TXVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXPlayerCacheManager : NSObject

@property (nonatomic, assign) NSInteger playerCacheCount;    // 默认3个

/// 获取单例
+ (TXPlayerCacheManager*) shareInstance;

// 获取播放器
- (TXVideoPlayer *)getVideoPlayer:(TXVideoModel *)model;

// 缓存播放器
- (void)updatePlayerCache:(NSArray *)modelArray;

// 移除所有缓存
- (void)removeAllCache;

@end

NS_ASSUME_NONNULL_END
