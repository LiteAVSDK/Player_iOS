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
  * Vertical/horizontal constraint flag bit
  */
/**
 * 竖向/横向约束标志位
 */
@property(assign, nonatomic) BOOL compact;
/**
  * Click to play and try the time range 0.0 - 1.0
  *
  * It is used to preview the scene to prevent the progress bar from being dragged beyond the trial duration
  */
/**
 * 点播放试看时间范围 0.0 - 1.0
 *
 * 用于试看场景，防止进度条拖动超过试看时长
 */
@property(assign, nonatomic) float maxPlayableRatio;
/**
  * title
  */
/**
 * 标题
 */
@property (nonatomic, copy) NSString *title;
/**
  * RBI information
  */
/**
 * 打点信息
 */
@property (nonatomic, strong) NSArray<SPVideoFrameDescription *> *pointArray;
/**
  * Whether the progress is being dragged
  */
/**
 * 是否在拖动进度
 */
@property (nonatomic, assign) BOOL isDragging;
/**
  * Whether to display the secondary menu
  */
/**
 * 是否显示二级菜单
 */
@property (nonatomic, assign) BOOL isShowSecondView;
/**
  * Whether to allow the control to respond to clicked FadeShow/FadeOut events, the default is YES
  */
/**
 * 是否允许控件响应点击的 FadeShow/ FadeOut事件，默认为YES
 */
@property (nonatomic, assign) BOOL enableFadeAction;
/**
  * callback delegate
  */
/**
 * 回调delegate
 */
@property (nonatomic, weak) id<SuperPlayerControlViewDelegate> delegate;
/**
  * Play configuration
  */
/**
 *  播放配置
 */
@property (nonatomic, strong) SuperPlayerViewConfig *playerConfig;
/**
  * Play progress
  * @param currentTime current playing time
  * @param totalTime Total video duration
  * @param progress value(0.0~1.0)
  * @param playable value(0.0~1.0)
  */
/**
 * 播放进度
 * @param currentTime 当前播放时长
 * @param totalTime   视频总时长
 * @param progress    value(0.0~1.0)
 * @param playable    value(0.0~1.0)
 */
- (void)setProgressTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime progressValue:(CGFloat)progress playableValue:(CGFloat)playable;
/**
  * Playing status
  * @param isPlay YES play, NO pause
  */
/**
 * 播放状态
 * @param isPlay YES播放，NO暂停
 */
- (void)setPlayState:(BOOL)isPlay;
/**
  * Whether to show or hide the back button
  * @param isShow YES show, NO hide
  */
/**
 * 是否显示或隐藏返回按钮
 * @param isShow YES显示，NO隐藏
 */
- (void)showOrHideBackBtn:(BOOL)isShow;
/**
  * Whether to disable dragging the progress bar
  * @param isEnable YES allows, NO prohibits
  */
/**
 * 是否禁止拖动进度条
 * @param isEnable  YES允许，NO禁止
 */
- (void)setSliderState:(BOOL)isEnable;
/**
  * Whether to hide the title, barrage, and screenshot controls
  * @param isShow YES show, NO hide
  */
/**
 * 是否隐藏标题、弹幕、截图控件
 * @param isShow  YES显示，NO隐藏
 */
- (void)setTopViewState:(BOOL)isShow;
/**
  * Whether to hide the switching resolution control
  * @param isShow YES show, NO hide
  */
/**
 * 是否隐藏切换分辨率控件
 * @param isShow  YES显示，NO隐藏
 */
- (void)setResolutionViewState:(BOOL)isShow;
/**
  * Whether to hide the next control
  * @param isShow YES show, NO hide
  */
/**
 * 是否隐下一个控件
 * @param isShow  YES显示，NO隐藏
 */
- (void)setNextBtnState:(BOOL)isShow;
/**
  * Whether to disable the offline cache control
  * @param disableOfflineBtn YES disabled, NO not disabled
  */
/**
 * 是否禁用离线缓存控件
 * @param disableOfflineBtn  YES禁用，NO不禁用
 */
- (void)setDisableOfflineBtn:(BOOL)disableOfflineBtn;
/**
  * Whether to hide the audio track controls
  * @param isShow YES show, NO hide
  */
/**
 * 是否隐藏音轨控件
 * @param isShow  YES显示，NO隐藏
 */
- (void)setTrackBtnState:(BOOL)isShow;
/**
  * Whether to hide the subtitle control
  * @param isShow YES show, NO hide
  */
/**
 * 是否隐藏字幕控件
 * @param isShow  YES显示，NO隐藏
 */
- (void)setSubtitlesBtnState:(BOOL)isShow;
/**
  * Reset playback control panel
  * @param resolutionNames resolution names
  * @param resolutionIndex The subscript of the resolution being played
  * @param isLive Whether it is a live stream,
  * the live broadcast is a time-shift button,
  * does not support mirroring and playback speed modification
  * @param isTimeShifting Whether to shift the live broadcast
  * @param isPlaying Whether it is playing, used to adjust the state of the play button
  */
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
  * Reset subtitle audio track panel
  * @param tracks array of audio tracks
  * @param trackIndex The subscript of the track being played
  * @param subtitles array of subtitles
  * @param subtitleIndex Subtitle subscript being played
  */
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
  * Set vertical constraints
  */
/**
 *  设置竖直方向的约束
 */
- (void)setOrientationPortraitConstraint;
/**
  * Set constraints for landscape orientation
  */
/**
 *  设置横屏方向的约束
 */
- (void)setOrientationLandscapeConstraint;

@end
