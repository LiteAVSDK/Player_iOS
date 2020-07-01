//
//  StrUtils.m
//  Pods
//
//  Created by annidyfeng on 2018/9/28.
//

#import "StrUtils.h"

NSString *kStrLoadFaildRetry = @"加载失败,点击重试";
NSString *kStrBadNetRetry = @"网络不给力,点击重试";
NSString *kStrTimeShiftFailed = @"时移失败，返回直播";
NSString *kStrHDSwitchFailed = @"清晰度切换失败";
NSString *kStrWeakNet = @"检测到你的网络较差，建议切换清晰度";

@implementation StrUtils

+ (NSString *)timeFormat:(NSInteger)totalTime {
    if (totalTime < 0) {
        return @"";
    }
    NSInteger durHour = totalTime / 3600;
    NSInteger durMin = (totalTime / 60) % 60;
    NSInteger durSec = totalTime % 60;
    
    if (durHour > 0) {
        return [NSString stringWithFormat:@"%zd:%02zd:%02zd", durHour, durMin, durSec];
    } else {
        return [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    }
}

@end
