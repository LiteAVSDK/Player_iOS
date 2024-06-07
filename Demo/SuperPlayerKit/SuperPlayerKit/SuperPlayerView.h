#import <UIKit/UIKit.h>

#import "SPVideoFrameDescription.h"
#import "SuperPlayer.h"
#import "SuperPlayerModel.h"
#import "SuperPlayerViewConfig.h"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
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

/**
 * Live event notification
 * @param player Live player
 * @param evtID see TXLiveSDKEventDef.h
 * @param param see TXLiveSDKTypeDef.h
 */
/**
 * 直播事件通知
 * @param player 直播播放器
 * @param evtID 参见 TXLiveSDKEventDef.h
 * @param param 参见 TXLiveSDKTypeDef.h
 */
- (void)onLivePlayEvent:(TXLivePlayer *)player event:(int)evtID withParam:(NSDictionary *)param;

/**
  * Live network status notification
  * @param player Live player
  * @param param see TXLiveSDKTypeDef.h
  */
/**
 * 直播网络状态通知
 * @param player 直播播放器
 * @param param 参见 TXLiveSDKTypeDef.h
 */
- (void)onLiveNetStatus:(TXLivePlayer *)player withParam:(NSDictionary *)param;

/**
  * On-demand event notification
  * @param player on-demand player
  * @param evtID see TXLiveSDKTypeDef.h
  * @param param see TXLiveSDKTypeDef.h
  */
/**
 * 点播事件通知
 * @param player 点播播放器
 * @param evtID 参见TXLiveSDKTypeDef.h
 * @param param 参见TXLiveSDKTypeDef.h
 */
- (void)onVodPlayEvent:(TXVodPlayer *)player event:(int)evtID withParam:(NSDictionary *)param;

/**
  * On-demand network status notification
  * @param player on-demand player
  * @param param see TXLiveSDKTypeDef.h
  */
/**
 * 点播网络状态通知
 * @param player 点播播放器
 * @param param 参见TXLiveSDKTypeDef.h
 */
- (void)onVodNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param;

@end

@protocol SuperPlayerDelegate <NSObject>
@optional
/// return event
/// 返回事件
- (void)superPlayerBackAction:(SuperPlayerView *)player;
/// Full screen change notification
/// 全屏改变通知
- (void)superPlayerFullScreenChanged:(SuperPlayerView *)player;
/// Play start notification
/// 播放开始通知
- (void)superPlayerDidStart:(SuperPlayerView *)player;
/// Play end notification
/// 播放结束通知
- (void)superPlayerDidEnd:(SuperPlayerView *)player;
/// Play error notification
/// 播放错误通知
- (void)superPlayerError:(SuperPlayerView *)player errCode:(int)code errMessage:(NSString *)why;
// Events that need to be notified to the parent view are added here
// 需要通知到父view的事件在此添加
/// Tap event callback
/// 轻拍事件回调
- (void)singleTapClick;
/// lock screen
///锁屏
- (void)lockScreen:(BOOL)lock;
///Screen rotation
///屏幕旋转
- (void)screenRotation:(BOOL)fullScreen;
///Full screen button hook event
///全屏按钮hook事件
- (void)fullScreenHookAction;
///Back button hook event
///返回按钮hook事件
- (void)backHookAction;
@end

/// The state of the player
/// 播放器的状态
typedef NS_ENUM(NSInteger, SuperPlayerState) {
    StateFailed,     /// play failed & 播放失败
    StateBuffering,  /// buffering & 缓冲中
    StatePrepare,    /// Ready & 准备就绪
    StatePlaying,    /// playing & 播放中
    StateStopped,    /// Stop play & 停止播放
    StatePause,      /// Pause playback & 暂停播放
    StateFirstFrame, /// first frame & 第一帧画面
};

/// Player layout style
/// 播放器布局样式
typedef NS_ENUM(NSInteger, SuperPlayerLayoutStyle) {
    SuperPlayerLayoutStyleCompact,    ///lite mode & 精简模式
    SuperPlayerLayoutStyleFullScreen  ///full screen mode & 全屏模式
};

@interface SuperPlayerView : UIView

/** Set proxy */
/** 设置代理 */
@property(nonatomic, weak) id<SuperPlayerDelegate> delegate;

@property(nonatomic, weak) id<SuperPlayerPlayListener> playListener;

@property(nonatomic, assign) SuperPlayerLayoutStyle layoutStyle;

