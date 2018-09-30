#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
 *
 */
@property NSString *playingDefinition;

@property (readonly) NSString *playingDefinitionUrl;

@property (readonly) NSInteger playingDefinitionIndex;

@property (readonly) NSArray *playDefinitions;

@end
