//
//  UIImage+TXExtension.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TXExtension)

/**
*  生成图片
*  @param color  图片颜色
*  @param size  图片大小
*  @return 生成的图片
*/
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
