// Copyright (c) 2023 Tencent. All rights reserved.

#import "TUIPlayerShortVideoControlView.h"
#import "TUIShortVideoSliderView.h"
#import "TUIShortVideoTimeView.h"
#import "TUIPSDLoadingView.h"
#import "TUIPSVDResourceManager.h"
#import "TUIPSVDCommonDefine.h"
#import "TUIPSVDResourceManager.h"
#import "TUIPSDFullScreenViewController.h"
#import "TUIPSVDCommentViewController.h"
#import "PlayerKitCommonHeaders.h"

@interface TUIPlayerShortVideoControlView() <TUIPlayerShortVideoControl,
TUIShortVideoSliderViewDelegate,
TUIPSDFullScreenViewControllerDelegate,
TUIPSVDCommentViewControllerDelegate>
///当前播放器是否正在播放
@property (nonatomic, weak) TUITXVodPlayer *vodPlayer;
@property (nonatomic, weak) UIView *videoWidget;
@property (nonatomic, assign) CGRect videoLayerRect;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) TUIPSDLoadingView *loadingView;///loading
@property (nonatomic, strong) TUIShortVideoSliderView *sliderView;/// 滚动条控件
@property (nonatomic, assign) BOOL isSeeking;    ///是否正在滑动
@property (nonatomic, strong) TUIShortVideoTimeView *timeView;/// 视频播放时长和总时长控件
@property (nonatomic, strong) UIButton *playBtn;///播放按钮
@property (nonatomic, assign) float duration;///视频总时长
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *fangdaButton;
@property (nonatomic, strong) UIButton *resolutionButton;
@property (nonatomic, strong) UILabel *stateLabel;
@end

@implementation TUIPlayerShortVideoControlView

@synthesize delegate;


- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.isSeeking = NO;
        
        
        [self addSubview:self.sliderView];
        [self addSubview:self.timeView];
        [self addSubview:self.playBtn];
        [self addSubview:self.commentButton];
        [self addSubview:self.fangdaButton];
        [self addSubview:self.resolutionButton];
        [self addSubview:self.stateLabel];
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
        [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.width.height.equalTo(self.resolutionButton);
            make.bottom.equalTo(self.fangdaButton.mas_top);
        }];
        [self.fangdaButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.width.height.equalTo(self.resolutionButton);
            make.bottom.equalTo(self.resolutionButton.mas_top);
        }];
        [self.resolutionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-150);
            make.bottom.equalTo(self.mas_bottom).offset(-200);
            make.right.equalTo(self.mas_right).offset(-20);
            make.width.equalTo(@(50));
            make.height.equalTo(@(50));
        }];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(100);
            make.right.equalTo(self.mas_right).offset(-10);
            make.left.equalTo(self.mas_left).offset(10);
        }];
        self.stateLabel.hidden = YES;
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
        [_playBtn setImage:[TUIPSVDResourceManager assetImageWithName:@"pause"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.hidden = YES;
    }
    return _playBtn;
}
- (UIButton *)commentButton {
    if (!_commentButton) {
        _commentButton = [[UIButton alloc] init];
        _commentButton.backgroundColor = TUIPSVD_COLOR_BLACK;
        [_commentButton setImage:[TUIPSVDResourceManager assetImageWithName:@"tuipsvd_comment"] forState:UIControlStateNormal];
        [_commentButton addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}
- (UIButton *)fangdaButton {
    if (!_fangdaButton) {
        _fangdaButton = [[UIButton alloc] init];
        _fangdaButton.backgroundColor = TUIPSVD_COLOR_BLACK;
        [_fangdaButton setImage:[TUIPSVDResourceManager assetImageWithName:@"tuipsvd_fullscreen"] forState:UIControlStateNormal];
        [_fangdaButton addTarget:self action:@selector(fangdaButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fangdaButton;
}
- (UIButton *)resolutionButton {
    if (!_resolutionButton) {
        _resolutionButton = [[UIButton alloc] init];
        _resolutionButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_resolutionButton setTitle:@"画质" forState:UIControlStateNormal];
        _resolutionButton.backgroundColor = TUIPSVD_COLOR_BLACK;
        [_resolutionButton addTarget:self action:@selector(resolutionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resolutionButton;
}
- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.backgroundColor = TUIPSVD_COLOR_BLACK;
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.numberOfLines = 0;
    }
    return _stateLabel;
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
    int progress = (slider.value) * self.duration ;
    int duration = (slider.maximumValue ) * self.duration;
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

// 暂时不对外暴露，只控制拖拽时label的变化
-(void)onSeekDragging:(UISlider *)slider{
    int progress = (slider.value) * self.duration ;
    int duration = (slider.maximumValue ) * self.duration;
    [_timeView setShortVideoTimeLabel:[self detailCurrentTime:progress totalTime:duration]];
}


- (void)resolutionButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customCallbackEvent:)]) {
        [self.delegate customCallbackEvent:@"resolutionAction"];
    }
}
- (void)commentButtonClick {
    TUIPSVDCommentViewController *vc = [[TUIPSVDCommentViewController alloc] init];
    vc.videoLayoutRect = self.videoLayerRect;
    vc.playerView = self.videoWidget;
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.window.rootViewController presentViewController:vc animated:NO completion:^{
        
    }];
}
- (void)fangdaButtonClick {
    self.hidden = YES;
    TUIPSDFullScreenViewController *vc = [[TUIPSDFullScreenViewController alloc] init];
    vc.playerView = self.videoWidget;
    vc.delegate = self;
    vc.vodPlayer = self.vodPlayer;
    vc.type = 1;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.window.rootViewController presentViewController:vc animated:NO completion:^{
        
    }];
}
#pragma mark - TUIPSVDCommentViewControllerDelegate
- (void)CommentViewControllerDismissed {
    self.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(resetVideoWeigetContainer)]) {
        [self.delegate resetVideoWeigetContainer];
    }
    self.hidden = NO;
}
#pragma mark - TUIPSDFullScreenViewControllerDelegate
- (void)viewControllerDismissed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(resetVideoWeigetContainer)]) {
        [self.delegate resetVideoWeigetContainer];
    }
    self.hidden = NO;
}

