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
    
    _userDefalut = [NSUserDefaults standardUserDefaults];
    
    _playShiftDomain = @"playtimeshift.live.myqcloud.com";
    
    [self loadDefalut];
    
    return self;
}

- (void)setFloatViewRect:(CGRect)floatViewRect
{
    _floatViewRect = floatViewRect;
    [_userDefalut setObject:NSStringFromCGRect(floatViewRect) forKey:kFloatViewRect];
}

- (void)loadDefalut
{
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
