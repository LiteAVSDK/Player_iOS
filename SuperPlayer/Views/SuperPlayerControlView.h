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

@interface SuperPlayerControlView : UIView 

@property NSString *liveUrl;

@property (nonatomic, weak) id<SuperPlayerControlViewDelegate> delegate;

@property CGFloat videoRatio;

/** 滑杆 */
@property (nonatomic, strong) PlayerSlider   *videoSlider;

/** 重播按钮 */
@property (nonatomic, strong) UIButton                *repeatBtn;

/**
 * 取消自动隐藏控制层view
 */
- (void)playerCancelAutoFadeOutControlView;


/**
 * 切换分辨率功能
 * @param resolutionArray 分辨率名称的数组
 * @param defualtIndex 当前分辨率
 */
- (void)playerResolutionArray:(NSArray<SuperPlayerUrl *> *)resolutionArray defaultIndex:(NSInteger)defualtIndex;
- (void)playerResolutionIndex:(NSInteger)defualtIndex;

/**
 * progress显示缓冲进度
 */
- (void)playerPlayableProgress:(CGFloat)progress;

/**
 * 正常播放
 * @param currentTime 当前播放时长
 * @param totalTime   视频总时长
 * @param value       slider的value(0.0~1.0)
 */
- (void)playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value;

- (void)playerRemoveAllPoints;
- (void)playerAddVideoPoint:(CGFloat)where text:(NSString *)text time:(NSInteger)time;

/**
 * 播放按钮状态 (播放、暂停状态)
 */
- (void)playerPlayBtnState:(BOOL)state;

/**
 * 视频标题
 */
- (void)playerTitle:(NSString *)title;

/**
 * 背景图片
 */
- (void)playerBackgroundImage:(UIImage *)image;
- (void)playerBackgroundImageUrl:(NSURL *)imageUrl placeholderImage:(UIImage *)placeholderImage;

/**
 * 视频加载失败提示
 */
- (void)playerIsFailed:(NSString *)error;

/**
 * 视频网络不好提示
 */
- (void)playerBadNet:(NSString *)tips;

- (void)playerMiddleBtn;

/**
 * 开始播放（隐藏placeholderImageView）
 */
- (void)playerIsPlaying;

/**
 * 加载的菊花
 */
- (void)playerIsActivity:(BOOL)animated;

/**
 * 拖拽快进 快退
 * @param draggedTime 拖拽的时长
 * @param totalTime   视频总时长
 * @param sliderValue 进度条位置
 */
- (void)playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)sliderValue thumbnail:(UIImage *)thumbnail;

- (void)playerDraggedLight:(CGFloat)draggedValue;

- (void)playerDraggedVolume:(CGFloat)draggedValue;

/**
 * 滑动调整进度结束结束
 */
- (void)playerDraggedEnd;

/**
 * 播放完了
 */
- (void)playerPlayEnd;


- (void)playerShowOrHideControlView;

/**
 * 锁定屏幕方向按钮状态
 */
- (void)playerLockBtnState:(BOOL)state;

/**
 *  隐藏控制层
 */
- (void)playerHideControlView;

/**
 *  显示控制层
 */
- (void)playerShowControlView;

/** 重置ControlView */
- (void)playerResetControlView;

/** 更多设置中的类容 */
- (void)playerControlViewLive:(BOOL)isLive;

- (void)autoFadeOutControlView;

/**
 * 时移隐藏
 */
- (void)playerBackLiveBtnHidden:(BOOL)hidden;

- (void)playerShowTips:(NSString *)tips delay:(NSTimeInterval)delay;

@end
