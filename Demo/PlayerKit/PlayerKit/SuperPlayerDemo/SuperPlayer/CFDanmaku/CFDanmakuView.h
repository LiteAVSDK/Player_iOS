//
//  CFDanmakuView.h
//  31- CFDanmakuDemo
//
//  Created by 于 传峰 on 15/7/9.
//  Copyright (c) 2015年 于 传峰. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CFDanmaku.h"
@class CFDanmakuView;

@protocol CFDanmakuDelegate <NSObject>

@required
/// Get video playback time
/// 获取视频播放时间
- (NSTimeInterval)danmakuViewGetPlayTime:(CFDanmakuView *)danmakuView;
/// loading video
/// 加载视频中
- (BOOL)danmakuViewIsBuffering:(CFDanmakuView *)danmakuView;

@end

@interface                                       CFDanmakuView : UIView
@property(nonatomic, weak) id<CFDanmakuDelegate> delegate;
@property(nonatomic, readonly, assign) BOOL      isPrepared;
@property(nonatomic, readonly, assign) BOOL      isPlaying;
@property(nonatomic, readonly, assign) BOOL      isPauseing;

- (void)prepareDanmakus:(NSArray *)danmakus;

/// The following properties must be configured --------
/// 以下属性都是必须配置的--------
/// /// Barrage animation time
/// 弹幕动画时间
@property(nonatomic, assign) CGFloat duration;
/// Middle top/bottom barrage animation time
/// 中间上边/下边弹幕动画时间
@property(nonatomic, assign) CGFloat centerDuration;
/// Bullet Height
/// 弹幕弹道高度
@property(nonatomic, assign) CGFloat lineHeight;
/// Spacing between the barrage projectiles
/// 弹幕弹道之间的间距
@property(nonatomic, assign) CGFloat lineMargin;
/// The maximum number of lines of the barrage bullet
/// 弹幕弹道最大行数
@property(nonatomic, assign) NSInteger maxShowLineCount;
/// The maximum number of lines above/below the middle of the bullet chatter
/// 弹幕弹道中间上边/下边最大行数
@property(nonatomic, assign) NSInteger maxCenterLineCount;
/// start corresponds to stop, pause corresponds to resume
/// start 与 stop 对应  pause 与 resume 对应
- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;
/// Send a barrage
/// 发送一个弹幕
- (void)sendDanmakuSource:(CFDanmaku *)danmaku;

@end
