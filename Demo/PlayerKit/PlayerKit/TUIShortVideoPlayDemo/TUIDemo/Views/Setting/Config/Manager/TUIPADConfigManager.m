//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import "TUIPADConfigManager.h"
@interface TUIPADConfigManager ()

@end
@implementation TUIPADConfigManager
@synthesize vodResumeMode = _vodResumeMode;
@synthesize vodLoopMode = _vodLoopMode;
@synthesize vodAudioNormalization = _vodAudioNormalization;
@synthesize vodSuperResolutionType = _vodSuperResolutionType;
@synthesize vodRenderMode = _vodRenderMode;
@synthesize livePip = _livePip;
@synthesize liveRendMode = _liveRendMode;
+ (instancetype)sharedManager {
    static TUIPADConfigManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

///VOD
- (NSString *)vodResumeMode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _vodResumeMode = [defaults objectForKey:@"vodResumeMode"];
    if (!_vodResumeMode) {
        _vodResumeMode = @"NONE";
        [defaults setObject:_vodResumeMode forKey:@"vodResumeMode"];
        [defaults synchronize];
    }
    
    return _vodResumeMode;
}
- (void)setVodResumeMode:(NSString *)vodResumeMode {
    if (!vodResumeMode) {
        return;
    }
    _vodResumeMode = vodResumeMode;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:vodResumeMode forKey:@"vodResumeMode"];
    [defaults synchronize];
}

- (NSString *)vodLoopMode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _vodLoopMode = [defaults objectForKey:@"vodLoopMode"];
    if (!_vodLoopMode) {
        _vodLoopMode = @"ONE_LOOP";
        [defaults setObject:_vodLoopMode forKey:@"vodLoopMode"];
        [defaults synchronize];
    }
    return _vodLoopMode;
}
- (void)setVodLoopMode:(NSString *)vodLoopMode {
    if (!_vodLoopMode) {
        return;
    }
    _vodLoopMode = vodLoopMode;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:vodLoopMode forKey:@"vodLoopMode"];
    [defaults synchronize];
}

- (NSString *)vodAudioNormalization {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _vodAudioNormalization = [defaults objectForKey:@"vodAudioNormalization"];
    if (!_vodAudioNormalization) {
        _vodAudioNormalization = @"OFF";
        [defaults setObject:_vodAudioNormalization forKey:@"vodAudioNormalization"];
        [defaults synchronize];
    }
    return _vodAudioNormalization;
}
- (void)setVodAudioNormalization:(NSString *)vodAudioNormalization {
    if (!vodAudioNormalization) {
        return;
    }
    _vodAudioNormalization = vodAudioNormalization;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_vodAudioNormalization forKey:@"vodAudioNormalization"];
    [defaults synchronize];
}
- (NSString *)vodSuperResolutionType {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _vodSuperResolutionType = [defaults objectForKey:@"vodSuperResolutionType"];
    if (!_vodSuperResolutionType) {
        _vodSuperResolutionType = @"OFF";
        [defaults setObject:_vodSuperResolutionType forKey:@"vodSuperResolutionType"];
        [defaults synchronize];
    }
    return _vodSuperResolutionType;
}
- (void)setVodSuperResolutionType:(NSString *)vodSuperResolutionType {
    if (!vodSuperResolutionType) {
        return;
    }
    _vodSuperResolutionType = vodSuperResolutionType;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_vodSuperResolutionType forKey:@"vodSuperResolutionType"];
    [defaults synchronize];
}
- (NSString *)vodRenderMode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _vodRenderMode = [defaults objectForKey:@"vodRenderMode"];
    if (!_vodRenderMode) {
        _vodRenderMode = @"FILL_EDGE";
        [defaults setObject:_vodRenderMode forKey:@"vodRenderMode"];
        [defaults synchronize];
    }
    return _vodRenderMode;
}
- (void)setVodRenderMode:(NSString *)vodRenderMode {
    if (!vodRenderMode) {
        return;
    }
    _vodRenderMode = vodRenderMode;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_vodRenderMode forKey:@"vodRenderMode"];
    [defaults synchronize];
}

//LIVE
- (NSString *)livePip {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _livePip = [defaults objectForKey:@"livePip"];
    if (!_livePip) {
        _livePip = @"OFF";
        [defaults setObject:_livePip forKey:@"livePip"];
        [defaults synchronize];
    }
    return _livePip;
}
- (void)setLivePip:(NSString *)livePip {
    if (!livePip) {
        return;
    }
    _livePip = livePip;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_livePip forKey:@"livePip"];
    [defaults synchronize];
}
- (NSString *)liveRendMode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _liveRendMode = [defaults objectForKey:@"liveRendMode"];
    if (!_liveRendMode) {
        _liveRendMode = @"Fill";
        [defaults setObject:_liveRendMode forKey:@"liveRendMode"];
        [defaults synchronize];
    }
    return _liveRendMode;
}
- (void)setLiveRendMode:(NSString *)liveRendMode {
    if (!liveRendMode) {
        return;
    }
    _liveRendMode = liveRendMode;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_liveRendMode forKey:@"liveRendMode"];
    [defaults synchronize];
}
@end
