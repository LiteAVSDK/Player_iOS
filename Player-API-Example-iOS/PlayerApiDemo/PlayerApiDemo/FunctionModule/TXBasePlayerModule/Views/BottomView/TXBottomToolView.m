//
//  TXBottomToolView.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXBottomToolView.h"
#import "TXBasePlayerMacro.h"
#import <Masonry/Masonry.h>

@interface TXBottomToolView()

// 开始播放按钮
@property (nonatomic, strong) UIButton *startPlayBtn;

// 停止播放按钮
@property (nonatomic, strong) UIButton *stopPlayBtn;

// log按钮
@property (nonatomic, strong) UIButton *logBtn;

// 静音切换按钮
@property (nonatomic, strong) UIButton *muteBtn;

// 软硬解切换按钮
@property (nonatomic, strong) UIButton *hardWareBtn;

// 填充按钮
@property (nonatomic, strong) UIButton *renderModeBtn;

// 缓存按钮
@property (nonatomic, strong) UIButton *cacheBtn;

@end

@implementation TXBottomToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initChildView];
    }
    return self;
}

#pragma mark - Public Method
- (void)updateStartPlayBtnStateSelected:(BOOL)isSelected {
    if (isSelected) {
        [self.startPlayBtn setImage:[UIImage imageNamed:@"suspend"] forState:UIControlStateSelected];
    } else {
        [self.startPlayBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    }
}

#pragma mark - Private Method
// 初始化View
- (void)initChildView {
    // 计算icon之间的margin
    CGFloat icon_margin = (TX_SCREEN_WIDTH - TX_BasePlayer_Bottom_Btn_Count * TX_BasePlayer_Bottom_Btn_Width) / TX_BasePlayer_Bottom_Mar_Count;
    
    // 添加开始播放按钮
    CGFloat left_margin = icon_margin;
    [self addSubview:self.startPlayBtn];
    [self.startPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left_margin);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(TX_BasePlayer_Bottom_Btn_Width);
        make.height.mas_equalTo(TX_BasePlayer_Bottom_Btn_Height);
    }];
    
    // 添加停止播放按钮
    left_margin = icon_margin * 2 + TX_BasePlayer_Bottom_Btn_Width;
    [self addSubview:self.stopPlayBtn];
    [self.stopPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left_margin);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(TX_BasePlayer_Bottom_Btn_Width);
        make.height.mas_equalTo(TX_BasePlayer_Bottom_Btn_Height);
    }];
    
    // 添加log按钮
    left_margin = icon_margin * 3 + TX_BasePlayer_Bottom_Btn_Width * 2;
    [self addSubview:self.logBtn];
    [self.logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left_margin);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(TX_BasePlayer_Bottom_Btn_Width);
        make.height.mas_equalTo(TX_BasePlayer_Bottom_Btn_Height);
    }];
    
    // 添加静音切换按钮
    left_margin = icon_margin * 4 + TX_BasePlayer_Bottom_Btn_Width * 3;
    [self addSubview:self.muteBtn];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left_margin);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(TX_BasePlayer_Bottom_Btn_Width);
        make.height.mas_equalTo(TX_BasePlayer_Bottom_Btn_Height);
    }];
    
    // 添加软硬解切换按钮
    left_margin = icon_margin * 5 + TX_BasePlayer_Bottom_Btn_Width * 4;
    [self addSubview:self.hardWareBtn];
    [self.hardWareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left_margin);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(TX_BasePlayer_Bottom_Btn_Width);
        make.height.mas_equalTo(TX_BasePlayer_Bottom_Btn_Height);
    }];
    
    // 添加填充按钮
    left_margin = icon_margin * 6 + TX_BasePlayer_Bottom_Btn_Width * 5;
    [self addSubview:self.renderModeBtn];
    [self.renderModeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left_margin);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(TX_BasePlayer_Bottom_Btn_Width);
        make.height.mas_equalTo(TX_BasePlayer_Bottom_Btn_Height);
    }];
    
    // 添加缓存按钮
    left_margin = icon_margin * 7 + TX_BasePlayer_Bottom_Btn_Width * 6;
    [self addSubview:self.cacheBtn];
    [self.cacheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(left_margin);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(TX_BasePlayer_Bottom_Btn_Width);
        make.height.mas_equalTo(TX_BasePlayer_Bottom_Btn_Height);
    }];
}

