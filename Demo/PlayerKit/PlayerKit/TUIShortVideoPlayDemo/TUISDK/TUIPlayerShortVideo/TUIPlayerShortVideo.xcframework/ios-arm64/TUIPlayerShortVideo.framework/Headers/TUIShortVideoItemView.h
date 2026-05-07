// Copyright (c) 2023 Tencent. All rights reserved.

#if __has_include(<TUIPlayerCore/TUIPlayerCore-umbrella.h>)
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
#else
#import "TUIPlayerCore-umbrella.h"
#endif
#import <UIKit/UIKit.h>
#import "TUIPlayerShortVideoUIManager.h"
#import "TUIShortVideoBaseView.h"
#import "TUIShortVideoCellInterface.h"

NS_ASSUME_NONNULL_BEGIN
///视频播放控件cell代理
@class TUIShortVideoItemView;
@protocol TUIShortVideoItemViewDelegate <NSObject>

/**
 * 暂停
 */
- (void)cellPause;

/**
 * 继续播放
 */
- (void)cellResume;

/**
 * 滑动进度条的处理
 * @param playTime   滑动的距离
 */
- (void)didSeekToTime:(float)playTime;
/**
 * 是否正在播放
 */
- (BOOL)cellIsPlaying;
/**
 * 自定义事件
 */
- (void)vodCustomCallbackEvent:(id)info;

@end

///视频播放控件cell
@interface TUIShortVideoItemView : UITableViewCell<TUIShortVideoBaseViewDelegate>

@property (nonatomic, weak, nullable) id<TUIShortVideoItemViewDelegate> delegate; ///代理
@property (nonatomic, weak, nullable) id<TUIShortVideoCellLayoutDelegate> layoutDelegate; /// 布局代理
@property (nonatomic, strong) TUIShortVideoBaseView *videoBaseView;          ///baseview
@property (nonatomic, strong) TUIPlayerVideoModel *itemViewModel;           ///数据模型
@property (nonatomic, strong) NSIndexPath *indexPath;                    ///索引
///当前播放器的播放状态
@property (nonatomic, assign) TUITXVodPlayerStatus currentPlayerStatus;
///当前播放器是否正在播放
@property (nonatomic, assign) BOOL isPlaying;

/**
 *  cell构造方法
 */
+ (TUIShortVideoItemView *)tableView:(UITableView *)tableView
               cellForRowAtIndexPath:(NSIndexPath *)indexPath
                           uiManager:(TUIPlayerShortVideoUIManager *)uiManager;

/**
 * 设置背景图缩放模式
 * @param renderMode 缩放模式
*/
- (void)setBackgroundImageRenderMode:(TUI_Enum_Type_RenderMode)renderMode;

/**
 *  设置进度条
 */
- (void)setProgress:(float)progress;

/**
 * 设置当前播放的进度
 * @param time  当前播放的时长
*/
- (void)setCurrentTime:(float)time;

/**
 * 显示中心view
 */
- (void)showCenterView;

/**
 * 隐藏中心view
 */
- (void)hideCenterView;

/**
 *  启动Loading
 */
- (void)startLoading;

/**
 *  停止Loading
 */
- (void)stopLoading;

/**
 *  显示播放按钮
 */
- (void)showPlayBtn;

/**
 *  隐藏播放按钮
 */
- (void)hidePlayBtn;

/**
 * 设置总视频时长
 * @param time  总时长
 */
- (void)setDurationTime:(float)time;

/**
 * 刷新视图
 */
- (void)reloadControlData;

/**
 * 获取播放器对象
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
- (void)vodRenderModeChanged:(TUI_Enum_Type_RenderMode)renderMode;

/**
 * 回调字幕信息
 * @param player 播放器对象
 * @param subtitleData 字幕信息
 */
- (void)onPlayer:(TUITXVodPlayer *)player subtitleData:(TXVodSubtitleData *)subtitleData;

/**
 * 隐藏/显示背景图
 */
- (void)hiddenCoverImage:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
