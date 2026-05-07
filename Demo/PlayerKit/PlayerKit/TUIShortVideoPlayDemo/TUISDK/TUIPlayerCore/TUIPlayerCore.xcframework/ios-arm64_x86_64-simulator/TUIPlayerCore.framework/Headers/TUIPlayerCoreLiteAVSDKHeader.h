// Copyright (c) 2022 Tencent. All rights reserved.

#ifndef TUIPlayerCoreLiteAVSDKHeader_h
#define TUIPlayerCoreLiteAVSDKHeader_h

#if __has_include(<TXLiteAVSDK_Player/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_Player/TXLiteAVSDK.h>
#elif __has_include(<TXLiteAVSDK_Player_Premium/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_Player_Premium/TXLiteAVSDK.h>
#elif __has_include(<TXLiteAVSDK_Professional/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_Professional/TXLiteAVSDK.h>
#elif __has_include(<TXLiteAVSDK_UGC/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>
#else
#import "TXLiteAVSDK.h"
#endif


#endif /* TUIPlayerCoreLiteAVSDKHeader_h */
