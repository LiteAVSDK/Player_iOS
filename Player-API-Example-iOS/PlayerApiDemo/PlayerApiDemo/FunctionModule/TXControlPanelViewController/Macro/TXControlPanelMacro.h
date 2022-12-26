//
//  TXControlPanelMacro.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#ifndef TXControlPanelMacro_h
#define TXControlPanelMacro_h

#define TX_SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define TX_SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#define TX_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define TX_IS_IPHONEX TX_SCREEN_WIDTH >=375.0f && TX_SCREEN_HEIGHT >=812.0f&& TX_IS_IPHONE

#define TX_NavBarAndStatusBarHeight (CGFloat)(TX_IS_IPHONEX?(88.0):(64.0)) //状态栏和导航栏总高度

#define TX_ControlPanel_BACK_BTN_WIDTH   60     // 导航栏自定义返回按钮的宽度
#define TX_ControlPanel_BACK_BTN_HEIGHT  25     // 导航栏自定义返回按钮的高度

#define TX_ControlPanel_VIDEO_TOP_MARGIN 100    // 承载视频的视图距离顶部的距离
#define TX_ControlPanel_VIDEO_HEIGHT     230    // 承载视频的视图的高度


#define TX_ControlPanel_URL "http://playertest-75538.gzc.vod.tencent-cloud.com/hls/hls_definition_source/hls_h264_1280_720.m3u8"

#define TX_ControlPanel_BACK_IMAGE_NAME "back"
#define TX_ControlPanel_Logo "TengXunYun_logo"

#define TX_RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:(a)]
#define TX_WhiteColor     [UIColor whiteColor]
#define TX_BlackColor     [UIColor blackColor]

#define TX_ControlPanel_Image_Width 100
#define TX_ControlPanel_Image_Height 100

#define TX_ControlPanel_Default_Seek 10

#endif /* TXControlPanelMacro_h */
