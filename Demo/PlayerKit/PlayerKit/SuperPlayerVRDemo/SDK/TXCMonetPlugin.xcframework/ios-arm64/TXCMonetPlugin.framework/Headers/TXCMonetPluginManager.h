//  Copyright © 2022 Tencent. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXCMonetPluginManager : NSObject

/**
 @brief  创建Mone tPlugin Manager对象
 @discussion  创建Mone tPlugin Manager对象
 @return  返回创建的Monet Plugin Manager对象
*/
+ (instancetype)sharedManager;

/**
 @brief  在线授权（此接口仅用超分功能，其他功能无需调用）
 @discussion   设置AppId、算法类型及license文件所在的路径，进行授权验证
 @param  appId  app Id信息
 @param  authId 认证Id信息
 @param  srAlgorithmType  算法类型（详见TXCMonetPluginCommonDef.h  内TXCMonetPluginAlgorithmType设置）
*/
- (void)setAppInfo:(NSString *)appId authId:(NSInteger)authId algorithmType:(NSInteger)srAlgorithmType;

/**
 @brief  获取组件的版本号
 @discussion  获取组件的版本号
 @return  返回超分组件的版本
*/
+(NSString *)getMonetPluginSDKVersion;

@end

NS_ASSUME_NONNULL_END
