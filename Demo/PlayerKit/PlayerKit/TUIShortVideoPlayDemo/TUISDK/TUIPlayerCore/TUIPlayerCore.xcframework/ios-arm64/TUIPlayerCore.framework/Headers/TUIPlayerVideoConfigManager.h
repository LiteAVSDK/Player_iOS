// Copyright (c) 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUIPlayerVideoModel.h"
#import "TUIPlayerVodStrategyManager.h"
#import "TUIPlayerCoreLiteAVSDKHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TUIPlayerVideoConfigManager : NSObject

+ (long)selectResolutionWith:(TUIPlayerVodStrategyManager *)strategyManager
                  videoModel:(TUIPlayerVideoModel *)videoModel;

+ (float)selectPreDownloadSizeWith:(TUIPlayerVodStrategyManager *)strategyManager
                         videoModel:(TUIPlayerVideoModel *)videoModel;

+ (float)selectRendModeWith:(TUIPlayerVodStrategyManager *)strategyManager
                         videoModel:(TUIPlayerVideoModel *)videoModel;

+ (TXVodPlayConfig *)vodPlayConfigWith:(TUIPlayerVodStrategyManager *)strategyManager
                            videoModel:(nullable TUIPlayerVideoModel *)videoModel;

@end

NS_ASSUME_NONNULL_END
