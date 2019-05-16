//
//  SPWeiboControlView.m
//  SuperPlayer
//
//  Created by annidyfeng on 2018/10/8.
//

#import "SPWeiboControlView.h"
#import <Masonry/Masonry.h>
#import "UIView+Fade.h"
#import "UIView+MMLayout.h"
#import "StrUtils.h"
#import "DataReport.h"
#import "SuperPlayer.h"

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
        make.width.mas_equalTo(@60);
    }];

    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-10);
        make.centerY.equalTo(self.backBtn);
        make.width.mas_equalTo(@40);
    }];
    [self.muteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.moreBtn.mas_leading).offset(-10);
        make.centerY.equalTo(self.backBtn);
        make.width.mas_equalTo(@40);
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
        [_resolutionBtn addTarget:self action:@selector(resolutionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resolutionBtn;
}

- (PlayerSlider *)videoSlider {
    if (!_videoSlider) {
        _videoSlider                       = [[PlayerSlider alloc] init];
        [_videoSlider setThumbImage:SuperPlayerImage(@"wb_thumb") forState:UIControlStateNormal];
        _videoSlider.minimumTrackTintColor = RGBA(223, 223, 223, 1);
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside|UIControlEventTouchCancel];
        _videoSlider.delegate = self;
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
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
- (UIButton *)muteBtn {
    if (!_muteBtn) {
        _muteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_muteBtn setImage:SuperPlayerImage(@"wb_volume_on") forState:UIControlStateNormal];
        [_muteBtn setImage:SuperPlayerImage(@"wb_volume_off") forState:UIControlStateSelected];
        [_muteBtn addTarget:self action:@selector(muteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muteBtn;
}

- (UIView *)resolutionView {
    if (!_resolutionView) {
        // 添加分辨率按钮和分辨率下拉列表
        
        _resolutionView = [[UIView alloc] initWithFrame:CGRectZero];
        _resolutionView.hidden = YES;
        [self addSubview:_resolutionView];
        [_resolutionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(330);
            make.height.mas_equalTo(self.mas_height);
            make.trailing.equalTo(self.mas_trailing).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
        
        _resolutionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _resolutionView;
}

- (MoreContentView *)moreContentView {
    if (!_moreContentView) {
        _moreContentView = [[MoreContentView alloc] initWithFrame:CGRectZero];
        _moreContentView.controlView = self;
        [self addSubview:_moreContentView];
        [_moreContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(330);
            make.height.mas_equalTo(self.mas_height);
            make.trailing.equalTo(self.mas_trailing).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
        _moreContentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _moreContentView;
}

- (void)playBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.delegate controlViewPlay:self];
    } else {
        [self.delegate controlViewPause:self];
    }
    [self cancelFadeOut];
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.delegate controlViewChangeScreen:self withFullScreen:sender.selected];
}

- (void)progressSliderTouchBegan:(UISlider *)sender {
    self.isDragging = YES;
    self.startBtn.hidden = YES; // 播放按钮挡住了fastView
    [self cancelFadeOut];
}

- (void)progressSliderValueChanged:(UISlider *)sender {
    [self.delegate controlViewPreview:self where:sender.value];
}

- (void)progressSliderTouchEnded:(UISlider *)sender {
    [self.delegate controlViewSeek:self where:sender.value];
    self.isDragging = NO;
    self.startBtn.hidden = NO;
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

- (void)muteBtnClick:(UIButton *)sender
{
    sender.selected = self.playerConfig.mute = !self.playerConfig.mute;
    [self.delegate controlViewConfigUpdate:self withReload:NO];
    [self fadeOut:3];
}


/** 重置ControlView */
- (void)resetControlView {
    self.videoSlider.value           = 0;
    self.videoSlider.progressView.progress = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.moreContentView.hidden      = YES;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    for (UIView *view in self.subviews) {
        if (view != self.resolutionView && view != self.moreContentView) {
            if (!self.isFullScreen && (view == self.backBtn || view == self.moreBtn || view == self.muteBtn))
                view.hidden = YES;
            else
                view.hidden = NO;
        } else {
            view.hidden = YES;
        }
    }
    self.isShowSecondView = NO;
    self.pointJumpBtn.hidden = YES;
}

/** 播放按钮状态 */
- (void)setPlayState:(BOOL)isPlay {
    self.startBtn.selected = isPlay;
}

- (void)resolutionBtnClick:(UIButton *)sender {
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
   
    // 显示分辨率View
    self.resolutionView.hidden = NO;
    [DataReport report:@"change_resolution" param:nil];
    
    [self cancelFadeOut];
    self.isShowSecondView = YES;
}

- (void)moreBtnClick:(UIButton *)sender {
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
    
    self.moreContentView.playerConfig = self.playerConfig;
    self.moreContentView.isLive = self.isLive;
    [self.moreContentView update];
    self.moreContentView.hidden = NO;
    
    [self cancelFadeOut];
    self.isShowSecondView = YES;
}

- (void)playerBegin:(SuperPlayerModel *)model
             isLive:(BOOL)isLive
     isTimeShifting:(BOOL)isTimeShifting
         isAutoPlay:(BOOL)isAutoPlay
{
    [self setPlayState:isAutoPlay];

    _resolutionArray = model.playDefinitions;
    if (model.playingDefinition != nil) {
        [_resolutionBtn setTitle:model.playingDefinition forState:UIControlStateNormal];
    }
    
    for (UIView *subview in self.resolutionView.subviews)
        [subview removeFromSuperview];
    
    UILabel *lable = [UILabel new];
    lable.text = @"清晰度";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    [self.resolutionView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.resolutionView.mas_width);
        make.height.mas_equalTo(30);
        make.left.equalTo(self.resolutionView.mas_left);
        make.top.equalTo(self.resolutionView.mas_top).mas_offset(20);
    }];
    
    // 分辨率View上边的Btn
    for (NSInteger i = 0 ; i < _resolutionArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_resolutionArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(252, 89, 81, 1) forState:UIControlStateSelected];
        [self.resolutionView addSubview:btn];
        [btn addTarget:self action:@selector(changeResolution:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.resolutionView.mas_width);
            make.height.mas_equalTo(45);
            make.left.equalTo(self.resolutionView.mas_left);
            make.centerY.equalTo(self.resolutionView.mas_centerY).offset((i-self.resolutionArray.count/2.0+0.5)*45);
        }];
        
        if ([_resolutionArray[i] isEqualToString:model.playingDefinition]) {
            btn.selected = YES;
            btn.backgroundColor = RGBA(34, 30, 24, 1);
            self.resoultionCurrentBtn = btn;
        }
    }
    if (self.isLive != isLive) {
        self.isLive = isLive;
        [self setNeedsLayout];
    }
    // 时移的时候不能切清晰度
    self.resolutionBtn.userInteractionEnabled = !isTimeShifting;
}

/**
 *  点击切换分别率按钮
 */
- (void)changeResolution:(UIButton *)sender {
    self.resoultionCurrentBtn.selected = NO;
    self.resoultionCurrentBtn.backgroundColor = [UIColor clearColor];
    self.resoultionCurrentBtn = sender;
    self.resoultionCurrentBtn.selected = YES;
    self.resoultionCurrentBtn.backgroundColor = RGBA(34, 30, 24, 1);
    
    // topImageView上的按钮的文字
    [self.resolutionBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    [self.delegate controlViewSwitch:self withDefinition:sender.titleLabel.text];
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
    self.pointJumpBtn.hidden = YES;
}

- (void)setPointArray:(NSArray *)pointArray
{
    [super setPointArray:pointArray];
    
    for (PlayerPoint *holder in self.videoSlider.pointArray) {
        [holder.holder removeFromSuperview];
    }
    [self.videoSlider.pointArray removeAllObjects];
    
    for (SuperPlayerVideoPoint *p in pointArray) {
        PlayerPoint *point = [self.videoSlider addPoint:p.where];
        point.content = p.text;
        point.timeOffset = p.time;
    }
}

- (UIButton *)pointJumpBtn {
    if (!_pointJumpBtn) {
        _pointJumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = SuperPlayerImage(@"copywright_bg");
        UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
        [_pointJumpBtn setBackgroundImage:resizableImage forState:UIControlStateNormal];
        _pointJumpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_pointJumpBtn addTarget:self action:@selector(pointJumpClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pointJumpBtn];
    }
    return _pointJumpBtn;
}

- (void)pointJumpClick:(UIButton *)sender {
    PlayerPoint *point = [self.videoSlider.pointArray objectAtIndex:self.pointJumpBtn.tag];
    [self.delegate controlViewSeek:self where:point.where];
    [self fadeOut:0.1];
}

- (void)onPlayerPointSelected:(PlayerPoint *)point {
    NSString *text = [NSString stringWithFormat:@"  %@ %@  ", [StrUtils timeFormat:point.timeOffset],
                      point.content];
    
    [self.pointJumpBtn setTitle:text forState:UIControlStateNormal];
    [self.pointJumpBtn sizeToFit];
    CGFloat x = self.videoSlider.mm_x + self.videoSlider.mm_w * point.where - self.pointJumpBtn.mm_w/2;
    if (x < 0)
        x = 0;
    if (x + self.pointJumpBtn.mm_w/2 > ScreenWidth)
        x = ScreenWidth - self.pointJumpBtn.mm_w/2;
    self.pointJumpBtn.tag = [self.videoSlider.pointArray indexOfObject:point];
    self.pointJumpBtn.mm_left(x).mm_bottom(60);
    self.pointJumpBtn.hidden = NO;
    
    [DataReport report:@"player_point" param:nil];
}
@end
