//
//  TXVideoRequest.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/24.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 请求类型的枚举 */
typedef NS_ENUM(NSUInteger, TXVideoRequestType)
{
    /** get请求 */
    TXVideoRequestTypeGet = 0,
    /** post请求 */
    TXVideoRequestTypePost
};

/**
 请求成功的block
 @param responseObject 返回的数据
 */
typedef void (^TXVideoRequestSuccessBlock)(id responseObject);

/**
 请求失败后的block
 @param error 返回的错误信息
 */
typedef void (^TXVideoRequestFailedBlock)(NSError *error);

//超时时间
extern NSInteger const TXAFNetworkingTimeoutInterval;

@interface TXVideoRequest : NSObject

/**
 *  网络请求的实例方法
 *
 *  @param type         get / post (项目目前只支持这倆中)
 *  @param urlString    请求的地址
 *  @param parameters   请求的参数
 *  @param successBlock 请求成功回调
 *  @param failureBlock 请求失败回调
 */
+ (void)requestWithtype:(TXVideoRequestType)type
              urlString:(NSString *)urlString
             parameters:(NSDictionary * _Nullable )parameters
                headers:(NSDictionary * _Nullable )headers
           successBlock:(TXVideoRequestSuccessBlock)successBlock
           failureBlock:(TXVideoRequestFailedBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
