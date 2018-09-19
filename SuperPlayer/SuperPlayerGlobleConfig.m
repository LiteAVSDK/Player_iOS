//
//  SuperPlayerPrefs.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/6/26.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "SuperPlayerGlobleConfig.h"
#import "SuperPlayer.h"
#import <Foundation/Foundation.h>

#define FLOAT_VIEW_WIDTH  200
#define FLOAT_VIEW_HEIGHT 112

#define kEnableFloatWindow      @"sp_enableFloatWindow"
#define kEnableHWAcceleration   @"sp_enableHWAcceleration"
#define kPlayRate               @"sp_playRate"
#define kMirror                 @"sp_mirror"
#define kFloatViewRect          @"sp_floatViewRect"

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
       
    _renderMode = RENDER_MODE_FILL_EDGE;
    
    _userDefalut = [NSUserDefaults standardUserDefaults];
    
    [self loadDefalut];
    
    return self;
}

- (void)setEnableFloatWindow:(BOOL)enableFloatWindow {
    _enableFloatWindow = enableFloatWindow;
    [_userDefalut setBool:enableFloatWindow forKey:kEnableFloatWindow];
}

- (void)setEnableHWAcceleration:(BOOL)enableHWAcceleration {
    _enableHWAcceleration = enableHWAcceleration;
    [_userDefalut setBool:enableHWAcceleration forKey:kEnableHWAcceleration];
}

- (void)setPlayRate:(CGFloat)playRate {
    _playRate = playRate;
    [_userDefalut setFloat:_playRate forKey:kPlayRate];
}

- (void)setMirror:(BOOL)mirror {
    _mirror = mirror;
    [_userDefalut setBool:mirror forKey:kMirror];
}

- (void)setFloatViewRect:(CGRect)floatViewRect
{
    _floatViewRect = floatViewRect;
    [_userDefalut setObject:NSStringFromCGRect(floatViewRect) forKey:kFloatViewRect];
}

- (void)loadDefalut
{
    if ([_userDefalut objectForKey:kEnableFloatWindow] == nil) {
        self.enableFloatWindow = YES;
    } else {
        self.enableFloatWindow = [_userDefalut boolForKey:kEnableFloatWindow];
    }
    if ([_userDefalut objectForKey:kEnableHWAcceleration] == nil) {
#if TARGET_OS_SIMULATOR
        self.enableHWAcceleration = NO;
#else
        self.enableHWAcceleration = YES;
#endif
    } else {
        self.enableHWAcceleration = [_userDefalut boolForKey:kEnableHWAcceleration];
    }
    if ([_userDefalut objectForKey:kPlayRate] == nil) {
        self.playRate = 1.0;
    } else {
        self.playRate = [_userDefalut floatForKey:kPlayRate];
    }
    if ([_userDefalut objectForKey:kMirror] == nil) {
        self.mirror = YES;
    } else {
        self.mirror = [_userDefalut boolForKey:kMirror];
    }
    if ([_userDefalut objectForKey:kFloatViewRect] == nil) {
        CGRect rect = CGRectMake(ScreenWidth-FLOAT_VIEW_WIDTH, ScreenHeight-FLOAT_VIEW_HEIGHT, FLOAT_VIEW_WIDTH, FLOAT_VIEW_HEIGHT);
        
        if (IsIPhoneX) {
            rect.origin.y -= 44;
        }
        self.floatViewRect = rect;
    } else {
        NSString *rect = [_userDefalut objectForKey:kFloatViewRect];
        self.floatViewRect = CGRectFromString(rect);
    }
}

@end
