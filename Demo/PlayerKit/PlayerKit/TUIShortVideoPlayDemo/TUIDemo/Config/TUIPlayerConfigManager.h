//  Copyright © 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
NS_ASSUME_NONNULL_BEGIN
///config
@interface TUIPlayerConfigManager : NSObject

///单例
+ (instancetype)shareInstance ;

///video
- (NSArray<TUIPlayerVideoModel *> *)getVideo:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
