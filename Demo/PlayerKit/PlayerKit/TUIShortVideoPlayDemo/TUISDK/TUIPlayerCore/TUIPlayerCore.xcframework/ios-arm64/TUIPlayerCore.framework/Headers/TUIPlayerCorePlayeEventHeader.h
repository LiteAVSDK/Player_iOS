//
//  TUIPlayerCorePlayeEventHeader.h
//  Pods
//
//  Created by hefeima on 2024/2/1.
//

#ifndef TUIPlayerCorePlayeEventHeader_h
#define TUIPlayerCorePlayeEventHeader_h

#if __has_include(<TXLiteAVSDK_Player/TXLiveSDKEventDef.h>)
#import <TXLiteAVSDK_Player/TXLiveSDKEventDef.h>
#elif __has_include(<TXLiteAVSDK_Player_Premium/TXLiveSDKEventDef.h>)
#import <TXLiteAVSDK_Player_Premium/TXLiveSDKEventDef.h>
#elif __has_include(<TXLiteAVSDK_Professional/TXLiveSDKEventDef.h>)
#import <TXLiteAVSDK_Professional/TXLiveSDKEventDef.h>
#elif __has_include(<TXLiteAVSDK_UGC/TXLiveSDKEventDef.h>)
#import <TXLiteAVSDK_UGC/TXLiveSDKEventDef.h>
#else
#import "TXLiveSDKEventDef.h"
#endif

#if __has_include(<TXLiteAVSDK_Player/TXVodPlayConfig.h>)
#import <TXLiteAVSDK_Player/TXVodPlayConfig.h>
#elif __has_include(<TXLiteAVSDK_Player_Premium/TXVodPlayConfig.h>)
#import <TXLiteAVSDK_Player_Premium/TXVodPlayConfig.h>
#elif __has_include(<TXLiteAVSDK_Professional/TXVodPlayConfig.h>)
#import <TXLiteAVSDK_Professional/TXVodPlayConfig.h>
#elif __has_include(<TXLiteAVSDK_UGC/TXVodPlayConfig.h>)
#import <TXLiteAVSDK_UGC/TXVodPlayConfig.h>
#else
#import "TXVodPlayConfig.h"
#endif

#endif /* TUIPlayerCorePlayeEventHeader_h */
