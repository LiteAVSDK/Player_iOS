// Copyright (c) 2023 Tencent. All rights reserved.
// SDKVersion: 1.3.0.29
#import <Foundation/Foundation.h>
#import "TUIPlayerConfig.h"

NS_ASSUME_NONNULL_BEGIN
///core
@interface TUIPlayerCore : NSObject

/**
  * 单例
  */
+ (instancetype)shareInstance;

/**
 * 播放器配置
 * @param playerConfig 配置模型
 */
- (void)setPlayerConfig:(TUIPlayerConfig *)playerConfig;

/**
 * 是否打印日志
 * @return BOOL值
 */
- (BOOL)logEnable;

/**
 * 获取当前SDK版本号
 * @return 版本号
 */
- (NSString *)getVersion;
@end

NS_ASSUME_NONNULL_END
