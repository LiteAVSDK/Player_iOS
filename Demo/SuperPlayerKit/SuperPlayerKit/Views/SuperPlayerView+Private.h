//
//  SuperPlayerView+Private.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/7/9.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#ifndef SuperPlayerView_Private_h
#define SuperPlayerView_Private_h
#import <MediaPlayer/MediaPlayer.h>
#import "Masonry.h"
#import "NetWatcher.h"
#import "SuperPlayer.h"
#import "SuperPlayerControlViewDelegate.h"
#import <AVFoundation/AVFoundation.h>

#import "SPSubStreamInfo.h"
/// Enumeration value, including horizontal movement direction and vertical movement direction
/// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection) {
    PanDirectionHorizontalMoved,  /// lateral movement & 横向移动
    PanDirectionVerticalMoved     /// vertical movement & 纵向移动
};

typedef NS_ENUM(NSInteger, ButtonAction) {
    ActionNone,
    ActionRetry,
    ActionSwitch,
    ActionIgnore,
    ActionContinueReplay,
};

@class TXVodPlayer, TXLivePlayer;
@interface SuperPlayerView () <UIGestureRecognizerDelegate, UIAlertViewDelegate, SuperPlayerControlViewDelegate, AVAssetResourceLoaderDelegate>
/// Used to save the total time of fast forward
/// 用来保存快进的总时长
@property(nonatomic, assign) CGFloat sumTime;
@property(nonatomic, assign) CGFloat startVeloctyPoint;
/// Define an instance variable to hold the enumeration value
/// 定义一个实例变量，保存枚举值
@property(nonatomic, assign) PanDirection panDirection;
/// Whether the volume is being adjusted
/// 是否在调节音量
@property(nonatomic, assign) BOOL isVolume;
/// Whether to be suspended by the user
/// 是否被用户暂停
@property(nonatomic, assign) BOOL isPauseByUser;
/// Finished playing
/// 播放完了
@property(nonatomic, assign) BOOL playDidEnd;
/// Enter the background
/// 进入后台
@property(nonatomic, assign) BOOL didEnterBackground;
/// click
/// 单击
@property(nonatomic, strong) UITapGestureRecognizer *singleTap;
/// Press
/// 长按
@property(nonatomic, strong) UILongPressGestureRecognizer *longPress;
/// double click
/// 双击
@property(nonatomic, strong) UITapGestureRecognizer *doubleTap;
/// Fast forward and rewind View
/// 快进快退View
@property(nonatomic, strong) SuperPlayerFastView *fastView;

@property(nonatomic, setter=setDragging:) BOOL isDragging;
/// The prompt button in the middle
/// 中间的提示按钮
@property(nonatomic, strong) UIButton *middleBlackBtn;
@property ButtonAction                 middleBlackBtnAction;
/// System Chrysanthemum
/// 系统菊花
@property(nonatomic, strong) MMMaterialDesignSpinner *spinner;

@property(nonatomic, strong) UIButton *lockTipsBtn;

@property(nonatomic, strong) SuperPlayerModel *playerModel;

@property(class, readonly) UISlider *volumeViewSlider;

@property (nonatomic, strong) MPVolumeView *volumeView;

// add for txvodplayer
@property BOOL isLoaded;

@property(nonatomic) BOOL isShiftPlayback;

@property CGFloat maxLiveProgressTime;  // 直播最大进度/总时间
@property CGFloat liveProgressTime;     // 直播播放器回调过来的时间
@property CGFloat liveProgressBase;     // 直播播放器超出时移的最大时间
#define MAX_SHIFT_TIME (2 * 60 * 60)
/// Whether it is a live stream
/// 是否是直播流
@property BOOL isLive;
/// Tencent on-demand player
/// 腾讯点播播放器
@property(nonatomic, strong) TXVodPlayer *vodPlayer;
/// Tencent Live Player
/// 腾讯直播播放器
@property(nonatomic, strong) TXLivePlayer *livePlayer;

@property NSDate *reportTime;

@property (nonatomic, strong) NetWatcher *netWatcher;

@property(nonatomic) CGFloat videoRatio;
/// Parse the resolution definition table from the protocol
/// 由协议解析出分辨率定义表
@property(strong, nonatomic) NSArray<SPSubStreamInfo *> *resolutions;
/// 当前可用的分辨率列表
//@property (strong, nonatomic) NSArray<NSString *> *currentResolutionNames;
@end

// ---------------------------------------------------------------

@class AdaptiveStream;

@interface SuperPlayerModel ()

//@property (nonatomic, strong) NSString *drmType;
@property NSMutableArray<AdaptiveStream *> *streams;

//- (BOOL)canSetDrmType:(NSString *)drmType;

@end

#endif /* SuperPlayerView_Private_h */
