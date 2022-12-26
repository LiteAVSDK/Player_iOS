//
//  UIImage+TXExtension.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "UIImage+TXExtension.h"

@implementation UIImage (TXExtension)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:size.width/2] addClip];
    [img drawInRect:rect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}

@end