#pragma mark - Click

- (void)startPlayClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onStartPlaySwitch:)]) {
        [self.delegate onStartPlaySwitch:sender.selected];
    }
}

- (void)stopPlayClick {
    // 重置开始播放按钮
    [self.startPlayBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onStopPlayClick)]) {
        [self.delegate onStopPlayClick];
    }
}

- (void)logClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLogSwitch:)]) {
        [self.delegate onLogSwitch:sender.selected];
    }
}

- (void)muteClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onMuteSwitch:)]) {
        [self.delegate onMuteSwitch:sender.selected];
    }
}

- (void)hardWareClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onHardWareSwitch:)]) {
        [self.delegate onHardWareSwitch:sender.selected];
    }
}

- (void)renderModeClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onRenderModeSwitch:)]) {
        [self.delegate onRenderModeSwitch:sender.selected];
    }
}

- (void)cacheClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCacheSwitch:)]) {
        [self.delegate onCacheSwitch:sender.selected];
    }
}

#pragma mark - 懒加载

- (UIButton *)startPlayBtn {
    if (!_startPlayBtn) {
        _startPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startPlayBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        [_startPlayBtn setImage:[UIImage imageNamed:@"suspend"] forState:UIControlStateSelected];
        [_startPlayBtn addTarget:self action:@selector(startPlayClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startPlayBtn;
}

- (UIButton *)stopPlayBtn {
    if (!_stopPlayBtn) {
        _stopPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopPlayBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [_stopPlayBtn addTarget:self action:@selector(stopPlayClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopPlayBtn;
}

- (UIButton *)logBtn {
    if (!_logBtn) {
        _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logBtn setImage:[UIImage imageNamed:@"log"] forState:UIControlStateNormal];
        [_logBtn setImage:[UIImage imageNamed:@"logSelected"] forState:UIControlStateSelected];
        [_logBtn addTarget:self action:@selector(logClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logBtn;
}

- (UIButton *)muteBtn {
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteBtn setImage:[UIImage imageNamed:@"play_sound"] forState:UIControlStateNormal];
        [_muteBtn setImage:[UIImage imageNamed:@"play_mute"] forState:UIControlStateSelected];
        [_muteBtn addTarget:self action:@selector(muteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muteBtn;
}

- (UIButton *)hardWareBtn {
    if (!_hardWareBtn) {
        _hardWareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hardWareBtn setImage:[UIImage imageNamed:@"quick"] forState:UIControlStateNormal];
        [_hardWareBtn setImage:[UIImage imageNamed:@"quickSelected"] forState:UIControlStateSelected];
        [_hardWareBtn addTarget:self action:@selector(hardWareClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hardWareBtn;
}

- (UIButton *)renderModeBtn {
    if (!_renderModeBtn) {
        _renderModeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_renderModeBtn setImage:[UIImage imageNamed:@"fill"] forState:UIControlStateNormal];
        [_renderModeBtn setImage:[UIImage imageNamed:@"adjust"] forState:UIControlStateSelected];
        [_renderModeBtn addTarget:self action:@selector(renderModeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _renderModeBtn;
}

- (UIButton *)cacheBtn {
    if (!_cacheBtn) {
        _cacheBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cacheBtn setImage:[UIImage imageNamed:@"cache"] forState:UIControlStateNormal];
        [_cacheBtn setImage:[UIImage imageNamed:@"cacheSelected"] forState:UIControlStateSelected];
        [_cacheBtn addTarget:self action:@selector(cacheClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cacheBtn;
}
@end
