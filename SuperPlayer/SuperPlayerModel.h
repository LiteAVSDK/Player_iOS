#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 多码率地址 */
@interface SuperPlayerUrl : NSObject
@property NSString *title;
@property NSString *url;
@end

@interface SuperPlayerModel : NSObject

/** 视频标题 */
@property (nonatomic, copy  ) NSString     *title;
/** 视频封面本地图片 */
@property (nonatomic, strong) UIImage      *placeholderImage;
/**
 * 视频封面网络图片url
 */
@property (nonatomic, copy  ) NSString     *placeholderImageURLString;


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

@end
