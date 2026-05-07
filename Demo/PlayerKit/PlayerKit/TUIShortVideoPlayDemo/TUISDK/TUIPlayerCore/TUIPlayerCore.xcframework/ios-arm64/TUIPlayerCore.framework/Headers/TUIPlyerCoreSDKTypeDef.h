// Copyright (c) 2024 Tencent. All rights reserved.
//

#ifndef TUIPlyerCoreSDKTypeDef_h
#define TUIPlyerCoreSDKTypeDef_h

// 播放器状态
typedef NS_ENUM(NSUInteger, TUITXVodPlayerStatus) {
    TUITXVodPlayerStatusUnload   = 0,  // 未加载
    TUITXVodPlayerStatusPrepared = 1,  // 准备播放
    TUITXVodPlayerStatusLoading  = 2,  // 加载中
    TUITXVodPlayerStatusPlaying  = 3,  // 播放中
    TUITXVodPlayerStatusPaused   = 4,  // 暂停
    TUITXVodPlayerStatusEnded    = 5,  // 播放完成
    TUITXVodPlayerStatusError    = 6,  // 错误
    TUITXVodPlayerStatusLoopCompleted    = 7,  // 已经结束一次(只在循环播放使用)
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

/**
 * 画面填充模式
 */
typedef NS_ENUM(NSInteger, TUI_Enum_Type_RenderMode) {
  /// 未知。
  TUI_RENDER_MODE_FILL_NONE = -1,
  /// 图像铺满屏幕，不留黑边，如果图像宽高比不同于屏幕宽高比，部分画面内容会被裁剪掉。
  TUI_RENDER_MODE_FILL_SCREEN = 0,
  /// 图像适应屏幕，保持画面完整，但如果图像宽高比不同于屏幕宽高比，会有黑边的存在。
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
/**
 * 超分类型
 */
typedef NS_ENUM (NSInteger, TUI_Enume_Type_SuperResolution) {
    TUI_SuperResolution_NONE = 0, /// 无超分
    TUI_SuperResolution_TSR = 2,  /// TSR超分
};
#endif /* TUIPlyerCoreSDKTypeDef_h */
