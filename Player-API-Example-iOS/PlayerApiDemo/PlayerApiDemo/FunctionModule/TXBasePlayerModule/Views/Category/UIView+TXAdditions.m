//
//  UIView+TXAdditions.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "UIView+TXAdditions.h"

@implementation UIView (TXAdditions)

- (UIImage *)toImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage *tImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return tImage;
}

- (void)setBackgroundImage:(UIImage *)image {
    UIGraphicsBeginImageContext(self.frame.size);
    [image drawInRect:self.bounds];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}

@end
