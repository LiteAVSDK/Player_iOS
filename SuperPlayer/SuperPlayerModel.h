#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class SuperPlayerView;

extern NSNotificationName kSuperPlayerModelReady;
extern NSNotificationName kSuperPlayerModelFail;

/** 多码率地址 */
@interface SuperPlayerUrl : NSObject
@property NSString *title;
@property NSString *url;
@end


typedef enum : NSUInteger {
    FileIdV2 = 0,
    FileIdV3 = 1,
} FileIdVer;

extern NSString *const kDrmType_FairPlay;
extern NSString *const kDrmType_SimpleAES;

/**
 * fileid播放
 * fileid相关字段请参考[云点播-数据结构](https://cloud.tencent.com/document/product/266/31773)
 */
@interface SuperPlayerVideoId : NSObject
/**
 * appId
 */
@property NSInteger appId;

/**
 * fileid
 */
@property NSString *fileId;
/**
 * 加密链接超时时间戳，转换为16进制小写字符串，腾讯云 CDN 服务器会根据该时间判断该链接是否有效。可选
 * (使用fileid播放时填写)
 */
@property NSString *timeout;
/**
 * 试看时长，单位：秒。可选
 * (使用fileid播放时填写)
 */
@property int exper;
/**
 * 唯一标识请求，增加链接唯一性
 * (使用fileid播放时填写)
 */
@property NSString *us;
/**
 * 防盗链签名
 * (使用fileid播放时填写)
 */
@property NSString *sign;

/**
 * 模板ID (V3)
 */
@property NSString *playDefinition;

/**
 * 播放器 ID，可选。默认使用文件绑定的播放器 ID 或默认播放器 ID
 */
@property NSString *playerId;

/// 允许不同 IP 的播放次数，仅当开启防盗链且需要开启试看时填写
@property int rlimit;

/**
 * 请求后台的interface版本
 * 普通转码 FileIdV2 （默认）
 * DRM视频 FileIdV3
 */
@property FileIdVer version;

@end

/////////////////////////////////////////////////////////////
//
//  播放前创建SuperPlayerModel对象
//
//  必填参数：
//  case 播放腾讯云的fileid
//      videoId
//  case 播放普通url
//      videoUrl
//  case 播放多清晰度
//      multiVideoURLs
//      playingDefinition
//
/////////////////////////////////////////////////////////////


@interface SuperPlayerModel : NSObject


// ------------------------------------------------------------------
// URL 播放方式
// ------------------------------------------------------------------

/** 视频URL */
@property (nonatomic, strong) NSString *videoURL;

// ------------------------------------------------------------------
// FileId 播放方式
// ------------------------------------------------------------------

/**
 * 腾讯云存储对象
 */
@property SuperPlayerVideoId *videoId;

/**
 * FairPlay 凭证数据
 */
@property NSData *certificate;

/**
 * 加密视频的token
 * 播放加密视频需要设置此值
 */
@property (nonatomic, strong) NSString *token;

// ------------------------------------------------------------------
// 多码率播放方法
// ------------------------------------------------------------------

/**
 * 多码率视频URL
 */
@property (nonatomic, strong) NSArray<SuperPlayerUrl *> *multiVideoURLs;

/**
 * 正在播放的清晰度
 */
@property (nonatomic) NSString *playingDefinition;




/**
 * 正在播放的清晰度URL
 */
@property (readonly) NSString *playingDefinitionUrl;
/**
 * 正在播放的清晰度索引
 */
@property (readonly) NSInteger playingDefinitionIndex;
/**
 * 清晰度列表
 */
@property (readonly) NSArray *playDefinitions;



- (void)requestPlayInfo:(SuperPlayerView *)playerView;
@end
