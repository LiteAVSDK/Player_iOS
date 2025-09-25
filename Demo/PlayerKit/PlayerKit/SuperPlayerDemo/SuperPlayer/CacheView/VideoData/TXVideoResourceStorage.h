//  Copyright © 2025 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoCacheModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXVideoResourceStorage : NSObject

+ (NSArray<VideoCacheModel *> *)cacheVideoResource;

+ (NSString *)videoTitleWithURL:(NSString *)videoURL;

+ (NSString *)videoCoverWithURL:(NSString *)videoURL;

@end

NS_ASSUME_NONNULL_END
