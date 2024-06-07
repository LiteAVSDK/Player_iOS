// Copyright (c) 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuperPlayerPIPManager : NSObject
/// 点击小窗返回的controller
@property (nonatomic, strong )UIViewController *backController;
@property(nonatomic, assign, readonly) BOOL isShowing;
/// 单例初始化
+ (instancetype)sharedInstance ;

- (void)show:(UIViewController *)vc;
- (void)back;
- (void)close;
@end

NS_ASSUME_NONNULL_END
