// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import "TUIPlayerVodStrategyModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TUIPlayerVodStrategyManagerDelegate <NSObject>

- (void)configDidChange:(TUIPlayerVodStrategyModel *)config;
- (void)onSwitchResolution:(long)switchResolution;
// 超分类型变化
- (void)onSuperResolutionTypeChanges:(TUI_Enume_Type_SuperResolution)superResolution;

@end

///播放策略管理
@interface TUIPlayerVodStrategyManager : NSObject
@property (nonatomic, getter=isEnableLastPrePlay) BOOL enableLastPrePlay;

/**
 *  添加代理
 *  @param  delegate 代理对象
 */
- (void)addDelegate:(id<TUIPlayerVodStrategyManagerDelegate>)delegate;
/**
 *  移除代理
 *  @param  delegate 代理对象
 */
- (void)removeDelegate:(id<TUIPlayerVodStrategyManagerDelegate>)delegate;

/**
 *  设置视频播放策略
 *  @brief      播放器策略管理
 *  @discussion  播放器策略管理
 */
- (void)setVideoStrategy:(TUIPlayerVodStrategyModel *)strategy;
/**
 *  获取策略管理器模型
 *  @brief  获取播放器策略管理器模型
 *  @discussion  播放器策略管理器模型
 *  @return  返回播放器策略管理器模型
 */
- (TUIPlayerVodStrategyModel *)getStrategyModel;
/**
 * 设置预下载个数
 * @param preloadCount 预下载个数
 */
- (void)setPreloadCount:(NSInteger)preloadCount;
/**
 *  视频预下载个数
 *  @brief  获取视频预下载个数
 *  @discussion  视频预下载个数
 *  @return  返回视频预下载个数
 */
- (NSInteger)getPreloadCount;
/**
 * 设置预播放缓存大小
 * @param preloadBufferSizeInMB 预播放缓存大小
 */
- (void)setPreloadBufferSizeInMB:(float)preloadBufferSizeInMB ;
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
 * 设置画面分辨率
 * @param preferredResolution 画面分辨率
 */
- (void)setPreferredResolution:(long)preferredResolution;
/**
 *  画面分辨率
 *  @brief  获取画面分辨率
 *  @discussion  画面分辨率
 *  @return  返回画面分辨率
 */
- (long)getPreferredResolution;
/**
 * 设置进度条回调时间间隔
 * @param progressInterval 进度条回调时间间隔
 */
- (void)setProgressInterval:(long)progressInterval;
/**
 *  进度条回调时间间隔
 *  @brief  获取进度条回调时间间隔
 *  @discussion  进度条回调时间间隔
 *  @return  返回进度条回调时间间隔
 */
- (long)getProgressInterval;
/**
 * 设置画面填充模式
 * @param renderMode 画面填充模式
 */
- (void)setRenderMode:(TUI_Enum_Type_RenderMode)renderMode;
/**
 *  画面填充模式
 *  @brief  获取画面填充模式
 *  @discussion  画面填充模式
 *  @return  返回画面填充模式
 */
- (TUI_Enum_Type_RenderMode)getRenderMode;
/**
 * 设置额外播放器策略信息
 * @param extInfoMap 额外播放器策略信息
 */
- (void)setExtInfoMap:(NSDictionary *)extInfoMap;
/**
 *  额外播放器策略信息
 *  @brief  额外播放器策略信息
 *  @discussion  额外播放器策略信息
 *  @return  返回额外播放器策略信息
 */
- (NSDictionary *)getExtInfoMap;
/**
 * 设置媒资类型
 * @param mediaType 媒资类型
 */
- (void)setMediaType:(TUI_Enum_MediaType)mediaType;
/**
 *  媒资类型
 *  @brief  获取置媒资类型
 *  @discussion  置媒资类型
 *  @return  返回置媒资类型
 */
- (TUI_Enum_MediaType)getMediaType;
/**
 * 设置是否支持自适应码率
 * @param isEnableAutoBitrate 是否支持自适应码率
 */
- (void)setIsEnableAutoBitrate:(BOOL)isEnableAutoBitrate;
/**
 *  是否支持自适应码率
 *  @brief  获取是否支持自适应码率
 *  @discussion  是否支持自适应码率
 *  @return  返回是否支持自适应码率BOOL值
 */
- (BOOL)getIsEnableAutoBitrate;

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
 * 设置最大预加载大小
 * @param maxBufferSize 最大预加载大小
 */
- (void)setMaxBufferSize:(float)maxBufferSize ;
/**
 * 获取最大预加载大小
 * @return 预加载大小
 */
- (float)getMaxBufferSize;
/**
 * 设置续播模式
 * @param resumeModel 续播模式
 */
- (void)setResumeModel:(TUI_Enum_Type_ResumModel)resumeModel;
/**
 * 获取续播模式
 * @retutn 续播模式
 */
- (TUI_Enum_Type_ResumModel)getResumeModel;
/**
 * 设置预下载缓存大小
 * @param preDownloadSize 预下载缓存大小
 */
- (void)setPreDownloadSize:(float)preDownloadSize;
/**
 *  预下载缓存大小
 *  @brief  获取预下载缓存大小
 *  @discussion  预下载缓存大小
 *  @return  返回预下载缓存大小
 */
- (float)getPreDownloadSize;
/**
 * 设置是否开启精准seek
 * @param enableAccurateSeek 否开启精准seek
 */
- (void)setEnableAccurateSeek:(BOOL)enableAccurateSeek;
/**
 * 获取是否开启精准seek状态
 * @retutn BOOL值
 */
- (BOOL)getEnableAccurateSeek;
/**
 * 设置音量均衡值
 * @param audioNormalization 音量均衡值
 */
- (void)setAudioNormalization:(float)audioNormalization;
/**
 * 获取音量均衡值
 * @retutn float
 */
- (float)getAudioNormalization;
/**
 *  设置是否预播放上一个视频
 *  @param  enableLastPrePlay 是否预播放上一个视频
 */
- (void)setEnableLastPrePlay:(BOOL)enableLastPrePlay;
/**
 *  获取是否开启预播放上一个视频
 *  @return  是否开启预播放上一个视频
 */
- (BOOL)isEnableLastPrePlay;
/**
 * 设置超分开关状态
 * @param superResolutionType 超分开关状态
 */
- (void)setSuperResolutionType:(TUI_Enume_Type_SuperResolution)superResolutionType;
/**
 * 获取超分开关状态
 * @retutn 枚举值
 */
- (TUI_Enume_Type_SuperResolution)getSuperResolutionType;
/**
 * 设置字幕样式
 * @param subtitleRenderModel 字幕样式
 */
- (void)setSubtitleRenderModel:(TXPlayerSubtitleRenderModel *)subtitleRenderModel;
/**
 * 获取字幕样式
 * @retutn TXPlayerSubtitleRenderModel
 */
- (TXPlayerSubtitleRenderModel *)getSubtitleRenderModel;
/**
 * 获取自定义 HTTP Headers
 * @retutn headers
 */
- (NSDictionary *)getHeaders;
/**
 * 设置自定义 HTTP Headers
 */
- (void)setHeaders:(NSDictionary *)headers;
@end

NS_ASSUME_NONNULL_END
