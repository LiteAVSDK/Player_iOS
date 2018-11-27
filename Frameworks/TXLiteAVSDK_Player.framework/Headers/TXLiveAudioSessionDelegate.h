#ifndef TXLiveAudioSessionDelegate_h
#define TXLiveAudioSessionDelegate_h

#import <AVFoundation/AVFoundation.h>

@protocol TXLiveAudioSessionDelegate <NSObject>

@optional
- (BOOL)setActive:(BOOL)active error:(NSError **)outError;

@optional
- (BOOL)setMode:(NSString *)mode error:(NSError **)outError;

@optional
- (BOOL)setCategory:(NSString *)category error:(NSError **)outError;

@optional
- (BOOL)setCategory:(NSString *)category withOptions:(AVAudioSessionCategoryOptions)options error:(NSError **)outError;

@optional
- (BOOL)setCategory:(NSString *)category mode:(NSString *)mode options:(AVAudioSessionCategoryOptions)options error:(NSError **)outError;

@optional
- (BOOL)setPreferredIOBufferDuration:(NSTimeInterval)duration error:(NSError **)outError;

@optional
- (BOOL)setPreferredSampleRate:(double)sampleRate error:(NSError **)outError;

@optional
- (BOOL)overrideOutputAudioPort:(AVAudioSessionPortOverride)portOverride error:(NSError **)outError;

@end
#endif /* TXLiveAudioSessionDelegate_h */
