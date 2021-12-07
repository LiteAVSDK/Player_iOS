//
//  SuperPlayerHelpers.h
//  Pods
//
//  Created by Steven Choi on 2020/3/20.
//

#ifndef SuperPlayerHelpers_h
#define SuperPlayerHelpers_h

// player的单例
#define SuperPlayerShared [SuperPlayerSharedView sharedInstance]
// 屏幕的宽
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
// 屏幕的高
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
// 颜色值RGB
#define RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]
// 图片路径
#define SuperPlayerImage(file) [UIImage imageNamed:[@"SuperPlayer.bundle" stringByAppendingPathComponent:file]]

#define IsIPhoneX (ScreenHeight >= 812 || ScreenWidth >= 812)

// 小窗单例
#define SuperPlayerWindowShared [SuperPlayerWindow sharedInstance]

#define TintColor RGBA(252, 89, 81, 1)

#define LOG_ME NSLog(@"%s", __func__);

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONEX SCREEN_WIDTH >=375.0f && SCREEN_HEIGHT >=812.0f&& IS_IPHONE

#define VIP_TIPVIEW_DEFAULT_HEIGHT  20
#define VIP_TIPVIEW_DEFAULT_LEFT    10
#define VIP_TIPVIEW_DEFAULT_BOTTOM  40
#define VIP_TIPVIEW_DEFAULTX_BOTTOM 70

#define WINDOW_VIP_TIPVIEW_LEFT     5
#define WINDOW_VIP_TIPVIEW_BOTTOM   10
#define WINDOW_VIP_TIPVIEW_TEXT_FONT 10

#define VIP_TIPVIEW_CLOSEBTN_WIDTH  18
#define VIP_TIPVIEW_CLOSEBTN_TOP    1
#define VIP_TIPVIEW_MARGIN          2

#define VIP_WATCHVIEW_BACKBTN_LEFT  15
#define VIP_WATCHVIEW_BACKBTN_TOP   8
#define VIP_WATCHVIEW_BACKBTN_WIDTH 25

#define VIP_WATCHVIEW_OPENVIPBTN_WIDTH 200
#define VIP_WATCHVIEW_OPENVIPBTN_HEIGHT 56

#define VIP_WATCHVIEW_ENDLABEL_HEIGHT 36
#define VIP_WATCHVIEW_MARGIN 10

#define VIP_WATCHVIEW_REPEARTBTN_WIDTH 120
#define VIP_WATCHVIEW_REPEARTBTN_HEIGHT 28

#define VIP_VIDEO_DEFAULT_TIP_TITLE @"可试看15秒，开通VIP观看完整视频"

#endif /* SuperPlayerHelpers_h */
