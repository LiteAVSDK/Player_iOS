//
//  TXAppModuleMacro.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#ifndef TXAppModuleMacro_h
#define TXAppModuleMacro_h

#define TX_SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define TX_SCREEN_HEIGHT       [UIScreen mainScreen].bounds.size.height

#define TX_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define TX_IS_IPHONEX TX_SCREEN_WIDTH >=375.0f && TX_SCREEN_HEIGHT >=812.0f&& TX_IS_IPHONE

#define TX_NavBarAndStatusBarHeight (CGFloat)(TX_IS_IPHONEX?(88.0):(64.0)) //状态栏和导航栏总高度

#define TX_RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.f green:(g) / 255.f blue:(b) / 255.f alpha:(a)]
#define TX_WhiteColor     [UIColor whiteColor]
#define TX_BlackColor     [UIColor blackColor]
#define TX_ClearColor     [UIColor clearColor]

#endif /* TXAppModuleMacro_h */
