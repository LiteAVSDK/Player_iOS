//
//  TXCUrl.m
//  SuperPlayer
//
//  Created by annidyfeng on 2018/9/17.
//  Copyright © 2018年 annidy. All rights reserved.
//

#import "TXCUrl.h"

@implementation TXCUrl {
    NSURL *_url;
}

- (instancetype)initWithString:(NSString *)url
{
    self = [super init];
    
    _url = [NSURL URLWithString:url];
    
    return self;
}

- (NSInteger)bizid
{
    NSString *bizId = nil;
    for (NSString *param in [_url.query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        if ([[elts firstObject] isEqualToString:@"bizid"]) {
            bizId = [elts lastObject];
            break;
        }
    }
    if (bizId == nil) {
        bizId = [[_url host] componentsSeparatedByString:@"."].firstObject;
    }

    return [bizId integerValue];
}

@end
