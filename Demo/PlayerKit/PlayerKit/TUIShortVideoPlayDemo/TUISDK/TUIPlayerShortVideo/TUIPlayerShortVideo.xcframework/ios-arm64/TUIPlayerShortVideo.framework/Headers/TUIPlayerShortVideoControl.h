// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TUIPlayerCore/TUITXVodPlayer.h>
@class TUIPlayerVideoModel;
@protocol TUIPlayerShortVideoControlDelegate <NSObject>
/**
 * 暂停
 */
- (void)pause;

/**
 * 继续播放
 */
- (void)resume;
/**
 * 滑动滚动条的处理
 * @param time   滑动的距离
 */
- (void)seekToTime:(float)time;
/**
 * 是否正在播放
 */
- (BOOL)isPlaying;
/**
 * 重置视频播放容器
 * - 用于视频播放容器被移除后需要重置的场景
 */
- (void)resetVideoWeigetContainer;

@optional
/**
 * 自定义回调事件
 */
- (void)customCallbackEvent:(id)info;
@end

@protocol TUIPlayerShortVideoControl <NSObject>
@required
@property (nonatomic, weak) id<TUIPlayerShortVideoControlDelegate>delegate; ///代理
@property (nonatomic, strong) TUIPlayerVideoModel *model; ///当前播放的视频模型
///当前播放器的播放状态
@property (nonatomic, assign) TUITXVodPlayerStatus currentPlayerStatus;
#pragma mark - CenterView
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

@optional
/**
 * 刷新视图
 */
- (void)reloadControlData;

#pragma mark - Player
/**
 * 获取播放器对象，保存在self中
 */
- (void)getPlayer:(TUITXVodPlayer *)player;

/**
 * 点播事件通知
 * @param player 播放器
 * @param EvtID 事件ID
 * @param param 点播事件参数
 */
- (void)onPlayEvent:(TUITXVodPlayer *)player
              event:(int)EvtID
          withParam:(NSDictionary *)param;
/**
 * 获取视频图层区域
 * @param rect 视频图层区域
 */
- (void)getVideoLayerRect:(CGRect)rect;

/**
 * 获取视频渲染图层
 * @param view 视频渲染图层
 */
- (void)getVideoWidget:(UIView *)view;

/**
 * 播放器回调字幕信息
 * @param player 播放器对象
 * @param subtitleData 字幕信息
 * @discussion 此接口在子线程返回
 */
- (void)onPlayer:(TUITXVodPlayer *)player subtitleData:(TXVodSubtitleData *)subtitleData;

@end

