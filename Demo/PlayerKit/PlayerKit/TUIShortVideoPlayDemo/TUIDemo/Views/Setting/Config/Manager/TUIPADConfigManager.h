//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUIPADConfigManager : NSObject
//VOD
@property (nonatomic, strong) NSString *vodResumeMode;
@property (nonatomic, strong) NSString *vodLoopMode;
@property (nonatomic, strong) NSString *vodAudioNormalization;
@property (nonatomic, strong) NSString *vodSuperResolutionType;
@property (nonatomic, strong) NSString *vodRenderMode;
//LIVE
@property (nonatomic, strong) NSString *livePip;
@property (nonatomic, strong) NSString *liveRendMode;


+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
