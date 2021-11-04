//
//  TXVideoRequest.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/24.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXVideoRequest.h"
#import <AFNetworking/AFHTTPSessionManager.h>

NSInteger const TXAFNetworkingTimeoutInterval = 30;

@implementation TXVideoRequest

static AFHTTPSessionManager *AFManager;
+ (AFHTTPSessionManager *)sharedAFManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AFManager = [AFHTTPSessionManager manager];
        
        AFManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/json",@"text/plain",@"text/JavaScript",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
        AFManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        // 设置超时时间
        AFManager.requestSerializer.timeoutInterval = TXAFNetworkingTimeoutInterval;
    });
    return AFManager;
}

+ (void)requestWithtype:(TXVideoRequestType)type urlString:(NSString *)urlString parameters:(NSDictionary *)parameters headers:(NSDictionary *)headers successBlock:(nonnull TXVideoRequestSuccessBlock)successBlock failureBlock:(nonnull TXVideoRequestFailedBlock)failureBlock {
    if (urlString == nil) {
        return;
    }
    
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if (type == TXVideoRequestTypeGet) {
        [[self sharedAFManager] GET:urlString parameters:parameters headers:headers progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code != -999) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }
        }];
    }
    
    if (type == TXVideoRequestTypePost) {
        [[self sharedAFManager] POST:urlString parameters:parameters headers:headers progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code != -999) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }
        }];
    }
}

@end
