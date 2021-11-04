//
//  TXVideoUtils.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/25.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXVideoUtils.h"
#import <AVFoundation/AVFoundation.h>

@implementation TXVideoUtils

// 此方法是为了构造请求视频数据的URL
+ (NSArray *)loadDefaultVideoUrls {
    NSArray *locatVideoFileidArray = @[@"3701925920152292697", @"3701925920152048882", @"3701925920152283492", @"3701925920152283699", @"3701925920152049422", @"3701925920152049645", @"3701925920152293774", @"3701925920152293840", @"3701925920152050112", @"3701925920152294230", @"3701925920152285056", @"3701925920152285302", @"3701925920152050929", @"3701925920152131172", @"3701925920152286184", @"3701925920152286399"];
    NSString *baseUrlStr = @"https://playvideo.qcloud.com/getplayinfo/v4";
    NSMutableArray *videoUrlArray = [NSMutableArray array];
    for (int i = 0; i < locatVideoFileidArray.count; i++) {
        NSString *videoUrlString = baseUrlStr;
        videoUrlString = [videoUrlString stringByAppendingString:@"/1500005830/"];
        videoUrlString = [videoUrlString stringByAppendingString:locatVideoFileidArray[i]];
        [videoUrlArray addObject:videoUrlString];
    }
    return videoUrlArray;
}

@end
