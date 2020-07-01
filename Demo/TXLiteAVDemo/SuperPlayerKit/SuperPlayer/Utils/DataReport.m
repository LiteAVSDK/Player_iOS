//
//  DataReport.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/7/10.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "DataReport.h"

//错误码
#define kError_InvalidParam                            -10001
#define kError_ConvertJsonFailed                       -10002
#define kError_HttpError                               -10003

//数据上报
#define DEFAULT_ELK_HOST                     @"https://ilivelog.qcloud.com"
#define kHttpTimeout                         30
@implementation DataReport

+ (void)report:(NSString *)action param:(NSDictionary *)param
{
    NSMutableDictionary *dict = @{}.mutableCopy;
    if (param) {
        [dict addEntriesFromDictionary:param];
    }
    [dict setObject:@"superplayer" forKey:@"bussiness"];
    [dict setObject:@"ios" forKey:@"platform"];
    [dict setObject:@"log" forKey:@"type"];
    [dict setObject:action?:@"" forKey:@"action"];
    [dict setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:@"appidentifier"];
    [dict setObject:[DataReport getPackageName] forKey:@"appname"];
    
    [self report:dict handler:^(int resultCode, NSString *message) {
        
    }];
}

+ (NSString *)getPackageName {
    static NSString *packname = nil;
    if (packname)
        return packname;
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    packname = [infoDict objectForKey:@"CFBundleDisplayName"];
    if (packname == nil || [packname isEqual:@""]) {
        packname = [infoDict objectForKey:@"CFBundleIdentifier"];
    }
    return packname;
}


+ (void)report:(NSMutableDictionary *)param handler:(void (^)(int resultCode, NSString *message))handler;
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData* data = [self dictionary2JsonData:param];
        if (data == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) handler(kError_ConvertJsonFailed, nil);
            });
            return;
        }
        
        NSMutableString *strUrl = [[NSMutableString alloc] initWithString:DEFAULT_ELK_HOST];
        
        NSURL *URL = [NSURL URLWithString:strUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        
        if (data)
        {
            [request setValue:[NSString stringWithFormat:@"%ld",(long)[data length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            
            [request setHTTPBody:data];
        }
        
        [request setTimeoutInterval:kHttpTimeout];
        
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil)
            {
                NSLog(@"internalSendRequest failed，NSURLSessionDataTask return error code:%ld, des:%@", (long)[error code], [error description]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) handler(kError_HttpError, nil);
                });
            }
            else
            {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([responseString isEqualToString:@"ok"]) {
                        if (handler) handler(0, responseString);
                    }else{
                        if (handler) handler(-1, responseString);
                    }
                });
            }
        }];
        
        [task resume];
    });
}

+ (NSData *)dictionary2JsonData:(NSDictionary *)dict
{
    // 转成Json数据
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        if(error)
        {
            NSLog(@"[%@] Post Json Error", [self class]);
        }
        return data;
    }
    else
    {
        NSLog(@"[%@] Post Json is not valid", [self class]);
    }
    return nil;
}
@end
