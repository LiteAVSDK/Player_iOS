//
//  FeedRequestUtil.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2022/6/17.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import "FeedRequestUtil.h"
#import "PlayerKitCommonHeaders.h"

#define BASE_URL   @"http://playvideo.qcloud.com/getplayinfo/v4"

@implementation FeedRequestUtil

+ (void)getPlayInfo:(int)appId
             fileId:(NSString *)fileId
              psign:(NSString *)psign
         completion:(void (^)(NSMutableDictionary *dic, NSError *error))completion {
    if (appId == 0 || fileId.length == 0) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"parameter error"]}];
            completion(nil, error);
            return;
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (psign) {
        params[@"psign"] = psign;
    }
    
    NSString *httpBodyString = [self makeParamtersString:params withEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%ld/%@", BASE_URL, (long)appId, fileId];
    if (httpBodyString) {
        urlStr = [urlStr stringByAppendingFormat:@"?%@", httpBodyString];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error) {
        if (error) {
            if (completion) {
                completion(nil, error);
                return;
            }
        }
        
        if (data.length == 0) {
            if (completion) {
                NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                     code:-1
                                                 userInfo:@{NSLocalizedDescriptionKey : @"request error", NSLocalizedFailureReasonErrorKey : @"content is nil"}];
                completion(nil, error);
                return;
            }
        }
        
        @try {
            NSError *error;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
            if (dict == nil) {
                if (completion) {
                    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                         code:-2
                                                     userInfo:@{NSLocalizedDescriptionKey : @"invalid format"}];
                    completion(nil, error);
                    return;
                }
            }
            
            if ([dict objectForKey:@"code"]) {
                int code = [[dict objectForKey:@"code"] intValue];
                if (code != 0) {
                    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                         code:code
                                                     userInfo:@{NSLocalizedDescriptionKey : dict[@"message"]}];
                    completion(nil, error);
                    return;
                }
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            int ver = dict[@"version"] ? J2Num(dict[@"version"]).intValue : 2;
            if (ver == 2) {
                NSString *url = @"";
                NSMutableArray *multiVideoURLs = [self makeV2UrlWithUrl:url response:dict];
                if (url.length > 0) {
                    [dic setObject:url forKey:@"videoUrl"];
                }
                [dic setObject:multiVideoURLs forKey:@"multiVideoURLs"];
                
            } else {
                NSString *url = [self makeV4Urlwithresponse:dict];
                if (url.length > 0) {
                    [dic setObject:url forKey:@"videoUrl"];
                }
            }
            
            if (completion) {
                completion(dic, nil);
                return;
            }
            
        } @catch (NSException *exception) {
            if (completion) {
                NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                     code:-2
                                                 userInfo:@{NSLocalizedDescriptionKey : @"invalid format"}];
                completion(nil, error);
                return;
            }
        }
    }];
    
    [dataTask resume];
}

+ (NSString *)makeParamtersString:(NSDictionary *)parameters withEncoding:(NSStringEncoding)encoding {
    if (nil == parameters || [parameters count] == 0) return nil;

    NSMutableString *stringOfParamters = [[NSMutableString alloc] init];
    NSEnumerator *   keyEnumerator     = [parameters keyEnumerator];
    id               key               = nil;
    while ((key = [keyEnumerator nextObject])) {
        [stringOfParamters appendFormat:@"%@=%@&", key, [parameters valueForKey:key]];
    }

    // Delete last character of '&'
    NSRange lastCharRange = {[stringOfParamters length] - 1, 1};
    [stringOfParamters deleteCharactersInRange:lastCharRange];
    return stringOfParamters;
}


// 获取URL
+ (NSString *)makeV4Urlwithresponse:(NSDictionary *)dict {
    NSDictionary *media = dict[@"media"];
    NSString* audioVideoType = [media valueForKey:@"audioVideoType"];
    NSDictionary *streamInfo = [self getStreamInfo:audioVideoType media:media];
    //解析视频播放url
    NSString *url = streamInfo[@"url"];
    return url;
}

+ (NSDictionary *)getStreamInfo:(NSString*) audioVideoType media:(NSDictionary*) media{
    NSDictionary *streamInfo;
    if ([audioVideoType isEqualToString:@"Original"]) { //原视频输出
        streamInfo = [media valueForKey:@"originalInfo"];
    }else if ([audioVideoType isEqualToString:@"Transcode"]){ //转码输出
        streamInfo = [media valueForKey:@"transcodeInfo"];
    }else{                                                    //自适应码流输出
        streamInfo = [media valueForKeyPath:@"streamingInfo.plainOutput"];
    }
    return  streamInfo;;
}


+ (NSMutableArray *)makeV2UrlWithUrl:(NSString *)url response:(NSDictionary *)dict {
    NSString * masterUrl = J2Str([dict valueForKeyPath:@"videoInfo.masterPlayList.url"]);
    NSMutableArray<SuperPlayerUrl *> *result = [NSMutableArray new];
    if (masterUrl.length > 0) {
        url = masterUrl;
    } else {
        NSString *mainDefinition = J2Str([dict valueForKeyPath:@"playerInfo.defaultVideoClassification"]);
        NSArray *videoClassification = J2Array([dict valueForKeyPath:@"playerInfo.videoClassification"]);
        NSArray *transcodeList       = J2Array([dict valueForKeyPath:@"videoInfo.transcodeList"]);
        
        for (NSDictionary *transcode in transcodeList) {
            SuperPlayerUrl *subModel = [SuperPlayerUrl new];
            subModel.url             = J2Str(transcode[@"url"]);
            NSNumber *theDefinition  = J2Num(transcode[@"definition"]);

            for (NSDictionary *definition in videoClassification) {
                for (NSObject *definition2 in J2Array([definition valueForKeyPath:@"definitionList"])) {
                    if ([definition2 isEqual:theDefinition]) {
                        subModel.title         = J2Str([definition valueForKeyPath:@"name"]);
                        NSString *definitionId = J2Str([definition valueForKeyPath:@"id"]);
                        // 初始播放清晰度
                        if ([definitionId isEqualToString:mainDefinition]) {
                            url = subModel.url;
                        }
                        break;
                    }
                }
            }
            // 同一个清晰度可能存在多个转码格式，这里只保留一种格式，且优先mp4类型
            for (SuperPlayerUrl *item in result) {
                if ([item.title isEqual:subModel.title]) {
                    if (![item.url containsString:@".mp4"]) {
                        item.url = subModel.url;
                    }
                    subModel = nil;
                    break;
                }
            }

            if (subModel) {
                [result addObject:subModel];
            }
        }
    }
    
    return result;
}

@end