/// Set the parent view of the player. Calling during playback can realize the transfer of the playback window
/// 设置播放器的父view。播放过程中调用可实现播放窗口转移
@property(nonatomic, weak) UIView *fatherView;
/// The state of the player
/// 播放器的状态
@property(nonatomic, assign) SuperPlayerState state;
/// Whether full screen
/// 是否全屏
@property(nonatomic, assign, setter=setFullScreen:) BOOL isFullScreen;
/// Whether to lock the rotation
/// 是否锁定旋转
@property(nonatomic, assign) BOOL isLockScreen;
/// Whether it is a live stream
/// 是否是直播流
@property(nonatomic, assign, readonly) BOOL isLive;
/// Whether to play automatically (set before playWithModel)
/// 是否自动播放（在playWithModel前设置)
@property(nonatomic, assign) BOOL autoPlay;
/// Super player control layer
/// 超级播放器控制层
@property(nonatomic, strong) SuperPlayerControlView *controlView;
/// Whether to allow vertical screen gestures
/// 是否允许竖屏手势
@property(nonatomic, assign) BOOL disableGesture;
/// Is it in the gesture
/// 是否在手势中
@property(nonatomic, assign, readonly) BOOL isDragging;
/// Is the loading successful?
/// 是否加载成功
@property(nonatomic, assign, readonly) BOOL isLoaded;
/// Whether to allow volume button control, the default is not allowed
/// 是否允许音量按钮控制，默认是不允许
@property(nonatomic, assign) BOOL disableVolumControl;
/// cover image
/// 封面图片
@property(nonatomic, strong) UIImageView *coverImageView;
/// Set vipTipView
/// 设置vipTipView
@property(nonatomic, strong) TXVipTipView *vipTipView;
/// Set vipWatchView
/// 设置vipWatchView
@property(nonatomic, strong) TXVipWatchView *vipWatchView;
/// Set the model for vip trial
/// 设置vip试看的model
@property(nonatomic, strong) TXVipWatchModel *vipWatchModel;
/// Set the model for vip trial
/// 设置vip试看的model
@property(nonatomic, assign) BOOL isCanShowVipTipView;
/// Replay button
/// 重播按钮
@property(nonatomic, strong) UIButton *repeatBtn;
/// play button
/// 播放按钮
@property(nonatomic, strong) UIButton *centerPlayBtn;
/// Full screen exit
/// 全屏退出
@property(nonatomic, strong) UIButton *repeatBackBtn;
/// Total video duration
/// 视频总时长
@property(nonatomic, assign) CGFloat playDuration;
/// The current playing time of the video
/// 视频当前播放时间
@property(nonatomic, assign) CGFloat playCurrentTime;
/// Start playing time, used to start playing from the last position
/// 起始播放时间，用于从上次位置开播
@property(nonatomic, assign) CGFloat startTime;
/// Played video Model
/// 播放的视频Model
@property(nonatomic, strong, readonly) SuperPlayerModel *playerModel;
/// Player configuration
/// 播放器配置
@property(nonatomic, strong) SuperPlayerViewConfig *playerConfig;
/// Loop
/// 循环播放
@property(nonatomic, assign) BOOL loop;
/// Video Sprite
/// 视频雪碧图
@property(nonatomic, strong) TXImageSprite *imageSprite;
/// RBI information
/// 打点信息
@property(nonatomic, strong) NSArray<SPVideoFrameDescription *> *keyFrameDescList;
/// PIP Begain
/// 是否正在开启画中画
@property(nonatomic, assign) BOOL isPipStart;
/**
  * play model
  * Note: Starting from version 10.7, you need to set the License through {@link TXLiveBase#setLicence} before you can successfully play, otherwise the playback will fail (black screen), and you only need to set it once globally.
  * Live broadcast license, short video license and video playback license can all be used. If you have not obtained the above licenses yet, you can <a href="https://cloud.tencent.com/act/event/License">quickly apply for a license for free </a> to play normally
  *
  */
/**
 * 播放model
 * 注意：10.7版本开始，需要通过{@link TXLiveBase#setLicence} 设置 Licence后方可成功播放， 否则将播放失败（黑屏），全局仅设置一次即可。
 * 直播License、短视频License和视频播放Licence均可使用，若您暂未获取上述Licence，可<a href="https://cloud.tencent.com/act/event/License">快速免费申请Licence</a>以正常播放
 * 
 */
- (void)playWithModelNeedLicence:(SuperPlayerModel *)playerModel;
/**
  * Play a set of videos
  * Note: Starting from version 10.7, you need to set the License through {@link TXLiveBase#setLicence} before you can successfully play, otherwise the playback will fail (black screen), and you only need to set it once globally.
  * Live broadcast license, short video license and video playback license are all available. If you have not obtained the above licenses yet, you can <a href="https://cloud.tencent.com/act/event/License">quickly apply for a license for free </a> to play normally
  * @param playModelList video model array
  * @param isLoop whether to loop
  * @param index starting position
  */
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
  * reset player
  */
/**
 * 重置player
 */
- (void)resetPlayer;
/**
  * play
  */
/**
 * 播放
 */
- (void)resume;
/**
  * pause
  * Pause is invalid when @warn isLoaded == NO
  */
/**
 * 暂停
 * @warn isLoaded == NO 时暂停无效
 */
- (void)pause;
/**
  * Stop play
  */
/**
 * 停止播放
 */
- (void)removeVideo;
/**
  * Start playing video jump from xx seconds
  *
  * @param dragedSeconds seconds of video jump
  */
/**
 *  从xx秒开始播放视频跳转
 *
 *  @param dragedSeconds 视频跳转的秒数
 */
- (void)seekToTime:(NSInteger)dragedSeconds;
/**
  * Show vipTipView
  */
/**
 *  展示vipTipView
 */
- (void)showVipTipView;
/**
  * hide vipTipView
  */
/**
 *  隐藏vipTipView
 */
- (void)hideVipTipView;
/**
  * Display vipWatchView
  */
/**
 *  展示vipWatchView
 */
- (void)showVipWatchView;
/**
  * hide vipWatchView
  */
/**
 *  隐藏vipWatchView
 */
- (void)hideVipWatchView;
/**
  * Whether to show the back button at the top left of the video
  *
  * @param isShow whether to display
  */
/**
 *  是否显示视频左上方的返回按钮
 *
 *  @param isShow 是否显示
 */
- (void)showOrHideBackBtn:(BOOL)isShow;
/**
  * Enter the picture-in-picture function (this method needs to be called after Prepared)
  */
/**
 * 进入画中画功能（此方法需要在Prepared后调用）
 */
- (void)enterPictureInPicture;
/**
  * Exit picture-in-picture function
  */
/**
 * 退出画中画功能
 */
- (void)exitPictureInPicture;
/**
 * 是否支持 Picture In Picture功能（‘画中画’功能）
 * 使用画中画能力时需要判断当前设备是否支持
 */
- (BOOL)isSupportPictureInPicture;
@end
#pragma clang diagnostic pop
