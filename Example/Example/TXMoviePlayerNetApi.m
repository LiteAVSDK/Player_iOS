//
//  TXMoviePlayerNetApi.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/4/13.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "TXMoviePlayerNetApi.h"
#define BASE_URL_S @"https://playvideo.qcloud.com/getplayinfo/v2"
#define BASE_URL @"http://playvideo.qcloud.com/getplayinfo/v2"

@implementation TXMoviePlayerNetApi{
    NSURLSession *_session;
}

- (int)getplayinfo:(NSInteger)appId fileId:(NSString *)fileId timeout:(NSString *)timeout us:(NSString *)us exper:(int)exper sign:(NSString *)sign {
    
    if (appId == 0 || fileId.length == 0) {
        NSLog(@"参数错误");
        [self.delegate onNetFailed:self reason:@"参数错误" code:-1];
        return -1;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (timeout) {
        [params setValue:timeout forKey:@"t"];
    }
    if (us) {
        [params setValue:us forKey:@"us"];
    }
    if (sign) {
        [params setValue:sign forKey:@"sign"];
    }
    if (exper >= 0) {
        [params setValue:@(exper) forKey:@"exper"];
    }
    NSString *httpBodyString = [self makeParamtersString:params withEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%ld/%@", self.https?BASE_URL_S:BASE_URL, (long)appId, fileId];
    if (httpBodyString) {
        urlStr = [urlStr stringByAppendingFormat:@"?%@", httpBodyString];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    //创建一个请求对象，并这是请求方法为POST，把参数放在请求体中传递
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"getplayinfo: %s", [urlStr UTF8String]);
    
    //1.创建NSURLSession对象（可以获取单例对象）
    if (_session == nil) {
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:defaultConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    }
    __weak __typeof__(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        
        if (data.length == 0) {
            [strongSelf.delegate onNetFailed:strongSelf reason:@"请求失败" code:-1];
            return ;
        }
        //拿到响应头信息
        //NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        //解析拿到的响应数据
        @try {
            NSError *error;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
            if (dict == nil) {
                [strongSelf.delegate onNetFailed:strongSelf reason:@"格式错误" code:-2];
                return;
            }
            
            if ([dict objectForKey:@"code"]) {
                int code = [[dict objectForKey:@"code"] intValue];
                if (code != 0) {
                    NSLog(@"请求失败: %s", [dict[@"message"] UTF8String]);
                    [strongSelf.delegate onNetFailed:strongSelf
                                              reason:dict[@"message"]
                                                code:code];
                    return;
                }
            }
            strongSelf.playInfo = [[TXMoviePlayInfoResponse alloc] initWithResponse:dict];
            strongSelf.playInfo.appId = appId;
            strongSelf.playInfo.fileId = fileId;
            [strongSelf.delegate onNetSuccess:self];
        } @catch (NSException *exception) {
            NSLog(@"%@", exception);
            NSLog(@"%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            [strongSelf.delegate onNetFailed:strongSelf reason:@"格式错误" code:-2];
        }
    }];
    
    //3.执行Task
    //注意：刚创建出来的task默认是挂起状态的，需要调用该方法来启动任务（执行任务）
    [dataTask resume];
    return 0;
}



- (NSString*)makeParamtersString:(NSDictionary*)parameters withEncoding:(NSStringEncoding)encoding
{
    if (nil == parameters || [parameters count] == 0)
        return nil;
    
    NSMutableString* stringOfParamters = [[NSMutableString alloc] init];
    NSEnumerator *keyEnumerator = [parameters keyEnumerator];
    id key = nil;
    while ((key = [keyEnumerator nextObject]))
    {
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

- (NSString *)URLEscaped:(NSString *)strIn withEncoding:(NSStringEncoding)encoding
{
    CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)strIn, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", CFStringConvertNSStringEncodingToEncoding(encoding));
    NSString *strOut = [NSString stringWithString:(__bridge NSString *)escaped];
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
