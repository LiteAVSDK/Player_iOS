//
//  SuperPlayerModelInternal.h
//  SuperPlayer
//
//  Created by Steven Choi on 2020/2/12.
//  Copyright © 2020 annidy. All rights reserved.
//

#import "SPPlayCGIParseResult.h"
#import "SPVideoFrameDescription.h"
#import "SuperPlayerModel.h"
@class TXBitrateItem;

@class TXImageSprite;

NS_ASSUME_NONNULL_BEGIN

@interface SuperPlayerModel ()
/// Playback configuration, "default" when it is nil
/// 播放配置, 为 nil 时为 "default"
@property(copy, nonatomic) NSString *pcfg;

// The following is the analysis result of the PlayCGI V4 protocol
// 以下为 PlayCGI V4 协议解析结果

/// The resolution of the playback
/// 正在播放的清晰度
@property(nonatomic) NSString *playingDefinition;

/// The resolution URL that is being played
/// 正在播放的清晰度URL
@property(readonly) NSString *playingDefinitionUrl;

/// The resolution index that is playing
/// 正在播放的清晰度索引
@property(readonly) NSInteger playingDefinitionIndex;

/// Definition list
/// 清晰度列表
@property(readonly) NSArray *playDefinitions;

/// dot information
/// 打点信息
@property(strong, nonatomic) NSArray<SPVideoFrameDescription *> *keyFrameDescList;

/// Video sprite
/// 视频雪碧图
@property(strong, nonatomic) TXImageSprite *imageSprite;

/// The original video duration (returns the full video duration for trial viewing)
/// 视频原时长（用于试看时返回完整视频时长）
@property(assign, nonatomic) NSTimeInterval originalDuration;

/// DRM Token
@property(strong, nonatomic) NSString *drmToken;

/// DRM Type
@property(nonatomic, assign) SPDrmType drmType;

// HLS EXT-X-KEY encryption key
// HLS EXT-X-KEY 加密key
@property NSString *_Nullable overlayKey;

// HLS EXT-X-KEY encryption Iv
// HLS EXT-X-KEY 加密Iv
@property NSString *_Nullable overlayIv;

@end

NS_ASSUME_NONNULL_END
