//  Copyright © 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUIPlayerLiveStrategyModel.h"
#import "TUIPlayerCoreLiteAVSDKHeader.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TUIPlayerLiveStrategyManagerDelegate <NSObject>

- (void)configDidChange:(TUIPlayerLiveStrategyModel *)config;

@end

@interface TUIPlayerLiveStrategyManager : NSObject
@property (nonatomic, getter=isEnableLastPrePlay, readonly) BOOL enableLastPrePlay;
/**
 *  添加代理
 *  @param  delegate 代理对象
 */
- (void)addDelegate:(id<TUIPlayerLiveStrategyManagerDelegate>)delegate;
/**
 *  移除代理
 *  @param  delegate 代理对象
 */
- (void)removeDelegate:(id<TUIPlayerLiveStrategyManagerDelegate>)delegate;

/**
 *  设置直播策略
 *  @param  model 直播策略模型
 */
- (void)setLiveStratey:(TUIPlayerLiveStrategyModel *)model;
/**
 *  获取直播策略
 *  @return  直播策略模型
 */
- (TUIPlayerLiveStrategyModel *)getLiveStratey;
/**
 *  设置是否预播放上一个视频
 *  @param enableLastPrePlay 是否预播放上一个视频
 */
- (void)setEnableLastPrePlay:(BOOL)enableLastPrePlay;
/**
 *  获取是否预播放上一个视频
 *  @return  是否预播放上一个视频
 */
- (BOOL)isEnableLastPrePlay;
/**
 *  设置画面填充模式
 *  @param  mode 画面填充模式
 */
- (void)setRenderMode:(V2TXLiveFillMode)mode;
/**
 *  画面填充模式
 *  @return  返回画面填充模式
 */
- (V2TXLiveFillMode)getRenderMode;
/**
 *  设置画中画开关状态
 *  @param  enablePictureInPicture 是否开启画中画
 */
- (void)setEnablePictureInPicture:(BOOL)enablePictureInPicture;
/**
 *  画中画开关状态
 *  @return  画中画开关状态
 */
- (BOOL)enablePictureInPicture;
/**
 *  设置播放器缓存自动调整的最大时间
 *  @param  maxAutoAdjustCacheTime 播放器缓存自动调整的最大时间
 */
- (void)setMaxAutoAdjustCacheTime:(float)maxAutoAdjustCacheTime;
/**
 *  播放器缓存自动调整的最大时间
 *  @return  播放器缓存自动调整的最大时间
 */
- (float)getMaxAutoAdjustCacheTime;
/**
 *  设置播放器缓存自动调整的最小时间
 *  @param  minAutoAdjustCacheTime 播放器缓存自动调整的最小时间
 */
- (void)setMinAutoAdjustCacheTime:(float)minAutoAdjustCacheTime;
/**
 *  播放器缓存自动调整的最小时间
 *  @return  播放器缓存自动调整的最小时间
 */
- (float)getMinAutoAdjustCacheTime;

@end

NS_ASSUME_NONNULL_END
