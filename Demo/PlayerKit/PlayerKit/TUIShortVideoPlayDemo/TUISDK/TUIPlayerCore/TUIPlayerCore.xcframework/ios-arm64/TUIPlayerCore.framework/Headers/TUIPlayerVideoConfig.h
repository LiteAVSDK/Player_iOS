// Copyright (c) 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 视频单独设置预加载大小和分辨率
@interface TUIPlayerVideoConfig : NSObject

@property (nonatomic, assign) float preDownloadSize; /// 预下载大小，单位MB，默认1MB
@property (nonatomic, assign) long mPreferredResolution;  /// 偏好分辨率
@property (nonatomic, assign) long switchResolution;///主动切换的分辨率
@end

NS_ASSUME_NONNULL_END
