//
//  TXBasePlayerLogView.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXBasePlayerLogView : UIView

// 播放状态日志View
@property (nonatomic, strong) UITextView  *logStatusView;

// 播放事件日志View
@property (nonatomic, strong) UITextView  *logEventView;

// 清除日志
- (void)clearLog;

// 日志拼接
- (void)appendLog:(NSString *)evt time:(NSDate *)date mills:(int)mil;
@end

NS_ASSUME_NONNULL_END
