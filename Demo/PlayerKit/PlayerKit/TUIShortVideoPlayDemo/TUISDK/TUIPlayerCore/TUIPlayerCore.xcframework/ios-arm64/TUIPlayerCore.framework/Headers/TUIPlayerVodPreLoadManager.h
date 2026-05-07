// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import "TUIPlayerDataModel.h"
#import "TUIPlayerVideoModel.h"
#import "TUITXVodPlayer.h"
#import "TUIPlayerVodStrategyManager.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TUIPlayerVodPreLoadManagerDelegate <NSObject>

/**
 * 预加载代理方法
 * @param videoModel 视频数据模型
 */
- (void)videoPreLoadStateWithModel:(TUIPlayerVideoModel *)videoModel;

@end
///播放器缓存管理
@interface TUIPlayerVodPreLoadManager : NSObject

@property (nonatomic, weak)id <TUIPlayerVodPreLoadManagerDelegate>delegate; ///代理

///视频播放设置策略管理
@property (nonatomic, strong) TUIPlayerVodStrategyManager *strategyManager;

/**
 *  添加视频数据模型
 *
 *  @discussion  添加视频数据模型
 *  @param  videoModels  视频数据模型
 */
- (void)setPlayerModels:(NSArray<TUIPlayerDataModel *> *)videoModels;

/**
 *  添加视频数据模型
 *
 *  @discussion  添加视频数据模型
 *  @param  videoModels  视频数据模型
 */
- (void)appendPlayerModels:(NSArray<TUIPlayerDataModel *> *)videoModels;
/**
 *   移除视频数据模型
 *
 *  @discussion  移除视频数据模型
 *  @param  videoModels  视频数据模型
 */
- (void)removePlayerModels:(NSArray<TUIPlayerDataModel *> *)videoModels;

/**
 *  插入视频数据模型：从index开始插入一组数据
 *
 *  @discussion  插入视频数据模型
 *  @param  videoModels  视频数据模型
 *  @param  index  插入的位置
 */

- (void)insertVideoModels:(NSArray<TUIPlayerDataModel *> *)videoModels atIndex:(NSInteger)index;

/**
 *  替换视频数据模型：从index开始替换一组数据
 *
 *  @discussion  替换视频数据模型
 *  @param  videoModels  视频数据模型
 *  @param  index  替换的位置
 */
- (void)replaceVideoModels:(NSArray<TUIPlayerDataModel *> *)videoModels fromIndex:(NSInteger)index;


/**
 *  设置正在播放的数据模型
 *
 *  @discussion  设置正在播放的数据模型
 *  @param playingModel  当前播放的视频模型
 */
- (void)setCurrentPlayingModel:(TUIPlayerDataModel *)playingModel;

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
