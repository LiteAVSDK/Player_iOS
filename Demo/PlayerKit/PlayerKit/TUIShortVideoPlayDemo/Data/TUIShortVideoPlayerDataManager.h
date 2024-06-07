
//  Copyright © 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///Data Manager
///数据管理
@interface TUIShortVideoPlayerDataManager : NSObject
///Get video data
///获取视频数据
+ (NSArray *)getVideo:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
