//  Copyright © 2023 Tencent. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (bundle)

// 从指定的Bundle 里面获取image
+ (UIImage *)imagewithName:(NSString *)imageName bundleName:(NSString *)bundleName;

@end

NS_ASSUME_NONNULL_END
