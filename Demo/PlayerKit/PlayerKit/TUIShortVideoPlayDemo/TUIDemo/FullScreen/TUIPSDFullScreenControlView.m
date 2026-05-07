//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import "PlayerKitCommonHeaders.h"
#import "TUIPSDFullScreenControlView.h"
#import "TUIShortVideoSliderView.h"
#import "TUIShortVideoTimeView.h"
#import "TUIPSDLoadingView.h"
#import "TUIPSVDResourceManager.h"
#import "TUIPSVDCommonDefine.h"
#import "TUIPSVDResourceManager.h"

@interface TUIPSDFullScreenControlView()<TUIShortVideoSliderViewDelegate>
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) TUIShortVideoSliderView *sliderView;/// 滚动条控件
@property (nonatomic, assign) BOOL isSeeking;    ///是否正在滑动
@property (nonatomic, strong) TUIShortVideoTimeView *timeView;/// 视频播放时长和总时长控件
@property (nonatomic, strong) UIButton *playBtn;///播放按钮
@property (nonatomic, assign) float duration;///视频总时长

@end
@implementation TUIPSDFullScreenControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isSeeking = NO;
        
        [self addSubview:self.backButton];
        [self addSubview:self.sliderView];
        [self addSubview:self.timeView];
        [self addSubview:self.playBtn];
        
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(3);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
            make.height.equalTo(@(35));
            make.width.equalTo(@(55));
        }];
        
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
        
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.right.equalTo(self.mas_right).offset(-8);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-8);
        }];
        [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.sliderView.mas_centerX);
            make.bottom.equalTo(self.sliderView.mas_top).offset(3);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(30);
        }];
    }
    self.isPlaying = YES;
    
    return self;
}


#pragma mark - touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self playVideo];
}
#pragma mark - Publick Methods
- (void)setCurrentTime:(float)time {
    NSString *timeLabelStr = [self detailCurrentTime:time totalTime:self.duration];
    [self.timeView setShortVideoTimeLabel:timeLabelStr];
}

- (void)setDurationTime:(float)time {
    self.duration = time;
    [self.sliderView setProgress:0];
    NSString *timeLabelStr = [self detailCurrentTime:0 totalTime:time];
    [self.timeView setShortVideoTimeLabel:timeLabelStr];
}

- (void)setProgress:(float)progress {
    if (_isSeeking) {
        return;
    }
    [self.sliderView setProgress:progress];
}

- (void)progressViewHidden:(BOOL)hidden {
    self.sliderView.hidden = hidden;
    self.timeView.hidden = hidden;
}

- (void)setPlayerStatus:(BOOL)isPlay {
    self.playBtn.hidden = isPlay;
    self.isPlaying = isPlay;
}
#pragma mark - lazyload
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[TUIPSVDResourceManager assetImageWithName:@"tuipsvd_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (TUIShortVideoSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[TUIShortVideoSliderView alloc] init];
        _sliderView.backgroundColor = [UIColor clearColor];
        _sliderView.delegate = self;
    }
    return _sliderView;
}

- (TUIShortVideoTimeView *)timeView {
    if (!_timeView) {
        _timeView = [[TUIShortVideoTimeView alloc] init];
        _timeView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
        _timeView.layer.cornerRadius = 15;
        _timeView.layer.masksToBounds = YES;
    }
    return _timeView;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[TUIPSVDResourceManager assetImageWithName:@"pause"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.hidden = YES;
    }
    return _playBtn;
}

#pragma mark - Button Action
-(void)backButtonClick:(UIButton*)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backAction)]) {
        [self.delegate backAction];
    }
}
- (void)playVideo {
    if (self.isPlaying == YES) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(pause)]) {
            [self.delegate pause];
            self.isPlaying = NO;
            self.playBtn.hidden = NO;
        }
    } else {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(resume)]) {
            [self.delegate resume];
            self.isPlaying = YES;
            self.playBtn.hidden = YES;
        }
    }
}
#pragma mark - TUIShortVideoSliderViewDelegate
- (void)onSeek:(nonnull UISlider *)slider {
    int progress = slider.value + 0.5;
    int duration = slider.maximumValue + 0.5;
    [_timeView setShortVideoTimeLabel:[self detailCurrentTime:progress totalTime:duration]];
    [_sliderView.slider setValue:slider.value];
}

- (void)onSeekBegin:(nonnull UISlider *)slider {
    _isSeeking = YES;
}

- (void)onSeekEnd:(nonnull UISlider *)slider {
    _isSeeking = NO;
    float sliderValue;
    if (slider.value >= slider.maximumValue) {
        sliderValue = slider.maximumValue;
    } else {
        sliderValue = slider.value;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(seekToTime:)]) {
        [self.delegate seekToTime:sliderValue];
    }
}

- (void)onSeekOutSide:(nonnull UISlider *)slider {
    _isSeeking = NO;
}

#pragma mark - private Methods
- (NSString *)detailCurrentTime:(float)currentTime totalTime:(float)totalTime {
    
    /// 错误时间戳设置
    if (currentTime <= 0) {
        return [NSString stringWithFormat:@"00:00/%02d:%02d",(int)(totalTime / 60), ((int)totalTime % 60)];
    }
    /// 返回正常时间戳设置
    return  [NSString stringWithFormat:@"%02d:%02d/%02d:%02d", (int)(currentTime / 60), (int)((int)currentTime % 60), ((int)totalTime / 60), ((int)totalTime % 60)];
}
@end
