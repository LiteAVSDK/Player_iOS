//
//  SuperPlayerPrefs.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/6/26.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "SuperPlayerGlobleConfig.h"
#import "SuperPlayer.h"

#define FLOAT_VIEW_WIDTH  200
#define FLOAT_VIEW_HEIGHT 112


@implementation SuperPlayerGlobleConfig {
    NSUserDefaults *_userDefalut;
}

+ (instancetype)sharedInstance {
    static SuperPlayerGlobleConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SuperPlayerGlobleConfig alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    _floatViewSize = CGSizeMake(FLOAT_VIEW_WIDTH, FLOAT_VIEW_HEIGHT);
    // 右下角
    _floatViewOrigin = CGPointMake(ScreenWidth-_floatViewSize.width, ScreenHeight-_floatViewSize.height);
    
    if (IsIPhoneX) {
        _floatViewOrigin = CGPointMake(ScreenWidth-_floatViewSize.width, ScreenHeight-_floatViewSize.height-44);
    }
    
    _renderMode = RENDER_MODE_FILL_EDGE;
    
    _userDefalut = [NSUserDefaults standardUserDefaults];
    
    return self;
}

- (BOOL)enableFloatWindow {
    if ([_userDefalut objectForKey:@"enableFloatWindow"]) {
        return [_userDefalut boolForKey:@"enableFloatWindow"];
    }
    return YES;
}

- (void)setEnableFloatWindow:(BOOL)enableFloatWindow {
    [_userDefalut setBool:enableFloatWindow forKey:@"enableFloatWindow"];
}

- (BOOL)enableHWAcceleration {
    if ([_userDefalut objectForKey:@"enableHWAcceleration"]) {
        return [_userDefalut boolForKey:@"enableHWAcceleration"];
    }
#if TARGET_OS_SIMULATOR
    return NO;
#else
    return YES;
#endif
}

- (void)setEnableHWAcceleration:(BOOL)enableHWAcceleration {
    [_userDefalut setBool:enableHWAcceleration forKey:@"enableHWAcceleration"];
}

- (CGFloat)playRate {
    if ([_userDefalut objectForKey:@"playRate"]) {
        return [_userDefalut floatForKey:@"playRate"];
    }
    return 1.0;
}

- (void)setPlayRate:(CGFloat)playRate {
    [_userDefalut setFloat:playRate forKey:@"playRate"];
}

- (BOOL)isMirror {
    if ([_userDefalut objectForKey:@"mirror"]) {
        return [_userDefalut boolForKey:@"mirror"];
    }
    return NO;
}

- (void)setMirror:(BOOL)mirror {
    [_userDefalut setBool:mirror forKey:@"mirror"];
}

- (void)synchronize
{
    [_userDefalut synchronize];
}




@end
