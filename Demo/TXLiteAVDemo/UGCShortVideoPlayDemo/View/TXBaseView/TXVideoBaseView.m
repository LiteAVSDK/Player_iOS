//
//  TXVideoControlView.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/18.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXVideoBaseView.h"
#import "TXVideoPlayMem.h"
#import "TXLineLoadingView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface TXVideoBaseView()<TXSliderViewDelegate>

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, assign) BOOL isStartSeek;

@end

@implementation TXVideoBaseView

- (instancetype)init {
    if (self = [super init]) {
        
        [self addSubview:self.coverImgView];
        [self addSubview:self.playBtn];
        [self addSubview:self.sliderView];
        [self addSubview:self.timeView];
        
        [self.coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
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

- (void)setModel:(TXVideoModel *)model {
    float duration = [model.duration floatValue];
    self.sliderView.slider.maximumValue = duration;
    [self.sliderView.slider setValue:0];
    
    _model = model;
    
//    if ([model.width floatValue] > [model.height floatValue]) {
//        self.coverImgView.contentMode = UIViewContentModeScaleAspectFit;
//    }else {
//        self.coverImgView.contentMode = UIViewContentModeScaleAspectFill;
//    }
    
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (model.coverUrl) {
        [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@"img_video_loading"]];
    }
}

#pragma mark - Public Method
- (void)setProgress:(float)progress {
    if (_isStartSeek) {
        return;
    }
    [self.sliderView setProgress:progress];
}

- (void)showPlayBtn {
    self.playBtn.hidden = NO;
}

- (void)hidePlayBtn {
    self.playBtn.hidden = YES;
}

- (void)startLoading {
    [self.sliderView hideSlider];
    [TXLineLoadingView showLoadingInView:self.sliderView withLineHeight:2];
}

- (void)stopLoading {
    [self.sliderView showSlider];
    [TXLineLoadingView hideLoadingInView:self.sliderView];
}

- (void)setTXtimeLabel:(NSString *)time {
    [self.timeView setTXtimeLabel:time];
}

#pragma mark - Private Method
- (NSString *)detailCurrentTime:(int)currentTime totalTime:(int)totalTime {
    if (currentTime <= 0) {
        return [NSString stringWithFormat:@"00:00/%02d:%02d",(int)(totalTime / 60), (int)(totalTime % 60)];
    }
    return  [NSString stringWithFormat:@"%02d:%02d/%02d:%02d", (int)(currentTime / 60), (int)(currentTime % 60), (int)(totalTime / 60), (int)(totalTime % 60)];
}

#pragma mark - Action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSTimeInterval delayTime = 0.3f;
    [self performSelector:@selector(controlViewDidClick) withObject:nil afterDelay:delayTime];
}

- (void)controlViewDidClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewDidClickSelf:)]) {
        [self.delegate controlViewDidClickSelf:self];
    }
}

- (void)playVideo {
    [self controlViewDidClick];
}

#pragma mark - TXSliderViewDelegate
-(void)onSeekBegin:(UISlider *)slider {
    _isStartSeek = YES;
}

-(void)onSeek:(UISlider *)slider {
    int progress = slider.value + 0.5;
    int duration = slider.maximumValue + 0.5;
    [_timeView setTXtimeLabel:[self detailCurrentTime:progress totalTime:duration]];
    [_sliderView.slider setValue:slider.value];
}

-(void)onSeekEnd:(UISlider *)slider {
    _isStartSeek = NO;
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

#pragma mark - 懒加载
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton new];
        [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.hidden = YES;
    }
    return _playBtn;
}

- (UIImageView *)coverImgView {
    if (!_coverImgView) {
        _coverImgView = [UIImageView new];
        _coverImgView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImgView.clipsToBounds = YES;
    }
    return _coverImgView;
}

- (TXSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [TXSliderView new];
        _sliderView.backgroundColor = [UIColor clearColor];
        _sliderView.delegate = self;
    }
    return _sliderView;
}

- (TXTimeView *)timeView {
    if (!_timeView) {
        _timeView = [TXTimeView new];
        _timeView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
        _timeView.layer.cornerRadius = 15;
        _timeView.layer.masksToBounds = YES;
    }
    return _timeView;
}

@end
