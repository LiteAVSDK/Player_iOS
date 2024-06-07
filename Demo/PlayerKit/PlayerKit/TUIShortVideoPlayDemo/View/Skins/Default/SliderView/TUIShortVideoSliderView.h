// Copyright (c) 2023 Tencent. All rights reserved.
// 滚动条控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TUIShortVideoSliderViewDelegate <NSObject>

/**
 * sliderView 开始拖拽的回调
 * @param slider  UISlider控件
*/
-(void)onSeekBegin:(UISlider *)slider;

/**
 * sliderView 拖拽中的回调
 * @param slider  UISlider控件
*/
-(void)onSeek:(UISlider *)slider;

/**
 * sliderView 拖拽结束的回调
 * @param slider  UISlider控件
*/
-(void)onSeekEnd:(UISlider *)slider;

/**
 * sliderView拖拽退出的回调
 * @param slider  UISlider控件
*/
-(void)onSeekOutSide:(UISlider *)slider;

@end

@interface TUIShortVideoSliderView : UIView

@property (nonatomic, weak) id<TUIShortVideoSliderViewDelegate> delegate;
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
