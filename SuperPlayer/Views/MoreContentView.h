//
//  SuperPlayerMoreView.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/7/4.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperPlayerViewConfig.h"

#define MoreViewWidth 330

@class SuperPlayerControlView;

@interface MoreContentView : UIView

@property (weak) SuperPlayerControlView *controlView;

@property UISlider *soundSlider;

@property UISlider *lightSlider;

@property (nonatomic) BOOL isLive;

@property SuperPlayerViewConfig *playerConfig;
- (void)update;

@end
