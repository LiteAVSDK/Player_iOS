//
//  TXVideoDownloadMacro.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#ifndef TXVideoDownloadLayoutMacro_h
#define TXVideoDownloadLayoutMacro_h

#define TX_SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define TX_SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#define TX_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define TX_IS_IPHONEX TX_SCREEN_WIDTH >=375.0f && TX_SCREEN_HEIGHT >=812.0f&& TX_IS_IPHONE

#define TX_NavBarAndStatusBarHeight (CGFloat)(TX_IS_IPHONEX?(88.0):(64.0)) //状态栏和导航栏总高度
#define TX_VIDEO_HEIGHT     230    // 承载视频的视图的高度
#define TX_Progress_Margin   20     // 视频下载进度条距离左右两边的间距
#define TX_Progress_HEIGHT  10     // 进度条的高度
#define TX_BUTTON_MARGIN    50     // 开始下载按钮、暂停下载按钮距离父View左右两边的距离
#define TX_BUTTON_WIDTH     100    // 开始下载按钮、暂停下载按钮的宽度

#define TX_LOADING_FONT_SIZE 14
#define TX_LOADING_WIDTH_MARGIN 20
#define TX_LOADING_HEIGHT 50
#define TX_LOADING_LABEL_MARGIN 10
#define TX_LOADING_LABEL_HEIGHT 40

#define TX_Download_BACK_IMAGE_NAME "back"
#define TX_Download_UserName "TX_VideoDownload"
#define TX_Download_Path "/downloader"
#define TX_Download_URL "http://playertest-75538.gzc.vod.tencent-cloud.com/hls/hls_definition_source/hls_h264_1280_720.m3u8"

#define TX_RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:(a)]
#define TX_WhiteColor     [UIColor whiteColor]
#define TX_BlackColor     [UIColor blackColor]

#define TX_WEAKIFY(x) __weak __typeof(x) weak_##x = x
#define TX_STRONGIFY(x) __strong __typeof(weak_##x) x = weak_##x


#endif /* TXVideoDownloadLayoutMacro_h */
