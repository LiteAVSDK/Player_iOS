// Copyright (c) 2023 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUIPlayerShortVideoControl.h"
NS_ASSUME_NONNULL_BEGIN

@interface TUIPlayerShortVideoPlaceholderControlView : UIView <TUIPlayerShortVideoControl>
@property (nonatomic, weak) id<TUIPlayerShortVideoControlDelegate>delegate; ///代理
@property (nonatomic, strong) TUIPlayerVideoModel *model; ///当前播放的视频模型
///当前播放器的播放状态
@property (nonatomic, assign) TUITXVodPlayerStatus currentPlayerStatus;
#pragma mark - playBtn
/**
 * 显示中心view
 */
- (void)showCenterView;

/**
 * 隐藏中心view
 */
- (void)hideCenterView;


#pragma mark - loadingView
/**
 * 显示loading图
 */
- (void)showLoadingView;
/**
 * 隐藏loading图
 */
- (void)hiddenLoadingView;


#pragma mark - timeview
/**
 * 设置总视频时长
 * @param time  总时长
*/
- (void)setDurationTime:(float)time;
/**
 * 设置当前播放的进度
 * @param time  当前播放的时长
*/
- (void)setCurrentTime:(float)time;

#pragma mark - SliderView
/**
 * 设置slider的进度条
 * @param progress  进度条大小
*/
- (void)setProgress:(float)progress;

/**
 * 显示slider
*/
- (void)showSlider;

/**
 * 隐藏slider
*/
- (void)hideSlider;
/**
 * 刷新视图
 */
- (void)reloadControlData;
@end

NS_ASSUME_NONNULL_END
