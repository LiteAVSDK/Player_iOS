//  Copyright © 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUIPlayerLiveModel.h"
#import "TUITXLivePlayer.h"
#import "TUIPlayerLiveStrategyManager.h"
#import "TUIPlayerCore/TUIMediaDataManager+Private.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TUIPlayerLiveManagerDelegate <NSObject>

- (void)currentPlayer:(TUITXLivePlayer *)player;
- (void)liveRenderModeChanged:(V2TXLiveFillMode)renderMode;
- (void)onVideoResolutionChanged:(TUITXLivePlayer *)player
                           width:(NSInteger)width
                          height:(NSInteger)height;
@end
@interface TUIPlayerLiveManager : NSObject
///直播播放策略
@property (nonatomic, strong) TUIPlayerLiveStrategyManager *liveStrategyManager;
///当前正在播放的播放器
@property (nonatomic, strong, nullable) TUITXLivePlayer *currentLivePlayer;

///数据管理
@property (nonatomic, strong) TUIMediaDataManager *liveDataManager;


- (void)setVideoWidget:(UIView *)view
                 model:(TUIPlayerLiveModel *)model;
- (void)prePlayWithModel:(TUIPlayerLiveModel *)model
                    type:(NSInteger)type;
/// 播放model对应的player，会将player绑定到currentLivePlayer中
///
/// = setCurrentLivePlayerWithModel + playCurretLivePlayerWithModel
- (void)playWithModel:(TUIPlayerLiveModel *)model;

/// 绑定player
-(BOOL)setCurrentLivePlayerWithModel:(TUIPlayerLiveModel *)model;

/// 播放当前player
-(BOOL)playCurretLivePlayerWithModel:(TUIPlayerLiveModel *)model;

- (BOOL)nextPrePlay;
- (BOOL)lastPrePlay;



- (void)removeLivePlayerCache;
- (BOOL)removePlayerCache:(TUIPlayerLiveModel *)model;
- (BOOL)removePlayerCacheForPlayer:(TUITXLivePlayer *)player;
- (void)stopAllPlayer;
- (void)muteAllPlayer;
- (void)addDelegate:(id<TUIPlayerLiveManagerDelegate>)delegate;
- (void)removeDelegate:(id<TUIPlayerLiveManagerDelegate>)delegate;
/// 手动清除不应该缓存的player
- (void)removeUselessPlayerCache;

- (BOOL)isPlaying;
- (void)pauseAudio;
- (void)resumeAudio;
- (void)pauseVideo;
- (void)resumeVideo;
@end

NS_ASSUME_NONNULL_END
