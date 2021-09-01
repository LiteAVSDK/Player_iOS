//
//  TXMoviePlayerNetApi.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/4/13.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "TXMoviePlayerNetApi.h"

#import "AppLocalized.h"
#define BASE_URL_S @"https://playvideo.qcloud.com/getplayinfo/v4"
#define BASE_URL   @"http://playvideo.qcloud.com/getplayinfo/v4"

@implementation TXMoviePlayerNetApi {
    NSURLSession *_session;
}

- (int)getplayinfo:(NSInteger)appId fileId:(NSString *)fileId psign:(NSString *)psign completion:(void (^)(TXMoviePlayInfoResponse *resp, NSError *error))completion {
    if (appId == 0 || fileId.length == 0) {
        NSLog(@"%@", LivePlayerLocalize(@"SuperPlayerDemo.TXMoviePlayerNetApi.parametererror"));
        if (completion) {
            NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey : LivePlayerLocalize(@"SuperPlayerDemo.TXMoviePlayerNetApi.parametererror")}];
            completion(nil, error);
        }

        //        [self.delegate onNetFailed:self reason:@"参数错误" code:-1];
        return -1;
    }

    NSMutableDictionary *params = [NSMutableDictionary new];

    if (psign) {
        params[@"psign"] = psign;
    }

    NSString *httpBodyString = [self makeParamtersString:params withEncoding:NSUTF8StringEncoding];
    NSString *urlStr         = [NSString stringWithFormat:@"%@/%ld/%@", self.https ? BASE_URL_S : BASE_URL, (long)appId, fileId];
    if (httpBodyString) {
        urlStr = [urlStr stringByAppendingFormat:@"?%@", httpBodyString];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    //创建一个请求对象，并这是请求方法为POST，把参数放在请求体中传递
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"getplayinfo: %s", [urlStr UTF8String]);

    // 1.创建NSURLSession对象（可以获取单例对象）
    if (_session == nil) {
        NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session                                 = [NSURLSession sessionWithConfiguration:defaultConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    }
    //    __weak __typeof__(self) weakSelf = self;
    NSURLSessionDataTask *dataTask =
        [_session dataTaskWithRequest:request
                    completionHandler:^(NSData *__nullable data, NSURLResponse *__nullable response, NSError *__nullable error) {
                        //        __strong __typeof__(weakSelf) strongSelf = weakSelf;
                        if (error) {
                            if (completion) {
                                completion(nil, error);
                            }
                            return;
                        }

                        if (data.length == 0) {
                            if (completion) {
                                NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                                     code:-1
                                                                 userInfo:@{
                                                                     NSLocalizedDescriptionKey : LivePlayerLocalize(@"SuperPlayerDemo.TXMoviePlayerNetApi.requesterror"),
                                                                     NSLocalizedFailureReasonErrorKey : LivePlayerLocalize(@"SuperPlayerDemo.TXMoviePlayerNetApi.contentisnil")
                                                                 }];
                                completion(nil, error);
                            }
                            return;
                        }
                        //拿到响应头信息
                        // NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                        //解析拿到的响应数据
                        @try {
                            NSError *     error;
                            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves)error:&error];
                            if (dict == nil) {
                                if (completion) {
                                    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                                         code:-2
                                                                     userInfo:@{NSLocalizedDescriptionKey : LivePlayerLocalize(@"SuperPlayerDemo.TXMoviePlayerNetApi.invalidformat")}];
                                    completion(nil, error);
                                }
                                //                [strongSelf.delegate onNetFailed:strongSelf reason:@"格式错误" code:-2];
                                return;
                            }

                            if ([dict objectForKey:@"code"]) {
                                int code = [[dict objectForKey:@"code"] intValue];
                                if (code != 0) {
                                    NSLog(@"%@: %s", LivePlayerLocalize(@"SuperPlayerDemo.TXMoviePlayerNetApi.requesterror"), [dict[@"message"] UTF8String]);
                                    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:code userInfo:@{NSLocalizedDescriptionKey : dict[@"message"]}];
                                    completion(nil, error);

                                    //                    [strongSelf.delegate onNetFailed:strongSelf
                                    //                                              reason:dict[@"message"]
                                    //                                                code:code];
                                    return;
                                }
                            }

                            TXMoviePlayInfoResponse *playInfo = [[TXMoviePlayInfoResponse alloc] initWithResponse:dict];
                            playInfo.appId                    = appId;
                            playInfo.fileId                   = fileId;
                            if (completion) {
                                completion(playInfo, nil);
                            }
                            //            [strongSelf.delegate onNetSuccess:self];
                        } @catch (NSException *exception) {
                            NSLog(@"%@", exception);
                            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                            if (completion) {
                                NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                                     code:-2
                                                                 userInfo:@{NSLocalizedDescriptionKey : LivePlayerLocalize(@"SuperPlayerDemo.TXMoviePlayerNetApi.invalidformat")}];
                                completion(nil, error);
                            }
                        }
                    }];

    // 3.执行Task
    //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
    [dataTask resume];
    return 0;
}

- (NSString *)makeParamtersString:(NSDictionary *)parameters withEncoding:(NSStringEncoding)encoding {
    if (nil == parameters || [parameters count] == 0) return nil;

    NSMutableString *stringOfParamters = [[NSMutableString alloc] init];
    NSEnumerator *   keyEnumerator     = [parameters keyEnumerator];
    id               key               = nil;
    while ((key = [keyEnumerator nextObject])) {
        //        NSString *value = [[parameters valueForKey:key] isKindOfClass:[NSString class]] ?
        //        [parameters valueForKey:key] : [[parameters valueForKey:key] stringValue];
        //        [stringOfParamters appendFormat:@"%@=%@&",
        //         [self URLEscaped:key withEncoding:encoding],
        //         [self URLEscaped:value withEncoding:encoding]];
        [stringOfParamters appendFormat:@"%@=%@&", key, [parameters valueForKey:key]];
    }

    // Delete last character of '&'
    NSRange lastCharRange = {[stringOfParamters length] - 1, 1};
    [stringOfParamters deleteCharactersInRange:lastCharRange];
    return stringOfParamters;
}

- (NSString *)URLEscaped:(NSString *)strIn withEncoding:(NSStringEncoding)encoding {
    CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)strIn, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", CFStringConvertNSStringEncodingToEncoding(encoding));
    NSString *  strOut  = [NSString stringWithString:(__bridge NSString *)escaped];
    CFRelease(escaped);
    return strOut;
}

- (void)dealloc {
    if (_session) {
        [_session invalidateAndCancel];
        _session = nil;
    }
}
@end
