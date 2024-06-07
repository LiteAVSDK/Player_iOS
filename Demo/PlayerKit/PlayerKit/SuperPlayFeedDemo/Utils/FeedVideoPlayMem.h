//
//  FeedVideoPlayMem.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/29.
//  Copyright © 2021 Tencent. All rights reserved.
//

#ifndef FeedVideoPlayMem_h
#define FeedVideoPlayMem_h

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#define STATUS_HEIGHT       [[UIApplication sharedApplication] statusBarFrame].size.height

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONEX SCREEN_WIDTH >=375.0f && SCREEN_HEIGHT >=812.0f&& IS_IPHONE

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(IS_IPHONEX ? (44.0):(20.0))
/*导航栏高度*/
#define kNavBarHeight (44)
/*状态栏和导航栏总高度*/
#define kNavBarAndStatusBarHeight (CGFloat)(IS_IPHONEX?(88.0):(64.0))

#define cellHeight (SCREEN_WIDTH - 16) * 9 / 16

#endif /* FeedVideoPlayMem_h */
