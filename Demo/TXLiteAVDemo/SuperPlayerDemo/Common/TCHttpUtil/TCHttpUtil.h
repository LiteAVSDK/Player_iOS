//
//  TCHttpUtil.h
//  TXLiteAVDemo
//
//  Created by rushanting on 2017/11/10.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#define kHttpTimeout                         30

#define kHttpServerAddr                      @"https://lvb.qcloud.com/weapp/utils"
#define kHttpUGCServerAddr                   @"http://demo.vod2.myqcloud.com/shortvideo" //@"http://119.29.189.135:8000"
#define UGCAppid     @"1256468886"
#define UGCAppKey    @"1973fcc2b70445af8b51053d4f9022bb"

//错误码
#define kError_InvalidParam                            -10001
#define kError_ConvertJsonFailed                       -10002
#define kError_HttpError                               -10003

#import <Foundation/Foundation.h>

@interface TCHttpUtil : NSObject

+ (NSData *)dictionary2JsonData:(NSDictionary *)dict;
+ (NSDictionary *)jsonData2Dictionary:(NSString *)jsonData;
+ (void)asyncSendHttpRequest:(NSString*)request
              httpServerAddr:(NSString *)httpServerAddr
                  HTTPMethod:(NSString *)HTTPMethod
                       param:(NSDictionary *)param
                     handler:(void (^)(int result, NSDictionary* resultDict))handler;
@end
