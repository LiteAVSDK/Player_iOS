//
//  TXBasePlayerBottomView.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXBasePlayerBottomView.h"
#import "TXBottomToolView.h"
#import "TXBasePlayerMacro.h"
#import "UIImage+TXExtension.h"
#import "UIView+TXAdditions.h"
#import <Masonry/Masonry.h>

@interface TXBasePlayerBottomView()<TXBottomToolViewDelegate>

// 速率进度条
@property (nonatomic, strong) UISlider *speedProgress;

// 速率Label
@property (nonatomic, strong) UILabel  *speedLabel;

// 速率Value
@property (nonatomic, strong) UILabel  *speedValue;

// 底部工具View
@property (nonatomic, strong) TXBottomToolView *toolView;

// 视频播放进度seek的值
@property (nonatomic, assign) float    sliderValue;

@end

@implementation TXBasePlayerBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initChildView];
    }
    return self;
}

#pragma mark - Public Method
// 重置底部View的状态
- (void)resetBottomProgressViewState {
    self.playableLabel.text = @"00:00";
    [self.durationLabel setText:@"00:00"];
    [_playProgress setValue:0];
    [_playProgress setMaximumValue:0];
    [_playableProgress setValue:0];
    [_playableProgress setMaximumValue:0];
    [self updateStartPlayBtnStateSelected:YES];
}

// 更新开始播放按钮状态
- (void)updateStartPlayBtnStateSelected:(BOOL)isSelected {
    [self.toolView updateStartPlayBtnStateSelected:isSelected];
}

#pragma mark - Private Method

- (void)initChildView {
    // 添加速率文案控件
    [self addSubview:self.speedLabel];
    [self.speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    // 添加速率进度条控件
    [self addSubview:self.speedProgress];
    [self.speedProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20 + 50);
        make.right.equalTo(self).offset(-(20 + 50));
        make.top.equalTo(self).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    // 添加速率值控件
    [self addSubview:self.speedValue];
    [self.speedValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    // 添加已播时长控件
    [self addSubview:self.playableLabel];
    [self.playableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(10 + 30 + 10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    // 添加可播放的进度条控件
    [self addSubview:self.playableProgress];
    [self.playableProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20 + 50);
        make.right.equalTo(self).offset(-(20 + 50 + 8));
        make.top.equalTo(self).offset(10 + 30 + 9);
        make.height.mas_equalTo(30);
    }];
    
    // 添加已播放的进度条控件
    [self addSubview:self.playProgress];
    [self.playProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20 + 50);
        make.right.equalTo(self).offset(-(20 + 50));
        make.top.equalTo(self).offset(10 + 30 + 10);
        make.height.mas_equalTo(30);
    }];
    
    // 添加当前视频总时长控件
    [self addSubview:self.durationLabel];
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(10 + 30 + 10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    
    // 添加底部工具栏View
    [self addSubview:self.toolView];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(10 + 30 + 10 + 30 + 10);
        make.height.mas_equalTo(TX_BasePlayer_Bottom_Btn_Height);
    }];
}

#pragma mark - Tools

// float转字符串
- (NSString *)getRateString:(float)rate {
    return [NSString stringWithFormat:@"%.2f", [self getRate:rate]];
}

// 速率转换
- (float)getRate:(float)rate {
    rate = rate * 100.f / 100.f;
    if (rate >= 0.f) {
        return (1.f + rate);
    } else {
        return (1.f + rate / 2);
    }
}

#pragma mark - Speed UISlider Click

- (void)onSpeedSeek:(UISlider *)slider {
    [_speedValue setText:[self getRateString:slider.value]];
}

- (void)onSpeedEnd:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSpeedEndWithSlideValue:)]) {
        [self.delegate onSpeedEndWithSlideValue:[self getRate:slider.value]];
    }
}

- (void)onSpeedOutSide:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSpeedOutSideWithSlideValue:)]) {
        [self.delegate onSpeedOutSideWithSlideValue:[self getRate:slider.value]];
    }
}

#pragma mark - Progress UISlider Click

- (void)onSeekBegin:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSeekBegin)]) {
        [self.delegate onSeekBegin];
    }
}

- (void)onSeek:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSeekEndWithSlideValue:)]) {
        [self.delegate onSeekEndWithSlideValue:self.sliderValue];
    }
}

- (void)onDrag:(UISlider *)slider {
    float progress    = slider.value;
    int   intProgress = progress + 0.5;
    self.playableLabel.text   = [NSString stringWithFormat:@"%02d:%02d", (int)(intProgress / 60), (int)(intProgress % 60)];
    self.sliderValue      = slider.value;
}

#pragma mark - TXBottomToolViewDelegate

