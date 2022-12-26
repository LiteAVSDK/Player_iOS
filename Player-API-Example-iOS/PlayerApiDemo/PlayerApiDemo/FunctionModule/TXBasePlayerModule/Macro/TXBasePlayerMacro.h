//
//  TXBasePlayerMacro.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#ifndef TXBasePlayerMacro_h
#define TXBasePlayerMacro_h

#define TX_SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define TX_SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#define TX_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define TX_IS_IPHONEX TX_SCREEN_WIDTH >=375.0f && TX_SCREEN_HEIGHT >=812.0f&& TX_IS_IPHONE

#define TX_NavBarAndStatusBarHeight (CGFloat)(TX_IS_IPHONEX?(88.0):(64.0)) // 状态栏和导航栏总高度

#define TX_TabBarHeight (TX_NavBarAndStatusBarHeight==88 ? 83 : 49)  // tabbar高度
#define TX_BottomSafeAreaHeight (TX_TabBarHeight - 49)  //底部的安全距离，全面屏手机为34pt，非全面屏手机为0pt

#define TX_BasePlayer_BACK_BTN_WIDTH   60     // 导航栏自定义返回按钮的宽度
#define TX_BasePlayer_BACK_BTN_HEIGHT  25     // 导航栏自定义返回按钮的高度

#define TX_BasePlayer_VIDEO_TOP_MARGIN 100    // 承载视频的视图距离顶部的距离
#define TX_BasePlayer_VIDEO_HEIGHT     230    // 承载视频的视图的高度
#define TX_BasePlayer_BUTTON_MARGIN    50     // 暂停按钮、继续播放按钮距离父View左右两边的距离
#define TX_BasePlayer_BUTTON_WIDTH     100    // 暂停按钮、继续播放按钮的宽度


#define TX_BasePlayer_URL "http://playertest-75538.gzc.vod.tencent-cloud.com/hls/hls_definition_source/hls_h264_1280_720.m3u8"

#define TX_BasePlayer_BACK_IMAGE_NAME "back"

#define TX_RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:(a)]
#define TX_WhiteColor     [UIColor whiteColor]
#define TX_BlackColor     [UIColor blackColor]

#define TX_BasePlayer_Bottom_Btn_Width  40
#define TX_BasePlayer_Bottom_Btn_Height 40
#define TX_BasePlayer_Bottom_Btn_Count  7
#define TX_BasePlayer_Bottom_Mar_Count  8

#define TX_BasePlayer_Bitrate_Btn_Height 30
#define TX_BasePlayer_Bitrate_Btn_Width  130
#define TX_BasePlayer_Bitrate_Padding    8
#define TX_BasePlayer_Auto_Btn_Tag       -1

#define DEFAULT_VIDEO_RESOLUTION_FLU TXBasePlayerLocalize(@"BASE_PLAYER-Module.smooth")
#define DEFAULT_VIDEO_RESOLUTION_SD  TXBasePlayerLocalize(@"BASE_PLAYER-Module.SD")
#define DEFAULT_VIDEO_RESOLUTION_FSD TXBasePlayerLocalize(@"BASE_PLAYER-Module.FSD")
#define DEFAULT_VIDEO_RESOLUTION_HD  TXBasePlayerLocalize(@"BASE_PLAYER-Module.HD")
#define DEFAULT_VIDEO_RESOLUTION_FHD TXBasePlayerLocalize(@"BASE_PLAYER-Module.FHD")
#define DEFAULT_VIDEO_RESOLUTION_2K  TXBasePlayerLocalize(@"BASE_PLAYER-Module.2K")
#define DEFAULT_VIDEO_RESOLUTION_4K  TXBasePlayerLocalize(@"BASE_PLAYER-Module.4K")


#define TX_BasePlayer_Config_Btn_Height 30
#define TX_BasePlayer_Config_Cell_Height 35

#endif /* TXBasePlayerMacro_h */
