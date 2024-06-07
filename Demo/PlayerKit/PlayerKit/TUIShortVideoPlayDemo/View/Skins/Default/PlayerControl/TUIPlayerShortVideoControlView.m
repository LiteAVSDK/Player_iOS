// Copyright (c) 2023 Tencent. All rights reserved.

#import "TUIPlayerShortVideoControlView.h"
#import "TUIShortVideoSliderView.h"
#import "TUIShortVideoTimeView.h"
#import "TUIPSDLoadingView.h"
#import "PlayerKitCommonHeaders.h"
#import "SDWebImage.h"
#import "TXAppInstance.h"
@interface TUIPlayerShortVideoControlView() <TUIPlayerShortVideoControl,TUIShortVideoSliderViewDelegate>
///当前播放器是否正在播放
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) TUIPSDLoadingView *loadingView;///loading
@property (nonatomic, strong) TUIShortVideoSliderView *sliderView;/// 滚动条控件
@property (nonatomic, assign) BOOL isSeeking;    ///是否正在滑动
@property (nonatomic, strong) TUIShortVideoTimeView *timeView;/// 视频播放时长和总时长控件
@property (nonatomic, strong) UIButton *playBtn;///播放按钮
@property (nonatomic, assign) float duration;///视频总时长
@end

@implementation TUIPlayerShortVideoControlView

@synthesize delegate;


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.isSeeking = NO;
        
        
        [self addSubview:self.sliderView];
        [self addSubview:self.timeView];
        [self addSubview:self.playBtn];
        
      
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-52);
            make.width.equalTo(self);
            make.height.mas_equalTo(80);
        }];
        [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.sliderView).offset(-20);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

#pragma mark - lazyload
- (TUIPSDLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[TUIPSDLoadingView alloc] init];
    }
    return _loadingView;
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
        [_playBtn setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"pause"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.hidden = YES;
    }
    return _playBtn;
}
#pragma mark - Button Action
- (void)playVideo {
    if (self.isPlaying == YES) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(pause)]) {
            [self.delegate pause];
        }
    } else {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(resume)]) {
            [self.delegate resume];
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


#pragma mark - TUIPlayerShortVideoControl

- (void)showLoadingView {
    [self.loadingView startLoading];
}

- (void)hiddenLoadingView {
    [self.loadingView stopLoading];
}

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

- (void)showSlider {
    self.sliderView.hidden = NO;
}
- (void)hideSlider {
    self.sliderView.hidden = YES;
}

- (void)hideCenterView {
    self.playBtn.hidden = YES;
}

- (void)showCenterView {
    self.playBtn.hidden = NO;
}
- (void)reloadControlData {
    
}
- (void)getPlayer:(TUITXVodPlayer *)player {
    /// Get current player
}
- (void)onPlayEvent:(TUITXVodPlayer *)player
              event:(int)EvtID
          withParam:(NSDictionary *)param {
    ///Get the real-time status of the player
}
#pragma mark - touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isPlaying == YES) {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(pause)]) {
            [self.delegate pause];
        }
    } else {
        if (self.delegate &&
            [self.delegate respondsToSelector:@selector(resume)]) {
            [self.delegate resume];
        }
    }
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

- (BOOL)isPlaying {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(isPlaying)]) {
        return [self.delegate isPlaying];
    }
    return NO;
}
@end
