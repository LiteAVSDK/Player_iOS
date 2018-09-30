//
//  SPWeiboControlView.m
//  SuperPlayer
//
//  Created by annidyfeng on 2018/10/8.
//

#import "SPWeiboControlView.h"
#import "Masonry.h"
#import "UIView+Fade.h"
#import "StrUtils.h"

@implementation SPWeiboControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.startBtn];
        [self addSubview:self.currentTimeLabel];
        [self addSubview:self.totalTimeLabel];
        [self addSubview:self.videoSlider];
        [self addSubview:self.fullScreenBtn];
        [self addSubview:self.resolutionBtn];
        [self addSubview:self.muteBtn];
        [self addSubview:self.moreBtn];
        [self addSubview:self.backBtn];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        [self resetControlView];
    }
    return self;
}

- (void)makeSubViewsConstraints {
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-8);
        make.left.mas_equalTo(@0);
        make.width.mas_equalTo(@60);
    }];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.currentTimeLabel);
        make.right.equalTo(self).offset(-12);
    }];
    [self.resolutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.currentTimeLabel);
        make.right.equalTo(self.fullScreenBtn.mas_left);
        make.width.mas_equalTo(0);
    }];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.currentTimeLabel);
        make.right.equalTo(self.resolutionBtn.mas_left);
        make.width.mas_equalTo(@60);
    }];
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.currentTimeLabel);
        make.left.equalTo(self.currentTimeLabel.mas_right);
        make.right.equalTo(self.totalTimeLabel.mas_left);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(5);
        make.top.equalTo(self).offset(3);
    }];

    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-5);
        make.centerY.equalTo(self.backBtn);
    }];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.moreBtn.mas_leading).offset(-5);
        make.centerY.equalTo(self.backBtn);
    }];
}


- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:SuperPlayerImage(@"wb_play") forState:UIControlStateNormal];
        [_startBtn setImage:SuperPlayerImage(@"wb_pause") forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _currentTimeLabel;
}

- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _resolutionBtn.backgroundColor = [UIColor clearColor];
        [_resolutionBtn addTarget:self action:@selector(playerShowResolutionView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resolutionBtn;
}

- (PlayerSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[PlayerSlider alloc] init];
        
        _videoSlider.progressView.progressTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _videoSlider.progressView.trackTintColor    = [UIColor clearColor];
        
        [_videoSlider setThumbImage:SuperPlayerImage(@"slider_thumb") forState:UIControlStateNormal];
        
        _videoSlider.maximumValue          = 1;
        _videoSlider.minimumTrackTintColor = TintColor;
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    }
    return _videoSlider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:SuperPlayerImage(@"wb_fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn setImage:SuperPlayerImage(@"wb_fullscreen_back") forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:SuperPlayerImage(@"wb_back") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:SuperPlayerImage(@"wb_more") forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
- (UIButton *)muteBtn {
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteBtn setImage:SuperPlayerImage(@"wb_volume_off") forState:UIControlStateNormal];
        [_muteBtn setImage:SuperPlayerImage(@"wb_volume_on") forState:UIControlStateSelected];
        [_muteBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muteBtn;
}
- (void)playBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.delegate controlViewPlay:self];
    } else {
        [self.delegate controlViewPause:self];
    }
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.delegate controlViewChangeScreen:self withFullScreen:sender.selected];
}

- (void)progressSliderTouchBegan:(UISlider *)sender {
    self.isDragging = YES;
    [self cancelFadeOut];
}

- (void)progressSliderValueChanged:(UISlider *)sender {
    [self.delegate controlViewPreview:self where:sender.value];
}

- (void)progressSliderTouchEnded:(UISlider *)sender {
    [self.delegate controlViewSeek:self where:sender.value];
    self.isDragging = NO;
    [self cancelFadeOut];
}

- (void)setProgressTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime
          progressValue:(CGFloat)progress playableValue:(CGFloat)playable;
{
    if (!self.isDragging) {
        // 更新slider
        self.videoSlider.value           = progress;
        // 更新当前播放时间
        self.currentTimeLabel.text = [StrUtils timeFormat:currentTime];
    }
    // 更新总时间
    self.totalTimeLabel.text = [StrUtils timeFormat:totalTime];
    [self.videoSlider.progressView setProgress:playable animated:NO];
}

/** 重置ControlView */
- (void)resetControlView {
    self.videoSlider.value           = 0;
    self.videoSlider.progressView.progress = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
}

/** 播放按钮状态 */
- (void)setPlayState:(BOOL)isPlay {
    self.startBtn.selected = isPlay;
}

- (void)playerShowResolutionView {

}



- (void)playerBegin:(SuperPlayerModel *)model
             isLive:(BOOL)isLive
     isTimeShifting:(BOOL)isTimeShifting
{
    [self setPlayState:YES];
    
    [_resolutionBtn setTitle:@"" forState:UIControlStateNormal];
    
    if (model.playingDefinition == nil) {
        return;
    }
    [_resolutionBtn setTitle:model.playingDefinition forState:UIControlStateNormal];
}

- (void)setOrientationLandscapeConstraint {
    self.fullScreen             = YES;
    self.fullScreenBtn.selected = YES;
    self.moreBtn.hidden = NO;
    self.backBtn.hidden = NO;
    self.muteBtn.hidden = NO;
    [self.resolutionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@60);
    }];
    
    self.videoSlider.hiddenPoints = NO;
}

- (void)setOrientationPortraitConstraint {
    self.fullScreen             = NO;
    self.fullScreenBtn.selected = NO;
    self.moreBtn.hidden = YES;
    self.backBtn.hidden = YES;
    self.muteBtn.hidden = YES;
    [self.resolutionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@0);
    }];
    
    
    self.videoSlider.hiddenPoints = YES;
}
@end
