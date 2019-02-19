#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TXImageSprite;

extern NSNotificationName kSuperPlayerModelReady;

/** 多码率地址 */
@interface SuperPlayerUrl : NSObject
@property NSString *title;
@property NSString *url;
@end

@interface SuperPlayerModel : NSObject

/**
 * 播放器Model可选填videoURL或appid+fileid
 * 如果填videoURL，且是flv格式，那么播放器默认它是直播流
 */

/** 视频URL */
@property (nonatomic, strong) NSString *videoURL;

/**
 * 多码率视频URL
 */
@property (nonatomic, strong) NSArray<SuperPlayerUrl *> *multiVideoURLs;

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
 * 视频雪碧图
 */
@property TXImageSprite *imageSprite;

/**
 * 打点信息
 */
@property NSArray *keyFrameDescList;

/**
 * 正在播放的清晰度
 */
@property (nonatomic) NSString *playingDefinition;
/**
 * 正在播放的清晰度
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

@property CGFloat playInfoDuration;

- (void)getPlayInfoV2;

@end
