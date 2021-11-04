//
//  TXVideoPlayMem.h
//  TXLiteAVDemo_Player
//
//  Created by 路鹏 on 2021/9/2.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef TXVideoPlayMem_h
#define TXVideoPlayMem_h

#define WEAKIFY(x) __weak __typeof(x) weak_##x = x
#define STRONGIFY(x) __strong __typeof(weak_##x) x = weak_##x
#define STRONGIFY_OR_RETURN(x) __strong __typeof(weak_##x) x = weak_##x; if (x == nil) {return;};

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#define STATUS_HEIGHT       [[UIApplication sharedApplication] statusBarFrame].size.height

// 适配比例
#define GENERALRATIO        SCREEN_WIDTH / 750.0f


#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kIs_iPhoneX SCREEN_WIDTH >=375.0f && SCREEN_HEIGHT >=812.0f&& kIs_iphone

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(kIs_iPhoneX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(kIs_iPhoneX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(kIs_iPhoneX?(44.0):(0))
 /*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(kIs_iPhoneX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)


#define kTXDefaultVideoPlayerCacheCount 3

#define kTXDefaultVideoCountOfScreen 1

#endif /* TXVideoPlayMem_h */
