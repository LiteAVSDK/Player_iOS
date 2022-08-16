#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SuperPlayerUrl.h"

/**
 * SuperPlayerModel
 *
 * 播放器组件支持三种方式播放视频:
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
@class TXVodDownloadMediaInfo;

// 播放模式
typedef NS_ENUM(NSInteger, SuperPlayerAction) {
    PLAY_ACTION_AUTO_PLAY = 0,     //自动播放
    PLAY_ACTION_MANUAL_PLAY,   //手动播放
    PLAY_ACTION_PRELOAD        //预加载
};

@interface SuperPlayerModel : NSObject

/// AppId 用于腾讯云点播 File ID 播放及腾讯云直播时移功能
@property(nonatomic, assign) long appId;

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
 * 多码率视频 URL
 *
 * 用于拥有多个播放地址的多清晰度视频播放
 */
@property(nonatomic, strong) NSArray<SuperPlayerUrl *> *multiVideoURLs;

/// 指定多码率情况下，默认播放的连接Index
@property(nonatomic, assign) NSUInteger defaultPlayIndex;

// ------------------------------------------------------------------
// FileId 播放方式
// ------------------------------------------------------------------

/// 腾讯云点播 File ID 播放参数
@property SuperPlayerVideoId *videoId;

/// 用于兼容旧版本(V2)腾讯云点播 File ID 播放参数（即将废弃，不推荐使用）
@property SuperPlayerVideoIdV2 *videoIdV2;

/// 用户自定义的封面图片URL
@property (nonatomic, strong) NSString *customCoverImageUrl;

/// 默认的封面图片URL
@property (nonatomic, strong) NSString *defaultCoverImageUrl;

/// 播放模式
@property (nonatomic, assign) SuperPlayerAction action;

/// 视频时长
@property (nonatomic, assign) NSTimeInterval duration;

/// 视频名称
@property (nonatomic, strong) NSString *name;

/// 是否开启缓存
@property (nonatomic, assign) BOOL isEnableCache;

@property (nonatomic, strong) DynamicWaterModel *dynamicWaterModel;

@property (nonatomic, strong) TXVodDownloadMediaInfo *mediaInfo;

@end

/// 腾讯云点播 File ID 播放参数
@interface SuperPlayerVideoId : NSObject

/// 云点播 File ID
@property(nonatomic, strong) NSString *fileId;

/**
 * 防盗链签名
 * (使用 fileId 播放时填写)
 */
@property(nonatomic, strong) NSString *psign;

@end

/**
 * V2 版本播放协议播放参数（即将废弃，不推荐使用）
 * 如果需要使用 timeout, exper, us, sign 进行播放。
 * 请使用这个对象初始化并传入包括fileId的各项参数，并传入SuperPlayerModel中的videoIdV2属性
 */
@interface SuperPlayerVideoIdV2 : NSObject

/**
 * 云点播 File Id
 */
@property(nonatomic, strong) NSString *fileId;
/**
 * 加密链接超时时间戳，转换为16进制小写字符串，腾讯云 CDN 服务器会根据该时间判断该链接是否有效。可选
 * (使用 fileId 播放时填写)
 */
@property(nonatomic, strong) NSString *timeout;
/**
 * 试看时长，单位：秒。可选
 * (使用 fileId 播放时填写)
 */
@property(nonatomic, assign) int exper;
/**
 * 唯一标识请求，增加链接唯一性
 * (使用 fileId 播放时填写)
 */
@property(nonatomic, strong) NSString *us;
/**
 * 防盗链签名
 * (使用 fileId 播放时填写)
 */
@property(nonatomic, strong) NSString *sign;

@end
