//  Copyright © 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TUIPSVDResourceManager : NSObject

+ (UIImage *)imageWithName:(NSString *)imageName type:(NSString *)type;
+ (UIImage *)assetImageWithName:(NSString *)imageName;
+ (NSString*)fileUrlWithFileName:(NSString *)fileName;
@end

NS_ASSUME_NONNULL_END
