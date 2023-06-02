
//  Copyright (c) 2023 Tencent. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIViewController (TXRotation)

/**
 尝试将手机旋转为指定方向。请确保传进来的参数属于 -[UIViewController supportedInterfaceOrientations] 返回的范围内，如不在该范围内会旋转失败。
 @return 旋转成功则返回 YES，旋转失败返回 NO。
 @note 请注意与 @c tx_setNeedsUpdateOfSupportedInterfaceOrientations 的区别：如果你的界面支持N个方向，而你希望保持对这N个方向的支持的情况下把设备方向旋转为这N个方向里的某一个时，应该调用 @c tx_rotateToInterfaceOrientation: 。如果你的界面支持N个方向，而某些情况下你希望把N换成M并触发设备的方向刷新，则请修改方向后，调用 @c tx_setNeedsUpdateOfSupportedInterfaceOrientations 。
 */
- (BOOL)tx_rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

/**
 告知系统当前界面的方向有变化，例如解除横屏锁定，需要刷新（注意：Xcode 13上编译iOS 16并不会主动尝试旋转页面）。
 通常在 -[UIViewController supportedInterfaceOrientations] 的值变化后调用。可取代 iOS 16 的同名系统方法。
 */
- (void)tx_setNeedsUpdateOfSupportedInterfaceOrientations;

@end

@interface UINavigationController (TXRotation)

@end


@interface UITabBarController (TXRotation)

@end
