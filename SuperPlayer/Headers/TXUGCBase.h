//
//  TXUGCBase.h
//  TXLiteAVSDK
//
//  Created by shengcui on 2018/5/17.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 短视频SDK基本信息设置类
@interface TXUGCBase : NSObject

/**
 设置sdk的licence下载url和key, 可以从控制台获取
 @param url licence 下载URL
 @param key licence钥匙
 */
+ (void)setLicenceURL:(NSString *)url key:(NSString *)key;

/// 获取Licence信息
+ (NSString *)getLicenceInfo;
/// 获取版本号
+ (NSString *)getSDKVersionStr;
@end
