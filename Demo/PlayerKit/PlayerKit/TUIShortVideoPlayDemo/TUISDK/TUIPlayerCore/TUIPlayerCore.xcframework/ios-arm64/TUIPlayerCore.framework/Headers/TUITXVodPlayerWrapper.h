// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TUIPlayerVideoModel.h"
#import "TUIPlayerStrategyManager.h"
#import "TUIPlayerBitrateItem.h"
NS_ASSUME_NONNULL_BEGIN

// 播放器状态
typedef NS_ENUM(NSUInteger, TUITXVodPlayerStatus) {
    TUITXVodPlayerStatusUnload   = 0,  // 未加载
    TUITXVodPlayerStatusPrepared = 1,  // 准备播放
    TUITXVodPlayerStatusLoading  = 2,  // 加载中
    TUITXVodPlayerStatusPlaying  = 3,  // 播放中
    TUITXVodPlayerStatusPaused   = 4,  // 暂停
    TUITXVodPlayerStatusEnded    = 5,  // 播放完成
    TUITXVodPlayerStatusError    = 6,  // 错误
};

/**
 * 画面旋转方向
 */
typedef NS_ENUM(NSInteger, TUI_Enum_Type_HomeOrientation) {
  ///< HOME 键在右边，横屏模式。
  TUI_HOME_ORIENTATION_RIGHT = 0,
  ///< HOME 键在下面，手机直播中最常见的竖屏直播模式。
  TUI_HOME_ORIENTATION_DOWN = 1,
  ///< HOME 键在左边，横屏模式。
  TUI_HOME_ORIENTATION_LEFT = 2,
  ///< HOME 键在上边，竖屏直播（适合小米 MIX2）。
  TUI_HOME_ORIENTATION_UP = 3,
};
/**
 * 外挂字幕Mime Type类型
 */
typedef NS_ENUM(NSInteger, TUI_VOD_PLAYER_SUBTITLE_MIME_TYPE) {

    ///外挂字幕SRT格式
    TUI_VOD_PLAYER_MIMETYPE_TEXT_SRT = 0,

    ///外挂字幕VTT格式
    TUI_VOD_PLAYER_MIMETYPE_TEXT_VTT = 1,
};

@class TUITXVodPlayer;
///播放器代理
@protocol TUITXVodPlayerDelegate <NSObject>

/**
 播放器状态
 @param player 当前播放
 @param status 播放状态
 */
- (void)player:(TUITXVodPlayer *)player statusChanged:(TUITXVodPlayerStatus)status;

/**
 播放器progress回调
 @param player 播放器
 @param currentTime 当前时间
 @param totalTime 总时长
 @param progress 进度
 */
- (void)player:(TUITXVodPlayer *)player
   currentTime:(float)currentTime
     totalTime:(float)totalTime
      progress:(float)progress;
/**
 * 播放器网络状态
 * @param player 播放器
 * @param param 网络状态参数
 */
- (void)onNetStatus:(TUITXVodPlayer *)player
          withParam:(NSDictionary *)param ;
/**
 * 点播事件通知
 * @param player 播放器
 * @param EvtID 事件ID
 * @param param 点播事件参数
 */
- (void)onPlayEvent:(TUITXVodPlayer *)player
              event:(int)EvtID
          withParam:(NSDictionary *)param;
@end

@interface TUITXVodPlayer : NSObject

///视频播放设置策略管理
@property (nonatomic, strong) TUIPlayerStrategyManager *strategyManager;
@property (nonatomic, weak) id<TUITXVodPlayerDelegate> delegate;///代理
@property (nonatomic, assign) TUITXVodPlayerStatus status;     ///状态
@property (nonatomic, assign) BOOL isPlaying;       ///是否正在播放
@property (nonatomic, assign) BOOL loop;            ///是否循环播放
@property (nonatomic, assign) BOOL isAutoPlay;
@property (nonatomic, assign) BOOL enableHWAcceleration; ///是否开启硬件加速
/**
 * 预加载
 * @param model 预加载的视频模型
 */
- (void)preparePlayWithVideoModel:(TUIPlayerVideoModel *)model;

/**
 * 根据指定model在指定视图上播放视频
 * @param playView 播放视图
 * @param model 播放视频模型
 */
- (void)playVideoWithView:(UIView *)playView model:(TUIPlayerVideoModel *)model;
/**
 * 设置播放器显示view
 * @param weiget view
 */
- (void)setupVideoWidget:(UIView *)weiget;
/**
 * 移除播放器器缓存
 */
- (void)removePlayerCache ;
/**
 * 停止播放并移除播放视图
 */
- (void)removeVideo;

/**
 * 暂停播放
 */
- (void)pausePlay;

/**
 * 恢复播放
 */
- (void)resumePlay;

/**
 * 开始播放
 * @param url 视频url
 */
- (void)startPlayWithUrl:(NSString *)url;

/**
 * 播放跳转到某个时间
 * @param time 流时间，单位为秒
 */
- (void)seekToTime:(float)time;

/**
 * 当播放地址为master playlist，返回支持的码率（清晰度）
 *
 * @warning 在收到EVT_VIDEO_PLAY_BEGIN事件后才能正确返回结果
 * @return 无多码率返回空数组
 */
