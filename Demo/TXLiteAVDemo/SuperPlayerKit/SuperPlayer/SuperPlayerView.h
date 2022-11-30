#import <UIKit/UIKit.h>

#import "SPVideoFrameDescription.h"
#import "SuperPlayer.h"
#import "SuperPlayerModel.h"
#import "SuperPlayerViewConfig.h"

@class SuperPlayerControlView;
@class SuperPlayerView;
@class TXImageSprite;
@class TXVipTipView;
@class TXVipWatchView;
@class TXVipWatchModel;
@class TXLivePlayer;
@class TXVodPlayer;

@protocol SuperPlayerPlayListener <NSObject>
@optional

/// 直播事件通知
/// @param player 直播播放器
/// @param evtID 参见 TXLiveSDKEventDef.h
/// @param param 参见 TXLiveSDKTypeDef.h
- (void)onLivePlayEvent:(TXLivePlayer *)player event:(int)evtID withParam:(NSDictionary *)param;

/// 直播网络状态通知
/// @param player 直播播放器
/// @param param 参见 TXLiveSDKTypeDef.h
- (void)onLiveNetStatus:(TXLivePlayer *)player withParam:(NSDictionary *)param;

/// 点播事件通知
/// @param player 点播播放器
/// @param evtID 参见TXLiveSDKTypeDef.h
/// @param param 参见TXLiveSDKTypeDef.h
- (void)onVodPlayEvent:(TXVodPlayer *)player event:(int)evtID withParam:(NSDictionary *)param;

/// 点播网络状态通知
/// @param player 点播播放器
/// @param param 参见TXLiveSDKTypeDef.h
- (void)onVodNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param;

@end

@protocol SuperPlayerDelegate <NSObject>
@optional
/// 返回事件
- (void)superPlayerBackAction:(SuperPlayerView *)player;
/// 全屏改变通知
- (void)superPlayerFullScreenChanged:(SuperPlayerView *)player;
/// 播放开始通知
- (void)superPlayerDidStart:(SuperPlayerView *)player;
/// 播放结束通知
- (void)superPlayerDidEnd:(SuperPlayerView *)player;
/// 播放错误通知
- (void)superPlayerError:(SuperPlayerView *)player errCode:(int)code errMessage:(NSString *)why;
// 需要通知到父view的事件在此添加
/// 轻拍事件回调
- (void)singleTapClick;
@end

/// 播放器的状态
typedef NS_ENUM(NSInteger, SuperPlayerState) {
    StateFailed,     // 播放失败
    StateBuffering,  // 缓冲中
    StatePrepare,    // 准备就绪
    StatePlaying,    // 播放中
    StateStopped,    // 停止播放
    StatePause,      // 暂停播放
    StateFirstFrame, // 第一帧画面
};

/// 播放器布局样式
typedef NS_ENUM(NSInteger, SuperPlayerLayoutStyle) {
    SuperPlayerLayoutStyleCompact,    ///< 精简模式
    SuperPlayerLayoutStyleFullScreen  ///< 全屏模式
};

@interface SuperPlayerView : UIView

/** 设置代理 */
@property(nonatomic, weak) id<SuperPlayerDelegate> delegate;

@property(nonatomic, weak) id<SuperPlayerPlayListener> playListener;

@property(nonatomic, assign) SuperPlayerLayoutStyle layoutStyle;

