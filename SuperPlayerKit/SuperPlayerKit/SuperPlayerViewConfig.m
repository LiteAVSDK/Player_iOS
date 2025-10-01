//
//  SuperPlayerViewConfig.m
//  SuperPlayer
//
//  Created by annidyfeng on 2018/10/18.
//

#import "SuperPlayerViewConfig.h"

#import "SuperPlayer.h"
#if __has_include("TXLiveSDKTypeDef.h")
#import "TXLiveSDKTypeDef.h"
#else
// 如果没有 SDK，定义默认的渲染模式常量
#ifndef RENDER_MODE_FILL_EDGE
#define RENDER_MODE_FILL_EDGE 1
#endif
#endif

@implementation SuperPlayerViewConfig

- (instancetype)init {
    self                 = [super init];
    self.hwAcceleration  = 1;
    self.pipAutomatic = NO;
    self.playRate        = 1;
    self.renderMode      = RENDER_MODE_FILL_EDGE;
    self.maxCacheSizeMB  = 500;
    self.playShiftDomain = @"playtimeshift.live.myqcloud.com";
    self.enableLog       = YES;
    return self;
}

- (BOOL)hwAcceleration {
#if TARGET_OS_SIMULATOR
    return NO;
#else
    return _hwAcceleration;
#endif
}

@end
