// Copyright (c) 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUIPlayerCorePlayeEventHeader.h"
#import "TUIPlayerVodStrategyModel.h"

@class TUIPlayerVideoConfig;

@protocol TUIPlayerVideoConfigDelegate <NSObject>

-(void)onConfigSwitchResolution: (TUIPlayerVideoConfig *) config;

@end

///视频设置
@interface TUIPlayerVideoConfig : NSObject<NSCopying>
/// TUIPlayerVideoConfigDelegate代理
@property (nonatomic, weak) id<TUIPlayerVideoConfigDelegate> delegate;
///预下载大小，单位MB，默认1MB
@property (nonatomic, assign) float preDownloadSize;
///偏好分辨率
@property (nonatomic, assign) long mPreferredResolution;
///主动切换的分辨率
@property (nonatomic, assign) long switchResolution;
///视频缩放模式
@property (nonatomic, assign) TUI_Enum_Type_RenderMode renderMode;
///自定义 HTTP Headers
@property (nonatomic, strong) NSDictionary *headers;
///点播播放器配置，优先级高于TUIPlayerVodStrategyModel
@property (nonatomic, strong) TXVodPlayConfig *playerConfig;

@end


