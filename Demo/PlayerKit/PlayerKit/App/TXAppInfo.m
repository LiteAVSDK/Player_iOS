//
//  TXAppInfo.m
//  TXLiteAVDemo
//
//  Created by jack on 2021/11/23.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXAppInfo.h"

@implementation TXAppInfo

#pragma mark - Public
+ (NSString *)displayName{
    return [[self applicationBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] ?: @"";
}

+ (NSString *)appVersion{
    return [[self applicationBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: @"";
}

+ (NSString *)buildNumber{
    return [[self applicationBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] ?: @"";
}

+ (NSString *)appVersionWithBuild{
    return [NSString stringWithFormat:@"%@.%@", [self appVersion], [self buildNumber]];
}

+ (NSString *)majorAppVersion{
    return [[[self appVersion] componentsSeparatedByString:@"."] firstObject] ?: @"";
}

#pragma mark - Private
+ (NSBundle *)applicationBundle{
    return [NSBundle mainBundle];
}

@end
