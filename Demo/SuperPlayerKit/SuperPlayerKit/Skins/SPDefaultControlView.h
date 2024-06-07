//
//  SPDefaultControlView.h
//  SuperPlayer
//
//  Created by annidyfeng on 2018/9/30.
//

#import "SuperPlayerControlView.h"

@interface SPDefaultControlView : SuperPlayerControlView
/// title
/// 标题
@property(nonatomic, strong) UILabel *titleLabel;
/// Start play button
/// 开始播放按钮
@property(nonatomic, strong) UIButton *startBtn;
/// Current playback duration label
/// 当前播放时长label
@property(nonatomic, strong) UILabel *currentTimeLabel;
/// Video total duration label
/// 视频总时长label
@property(nonatomic, strong) UILabel *totalTimeLabel;
/// Full screen button
/// 全屏按钮
@property(nonatomic, strong) UIButton *fullScreenBtn;
/// Lock screen orientation buttons
/// 锁定屏幕方向按钮
@property(nonatomic, strong) UIButton *lockBtn;
/// Back button
/// 返回按钮
@property(nonatomic, strong) UIButton *backBtn;
/// Whether to disable the return
/// 是否禁用返回
@property(nonatomic, assign) BOOL disableBackBtn;
/// bottomView
/// 底部控制栏
@property(nonatomic, strong) UIImageView *bottomImageView;
/// topView
/// 顶部控制栏
@property(nonatomic, strong) UIImageView *topImageView;
/// Barrage button
/// 弹幕按钮
@property(nonatomic, strong) UIButton *danmakuBtn;
/// Whether to disable barrage
/// 是否禁用弹幕
@property(nonatomic, assign) BOOL disableDanmakuBtn;
/// Offline cache button
/// 离线缓存按钮
@property(nonatomic, strong) UIButton *offlineBtn;
/// Whether to disable offline caching
/// 是否禁用离线缓存
@property(nonatomic, assign) BOOL disableOfflineBtn;
/// Track switch button
/// 音轨切换按钮
@property(nonatomic, strong) UIButton *trackBtn;
/// Whether to disable track switching
/// 是否禁用音轨切换
@property(nonatomic, assign) BOOL disableTrackBtn;
/// Subtitle toggle button
/// 字幕切换按钮
@property(nonatomic, strong) UIButton *subtitlesBtn;
/// Whether to disable subtitle switching
/// 是否禁用字幕切换
@property(nonatomic, assign) BOOL disableSubtitlesBtn;
/// Screenshot button
/// 截图按钮
@property(nonatomic, strong) UIButton *captureBtn;
/// Whether to disable screenshots
/// 是否禁用截图
@property(nonatomic, assign) BOOL disableCaptureBtn;
/// Picture-in-picture button
/// 画中画按钮
@property(nonatomic, strong) UIButton *pipBtn;
/// Whether to disable picture-in-picture
/// 是否禁用画中画
@property(nonatomic, assign) BOOL disablePipBtn;
/// more button
/// 更多按钮
@property(nonatomic, strong) UIButton *moreBtn;
/// Whether to disable more
/// 是否禁用更多
@property(nonatomic, assign) BOOL disableMoreBtn;
/// Switch resolution button
/// 切换分辨率按钮
@property(nonatomic, strong) UIButton *resolutionBtn;
/// Resolution View
/// 分辨率的View
@property(nonatomic, strong) UIView *resolutionView;
/// Whether to disable the resolution button
/// 是否禁用分辨率按钮
@property(nonatomic, assign) BOOL disableResolutionBtn;
/// play button
/// 播放按钮
@property(nonatomic, strong) UIButton *playeBtn;
/// Failed to load button
/// 加载失败按钮
@property(nonatomic, strong) UIButton *middleBtn;
/// The currently selected resolution btn button
/// 当前选中的分辨率btn按钮
@property(nonatomic, weak) UIButton *resoultionCurrentBtn;
/// The name of the resolution
/// 分辨率的名称
@property(nonatomic, strong) NSArray<NSString *> *resolutionArray;
/// More settings View
/// 更多设置View
@property(nonatomic, strong) SuperPlayerSettingsView *moreContentView;
/// Track View
/// 音轨View
@property (nonatomic, strong) SuperPlayerTrackView *trackView;
/// Subtitle View
/// 字幕View
@property (nonatomic, strong) SuperPlayerSubtitlesView *subtitlesView;
/// Return to the live broadcast
/// 返回直播
@property(nonatomic, strong) UIButton *backLiveBtn;
/// aspect ratio
/// 画面比例
@property CGFloat videoRatio;
/// slider
/// 滑杆
@property(nonatomic, strong) PlayerSlider *videoSlider;
/// Next button
/// 下一个按钮
@property(nonatomic, strong) UIButton *nextBtn;
/// Replay button
/// 重播按钮
@property(nonatomic, strong) UIButton *repeatBtn;
/// Whether to play in full screen
/// 是否全屏播放
@property(nonatomic, assign, getter=isFullScreen) BOOL fullScreen;
@property(nonatomic, assign, getter=isLockScreen) BOOL isLockScreen;
@property(nonatomic, strong) UIButton *                pointJumpBtn;
///  字幕配置
///  Subtitle configuration
@property (nonatomic, strong, readonly) NSDictionary *subtitlesConfig;
/// Set the selected state of the landscape button
/// 设置横屏按钮的选中状态
- (void)fullScreenButtonSelectState:(BOOL)state;

@end
