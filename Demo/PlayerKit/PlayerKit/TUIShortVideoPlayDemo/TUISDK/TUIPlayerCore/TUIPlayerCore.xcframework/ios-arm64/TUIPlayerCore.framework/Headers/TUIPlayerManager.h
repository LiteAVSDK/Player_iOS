// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import "TUIPlayerVideoModel.h"
#import "TUITXVodPlayerWrapper.h"
#import "TUIPlayerStrategyManager.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TUIPlayerManagerDelegate <NSObject>

/**
 * 预加载代理方法
 * @param videoModel 视频数据模型
 */
- (void)videoPreLoadStateWithModel:(TUIPlayerVideoModel *)videoModel;

@end
/// 播放器缓存管理
@interface TUIPlayerManager : NSObject

@property (nonatomic, weak)id <TUIPlayerManagerDelegate>delegate; ///代理

///视频播放设置策略管理
@property (nonatomic, strong) TUIPlayerStrategyManager *strategyManager;

/**
 *  添加视频数据模型
 *
 *  @discussion  添加视频数据模型
 *  @param  videoModels  视频数据模型
 */
- (void)setPlayerModels:(NSArray<TUIPlayerVideoModel *> *)videoModels;

/**
 *  添加视频数据模型
 *
 *  @discussion  添加视频数据模型
 *  @param  videoModels  视频数据模型
 */
- (void)appendPlayerModels:(NSArray<TUIPlayerVideoModel *> *)videoModels;
/**
 *   移除视频数据模型
 *
 *  @discussion  移除视频数据模型
 *  @param  videoModels  视频数据模型
 */
- (void)removePlayerModels:(NSArray<TUIPlayerVideoModel *> *)videoModels;

/**
 *  设置正在播放的数据模型
 *
 *  @discussion  设置正在播放的数据模型
 *  @param playingModel  当前播放的视频模型
 */
- (void)setCurrentPlayingModel:(TUIPlayerVideoModel *)playingModel;

/**
 * 取消预加载任务
 * @param  videoModel  视频数据模型
 */
- (BOOL)cancelPreLoadOperationWith:(TUIPlayerVideoModel *)videoModel;

/**
 * 重新从当前索引开始预加载
 * 应用场景：用户中途切换了分辨率等
 */
- (void)resetPreloadList;

/**
 * 暂停预加载
 */
- (void)pausePreload;

/**
 * 恢复预加载
 */
- (void)resumePreload;
@end

NS_ASSUME_NONNULL_END
