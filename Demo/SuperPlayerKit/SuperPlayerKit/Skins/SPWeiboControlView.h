//
//  SPWeiboControlView.h
//  SuperPlayer
//
//  Created by annidyfeng on 2018/10/8.
//

#import "SuperPlayerControlView.h"

@interface SPWeiboControlView : SuperPlayerControlView
/// The name of the resolution
/// 分辨率的名称
@property(nonatomic, strong) NSArray<NSString *> *resolutionArray;
/// Start playing button
/// 开始播放按钮
@property(nonatomic, strong) UIButton *startBtn;
/// The current playback duration label
/// 当前播放时长label
@property(nonatomic, strong) UILabel *currentTimeLabel;
/// Total video duration label
/// 视频总时长label
@property(nonatomic, strong) UILabel *totalTimeLabel;
/// Full screen button
/// 全屏按钮
@property(nonatomic, strong) UIButton *fullScreenBtn;
/// slider
/// 滑杆
@property(nonatomic, strong) PlayerSlider *videoSlider;
/// more button
/// 更多按钮
@property(nonatomic, strong) UIButton *moreBtn;
/// Back button
/// 返回按钮
@property(nonatomic, strong) UIButton *backBtn;
/// Mute button
/// 静音按钮
@property(nonatomic, strong) UIButton *muteBtn;
/// Whether it is full screen
/// 是否是全屏状态
@property(nonatomic, assign, getter=isFullScreen) BOOL fullScreen;
/// Switch resolution button
/// 切换分辨率按钮
@property(nonatomic, strong) UIButton *resolutionBtn;
@property(nonatomic, strong) UIButton *resoultionCurrentBtn;
/// Resolution View
/// 分辨率的View
@property(nonatomic, strong) UIView *resolutionView;
/// More settings View
/// 更多设置View
@property(nonatomic, strong) SuperPlayerSettingsView *moreContentView;
@property(nonatomic, strong) UIButton *               pointJumpBtn;
@end
