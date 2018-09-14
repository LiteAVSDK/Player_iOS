//
//  SuperPlayerGlobleConfig.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/6/26.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreGraphics/CGGeometry.h>

/**
 * 超级播放器配置类
 */
@interface SuperPlayerGlobleConfig : NSObject

+ (instancetype)sharedInstance;

/** 是否启用悬浮窗 */
@property BOOL enableFloatWindow;
/** 悬浮窗位置 */
@property CGPoint floatViewOrigin;
@property CGSize floatViewSize;
/** 是否开启硬件加速 */
@property BOOL enableHWAcceleration;
/** 默认播放填充模式 */
@property NSInteger renderMode;
/** 播放器最大缓存个数 */
@property NSInteger maxCacheItem;
/** 多倍速 */
@property CGFloat playRate;

@property (getter=isMirror) BOOL mirror;


- (void)synchronize;

@end
