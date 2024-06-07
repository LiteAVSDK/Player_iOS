//
//  SuperPlayerSubtitles.h
//  Pods
//
//  Created by 路鹏 on 2022/10/14.
//  Copyright © 2022 Tencent. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// subtitle type
/// 字幕类型
typedef NS_ENUM(NSInteger, SuperPlayerSubtitesType) {
    SUPER_PLAYER_MIMETYPE_TEXT_SRT = 0,     ///外挂字幕SRT格式 & External subtitle SRT format
    SUPER_PLAYER_MIMETYPE_TEXT_VTT = 1,     ///外挂字幕VTT格式 & External subtitle VTT format
};

@interface SuperPlayerSubtitles : NSObject
/// Subtitle address
/// 字幕地址
@property (nonatomic, strong) NSString *subtitlesUrl;
/// subtitle name
/// 字幕名称
@property (nonatomic, strong) NSString *subtitlesName;
/// subtitle type
/// 字幕类型
@property (nonatomic, assign) SuperPlayerSubtitesType subtitlesType;

@end

NS_ASSUME_NONNULL_END
