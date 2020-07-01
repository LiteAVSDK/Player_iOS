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

- (void)cancelFadeOut
{
    [self setFadeSeeds:@(arc4random_uniform(1000))];
}

- (UIView *)fadeShow
{
    [self cancelFadeOut];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.hidden = NO;
    } completion:^(BOOL finished) {

    }];
    return self;
}

- (void)fadeOut:(NSTimeInterval)delay
{
    int seeds = [self.fadeSeeds intValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (seeds == [self.fadeSeeds intValue]) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.hidden = YES;
            } completion:^(BOOL finished) {
                
            }];
            [self cancelFadeOut];
        }
    });
}

@end
