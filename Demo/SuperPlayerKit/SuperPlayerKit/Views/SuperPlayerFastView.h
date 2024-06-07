//
//  SuperPlayerFastView.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/8/24.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ImgWithProgress,   /// Picture + progress, such as sound sliding & 图片+进度，比如声音滑动
    TextWithProgress,  /// Text + progress, such as progress sliding & 文字+进度，比如进度滑动
    ImgWithText,       /// Image + text, such as thumbnail sliding & 图片+文字，比如缩略图滑动
    SnapshotImg,
} FastViewStyle;

@interface SuperPlayerFastView : UIView
/// Fast forward and rewind progress progress
/// 快进快退进度progress
@property(nonatomic, strong) UIProgressView *progressView;
/// Fast forward and rewind time
/// 快进快退时间
@property(nonatomic, strong) UILabel *textLabel;
/// Fast forward and rewind the brightness image
/// 快进快退亮度图片
@property(nonatomic, strong) UIImageView *imgView;

@property(nonatomic, strong) UIImageView *thumbView;

@property(nonatomic, strong) UIImageView *snapshotView;

@property CGFloat videoRatio;

@property(nonatomic) FastViewStyle style;
/// Brightness etc.
/// 亮度等
- (void)showImg:(UIImage *)img withProgress:(GLfloat)progress;
/// fast forward
/// 快进
- (void)showThumbnail:(UIImage *)img withText:(NSString *)text;
- (void)showText:(NSString *)text withText:(GLfloat)progress;
/// screenshot
/// 截图
- (void)showSnapshot:(UIImage *)img;

@end