- (void)resume {
    if ([self.delegate respondsToSelector:@selector(resume)]) {
        [self.delegate resume];
    }
}

- (void)pause {
    if ([self.delegate respondsToSelector:@selector(pause)]) {
        [self.delegate pause];
    }
}

#pragma mark - TUIPlayerShortVideoControl
- (void)setModel:(TUIPlayerVideoModel *)model {
    self.stateLabel.text = @"";
    [self.sliderView setProgress:0];
}
- (void)getVideoWidget:(UIView *)view {
    self.videoWidget = view;
}
- (void)getVideoLayerRect:(CGRect)rect {
    self.videoLayerRect = rect;
}
- (void)showLoadingView {
    [self.loadingView startLoading];
}

- (void)hiddenLoadingView {
    [self.loadingView stopLoading];
}

- (void)setCurrentTime:(float)time {
    if(self.isSeeking){
        return;
    }
    NSString *timeLabelStr = [self detailCurrentTime:time totalTime:self.duration];
    [self.timeView setShortVideoTimeLabel:timeLabelStr];
}

- (void)setDurationTime:(float)time {
    if(time == self.duration){
        return;
    }
    if(self.isSeeking){
        return;
    }
    self.duration = time;
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
    self.vodPlayer = player;
}
- (void)onPlayEvent:(TUITXVodPlayer *)player
              event:(int)EvtID
          withParam:(NSDictionary *)param {
    ///Get the real-time status of the player
    if (EvtID == 2005) {
        return;
    }
    
    NSString *newText = [NSString stringWithFormat:@"EvtID:%d param:%@", EvtID, param.description];
    if (![self.stateLabel.text isEqualToString:newText]) {
        self.stateLabel.text = newText;
        return;
    }
}

- (void)onPlayer:(TUITXVodPlayer *)player subtitleData:(TXVodSubtitleData *)subtitleData {
    if (![player isEqual:self.vodPlayer]) {
        return;
    }
    // Rendering subtitles
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
