//  Copyright © 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUIPlyerCoreSDKTypeDef.h"
#import "TUIPlayerCoreLiteAVSDKHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface TUIPlayerLiveStrategyModel : NSObject
///是否开启上一个预播放，默认NO
@property (nonatomic, assign) BOOL enableLastPrePlay;
///画布填充样式，默认V2TXLiveFillModeFill
@property (nonatomic, assign) V2TXLiveFillMode mRenderMode;
///YES:开启画中画功能; NO: 关闭画中画功能。【默认值】: NO。
@property (nonatomic, assign) BOOL enablePictureInPicture;
///播放器音量，取值范围0 - 100。【默认值】: 100。
@property (nonatomic, assign) NSUInteger volume;
///【字段含义】播放器缓存自动调整的最大时间，单位秒，取值需要大于0，默认值：5。
@property(nonatomic, assign) float maxAutoAdjustCacheTime;
///【字段含义】播放器缓存自动调整的最小时间，单位秒，取值需要大于0，默认值为1。
@property(nonatomic, assign) float minAutoAdjustCacheTime;
///是否显示播放器状态信息的调试浮层【默认值】：NO。
@property (nonatomic, assign) BOOL isShowDebugView;

@end

NS_ASSUME_NONNULL_END
