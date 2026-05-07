// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import "TUITXVodPlayer.h"
#import "TUIPlayerVideoModel.h"
#import "TUIPlayerVodStrategyManager.h"
#import "TUIPlayerRecordManager.h"
#import "TUIPlayerCore/TUIPlayerVodPreLoadManager.h"
#import "TUIPlayerCore/TUIMediaDataManager.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TUIPlayerVodManagerDelegate <NSObject>
@optional
- (void)currentPlayer:(TUITXVodPlayer *)player;
- (void)onPlayEvent:(TUITXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param ;
- (void)onNetStatus:(TUITXVodPlayer *)player withParam:(NSDictionary *)param ;
- (void)player:(TUITXVodPlayer *)player statusChanged:(TUITXVodPlayerStatus)status;
- (void)player:(TUITXVodPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress;
- (void)vodRenderModeChanged:(TUI_Enum_Type_RenderMode)renderMode;
- (void)player:(TUITXVodPlayer *)player willLoadVideoModel:(TUIPlayerVideoModel *)videoModel;
- (void)onPlayer:(TUITXVodPlayer *)player subtitleData:(TXVodSubtitleData *)subtitleData;
@end
///播放器预加载缓存管理
@interface TUIPlayerVodManager : NSObject

///视频播放设置策略管理
@property (nonatomic, strong) TUIPlayerVodStrategyManager *vodStrategyManager;
///当前正在播放的播放器
@property (nonatomic, strong, nullable) TUITXVodPlayer *currentVodPlayer;
///视频预加载管理
@property (nonatomic, strong) TUIPlayerVodPreLoadManager *vodPreLoadManager;
///数据管理
@property (nonatomic, strong) TUIMediaDataManager *vodDataManager;

@property (nonatomic, assign) BOOL loop;
- (void)addDelegate:(id<TUIPlayerVodManagerDelegate>)delegate;
- (void)removeDelegate:(id<TUIPlayerVodManagerDelegate>)delegate;

/// 一定从缓存中拿出model对应的player并绑定
- (BOOL)setVideoWidget:(UIView *)view
                 model:(TUIPlayerVideoModel *)model
    firstFrameCallBack:(void (^)(BOOL isFirstFrame))firstFrameCallBack;

/// 移除currentVodPlayer的widget
- (void)removeCurrentWidget;

/// 播放model对应的player  =  绑定currentPlayer + 播放currentPlayer
- (void)playWithModel:(TUIPlayerVideoModel *)model;

/// 绑定player
-(BOOL)setCurrentVodPlayerWithModel:(TUIPlayerVideoModel *)model;

/// 播放当前player
-(BOOL)playCurretVodPlayerWithModel:(TUIPlayerVideoModel *)model;


/// 获取player ，会尝试从缓存中取出
- (TUITXVodPlayer *)getPlayerWithModel:(TUIPlayerVideoModel *)model
                                   type:(NSInteger)type;

/// 获取预播放的player
/// 如果type -> 0,一定会取出没有缓存过的player
- (TUITXVodPlayer *)getPrePlayerWithModel:(TUIPlayerVideoModel *)model
                                      type:(NSInteger)type;

/// 记录当前视频的播放时长
- (void)recordCurrentPlayBackTime;

/**
 * 预播放
 * @param model 视频模型
 */
- (void)prePlayWithModel:(TUIPlayerVideoModel *)model
                    type:(NSInteger)type;
- (void)firstPrePlayWithModel:(TUIPlayerVideoModel *)model;

- (BOOL)nextPrePlay;
- (BOOL)lastPrePlay;

/**
 * 移除播放器缓存
 */
- (void)removeAllPlayerCache;
- (BOOL)removePlayerCache:(TUIPlayerVideoModel *)model;
- (BOOL)removePlayerCacheForPlayer:(TUITXVodPlayer *)player;
/// 手动清除不应该缓存的player
- (void)removeUselessPlayerCache;
/**
 * 销毁所有播放器
 */
- (void)stopAllPlayer;
- (void)resetAllPlayer;
- (void)muteAllPlayer;
- (void)pause;
- (void)resume;

/// 销毁CurrentVodPlayer
- (void)destroyCurrentVodPlayer;
@end

NS_ASSUME_NONNULL_END
