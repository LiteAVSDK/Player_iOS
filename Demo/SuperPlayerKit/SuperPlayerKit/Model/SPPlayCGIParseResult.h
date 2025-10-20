//
//  SPPlayCGIParseResult.h
//  SuperPlayer
//
//  Created by cui on 2019/12/25.
//  Copyright © 2019 annidy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdaptiveStream.h"
#import "SPSubStreamInfo.h"
#import "SPVideoFrameDescription.h"
#import "SuperPlayerSprite.h"
#import "SuperPlayerUrl.h"

@class TXImageSprite;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SPDrmType) { SPDrmTypeNone, SPDrmTypeSimpleAES };

@interface SPPlayCGIParseResult : NSObject
/// Video playback url
/// 视频播放url
@property(strong, nonatomic) NSString *url;
/// video name
/// 视频名称
@property(strong, nonatomic) NSString *name;
/// Snow thumbnail object
/// 雪略图对象
@property(strong, nonatomic) TXImageSprite *imageSprite;
/// Snow thumbnail dotted frame information
/// 雪略图打点帧信息
@property(strong, nonatomic) NSArray<SPVideoFrameDescription *> *keyFrameDescList;
/// Text stream quality information
/// 字流画质信息
@property(strong, nonatomic) NSArray<SPSubStreamInfo *> *resolutionArray;
/// Original video duration
/// 原视频时长
@property(assign, nonatomic) NSTimeInterval originalDuration;
/// Reserved field, not used for now
/// 预留字段，暂不使用
@property(strong, nonatomic) NSArray<AdaptiveStream *> *adaptiveStreamArray;
/// List of multi-bit rate URLs for V2 protocol
/// V2协议的多码率URL列表
@property(strong, nonatomic) NSArray<SuperPlayerUrl *> *multiVideoURLs;
/// Encryption type, for Drm
/// 加密类型，用于 Drm
@property(assign, nonatomic) SPDrmType drmType;
/// Encrypted token for Drm
/// 加密令牌，用于 Drm
@property(copy, nonatomic) NSString *drmToken;
+ (SPDrmType)drmTypeFromString:(NSString *)typeString;
/**
 * 获取画质信息
 *
 * @return 画质信息数组

List<TCVideoQuality> getVideoQualityList();


 * 获取默认画质信息
 *
 * @return 默认画质信息对象

TCVideoQuality getDefaultVideoQuality();
 */

@end

NS_ASSUME_NONNULL_END
