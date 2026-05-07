//  Copyright © 2023 Tencent. All rights reserved.

#import "TUIPSVDResourceManager.h"

@implementation TUIPSVDResourceManager

+ (UIImage *)imageWithName:(NSString *)imageNage type:(NSString *)type {
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:imageNage ofType:type]];
    return image;
    
}
+ (UIImage *)assetImageWithName:(NSString *)imageName {
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    UIImage *image = nil;
    if (@available(iOS 13.0, *)) {
        image = [UIImage imageNamed:imageName inBundle:bundle withConfiguration:nil];
    } else {
        image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    }
    return image;
    
}

+ (NSString*)fileUrlWithFileName:(NSString *)fileName {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"];
    NSString *fileUrl = [NSString stringWithFormat:@"%@/materials/%@",bundlePath,fileName];
    return fileUrl;
}
@end
