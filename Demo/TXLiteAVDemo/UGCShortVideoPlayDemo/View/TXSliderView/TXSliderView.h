//
//  TXSliderView.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/9/2.
//  Copyright © 2021 Tencent. All rights reserved.
//  滚动条控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXSliderViewDelegate <NSObject>

/**
 * sliderView开始拖拽的回调
 * @param slider  UISlider控件
*/
-(void)onSeek:(UISlider *)slider;

/**
 * sliderView拖拽中的回调
 * @param slider  UISlider控件
*/
-(void)onSeekBegin:(UISlider *)slider;

/**
 * sliderView拖拽结束的回调
 * @param slider  UISlider控件
*/
-(void)onSeekEnd:(UISlider *)slider;

@end

@interface TXSliderView : UIView

@property(nonatomic,weak) id<TXSliderViewDelegate> delegate;

@property (nonatomic, strong) UISlider *slider;

/**
 * 设置slider的进度条
 * @param value  进度条大小
*/
- (void)setProgress:(float)value;

/**
 * 显示slider
*/
- (void)showSlider;

/**
 * 隐藏slider
*/
- (void)hideSlider;

@end

NS_ASSUME_NONNULL_END
