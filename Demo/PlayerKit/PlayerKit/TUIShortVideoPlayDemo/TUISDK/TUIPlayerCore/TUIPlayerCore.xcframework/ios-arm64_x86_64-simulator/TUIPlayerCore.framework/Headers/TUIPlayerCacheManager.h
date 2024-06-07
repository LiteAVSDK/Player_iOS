// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import "TUITXVodPlayerWrapper.h"
#import "TUIPlayerVideoModel.h"
#import "TUIPlayerStrategyManager.h"
NS_ASSUME_NONNULL_BEGIN
/// 播放器预加载缓存管理
@interface TUIPlayerCacheManager : NSObject

///视频播放设置策略管理
@property (nonatomic, strong) TUIPlayerStrategyManager *strategyManager;
/**
 * 获取播放器
 * @param model 视频模型
 * @rerurn 播放器
 */
- (TUITXVodPlayer *)getTUIVideoPlayerWithModel:(TUIPlayerVideoModel *)model;

/**
 * 更新播放器缓存
 * @param model 视频模型
 */
- (void)updatePlayerCache:(TUIPlayerVideoModel *)model;

/**
 * 移除播放器缓存
 */
- (void)removeAllCache;

@end

NS_ASSUME_NONNULL_END
