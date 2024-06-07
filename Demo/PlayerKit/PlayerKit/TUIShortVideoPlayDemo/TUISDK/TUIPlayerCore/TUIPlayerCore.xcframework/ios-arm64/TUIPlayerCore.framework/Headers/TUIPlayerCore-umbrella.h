#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TUIPlayerAuth.h"
#import "TUIPlayerBitrateItem.h"
#import "TUIPlayerCacheManager.h"
#import "TUIPlayerConfig.h"
#import "TUIPlayerCore.h"
#import "TUIPlayerCorePlayeEventHeader.h"
#import "TUIPlayerLog.h"
#import "TUIPlayerManager.h"
#import "TUIPlayerResumeManager.h"
#import "TUIPlayerStrategyManager.h"
#import "TUIPlayerStrategyModel.h"
#import "TUIPlayerVideoConfig.h"
#import "TUIPlayerVideoModel.h"
#import "TUIPlayerVideoPreloadState.h"
#import "TUITXVodPlayerWrapper.h"

FOUNDATION_EXPORT double TUIPlayerCoreVersionNumber;
FOUNDATION_EXPORT const unsigned char TUIPlayerCoreVersionString[];

