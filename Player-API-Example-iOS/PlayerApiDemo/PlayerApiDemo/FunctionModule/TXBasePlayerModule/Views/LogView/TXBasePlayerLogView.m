//
//  TXBasePlayerLogView.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXBasePlayerLogView.h"
#import "TXBasePlayerLocalized.h"
#import "TXBasePlayerMacro.h"
#import <Masonry/Masonry.h>

@interface TXBasePlayerLogView()

// 日志背景View
@property (nonatomic, strong) UIView   *logCoverView;

// 日志信息
@property (nonatomic, strong) NSString *logMsg;

@end

@implementation TXBasePlayerLogView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initChildView];
    }
    return self;
}

#pragma mark - Public Method
// 清除日志
- (void)clearLog {
    self.logMsg  = @"";
    [self.logStatusView setText:@""];
    [self.logEventView setText:@""];
}

// 日志拼接
- (void)appendLog:(NSString *)evt time:(NSDate *)date mills:(int)mil {
    if (evt == nil) {
        return;
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat       = @"hh:mm:ss";
    NSString *time          = [format stringFromDate:date];
    NSString *log           = [NSString stringWithFormat:@"[%@.%-3.3d] %@", time, mil, evt];
    if (self.logMsg == nil) {
        self.logMsg = @"";
    }
    self.logMsg = [NSString stringWithFormat:@"%@\n%@", self.logMsg, log];
    [self.logEventView setText:self.logMsg];
}

#pragma mark - Private Method
// 初始化View
- (void)initChildView {
    // 添加日志背景View
    [self addSubview:self.logCoverView];
    [self.logCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 添加播放状态日志View
    [self.logCoverView addSubview:self.logStatusView];
    [self.logStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logCoverView);
        make.right.equalTo(self.logCoverView);
        make.top.equalTo(self.logCoverView);
        make.height.mas_equalTo(65);
    }];
    
    // 添加播放事件日志View
    [self.logCoverView addSubview:self.logEventView];
    [self.logEventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logCoverView);
        make.right.equalTo(self.logCoverView);
        make.top.equalTo(self.logCoverView).offset(65);
        make.bottom.equalTo(self.logCoverView);
    }];
}

#pragma mark - 懒加载

- (UIView *)logCoverView {
    if (!_logCoverView) {
        _logCoverView = [[UIView alloc] init];
        _logCoverView.backgroundColor = [UIColor whiteColor];
        _logCoverView.alpha = 0.5;
    }
    return _logCoverView;
}

- (UITextView *)logStatusView {
    if (!_logStatusView) {
        _logStatusView = [[UITextView alloc] init];
        _logStatusView.backgroundColor = [UIColor clearColor];
        _logStatusView.alpha           = 1;
        _logStatusView.textColor       = [UIColor blackColor];
        _logStatusView.editable        = NO;
    }
    return _logStatusView;
}

- (UITextView *)logEventView {
    if (!_logEventView) {
        _logEventView = [[UITextView alloc] init];
        _logEventView.backgroundColor = [UIColor clearColor];
        _logEventView.alpha           = 1;
        _logEventView.textColor       = [UIColor blackColor];
        _logEventView.editable        = NO;
    }
    return _logEventView;
}

@end
