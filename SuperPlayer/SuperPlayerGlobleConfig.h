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

/** 悬浮窗位置 */
@property (nonatomic) CGRect floatViewRect;
/** 播放器最大缓存个数 */
@property (nonatomic) NSInteger maxCacheItem;
/// 时移域名，默认为playtimeshift.live.myqcloud.com
@property NSString *playShiftDomain;

@end
