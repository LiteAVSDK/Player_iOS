//
//  SuperPlayerControlView.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/6/25.
//  Copyright © 2018年 Tencent. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "SuperPlayer.h"
#import "SuperPlayerControlViewDelegate.h"
#import "SuperPlayerModel.h"
#import "PlayerSlider.h"
#import "SuperPlayerFastView.h"
#import "MMMaterialDesignSpinner.h"
#import "MoreContentView.h"
#import "SuperPlayerModel.h"



@interface SuperPlayerControlView : UIView


/**
 * 播放进度
 * @param currentTime 当前播放时长
 * @param totalTime   视频总时长
 * @param progress       slider的value(0.0~1.0)
 * @param playable       slider的value(0.0~1.0)
 */
- (void)setProgressTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime
          progressValue:(CGFloat)progress playableValue:(CGFloat)playable;



/**
 * 播放按钮状态 (播放、暂停状态)
 * @param isPlay YES 在播放；
 */
- (void)setPlayState:(BOOL)isPlay;


/**
 * 单击时控制显示or隐藏
 */
- (void)taggleControlView;

/**
 *  隐藏控制层
 */
- (void)hideControlView;

/**
 *  显示控制层
 */
- (void)showControlView;

/**
 * 进度条打点
 */
- (void)playerAddVideoPoint:(CGFloat)where text:(NSString *)text time:(NSInteger)time;


/**
 * 切换分辨率功能
 */
- (void)playerBegin:(SuperPlayerModel *)model
             isLive:(BOOL)isLive
     isTimeShifting:(BOOL)isTimeShifting;

// ---------------------------------------------------------------------------------------------------------------------
@property NSString *title;
@property BOOL  isDragging;
@property (nonatomic, weak) id<SuperPlayerControlViewDelegate> delegate;

- (void)setOrientationPortraitConstraint;
- (void)setOrientationLandscapeConstraint;

@end
