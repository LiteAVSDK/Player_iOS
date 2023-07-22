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




#define TintColor RGBA(252, 89, 81, 1)

#define LOG_ME NSLog(@"%s", __func__);

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONEX SCREEN_WIDTH >=375.0f && SCREEN_HEIGHT >=812.0f&& IS_IPHONE

#define HomeIndicator_Height ((IS_IPHONEX) ? 34 : 0)

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(IS_IPHONEX ? (44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)

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

#define VIP_VIDEO_DEFAULT_TIP_TITLE superPlayerLocalized(@"SuperPlayer.trywactchtitle")

#define DYNAMIC_WATERMARK_DEGREE_360 360
#define DYNAMIC_WATERMARK_DEGREE_270 270
#define DYNAMIC_WATERMARK_DEGREE_180 180
#define DYNAMIC_WATERMARK_DEGREE_90  90
#define DYNAMIC_WATERMARK_DEGREE_0   0

#define DYNAMIC_WATERMARK_BORDER_LEFT 0
#define DYNAMIC_WATERMARK_BORDER_TOP 1
#define DYNAMIC_WATERMARK_BORDER_RIGHT 2
#define DYNAMIC_WATERMARK_BORDER_BOTTOM  3

#define DEFAULT_VIDEO_RESOLUTION_FLU superPlayerLocalized(@"SuperPlayer.smooth")
#define DEFAULT_VIDEO_RESOLUTION_SD  superPlayerLocalized(@"SuperPlayer.SD")
#define DEFAULT_VIDEO_RESOLUTION_FSD superPlayerLocalized(@"SuperPlayer.FSD")
#define DEFAULT_VIDEO_RESOLUTION_HD  superPlayerLocalized(@"SuperPlayer.HD")
#define DEFAULT_VIDEO_RESOLUTION_FHD superPlayerLocalized(@"SuperPlayer.FHD")
#define DEFAULT_VIDEO_RESOLUTION_2K  superPlayerLocalized(@"SuperPlayer.2K")
#define DEFAULT_VIDEO_RESOLUTION_4K  superPlayerLocalized(@"SuperPlayer.4K")

#define DEVICE_VERSION (CGFloat) [[UIDevice currentDevice].systemVersion floatValue]
#define IS_MORE_THAN_15 (DEVICE_VERSION >= 15.0 ? YES : NO)

#define VOLUME_NOTIFICATION_NAME @"SystemVolumeDidChange"
#define VOLUME_CHANGE_PARAMATER  (IS_MORE_THAN_15 ? @"Reason" : @"AudioVolumeChangeReason")
#define VOLUME_CHANGE_KEY        (IS_MORE_THAN_15 ? @"Volume" : @"AudioVolume")
#define VOLUME_EXPLICIT_CHANGE   @"ExplicitVolumeChange"

#define PIP_START_LOADING_TEXT superPlayerLocalized(@"SuperPlayer.piploading")
#define PIP_ERROR_LOADING_TEXT superPlayerLocalized(@"SuperPlayer.pipfailed")
#define DEFAULT_PIP_LOADING_WIDTH_MARGIN 20
#define DEFAULT_PIP_LOADING_HEIGHT 50
#define DEFAULT_PIP_LOADING_LABEL_MARGIN 10
#define DEFAULT_PIP_LOADING_LABEL_HEIGHT 40
#define DEFAULT_PIP_LOADING_FONT_SIZE 14

#endif /* SuperPlayerHelpers_h */
