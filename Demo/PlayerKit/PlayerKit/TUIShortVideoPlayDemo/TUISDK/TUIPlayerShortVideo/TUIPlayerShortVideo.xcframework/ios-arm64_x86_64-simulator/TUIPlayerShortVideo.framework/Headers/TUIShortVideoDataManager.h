// Copyright (c) 2024 Tencent. All rights reserved.
//
#if __has_include(<TUIPlayerCore/TUIMediaDataManager.h>)
#import <TUIPlayerCore/TUIMediaDataManager.h>
#else
#import "TUIMediaDataManager.h"
#endif

#if __has_include(<TUIPlayerCore/TUIMediaDataManager+Private.h>)
#import <TUIPlayerCore/TUIMediaDataManager+Private.h>
#else
#import "TUIMediaDataManager+Private.h"
#endif



NS_ASSUME_NONNULL_BEGIN

@protocol TUIShortVideoDataManagerDelegate <TUIMediaDataManagerDelegate>
@end

@interface TUIShortVideoDataManager : TUIMediaDataManager
@end


NS_ASSUME_NONNULL_END