// 开始播放或者暂停的事件
- (void)onStartPlaySwitch:(BOOL)isSelected {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onStartPlaySwitch:)]) {
        [self.delegate onStartPlaySwitch:isSelected];
    }
}

// 停止播放的事件
- (void)onStopPlayClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onStopPlayClick)]) {
        [self.delegate onStopPlayClick];
    }
}

// 开日志开启与否的事件
- (void)onLogSwitch:(BOOL)isOpenLog {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLogSwitch:)]) {
        [self.delegate onLogSwitch:isOpenLog];
    }
}

// 是否静音的事件
- (void)onMuteSwitch:(BOOL)isMute {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onMuteSwitch:)]) {
        [self.delegate onMuteSwitch:isMute];
    }
}

// 软硬解切换的事件
- (void)onHardWareSwitch:(BOOL)bHWDec {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onHardWareSwitch:)]) {
        [self.delegate onHardWareSwitch:bHWDec];
    }
}

// 填充模式切换的事件
- (void)onRenderModeSwitch:(BOOL)isFillScreen {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onRenderModeSwitch:)]) {
        [self.delegate onRenderModeSwitch:isFillScreen];
    }
}

// 是否开启缓存的事件
- (void)onCacheSwitch:(BOOL)isCache {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCacheSwitch:)]) {
        [self.delegate onCacheSwitch:isCache];
    }
}

#pragma mark - 懒加载

- (UISlider *)speedProgress {
    if (!_speedProgress) {
        _speedProgress = [[UISlider alloc] init];
        _speedProgress.minimumValue = -1.f;
        _speedProgress.maximumValue = 1.f;
        _speedProgress.value = 0;
        [_speedProgress addTarget:self action:@selector(onSpeedSeek:) forControlEvents:UIControlEventValueChanged];
        [_speedProgress addTarget:self action:@selector(onSpeedEnd:) forControlEvents:UIControlEventTouchUpInside];
        [_speedProgress addTarget:self action:@selector(onSpeedOutSide:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _speedProgress;
}

- (UILabel *)speedLabel {
    if (!_speedLabel) {
        _speedLabel = [[UILabel alloc] init];
        [_speedLabel setText:@"速率"];
        [_speedLabel setTextColor:[UIColor whiteColor]];
    }
    return _speedLabel;
}

- (UILabel *)speedValue {
    if (!_speedValue) {
        _speedValue = [[UILabel alloc] init];
        [_speedValue setText:[self getRateString:_speedProgress.value]];
        [_speedValue setTextColor:[UIColor whiteColor]];
    }
    return _speedValue;
}

- (UILabel *)playableLabel {
    if (!_playableLabel) {
        _playableLabel = [[UILabel alloc] init];
        _playableLabel.text = @"00:00";
        [_playableLabel setTextColor:[UIColor whiteColor]];
    }
    return _playableLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.text = @"00:00";
        [_durationLabel setTextColor:[UIColor whiteColor]];
    }
    return _durationLabel;
}

- (UISlider *)playableProgress {
    if (!_playableProgress) {
        _playableProgress = [[UISlider alloc] init];
        _playableProgress.maximumValue = 0;
        _playableProgress.minimumValue = 0;
        _playableProgress.value        = 0;
        [_playableProgress setThumbImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(20, 10)] forState:UIControlStateNormal];
        [_playableProgress setMaximumTrackTintColor:[UIColor clearColor]];
        _playableProgress.userInteractionEnabled = NO;
        _playableProgress.hidden                 = YES;
    }
    return _playableProgress;
}

- (UISlider *)playProgress {
    if (!_playProgress) {
        _playProgress = [[UISlider alloc] init];
        _playProgress.maximumValue = 0;
        _playProgress.minimumValue = 0;
        _playProgress.value        = 0;
        _playProgress.continuous   = NO;
        [_playProgress addTarget:self action:@selector(onSeek:) forControlEvents:(UIControlEventValueChanged)];
        [_playProgress addTarget:self action:@selector(onSeekBegin:) forControlEvents:(UIControlEventTouchDown)];
        [_playProgress addTarget:self action:@selector(onDrag:) forControlEvents:UIControlEventTouchDragInside];
        _playProgress.hidden = YES;
        
        UIView *thumeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        thumeView.backgroundColor    = UIColor.whiteColor;
        thumeView.layer.cornerRadius = 10;
        UIImage *thumeImage          = thumeView.toImage;
        [_playProgress setThumbImage:thumeImage forState:UIControlStateNormal];
    }
    return _playProgress;
}

- (TXBottomToolView *)toolView {
    if (!_toolView) {
        _toolView = [[TXBottomToolView alloc] init];
        _toolView.backgroundColor = [UIColor clearColor];
        _toolView.delegate = self;
    }
    return _toolView;
}
@end
