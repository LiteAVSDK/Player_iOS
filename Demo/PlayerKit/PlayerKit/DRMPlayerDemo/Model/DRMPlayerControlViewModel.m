//  Copyright © 2025 Tencent. All rights reserved.

#import "DRMPlayerControlViewModel.h"

@implementation DRMPlayerControlViewModel

- (instancetype)initWithImageName:(NSString *)imageName {
    self = [super init];
    if (self) {
        _imageName = imageName;
    }
    return self;
}

@end
