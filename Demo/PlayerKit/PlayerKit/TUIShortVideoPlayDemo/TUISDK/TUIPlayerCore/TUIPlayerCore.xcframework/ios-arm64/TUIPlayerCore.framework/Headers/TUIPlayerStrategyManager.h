// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import "TUIPlayerStrategyModel.h"

NS_ASSUME_NONNULL_BEGIN
///播放策略管理
@interface TUIPlayerStrategyManager : NSObject

#pragma mark - Public
/**
 *  设置视频播放策略
 *  @brief      播放器策略管理
 *  @discussion  播放器策略管理
 */
- (void)setVideoStrategy:(TUIPlayerStrategyModel *)strategy;
/**
 *  获取策略管理器模型
 *  @brief  获取播放器策略管理器模型
 *  @discussion  播放器策略管理器模型
 *  @return  返回播放器策略管理器模型
 */
- (TUIPlayerStrategyModel *)getStrategyModel;
/**
 *  视频预下载个数
 *  @brief  获取视频预下载个数
 *  @discussion  视频预下载个数
 *  @return  返回视频预下载个数
 */
- (NSInteger)getPreloadCount;
/**
 *  预播放缓存大小
 *  @brief  获取预播放缓存大小
 *  @discussion  预播放缓存大小
 *  @return  返回预播放缓存大小
 */
- (float)getPreloadBufferSizeInMB;
/**
 *  是否支持预下载
 *  @brief  获取是否支持预下载
 *  @discussion  是否支持预下载
 *  @return  返回是否支持预下载BOOL值
 */
- (BOOL)enablePreload;
/**
 *  画面分辨率
 *  @brief  获取画面分辨率
 *  @discussion  画面分辨率
 *  @return  返回画面分辨率
 */
- (long)getPreferredResolution;
/**
 *  进度条回调时间间隔
 *  @brief  获取进度条回调时间间隔
 *  @discussion  进度条回调时间间隔
 *  @return  返回进度条回调时间间隔
 */
- (long)getProgressInterval;
/**
 *  画面填充模式
 *  @brief  获取画面填充模式
 *  @discussion  画面填充模式
 *  @return  返回画面填充模式
 */
- (TUI_Enum_Type_RenderMode)getRenderMode;
/**
 *  额外播放器策略信息
 *  @brief  额外播放器策略信息
 *  @discussion  额外播放器策略信息
 *  @return  返回额外播放器策略信息
 */
- (NSDictionary *)getExtInfoMap;
/**
 *  置媒资类型
 *  @brief  获取置媒资类型
 *  @discussion  置媒资类型
 *  @return  返回置媒资类型
 */
- (TUI_Enum_MediaType)getMediaType ;
/**
 *  是否支持自适应码率
 *  @brief  获取是否支持自适应码率
 *  @discussion  是否支持自适应码率
 *  @return  返回是否支持自适应码率BOOL值
 */
- (BOOL)getIsEnableAutoBitrate ;

/**
 * 设置手动切换的分辨率
 * @param switchResolution 分辨率
 */
- (void)setSwitchResolution:(long)switchResolution;

/**
 * 获取手动切换的分辨率
 * @return 分辨率
 */
- (long)getSwitchResolution;

/**
 * 获取最大预加载大小
 * @return 预加载大小
 */
- (float)getMaxBufferSize;

/**
 * 获取续播模式
 * @retutn 续播模式
 */
- (TUI_Enum_Type_ResumModel)getResumeModel;

/**
 *  预下载缓存大小
 *  @brief  获取预下载缓存大小
 *  @discussion  预下载缓存大小
 *  @return  返回预下载缓存大小
 */
- (float)getPreDownloadSize;
/**
 * 获取是否开启精准seek状态
 * @retutn BOOL值
 */
- (BOOL)getEnableAccurateSeek;
/**
 * 获取音量均衡值
 * @retutn float
 */
- (float)getAudioNormalization;
@end

NS_ASSUME_NONNULL_END
