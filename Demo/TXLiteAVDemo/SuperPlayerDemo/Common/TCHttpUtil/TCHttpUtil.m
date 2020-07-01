//
//  TCHttpUtil.m
//  TXLiteAVDemo
//
//  Created by rushanting on 2017/11/10.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "TCHttpUtil.h"
#import "NSString+Common.h"

@implementation TCHttpUtil

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

+ (NSDictionary *)jsonData2Dictionary:(NSString *)jsonData
{
    if (jsonData == nil) {
        return nil;
    }
    NSData *data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"Json parse failed: %@", jsonData);
        return nil;
    }
    return dic;
}

+ (void)asyncSendHttpRequest:(NSString*)request
              httpServerAddr:(NSString *)httpServerAddr
                  HTTPMethod:(NSString *)HTTPMethod
                       param:(NSDictionary *)param
                     handler:(void (^)(int result, NSDictionary* resultDict))handler
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* strUrl = @"";
        if ([httpServerAddr isEqualToString:kHttpUGCServerAddr]) {
            NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
            UInt64 timestamp= (UInt64)[date timeIntervalSince1970];
            UInt64 msTimestamp = (UInt64)([date timeIntervalSince1970] * 1000);
            NSString *nonce = [[NSString stringWithFormat:@"%llu",msTimestamp] md5];
            NSString *sig = [[NSString stringWithFormat:@"%@%llu%@%@",UGCAppid,timestamp,nonce,UGCAppKey] md5];
            strUrl = [NSString stringWithFormat:@"%@/%@?timestamp=%llu&nonce=%@&sig=%@&appid=%@", httpServerAddr, request,timestamp,nonce,sig,UGCAppid];
        }else{
            strUrl = [NSString stringWithFormat:@"%@/%@", httpServerAddr, request];
        }
        
        NSURL *URL = [NSURL URLWithString:strUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        
        [request setHTTPMethod:HTTPMethod];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setTimeoutInterval:kHttpTimeout];
        for (NSString *key in param.allKeys) {
            [request setValue:param[key] forHTTPHeaderField:key];
        }
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil)
            {
                NSLog(@"internalSendRequest failed，NSURLSessionDataTask return error code:%ld, des:%@", [error code], [error description]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(kError_HttpError, nil);
                });
            }
            else
            {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary* resultDict = [TCHttpUtil jsonData2Dictionary:responseString];
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(0, resultDict);
                });
            }
        }];
        
        [task resume];
    });
}

@end
