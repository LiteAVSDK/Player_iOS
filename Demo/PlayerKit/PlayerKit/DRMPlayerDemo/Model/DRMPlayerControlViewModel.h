//  Copyright © 2025 Tencent. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMPlayerControlViewModel : NSObject

@property (nonatomic, copy) NSString *imageName;

- (instancetype)initWithImageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
