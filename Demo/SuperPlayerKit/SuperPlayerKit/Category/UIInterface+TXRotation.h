
//  Copyright (c) 2023 Tencent. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIViewController (TXRotation)
/**
  Try rotating the phone to the specified orientation. Please make sure that the parameters passed in are within the range returned by -[UIViewController supportedInterfaceOrientations], otherwise the rotation will fail.
  @return returns YES if the rotation is successful, and returns NO if the rotation fails.
  @note Please pay attention to the difference with @c tx_setNeedsUpdateOfSupportedInterfaceOrientations: If your interface supports N orientations, and you want to maintain support for these N orientations and rotate the device orientation to one of these N orientations, you should Call @c tx_rotateToInterfaceOrientation: . If your interface supports N orientations, and in some cases you want to change N to M and trigger the orientation refresh of the device, please call @c tx_setNeedsUpdateOfSupportedInterfaceOrientations after modifying the orientation.
  */
/**
 尝试将手机旋转为指定方向。请确保传进来的参数属于 -[UIViewController supportedInterfaceOrientations] 返回的范围内，如不在该范围内会旋转失败。
 @return 旋转成功则返回 YES，旋转失败返回 NO。
 @note 请注意与 @c tx_setNeedsUpdateOfSupportedInterfaceOrientations 的区别：如果你的界面支持N个方向，而你希望保持对这N个方向的支持的情况下把设备方向旋转为这N个方向里的某一个时，应该调用 @c tx_rotateToInterfaceOrientation: 。如果你的界面支持N个方向，而某些情况下你希望把N换成M并触发设备的方向刷新，则请修改方向后，调用 @c tx_setNeedsUpdateOfSupportedInterfaceOrientations 。
 */
- (BOOL)tx_rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
/**
  Inform the system that the orientation of the current interface has changed, such as unlocking the horizontal screen lock and need to refresh (note: compiling iOS 16 on Xcode 13 will not actively try to rotate the page).
  Usually called after the value of -[UIViewController supportedInterfaceOrientations] has changed. Replaces the iOS 16 system method of the same name.
  */
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
