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

@interface SuperPlayerControlView : UIView

/** 标题 */
@property (nonatomic, strong) UILabel                 *titleLabel;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton                *fullScreenBtn;
/** 锁定屏幕方向按钮 */
@property (nonatomic, strong) UIButton                *lockBtn;

/** 返回按钮*/
@property (nonatomic, strong) UIButton                *backBtn;
/** bottomView*/
@property (nonatomic, strong) UIImageView             *bottomImageView;
/** topView */
@property (nonatomic, strong) UIImageView             *topImageView;
/** 弹幕按钮 */
@property (nonatomic, strong) UIButton                *danmakuBtn;
/// 是否禁用弹幕
@property BOOL                                        disableDanmakuBtn;
/** 截图按钮 */
@property (nonatomic, strong) UIButton                *captureBtn;
/// 是否禁用截图
@property BOOL                                        disableCaptureBtn;
/** 更多按钮 */
@property (nonatomic, strong) UIButton                *moreBtn;
/// 是否禁用更多
@property BOOL                                        disableMoreBtn;
/** 更多的View */
@property (nonatomic, strong) UIScrollView            *moreView;
/** 切换分辨率按钮 */
@property (nonatomic, strong) UIButton                *resolutionBtn;
/** 分辨率的View */
@property (nonatomic, strong) UIView                  *resolutionView;
/** 播放按钮 */
@property (nonatomic, strong) UIButton                *playeBtn;
/** 加载失败按钮 */
@property (nonatomic, strong) UIButton                *middleBtn;

/** 当前选中的分辨率btn按钮 */
@property (nonatomic, weak  ) UIButton                *resoultionCurrentBtn;
/** 占位图 */
@property (nonatomic, strong) UIImageView             *placeholderImageView;
/** 分辨率的名称 */
@property (nonatomic, strong) NSArray<SuperPlayerUrl *> *resolutionArray;
/** 更多设置View */
@property (nonatomic, strong) MoreContentView        *moreContentView;
/** 返回直播 */
@property (nonatomic, strong) UIButton               *backLiveBtn;
/** 显示控制层 */
@property (nonatomic, assign, getter=isShowing) BOOL  showing;

@property (nonatomic, weak) id<SuperPlayerControlViewDelegate> delegate;

/// 画面比例
@property CGFloat videoRatio;

/** 滑杆 */
@property (nonatomic, strong) PlayerSlider   *videoSlider;

/** 重播按钮 */
@property (nonatomic, strong) UIButton       *repeatBtn;

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
 * 播放进度
 * @param currentTime 当前播放时长
 * @param totalTime   视频总时长
 * @param value       slider的value(0.0~1.0)
 */
- (void)playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value;

/**
 * 进度条打点
 */
- (void)playerRemoveAllPoints;
- (void)playerAddVideoPoint:(CGFloat)where text:(NSString *)text time:(NSInteger)time;

/**
 * 播放按钮状态 (播放、暂停状态)
 */
- (void)playerPlayBtnState:(BOOL)state;



/**
 * 开始播放（隐藏placeholderImageView）
 */
- (void)playerIsPlaying;

/**
 * 播放完了
 */
- (void)playerPlayEnd;

/**
 * 锁定屏幕方向按钮状态
 */
- (void)playerLockBtnState:(BOOL)state;

- (void)playerShowOrHideControlView;

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

/** 设置是否为直播模式 */
- (void)playerIsLive:(BOOL)isLive;

/**
 * 时移隐藏
 */
- (void)playerBackLiveBtnHidden:(BOOL)hidden;


@end
