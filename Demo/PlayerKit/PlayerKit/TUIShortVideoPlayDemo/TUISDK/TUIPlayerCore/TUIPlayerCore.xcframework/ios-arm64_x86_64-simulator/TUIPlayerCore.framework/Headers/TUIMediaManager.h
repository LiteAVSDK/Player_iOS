#import <Foundation/Foundation.h>
#import "TUIPlayerCore/TUIPlayerLiveManager.h"
#import "TUIPlayerCore/TUIPlayerVodManager.h"
#import "TUIPlayerCore/TUIMediaDataManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface TUIMediaManager : NSObject

@property (nonatomic, strong) TUIPlayerLiveManager *liveManager;
@property (nonatomic, strong) TUIPlayerVodManager *vodManager;
///当前绑定的vod player
//@property (nonatomic, strong) TUITXVodPlayer *currentVodPlayer;
///当前绑定的live player
//@property (nonatomic, strong) TUITXLivePlayer *currentLivePlayer;
///数据管理
@property (nonatomic, strong) TUIMediaDataManager *dataManager;

- (BOOL)nextPreplay;
- (BOOL)lastPreplay;

- (BOOL)isPlaying;

/// 清除所有live + vod player的缓存
- (void)removeAllPlayerCache;
/// 停止所有live + vod player
- (void)stopAllPlayers;
/// 暂停live(audio/video) + vod currentPlayer
- (void)pauseCurrentPlayer;
/// 销毁live + vodcurrentPlayer
- (void)destroyCurrentPlayer;
/// 静音live + vod player
- (void)muteAllPlayers;
/// 清除live + vod 中currentPlayer的缓存
- (void)removeCurrentPlayerCache;
/// 从UI上移除 live + vod 中currentPlayer
- (void)removeCurrentPlayerVideo;

@end
NS_ASSUME_NONNULL_END
