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
    NSArray *locatVideoFileidArray = @[@"387702294394366256", @"387702294394228858", @"387702294394228636", @"387702294394228527", @"387702294167066523", @"387702294167066515", @"387702294168748446", @"387702294394227941"];
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
