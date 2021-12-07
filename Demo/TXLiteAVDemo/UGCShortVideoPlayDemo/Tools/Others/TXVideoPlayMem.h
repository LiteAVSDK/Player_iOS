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


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONEX SCREEN_WIDTH >=375.0f && SCREEN_HEIGHT >=812.0f&& IS_IPHONE

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(IS_IPHONEX?(44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(IS_IPHONEX?(88.0):(64.0))
/*TabBar高度*/
#define kTabBarHeight (CGFloat)(IS_IPHONEX?(49.0 + 34.0):(49.0))
/*顶部安全区域远离高度*/
#define kTopBarSafeHeight (CGFloat)(IS_IPHONEX?(44.0):(0))
 /*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(IS_IPHONEX?(34.0):(0))
/*iPhoneX的状态栏高度差值*/
#define kTopBarDifHeight (CGFloat)(IS_IPHONEX?(24.0):(0))
/*导航条和Tabbar总高度*/
#define kNavAndTabHeight (kNavBarAndStatusBarHeight + kTabBarHeight)


#define DEFAULT_VIDEOPLAYER_CACHE_COUNT 3

#define DEFAULT_VIDEO_COUNT_SCREEN 1

#endif /* TXVideoPlayMem_h */
