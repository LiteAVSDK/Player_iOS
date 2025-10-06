//
//  SuperPlayerUrl.h
//  SuperPlayer
//
//  Created by cui on 2019/12/25.
//  Copyright © 2019 annidy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
  * Multi-bit rate address
  * Used for playing multi-definition videos with multiple playback addresses
  */
/**
 * 多码率地址
 * 用于有多个播放地址的多清晰度视频的播放
 */
@interface SuperPlayerUrl : NSObject
/// The corresponding title displayed by the player, such as "HD", "Low HD", etc.
/// 播放器展示的对应标题，如“高清”、“低清”等
@property NSString *title;
/// Play URL
/// 播放地址
@property NSString *url;

@property (nonatomic, assign) int qualityIndex;

@property (nonatomic, assign) NSInteger birtateIndex;
@end

NS_ASSUME_NONNULL_END
