// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
/**
 * 画面填充模式
 */
typedef NS_ENUM(NSInteger, TUI_Enum_Type_RenderMode) {
  ///< 图像铺满屏幕，不留黑边，如果图像宽高比不同于屏幕宽高比，部分画面内容会被裁剪掉。
  TUI_RENDER_MODE_FILL_SCREEN = 0,
  ///< 图像适应屏幕，保持画面完整，但如果图像宽高比不同于屏幕宽高比，会有黑边的存在。
  TUI_RENDER_MODE_FILL_EDGE = 1,
};
/**
 * 媒资类型（ 使用自适应码率播放功能时需设定具体HLS码流是点播/直播媒资，暂时不支持Auto类型）
 */
typedef NS_ENUM(NSInteger, TUI_Enum_MediaType) {

    /// AUTO类型（默认值，自适应码率播放暂不支持）
    TUI_MEDIA_TYPE_AUTO = 0,

    /// HLS点播媒资
    TUI_MEDIA_TYPE_HLS_VOD = 1,

    /// HLS直播媒资
    TUI_MEDIA_TYPE_HLS_LIVE = 2,

    /// MP4等通用文件点播媒资
    TUI_MEDIA_TYPE_FILE_VOD = 3,

    /// DASH点播媒资
    TUI_MEDIA_TYPE_DASH_VOD = 4,
};
/**
 * 续播模式
 * 如果剩余时间只剩下0.5s,将不做记录，视作播放完成
 */
typedef NS_ENUM(NSInteger, TUI_Enum_Type_ResumModel) {

    /// 不续播
    TUI_RESUM_MODEL_NONE = 0,

    /// 续播上次播放过的视频
    TUI_RESUM_MODEL_LAST = 1,

    /// 续播所有的视频
    TUI_RESUM_MODEL_PLAYED = 2,

};
NS_ASSUME_NONNULL_BEGIN
///播放器策略模型
@interface TUIPlayerStrategyModel : NSObject

@property (nonatomic, assign) NSInteger mPreloadConcurrentCount;    /// 缓存个数，默认3
@property (nonatomic, assign) float mPreloadBufferSizeInMB; /// 预播放大小，单位MB，默认0.5MB
@property (nonatomic, assign) long mPreferredResolution;  /// 偏好分辨率，默认720 * 1280
@property (nonatomic, assign) long mProgressInterval;     /// 进度条回调间隔时长，单位毫秒，默认500ms
@property (nonatomic, assign) TUI_Enum_Type_RenderMode mRenderMode; ///画布填充样式，默认RENDER_MODE_FILL_SCREEN
@property (nonatomic, strong) NSDictionary *mExtInfoMap;   ///额外参数，预留
@property (nonatomic, assign) BOOL enableAutoBitrate; /// 是否开启自适应码率，默认NO
/// 设置媒资类型
///【重要】若自适应码率播放，暂须指定具体类型，如自适应播放HLS直播资源，须传入TUI_MEDIA_TYPE_HLS_LIVE类型
@property (nonatomic, assign) TUI_Enum_MediaType mediaType;
@property (nonatomic, assign) long switchResolution;///主动切换的全局分辨率
///最大预加载大小，单位 MB ，默认10MB，此设置会影响playableDuration，设置越大，提前缓存的越多
@property(nonatomic, assign) float maxBufferSize;
@property (nonatomic, assign) TUI_Enum_Type_ResumModel mResumeModel; ///续播模式，默认TUI_RESUM_MODEL_NONE
@property (nonatomic, assign) float preDownloadSize;/// 预下载大小，单位MB，默认1MB
///是否精确 seek，默认 YES。开启精确后 seek，seek 的时间平均多出 200ms
@property (nonatomic, assign) BOOL enableAccurateSeek;
/// 音量均衡 .响度范围：-70～0(LUFS)。此配置需要LiteAVSDK 11.7 及以上版本支持。
/// 以下几种常量供参考使用
/// 关：AUDIO_NORMALIZATION_OFF (TXVodPlayConfig.h)
/// 开（标准响度）：AUDIO_NORMALIZATION_STANDARD (TXVodPlayConfig.h)
/// 开（低响度）：AUDIO_NORMALIZATION_LOW (TXVodPlayConfig.h)
/// 开（高响度）：AUDIO_NORMALIZATION_HIGH (TXVodPlayConfig.h)
/// 默认值为AUDIO_NORMALIZATION_OFF。
@property (nonatomic, assign) float audioNormalization;
@end

NS_ASSUME_NONNULL_END
