//
//  SuperPlayerViewConfig.m
//  SuperPlayer
//
//  Created by annidyfeng on 2018/10/18.
//

#if __has_include(<TXLiteAVSDK_Player/TXLiveSDKTypeDef.h>)
#import <TXLiteAVSDK_Player/TXLiveSDKTypeDef.h>
#elif __has_include(<TXLiteAVSDK_Player_Premium/TXLiveSDKTypeDef.h>)
#import <TXLiteAVSDK_Player_Premium/TXLiveSDKTypeDef.h>
#elif __has_include(<TXLiteAVSDK_Professional/TXLiveSDKTypeDef.h>)
#import <TXLiteAVSDK_Professional/TXLiveSDKTypeDef.h>
#else
#import "TXLiveSDKTypeDef.h"
#endif

#import "SuperPlayer.h"
#import "SuperPlayerViewConfig.h"

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
