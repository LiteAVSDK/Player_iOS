//  Copyright © 2025 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import "TXLiveSDKTypeDef.h"
@class DRMPlayerVideoInfo;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DRMPlayerScreenMode) {
    DRMPlayerScreenModePortrait = 0,
    DRMPlayerScreenModeLandscape = 1,
};

typedef NS_ENUM(NSUInteger, DRMPlayerStatus) {
    DRMPlayerStatusIdle = 0,
    DRMPlayerStatusLoading = 1,
    DRMPlayerStatusPrepared = 2,
    DRMPlayerStatusPlaying = 3,
    DRMPlayerStatusPause = 4,
    DRMPlayerStatusError = 5,
    DRMPlayerStatusPlayEnd = 6,
};

@interface DRMPlayerControlModel : NSObject

@property (nonatomic, assign) DRMPlayerStatus status;

@property (nonatomic, assign, getter = isMute) BOOL mute;

@property (nonatomic, assign) BOOL hardware;

@property (nonatomic, assign) BOOL logSwitch;

@property (nonatomic, assign) BOOL cacheEnable;

@property (nonatomic, assign) DRMPlayerScreenMode screenMode;

@property (nonatomic, assign) TX_Enum_Type_RenderMode renderMode;

@property (nonatomic, copy) NSString *playerLog;

@property (nonatomic, assign, getter = isSeeking) BOOL seeking;

@property (nonatomic, strong) DRMPlayerVideoInfo *videoInfo;

/**
 * @brief Initialize player log
 */
- (void)initPlayerLog;

/**
 * @brief Append player log
 */
- (void)appendLogWithParams:(NSDictionary *)params;

/**
 * @brief Reset player status data
 */
- (void)reset;

@end

@interface DRMPlayerVideoInfo : NSObject

@property (nonatomic, copy) NSString *videoURL;

@property (nonatomic, copy) NSString *license;

@property (nonatomic, copy) NSString *certificate;

@end

NS_ASSUME_NONNULL_END