/// 设置播放器的父view。播放过程中调用可实现播放窗口转移
@property(nonatomic, weak) UIView *fatherView;
/// 播放器的状态
@property(nonatomic, assign) SuperPlayerState state;
/// 是否全屏
@property(nonatomic, assign, setter=setFullScreen:) BOOL isFullScreen;
/// 是否锁定旋转
@property(nonatomic, assign) BOOL isLockScreen;
/// 是否是直播流
@property(nonatomic, assign, readonly) BOOL isLive;
/// 是否自动播放（在playWithModel前设置)
@property(nonatomic, assign) BOOL autoPlay;
/// 超级播放器控制层
@property(nonatomic, strong) SuperPlayerControlView *controlView;
/// 是否允许竖屏手势
@property(nonatomic, assign) BOOL disableGesture;
/// 是否在手势中
@property(nonatomic, assign, readonly) BOOL isDragging;
/// 是否加载成功
@property(nonatomic, assign, readonly) BOOL isLoaded;
/// 是否允许音量按钮控制，默认是不允许
@property(nonatomic, assign) BOOL disableVolumControl;
/// 封面图片
@property(nonatomic, strong) UIImageView *coverImageView;
/// 设置vipTipView
@property(nonatomic, strong) TXVipTipView *vipTipView;
/// 设置vipWatchView
@property(nonatomic, strong) TXVipWatchView *vipWatchView;
/// 设置vip试看的model
@property(nonatomic, strong) TXVipWatchModel *vipWatchModel;
/// 设置vip试看的model
@property(nonatomic, assign) BOOL isCanShowVipTipView;
/// 重播按钮
@property(nonatomic, strong) UIButton *repeatBtn;
/// 播放按钮
@property(nonatomic, strong) UIButton *centerPlayBtn;
/// 全屏退出
@property(nonatomic, strong) UIButton *repeatBackBtn;
/// 视频总时长
@property(nonatomic, assign) CGFloat playDuration;
/// 视频当前播放时间
@property(nonatomic, assign) CGFloat playCurrentTime;
/// 起始播放时间，用于从上次位置开播
@property(nonatomic, assign) CGFloat startTime;
/// 播放的视频Model
@property(nonatomic, strong, readonly) SuperPlayerModel *playerModel;
/// 播放器配置
@property(nonatomic, strong) SuperPlayerViewConfig *playerConfig;
/// 循环播放
@property(nonatomic, assign) BOOL loop;
/**
 * 视频雪碧图
 */
@property(nonatomic, strong) TXImageSprite *imageSprite;
/**
 * 打点信息
 */
@property(nonatomic, strong) NSArray<SPVideoFrameDescription *> *keyFrameDescList;
/**
 * 播放model
 * 注意：10.7版本开始，需要通过{@link TXLiveBase#setLicence} 设置 Licence后方可成功播放， 否则将播放失败（黑屏），全局仅设置一次即可。
 * 直播License、短视频License和视频播放Licence均可使用，若您暂未获取上述Licence，可<a href="https://cloud.tencent.com/act/event/License">快速免费申请Licence</a>以正常播放
 * 
 */
- (void)playWithModelNeedLicence:(SuperPlayerModel *)playerModel;

/**
 * 播放一组视频
 * 注意：10.7版本开始，需要通过{@link TXLiveBase#setLicence} 设置 Licence后方可成功播放， 否则将播放失败（黑屏），全局仅设置一次即可。
 * 直播License、短视频License和视频播放License均可使用，若您暂未获取上述Licence，可<a href="https://cloud.tencent.com/act/event/License">快速免费申请Licence</a>以正常播放
 *  @param playModelList    视频模型数组
 *  @param isLoop    是否循环播放
 *  @param index   起始位置
 */
- (void)playWithModelListNeedLicence:(NSArray *)playModelList isLoopPlayList:(BOOL)isLoop startIndex:(NSInteger)index;

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
 * @warn isLoaded == NO 时暂停无效
 */
- (void)pause;

/**
 * 停止播放
 */
- (void)removeVideo;

/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds;

/**
 *  展示vipTipView
 */
- (void)showVipTipView;

/**
 *  隐藏vipTipView
 */
- (void)hideVipTipView;

/**
 *  展示vipWatchView
 */
- (void)showVipWatchView;

/**
 *  隐藏vipWatchView
 */
- (void)hideVipWatchView;

/**
 *  是否显示视频左上方的返回按钮
 *
 *  @param isShow 是否显示
 */
- (void)showOrHideBackBtn:(BOOL)isShow;

@end
