//
//  AppDelegate.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "TXApiConfigManager.h"
#import <TXLiteAVSDK_Player/TXLiveBase.h>

@interface AppDelegate ()

@property (nonatomic, strong) MainViewController *mainViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[TXApiConfigManager shareInstance] loadConfig];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0) forBarMetrics:UIBarMetricsDefault];
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    self.window.rootViewController = navc;
    
    [self.window makeKeyAndVisible];
    
    // 设置licence
    [TXLiveBase setLicenceURL:@"your_liense_url" key:@"your_license_key"];
    
    return YES;
}

- (MainViewController *)mainViewController {
    if (!_mainViewController) {
        _mainViewController = [[MainViewController alloc] init];
    }
    return _mainViewController;
}

@end
