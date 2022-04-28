//
//  TXVideoControlView.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/18.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXVideoModel.h"
#import "TXSliderView.h"
#import "TXTimeView.h"

NS_ASSUME_NONNULL_BEGIN

@class TXVideoBaseView;

@protocol TXVideoBaseViewDelegate <NSObject>

/**
点击手势的处理
@param baseView   TXVideoBaseView类
*/
- (void)controlViewDidClickSelf:(TXVideoBaseView *)baseView;

/**
滑动滚动条的处理
@param time   滑动的距离
*/
- (void)seekToTime:(float)time;

@end

@interface TXVideoBaseView : UIView

@property (nonatomic, weak) id<TXVideoBaseViewDelegate> delegate;

// 视频封面图:显示封面并播放视频
@property (nonatomic, strong) UIImageView                  *coverImgView;

// 视频模型
@property (nonatomic, strong) TXVideoModel                 *model;

// 滚动条控件
@property (nonatomic, strong) TXSliderView                 *sliderView;

// 视频播放时长和总时长控件
@property (nonatomic, strong) TXTimeView                   *timeView;

// 视频播放view
@property (nonatomic, strong) UIView                       *__nullable videoFatherView;

/**
 * 设置slider的进度条
 * @param progress  进度条大小
*/
- (void)setProgress:(float)progress;

/**
 * 显示暂停按钮
*/
- (void)showPlayBtn;

/**
 * 隐藏暂停按钮
*/
- (void)hidePlayBtn;

/**
 * 显示线性loadingView
*/
- (void)startLoading;

/**
 * 隐藏线性loadingView
*/
- (void)stopLoading;

/**
 *  设置显示的播放时长和总视频总时长
 *
 *  @param time                 需要label显示的字符串
 */
- (void)setTXtimeLabel:(NSString *)time;

@end

NS_ASSUME_NONNULL_END
