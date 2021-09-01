//
//  NSString+URL.m
//  SuperPlayer
//
//  Created by xcoderliu on 12/10/20.
//  Copyright © 2020 annidy. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)
+ (NSString *)getParameter:(NSString *)parameter WithOriginUrl:(NSString *)originUrl {
    NSError *error;
    if (originUrl.length == 0) {
        return @"";
    }
    NSString *           regTags = [[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", parameter];
    NSRegularExpression *regex   = [NSRegularExpression regularExpressionWithPattern:regTags options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *            matches = [regex matchesInString:originUrl options:0 range:NSMakeRange(0, [originUrl length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [originUrl substringWithRange:[match rangeAtIndex:2]];
        return tagValue;
    }
    return @"";
}

+ (NSString *)deleteParameter:(NSString *)parameter WithOriginUrl:(NSString *)originUrl {
    NSString *       finalStr       = [NSString string];
    NSMutableString *mutStr         = [NSMutableString stringWithString:originUrl];
    NSArray *        strArray       = [mutStr componentsSeparatedByString:parameter];
    NSMutableString *firstStr       = [strArray objectAtIndex:0];
    NSMutableString *lastStr        = [strArray lastObject];
    NSRange          characterRange = [lastStr rangeOfString:@"&"];

    if (characterRange.location != NSNotFound) {
        NSArray *       lastArray = [lastStr componentsSeparatedByString:@"&"];
        NSMutableArray *mutArray  = [NSMutableArray arrayWithArray:lastArray];
        [mutArray removeObjectAtIndex:0];
        NSString *modifiedStr = [mutArray componentsJoinedByString:@"&"];
        finalStr              = [[strArray objectAtIndex:0] stringByAppendingString:modifiedStr];
    } else {
        finalStr = [firstStr substringToIndex:[firstStr length] - 1];
    }
    return finalStr;
}

+ (NSString *)appendParameter:(NSString *)queryString WithOriginUrl:(NSString *)originUrl {
    if (![queryString length]) {
        return originUrl;
    }
    return [NSString stringWithFormat:@"%@%@%@", originUrl, [originUrl rangeOfString:@"?"].length > 0 ? @"&" : @"?", queryString];
}
@end
