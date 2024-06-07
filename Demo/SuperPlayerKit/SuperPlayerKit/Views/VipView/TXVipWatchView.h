//
//  TXVipWatchView.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/8.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXVipWatchModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TXVipWatchViewDelegate <NSObject>

/**
  * Call the back button
  */
/**
 * 调用返回按钮
 */
- (void)onBackClick;

/**
  * Invoke the VIP button
  */
/**
 * 调用开通VIP按钮
 */
- (void)onOpenVIPClick;

/**
  * Call the retry button
  */
/**
 * 调用重试按钮
 */
- (void)onRepeatClick;

/**
  * Show VipView
  */
/**
 * 显示VipView
 */
- (void)showVipView;

@end

@interface TXVipWatchView : UIView

@property (nonatomic, weak)   id<TXVipWatchViewDelegate> delegate;

@property (nonatomic, assign) CGFloat textFontSize;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, strong) TXVipWatchModel *vipWatchModel;

/**
  * Initialize all subviews of vipWatchView
  */
/**
 * 初始化vipWatchView的所有子视图
 */
- (void)initVipWatchSubViews;

/**
  * When the video is playing, when the video progress is updated, this method is called, and vipView is called according to the progress
  * @param currentTime video playback time, in seconds
  */
/**
 * 视频播放时，视频进度更新时，调用此方法，根据进度调用vipView
 * @param currentTime  视频播放时长，单位为秒
 */
- (void)setCurrentTime:(float)currentTime;

@end

NS_ASSUME_NONNULL_END
