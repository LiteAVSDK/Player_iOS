
//  Copyright (c) 2023 Tencent. All rights reserved.

#import "UIInterface+TXRotation.h"

@implementation UIViewController (TXRotation)

- (BOOL)tx_rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
#ifdef __IPHONE_16_0
    if (@available(iOS 16.0, *)) {
        [self setNeedsUpdateOfSupportedInterfaceOrientations];
        __block BOOL result = YES;
        UIInterfaceOrientationMask mask = 1 << interfaceOrientation;
        UIWindow *window = self.view.window ?: UIApplication.sharedApplication.delegate.window;
        [window.windowScene requestGeometryUpdateWithPreferences:
         [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:mask] errorHandler:^(NSError * _Nonnull error) {
            if (error) {
                result = NO;
            }
        }];
        return result;
    } else {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            NSNumber *orientationUnknown = @(UIInterfaceOrientationUnknown);
            [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:interfaceOrientation] forKey:@"orientation"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [UIViewController attemptRotationToDeviceOrientation];
        });

        return YES;
    }
#else
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        NSNumber *orientationUnknown = @(UIInterfaceOrientationUnknown);
        [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:interfaceOrientation] forKey:@"orientation"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [UIViewController attemptRotationToDeviceOrientation];
    });
    
    return YES;
#endif
}

- (void)tx_setNeedsUpdateOfSupportedInterfaceOrientations {
    
    if (@available(iOS 16.0, *)) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000
            [self setNeedsUpdateOfSupportedInterfaceOrientations];
#else            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            SEL supportedInterfaceSelector = NSSelectorFromString(@"setNeedsUpdateOfSupportedInterfaceOrientations");
            [self performSelector:supportedInterfaceSelector];
#pragma clang diagnostic pop
        
#endif
        });
        
    }

}

@end

// UINavigationController
@implementation UINavigationController (TXRotation)

- (BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return [self.viewControllers lastObject];
}

@end

// UITabBarController
@implementation UITabBarController (TXRotation)

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end
