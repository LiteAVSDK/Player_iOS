// Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuperPlayerView;

typedef void (^SuperPlayerWindowEventHandler)(void);

@interface SuperPlayerSmallWindowManager : NSObject

@property(nonatomic, copy) SuperPlayerWindowEventHandler backHandler;
@property(nonatomic, copy) SuperPlayerWindowEventHandler closeHandler;  // 默认关闭
/// 小窗播放器
@property(nonatomic, weak) SuperPlayerView *superPlayer;
/// 小窗主view
@property(readonly) UIView *rootView;
/// 点击小窗返回的controller
@property UIViewController *backController;
/// 小窗是否显示
@property(nonatomic, assign, readonly) BOOL isShowing;

/// 单例初始化
+ (instancetype)sharedInstance ;
/// 显示小窗
- (void)show;
/// 隐藏小窗
- (void)hide;

@end


