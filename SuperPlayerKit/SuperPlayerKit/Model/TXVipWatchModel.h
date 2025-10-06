//
//  TXVipWatchModel.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/8.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXVipWatchModel : NSObject
/// Prompt information
/// 提示语信息
@property (nonatomic, strong) NSString *tipTtitle;
/// Check the time, the unit is second
/// 试看时间，单位是秒
@property (nonatomic, assign) float    canWatchTime;

@end

NS_ASSUME_NONNULL_END
