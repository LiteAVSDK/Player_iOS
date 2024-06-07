//  Copyright © 2023 Tencent. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    Class class = NSClassFromString(@"MainViewController");
    UIViewController *mianVC = [[class alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mianVC];
    nav.navigationBar.barTintColor = [UIColor colorWithRed:5.0 / 255.0 green:30.0 / 255.0 blue:80.0 / 255.0 alpha:1];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application
    supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return self.interfaceOrientationMask ?: UIInterfaceOrientationMaskPortrait;
}


@end
