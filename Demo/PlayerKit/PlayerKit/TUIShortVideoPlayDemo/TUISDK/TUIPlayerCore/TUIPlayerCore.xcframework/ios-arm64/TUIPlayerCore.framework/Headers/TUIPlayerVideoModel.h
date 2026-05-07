// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TUIPlayerDataModel.h"
#import "TUIPlayerVideoConfig.h"
#import "TUIPlayerVideoPreloadState.h"
#import "TUIPlayerSubtitleModel.h"

NS_ASSUME_NONNULL_BEGIN

// 当videoModel 改变resoltion时 触发的messageName
static NSString * const VIDEO_MODEL_SWITCH_RESOLUTION = @"VIDEO_MODEL_SWITCH_RESOLUTION";



///视频数据模型
@interface TUIPlayerVideoModel : TUIPlayerDataModel<NSCopying>

/*** 基础信息 */
///视频Url地址
@property (nonatomic, copy) NSString *videoUrl;
///封面图
@property (nonatomic, copy) NSString *coverPictureUrl;
///视频时长
@property (nonatomic, copy) NSString *duration;
///appid
@property (nonatomic, assign) int appId;
///视频的fileId
@property (nonatomic, copy) NSString *fileId;
///签名字串
@property (nonatomic, copy) NSString *pSign;
///字幕信息
@property (nonatomic, strong) NSArray <TUIPlayerSubtitleModel*>*subtitles;
/*** 预下载状态 */
///预下载状态
@property (nonatomic, assign, readonly) TUIPlayerVideoPreloadState preloadState;
///预加载状态（按分辨率）
@property (nonatomic, strong, readonly) NSMutableDictionary *preloadStateMap;

/*** 配置信息 */
///配置
@property (nonatomic, strong) TUIPlayerVideoConfig *config;


 /**
 * 视频模型描述
 * @return 返回字符串描述信息
 */
- (NSString *)info ;


@end

NS_ASSUME_NONNULL_END
