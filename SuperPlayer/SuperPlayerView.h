#import <UIKit/UIKit.h>
#import "SuperPlayer.h"
#import "SuperPlayerModel.h"
#import "TXVodPlayer.h"
#import "TXLivePlayer.h"
#import "TXLiveBase.h"
#import "TXImageSprite.h"

@protocol SuperPlayerDelegate <NSObject>
@optional
/** 返回按钮事件 */
- (void)onPlayerBackAction;
// 需要通知到父view的事件在此添加
@end

// 播放器的几种状态
typedef NS_ENUM(NSInteger, SuperPlayerState) {
    StateFailed,     // 播放失败
    StateBuffering,  // 缓冲中
    StatePlaying,    // 播放中
    StateStopped,    // 停止播放
    StatePause       // 暂停播放
};


@interface SuperPlayerView : UIView

/** 设置代理 */
@property (nonatomic, weak) id<SuperPlayerDelegate>      delegate;

/**
 * 设置播放器的父view。播放过程中调用可实现播放窗口转移
 */
@property (nonatomic, weak) UIView *fatherView;

/** 播放器的状态 */
@property (nonatomic, assign) SuperPlayerState       state;
/** 是否全屏 */
@property (nonatomic, assign) BOOL isFullScreen;
/** 是否锁定旋转 */
@property (nonatomic, assign) BOOL isLockScreen;
/** 是否是直播流 */
@property (readonly) BOOL isLive;
/**
 * 播放model
 */
- (void)playWithModel:(SuperPlayerModel *)playerModel;

/**
 * 重置player
 */
- (void)resetPlayer;

/**
 * 播放
 */
- (void)resume;

/**
 * 暂停
 */
- (void)pause;

/**
 * 是否显示控制层
 */
- (void)showControlView:(BOOL)isShow;
@end
