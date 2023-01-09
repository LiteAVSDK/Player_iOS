//
//  SuperPlayerControlView.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/6/25.
//  Copyright © 2018年 Tencent. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "MMMaterialDesignSpinner.h"
#import "PlayerSlider.h"
#import "SPVideoFrameDescription.h"
#import "SuperPlayerControlViewDelegate.h"
#import "SuperPlayerFastView.h"
#import "SuperPlayerSettingsView.h"
#import "SuperPlayerTrackView.h"
#import "SuperPlayerSubtitlesView.h"
#import "SuperPlayerViewConfig.h"

@interface SuperPlayerControlView : UIView

/**
 * 竖向/横向约束标志位
 */
@property(assign, nonatomic) BOOL compact;
/**
 * 点播放试看时间范围 0.0 - 1.0
 *
 * 用于试看场景，防止进度条拖动超过试看时长
 */
@property(assign, nonatomic) float maxPlayableRatio;
/**
 * 标题
 */
@property (nonatomic, copy) NSString *title;
/**
 * 打点信息
 */
@property (nonatomic, strong) NSArray<SPVideoFrameDescription *> *pointArray;
/**
 * 是否在拖动进度
 */
@property (nonatomic, assign) BOOL isDragging;
/**
 * 是否显示二级菜单
 */
@property (nonatomic, assign) BOOL isShowSecondView;
/**
 * 是否允许控件响应点击的 FadeShow/ FadeOut事件，默认为YES
 */
@property (nonatomic, assign) BOOL enableFadeAction;
/**
 * 回调delegate
 */
@property (nonatomic, weak) id<SuperPlayerControlViewDelegate> delegate;
/**
 *  播放配置
 */
@property (nonatomic, strong) SuperPlayerViewConfig *playerConfig;
/**
 * 播放进度
 * @param currentTime 当前播放时长
 * @param totalTime   视频总时长
 * @param progress    value(0.0~1.0)
 * @param playable    value(0.0~1.0)
 */
- (void)setProgressTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime progressValue:(CGFloat)progress playableValue:(CGFloat)playable;

/**
 * 播放状态
 * @param isPlay YES播放，NO暂停
 */
- (void)setPlayState:(BOOL)isPlay;

/**
 * 是否显示或隐藏返回按钮
 * @param isShow YES显示，NO隐藏
 */
- (void)showOrHideBackBtn:(BOOL)isShow;

/**
 * 是否禁止拖动进度条
 * @param isEnable  YES允许，NO禁止
 */
- (void)setSliderState:(BOOL)isEnable;

/**
 * 是否隐藏标题、弹幕、截图控件
 * @param isShow  YES显示，NO隐藏
 */
- (void)setTopViewState:(BOOL)isShow;

/**
 * 是否隐藏切换分辨率控件
 * @param isShow  YES显示，NO隐藏
 */
- (void)setResolutionViewState:(BOOL)isShow;

/**
 * 是否隐下一个控件
 * @param isShow  YES显示，NO隐藏
 */
- (void)setNextBtnState:(BOOL)isShow;

/**
 * 是否禁用离线缓存控件
 * @param disableOfflineBtn  YES禁用，NO不禁用
 */
- (void)setDisableOfflineBtn:(BOOL)disableOfflineBtn;

/**
 * 是否隐藏音轨控件
 * @param isShow  YES显示，NO隐藏
 */
- (void)setTrackBtnState:(BOOL)isShow;

/**
 * 是否隐藏字幕控件
 * @param isShow  YES显示，NO隐藏
 */
- (void)setSubtitlesBtnState:(BOOL)isShow;

/**
 * 重置播放控制面板
 * @param resolutionNames 清晰度名称
 * @param resolutionIndex 正在播放的清晰度的下标
 * @param isLive 是否为直播流，直播是有时移按钮，不支持镜像与播放速度修改
 * @param isTimeShifting 是否在直播时移
 * @param isPlaying 是否正在播放中，用于调整播放按钮状态
 */
- (void)resetWithResolutionNames:(NSArray<NSString *> *)resolutionNames
          currentResolutionIndex:(NSUInteger)resolutionIndex
                          isLive:(BOOL)isLive
                  isTimeShifting:(BOOL)isTimeShifting
                       isPlaying:(BOOL)isPlaying;

/**
 * 重置字幕音轨面板
 * @param tracks 音轨数组
 * @param trackIndex 正在播放的音轨下标
 * @param subtitles 字幕数组
 * @param subtitleIndex 正在播放的字幕下标
 */
- (void)resetWithTracks:(NSMutableArray *)tracks
      currentTrackIndex:(NSInteger)trackIndex
              subtitles:(NSMutableArray *)subtitles
  currentSubtitlesIndex:(NSInteger)subtitleIndex;

/**
 *  设置竖直方向的约束
 */
- (void)setOrientationPortraitConstraint;

/**
 *  设置横屏方向的约束
 */
- (void)setOrientationLandscapeConstraint;

@end
