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
// 获取视频播放时间
- (NSTimeInterval)danmakuViewGetPlayTime:(CFDanmakuView *)danmakuView;
// 加载视频中
- (BOOL)danmakuViewIsBuffering:(CFDanmakuView *)danmakuView;

@end


@interface CFDanmakuView : UIView
@property (nonatomic, weak) id<CFDanmakuDelegate> delegate;
@property (nonatomic, readonly, assign) BOOL isPrepared;
@property (nonatomic, readonly, assign) BOOL isPlaying;
@property(nonatomic, readonly, assign) BOOL isPauseing;

- (void)prepareDanmakus:(NSArray *)danmakus;

// 以下属性都是必须配置的--------
// 弹幕动画时间
@property (nonatomic, assign) CGFloat duration;
// 中间上边/下边弹幕动画时间
@property (nonatomic, assign) CGFloat centerDuration;
// 弹幕弹道高度
@property (nonatomic, assign) CGFloat lineHeight;
// 弹幕弹道之间的间距
@property (nonatomic, assign) CGFloat lineMargin;

// 弹幕弹道最大行数
@property (nonatomic, assign) NSInteger maxShowLineCount;

// 弹幕弹道中间上边/下边最大行数
@property (nonatomic, assign) NSInteger maxCenterLineCount;

// start 与 stop 对应  pause 与 resume 对应
- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;

// 发送一个弹幕
- (void)sendDanmakuSource:(CFDanmaku *)danmaku;

@end
