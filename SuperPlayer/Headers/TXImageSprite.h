//
//  TXImageSprite.h
//  TXLiteAVSDK
//
//  Created by annidyfeng on 2018/8/23.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 雪碧图解析工具
@interface TXImageSprite : NSObject
/**
 * 设置雪碧图地址
 * @param vttUrl VTT链接
 * @param images 雪碧图大图列表
 */
- (void)setVTTUrl:(NSURL *)vttUrl imageUrls:(NSArray<NSURL *> *)images;

/**
 * 获取缩略图
 * @param time 时间点，单位秒
 * @return 获取失败返回nil
 */
- (UIImage *)getThumbnail:(GLfloat)time;
@end
