//
//  UIView+Fade.m
//  SuperPlayer
//
//  Created by annidyfeng on 2018/9/28.
//

#import "UIView+Fade.h"
#import <objc/runtime.h>


@implementation UIView (Fade)

- (NSNumber *)fadeSeeds{
    return objc_getAssociatedObject(self, @selector(fadeSeeds));
}

- (void)setFadeSeeds:(NSNumber *)seeds{
    objc_setAssociatedObject(self, @selector(fadeSeeds), seeds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)fadeShow
{
    [self setAlpha:1];
    [self setFadeSeeds:@(random())];
}

- (void)fadeOut:(NSTimeInterval)delay
{
    int seeds = [self.fadeSeeds intValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (seeds == [self.fadeSeeds intValue]) {
            [self setAlpha:0];
        } else {
            
        }
    });
}

@end
