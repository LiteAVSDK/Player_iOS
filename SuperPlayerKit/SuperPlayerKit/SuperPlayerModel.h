#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SuperPlayerUrl.h"

/**
  * SuperPlayerModel
  *
  * Super Player supports three ways to play videos:
  * 1. Video URL
  * Fill in the video URL, if you want to use the live broadcast time shift function, you also need to fill in the appId
  * 2. Tencent Cloud VOD File ID playback
  * Fill in appId and videoId (if using the old version V2, please fill in videoIdV2)
  * 3. Multi-bit rate video playback
  * It is an extension of the URL playback method, which can pass in multiple URLs at the same time for bit rate switching
  *
  */
/**
 * SuperPlayerModel
 *
 * 超级播放器支持三种方式播放视频:
 * 1. 视频 URL
 *    填写视频 URL, 如需使用直播时移功能，还需填写appId
 * 2. 腾讯云点播 File ID 播放
 *    填写 appId 及 videoId (如果使用旧版本V2, 请填写videoIdV2)
 * 3. 多码率视频播放
 *    是URL播放方式扩展，可同时传入多条URL，用于进行码率切换
 *
 */
@class SuperPlayerVideoId;
@class SuperPlayerVideoIdV2;
@class DynamicWaterModel;
@class SuperPlayerSubtitles;

#if __has_include("TXVodDownloadManager.h")
@class TXVodDownloadMediaInfo;
#else
// 如果没有 SDK，定义一个简单的 TXVodDownloadMediaInfo 接口
@interface TXVodDownloadMediaInfo : NSObject
@end
#endif
// play mode
// 播放模式
typedef NS_ENUM(NSInteger, SuperPlayerAction) {
    PLAY_ACTION_AUTO_PLAY = 0,
    PLAY_ACTION_MANUAL_PLAY,
    PLAY_ACTION_PRELOAD
};

@interface SuperPlayerModel : NSObject
/// AppId is used for Tencent Cloud VOD File ID playback and Tencent Cloud live broadcast time-shifting function
/// AppId 用于腾讯云点播 File ID 播放及腾讯云直播时移功能
@property(nonatomic, assign) long appId;

// ------------------------------------------------ ------------------
// URL playback method
// ------------------------------------------------ ------------------

/**
  * Directly use the URL to play
  *
  * Support RTMP, FLV, MP4, HLS encapsulation formats
  * You need to fill in the appId when using the time-shifting function of Tencent Cloud Live Streaming
  */
// ------------------------------------------------------------------
// URL 播放方式
// ------------------------------------------------------------------

/**
 * 直接使用URL播放
 *
 * 支持 RTMP、FLV、MP4、HLS 封装格式
 * 使用腾讯云直播时移功能则需要填写appId
 */
@property(nonatomic, strong) NSString *videoURL;

/**
  * Multi-bitrate video URL
  *
  * For multi-definition video playback with multiple playback addresses
  */
/**
 * 多码率视频 URL
 *
 * 用于拥有多个播放地址的多清晰度视频播放
 */
@property(nonatomic, strong) NSArray<SuperPlayerUrl *> *multiVideoURLs;

/// In the case of specifying multiple bitrates, the default playback connection Index
/// 指定多码率情况下，默认播放的连接Index
@property(nonatomic, assign) NSUInteger defaultPlayIndex;

// ------------------------------------------------ ------------------
// FileId playback method
// ------------------------------------------------ ------------------

// ------------------------------------------------------------------
// FileId 播放方式
// ------------------------------------------------------------------

/// Tencent Cloud VOD File ID playback parameters
/// 腾讯云点播 File ID 播放参数
@property SuperPlayerVideoId *videoId;

/// Used to be compatible with the old version (V2) Tencent Cloud VOD File ID playback parameters (to be discarded soon, not recommended)
/// 用于兼容旧版本(V2)腾讯云点播 File ID 播放参数（即将废弃，不推荐使用）
@property SuperPlayerVideoIdV2 *videoIdV2;

/// User-defined cover image URL
/// 用户自定义的封面图片URL
@property (nonatomic, strong) NSString *customCoverImageUrl;

/// Default cover image URL
/// 默认的封面图片URL
@property (nonatomic, strong) NSString *defaultCoverImageUrl;

/// play mode
/// 播放模式
@property (nonatomic, assign) SuperPlayerAction action;

/// Video duration
/// 视频时长
@property (nonatomic, assign) NSTimeInterval duration;

/// video name
/// 视频名称
@property (nonatomic, strong) NSString *name;

/// List of subtitles
/// 字幕列表
@property (nonatomic, strong) NSMutableArray<SuperPlayerSubtitles *> *subtitlesArray;

/// Whether to enable caching
/// 是否开启缓存
@property (nonatomic, assign) BOOL isEnableCache;

@property (nonatomic, strong) DynamicWaterModel *dynamicWaterModel;

@property (nonatomic, strong) TXVodDownloadMediaInfo *mediaInfo;

@end

/// Tencent Cloud VOD File ID playback parameters
/// 腾讯云点播 File ID 播放参数
@interface SuperPlayerVideoId : NSObject

/// Cloud VOD File ID
/// 云点播 File ID
@property(nonatomic, strong) NSString *fileId;

/**
  * Anti-leech signature
  * (fill in when playing with fileId)
  */
/**
 * 防盗链签名
 * (使用 fileId 播放时填写)
 */
@property(nonatomic, strong) NSString *psign;

@end

/**
  * V2 version playback protocol playback parameters (to be obsolete, not recommended)
  * Play with timeout, exper, us, sign if needed.
  * Please use this object to initialize and pass in various parameters including fileId, and pass in the videoIdV2 attribute in SuperPlayerModel
  */
/**
 * V2 版本播放协议播放参数（即将废弃，不推荐使用）
 * 如果需要使用 timeout, exper, us, sign 进行播放。
 * 请使用这个对象初始化并传入包括fileId的各项参数，并传入SuperPlayerModel中的videoIdV2属性
 */
@interface SuperPlayerVideoIdV2 : NSObject

/**
  * Cloud VOD File Id
  */
/**
 * 云点播 File Id
 */
@property(nonatomic, strong) NSString *fileId;
/**
  * Encrypted link timeout timestamp, converted to a hexadecimal lowercase string, Tencent Cloud CDN server will judge whether the link is valid based on this time. optional
  * (fill in when playing with fileId)
  */
/**
 * 加密链接超时时间戳，转换为16进制小写字符串，腾讯云 CDN 服务器会根据该时间判断该链接是否有效。可选
 * (使用 fileId 播放时填写)
 */
@property(nonatomic, strong) NSString *timeout;
/**
  * Trial duration, unit: second. optional
  * (fill in when playing with fileId)
  */
/**
 * 试看时长，单位：秒。可选
 * (使用 fileId 播放时填写)
 */
@property(nonatomic, assign) int exper;
/**
  * Uniquely identify the request and increase the uniqueness of the link
  * (fill in when playing with fileId)
  */
/**
 * 唯一标识请求，增加链接唯一性
 * (使用 fileId 播放时填写)
 */
@property(nonatomic, strong) NSString *us;
/**
  * Anti-leech signature
  * (fill in when playing with fileId)
  */
/**
 * 防盗链签名
 * (使用 fileId 播放时填写)
 */
@property(nonatomic, strong) NSString *sign;

@end
