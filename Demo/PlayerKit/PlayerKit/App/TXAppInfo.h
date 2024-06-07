//
//  TXAppInfo.h
//  TXLiteAVDemo
//
//  Created by jack on 2021/11/23.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 获取App配置信息
@interface TXAppInfo : NSObject

/// 商店显示名称
+ (nonnull NSString *)displayName;

/// 版本号 eg. 9.4.0
+ (nonnull NSString *)appVersion;

/// 有构建版本号的版本号 eg. 9.4.0.12345
+ (nonnull NSString *)appVersionWithBuild;

/// 构建版本
+ (nonnull NSString *)buildNumber;

/// 主版本号
+ (nonnull NSString *)majorAppVersion;

@end


