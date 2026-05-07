//  Copyright (c) 2023 Tencent. All rights reserved.
//

#ifndef TUIPSDLiteAVSDKHeader_h
#define TUIPSDLiteAVSDKHeader_h

#if __has_include(<TXLiteAVSDK_Player/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_Player/TXLiteAVSDK.h>
#elif __has_include(<TXLiteAVSDK_Player_Premium/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_Player_Premium/TXLiteAVSDK.h>
#elif __has_include(<TXLiteAVSDK_Professional/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_Professional/TXLiteAVSDK.h>
#elif __has_include(<TXLiteAVSDK_UGC/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>
#elif __has_include(<TXLiteAVSDK_Player_Mini/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_Player_Mini/TXLiteAVSDK.h>
#else
#import "TXLiteAVSDK.h"
#endif

#endif /* TUIPSDLiteAVSDKHeader_h */
