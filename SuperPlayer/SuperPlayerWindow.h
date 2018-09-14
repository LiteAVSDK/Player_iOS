//
//  SuperPlayerWindow.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/6/26.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuperPlayerView;

typedef void(^SuperPlayerWindowEventHandler)();

@interface SuperPlayerWindow : UIWindow

- (void)show;
- (void)hide;

+ (instancetype)sharedInstance;

@property (nonatomic,copy) SuperPlayerWindowEventHandler backHandler;
@property (nonatomic,copy) SuperPlayerWindowEventHandler closeHandler;  // 默认关闭

@property (nonatomic,strong) SuperPlayerView *superPlayer;

@property (readonly) UIView *rootView;

@property UIViewController *backController;

@property (readonly) BOOL isShowing;  //

@end
