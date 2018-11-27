//
//  SuperPlayerControlView.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/6/25.
//  Copyright © 2018年 Tencent. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "SuperPlayerControlViewDelegate.h"
#import "SuperPlayerModel.h"
#import "PlayerSlider.h"
#import "SuperPlayerFastView.h"
#import "MMMaterialDesignSpinner.h"
#import "MoreContentView.h"
#import "SuperPlayerModel.h"
#import "SuperPlayerViewConfig.h"


@interface SuperPlayerVideoPoint : NSObject
@property CGFloat where;
@property NSString *text;
@property CGFloat time;
@end

@interface SuperPlayerControlView : UIView

/**
 * 播放进度
 * @param currentTime 当前播放时长
 * @param totalTime   视频总时长
 * @param progress    value(0.0~1.0)
 * @param playable    value(0.0~1.0)
 */
- (void)setProgressTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime
          progressValue:(CGFloat)progress playableValue:(CGFloat)playable;

/**
 * 播放状态
 * @param isPlay YES播放，NO暂停
 */
- (void)setPlayState:(BOOL)isPlay;



/**
 * 开始新的播放
 *  @param isLive 是否为直播流
 *  @param isTimeShifting 是否在直播时移
 *  @param isAutoPlay 是否自动播放
 */
- (void)playerBegin:(SuperPlayerModel *)model
             isLive:(BOOL)isLive
     isTimeShifting:(BOOL)isTimeShifting
         isAutoPlay:(BOOL)isAutoPlay;

/// 标题
@property NSString *title;
/// 打点信息
@property NSArray<SuperPlayerVideoPoint *>  *pointArray;
/// 是否在拖动进度
@property BOOL  isDragging;
/// 是否显示二级菜单
@property BOOL  isShowSecondView;
/// 回调delegate
@property (nonatomic, weak) id<SuperPlayerControlViewDelegate> delegate;
/// 播放配置
@property SuperPlayerViewConfig *playerConfig;

- (void)setOrientationPortraitConstraint;
- (void)setOrientationLandscapeConstraint;

@end
