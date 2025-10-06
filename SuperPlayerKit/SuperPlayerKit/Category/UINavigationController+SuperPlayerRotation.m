#import <objc/runtime.h>

#import "UINavigationController+SuperPlayerRotation.h"

@implementation UINavigationController (SuperPlayerRotation)
/**
  * If the root view of the window is UINavigationController, the Category will be called first, and then UIViewController+SuperPlayerRotation will be called
  * Only need to redo the following three methods on pages that support orientations other than vertical screen
  */
/**
 * 如果window的根视图是UINavigationController，则会先调用这个Category，然后调用UIViewController+SuperPlayerRotation
 * 只需要在支持除竖屏以外方向的页面重新下边三个方法
 */

// Whether to support automatic screen transfer
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

// Which screen orientations are supported
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

// The default screen direction (the current ViewController must be displayed through a modal UIViewController (modal with navigation invalid) to call this method)
// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

@end
