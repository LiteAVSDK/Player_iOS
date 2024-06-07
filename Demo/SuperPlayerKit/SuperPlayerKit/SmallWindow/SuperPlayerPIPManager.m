// Copyright (c) 2024 Tencent. All rights reserved.
//

#import "SuperPlayerPIPManager.h"
@interface SuperPlayerPIPManager()

@end
@implementation SuperPlayerPIPManager

+ (instancetype)sharedInstance  {
    static SuperPlayerPIPManager *instance;
    static dispatch_once_t    onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SuperPlayerPIPManager alloc] init];
    });
    return instance;
}
- (void)show:(UIViewController *)vc {
    self.backController = vc;
    _isShowing = YES;
}
- (void)back {
    if (self.backController.parentViewController){
        return;
    }
    [self.topNavigationController pushViewController:self.backController animated:YES];
}
- (void)close {
    self.backController = nil;
    _isShowing = NO;
}

- (UINavigationController *)topNavigationController {
    UIWindow *        window            = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController       = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController.navigationController;
}
@end
