//  Copyright © 2023 Tencent. All rights reserved.
#import "UIImage+bundle.h"

@implementation UIImage (bundle)

+ (UIImage *)imagewithName:(NSString *)imageName bundleName:(NSString *)bundleName {
    // 参数判断
    if (imageName.length == 0) {
        return nil;
    }
    
    // 数据处理
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    if (bundlePath.length == 0) { return nil; }
    NSBundle *imageBundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageNamed:imageName inBundle:imageBundle compatibleWithTraitCollection:nil];
    return image;
}

@end