- (NSArray<TUIPlayerBitrateItem *> *)supportedBitrates;

/**
 * 获取当前正在播放的码率索引
 */
- (NSInteger)bitrateIndex;

/**
 * 设置当前正在播放的码率索引，无缝切换清晰度
 *  清晰度切换可能需要等待一小段时间。腾讯云支持多码率HLS分片对齐，保证最佳体验。
 *
 * @param index 码率索引，index == -1，表示开启HLS码流自适应；index > 0 （可从supportedBitrates获取），表示手动切换到对应清晰度码率
 */
- (BOOL)setBitrateIndex:(NSInteger)index;

/**
 * 移除视频渲染图层
 */
-(void)removeVideoWidget;

/**
 * 应用进入前台处理
 */
- (void)detailAppWillEnterForeground;

/**
 * 应用退到后台处理
 */
- (void)detailAppDidEnterBackground;

/**
 * 设置播放开始时间
 */
- (void)setStartTime:(CGFloat)startTime;
/**
 * 设置播放速率
 *
 * @param rate 播放速度（0.5-3.0）
 */
- (void)setRate:(float)rate;

/**
 * 获取当前播放时间
 */
- (float)currentPlaybackTime;

/**
 * 获取视频总时长
 */
- (float)duration;

/**
 * 可播放时长
 */
- (float)playableDuration;

/**
 * 视频宽度
 */
- (int)width;

/**
 * 视频高度
 */
- (int)height;

/**
 * 设置画面的方向
 *
 * @info 设置本地图像的顺时针旋转角度
 * @param rotation 支持 TRTCVideoRotation90 、 TRTCVideoRotation180 以及 TRTCVideoRotation270 旋转角度，默认值：TRTCVideoRotation0
 * @note 用于窗口渲染模式
 */
- (void)setRenderRotation:(TUI_Enum_Type_HomeOrientation)rotation;

/**
 * 设置画面的裁剪模式
 *
 * @param renderMode 填充（画面可能会被拉伸裁剪）或适应（画面可能会有黑边），默认值：TUI_RENDER_MODE_FILL_SCREEN
 * @note 用于窗口渲染模式
 */
- (void)setRenderMode:(TUI_Enum_Type_RenderMode)renderMode;

/**
 * 设置静音
 */
- (void)setMute:(BOOL)bEnable;

/**
 * 设置音量大小
 *
 * @param volume 音量大小，100为原始音量，范围是：[0 ~ 150]，默认值为100
 */
- (void)setAudioPlayoutVolume:(int)volume;

/**
 * 设置音量均衡，响度范围：-70～0(LUFS)。注意：只对播放器高级版生效。
 * 此接口需要LiteAVSDK 11.7 及以上版本支持。
 * @param value
 *  以下几种常量供参考使用
 *  关：AUDIO_NORMALIZATION_OFF (TXVodPlayConfig.h)
 *  开（标准响度）：AUDIO_NORMALIZATION_STANDARD (TXVodPlayConfig.h)
 *  开（低响度）：AUDIO_NORMALIZATION_LOW (TXVodPlayConfig.h)
 *  开（高响度）：AUDIO_NORMALIZATION_HIGH (TXVodPlayConfig.h)
 * 默认值为AUDIO_NORMALIZATION_OFF。
 */
- (void)setAudioNormalization:(float)value;

/**
 * snapshotCompletionBlock 通过回调返回当前图像
 */
- (void)snapshot:(void (^)(UIImage *))snapshotCompletionBlock;

/**
 * 设置画面镜像
 */
- (void)setMirror:(BOOL)isMirror;

/**
 * 将当前vodPlayer附着至TRTC
 *
 * @param trtcCloud TRTC 实例指针
 * @note 用于辅流推送，绑定后音频播放由TRTC接管
 */
- (void)attachTRTC:(NSObject *)trtcCloud;

/**
 * 将当前vodPlayer和TRTC分离
 */
- (void)detachTRTC;

/**
 * 设置扩展的Option参数
 */
- (void)setExtentOptionInfo:(NSDictionary<NSString *, id> *)extInfo;

/**
 * 添加外挂字幕
 *
 * @param url  字幕地址
 * @param name  字幕的名称。如果添加多个字幕，字幕名称请设置为不同的名字，用于区分与其他添加的字幕，否则可能会导致字幕选择错误
 * @param mimeType  字幕类型，仅支持VVT和SRT格式，详细见 TXVodSDKEventDef.h 文件
 */
- (void)addSubtitleSource:(NSString *)url
                     name:(NSString *)name
                 mimeType:(TUI_VOD_PLAYER_SUBTITLE_MIME_TYPE)mimeType;

/**
 * 选择轨道
 *
 * @param trackIndex 轨道的Index
 */
- (void)selectTrack:(NSInteger)trackIndex;

/**
 * 取消选择轨道
 *
 * @param trackIndex 轨道的Index
 */
- (void)deselectTrack:(NSInteger)trackIndex;

/**
  * 停止播放音视频流
  * @param keepLastFrame 停止后是否保留最后一帧
  */
- (int)stopPlay:(BOOL)keepLastFrame;

@end

NS_ASSUME_NONNULL_END
