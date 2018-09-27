#import "SuperPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "MoreContentView.h"
#import "DataReport.h"
#import "SuperPlayerFastView.h"
#import "PlayerSlider.h"
#import "UIView+MMLayout.h"
#import "SuperPlayerView+Private.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

#define MODEL_TAG_BEGIN 20


static const CGFloat SuperPlayerAnimationTimeInterval             = 7.0f;
static const CGFloat SuperPlayerControlBarAutoFadeOutTimeInterval = 0.15f;

@interface SuperPlayerControlView () <UIGestureRecognizerDelegate, PlayerSliderDelegate>


/** 小屏播放 */
@property (nonatomic, assign, getter=isShrink ) BOOL  shrink;
/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign, getter=isDragged) BOOL  dragged;
/** 是否播放结束 */
@property (nonatomic, assign, getter=isPlayEnd) BOOL  playeEnd;
/** 是否全屏播放 */
@property (nonatomic, assign,getter=isFullScreen)BOOL fullScreen;
@property (nonatomic, assign,getter=isLockScreen)BOOL isLockScreen;

@property (nonatomic, strong) UIButton               *pointJumpBtn;

@property BOOL isLive;

- (void)autoFadeOutControlView;

@end

@implementation SuperPlayerControlView

- (instancetype)init {
    self = [super init];
    if (self) {

        [self addSubview:self.placeholderImageView];
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.videoSlider];
        [self.bottomImageView addSubview:self.resolutionBtn];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        
        [self.topImageView addSubview:self.captureBtn];
        [self.topImageView addSubview:self.danmakuBtn];
        [self.topImageView addSubview:self.moreBtn];
        [self addSubview:self.lockBtn];
        [self.topImageView addSubview:self.backBtn];
        [self addSubview:self.activity];
        [self addSubview:self.repeatBtn];
        [self addSubview:self.playeBtn];
        [self addSubview:self.middleBtn];
        
        [self addSubview:self.fastView];
        
        [self.topImageView addSubview:self.titleLabel];
        [self addSubview:self.closeBtn];

        
        [self addSubview:self.backLiveBtn];
        
        // 添加子控件的约束
        [self makeSubViewsConstraints];
        
        self.captureBtn.hidden = YES;
        self.danmakuBtn.hidden = YES;
        self.moreBtn.hidden     = YES;
        self.resolutionBtn.hidden   = YES;
        // 初始化时重置controlView
        [self playerResetControlView];

        [self listeningRotating];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)makeSubViewsConstraints {
    [self.placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(7);
        make.top.equalTo(self.mas_top).offset(-7);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topImageView.mas_leading).offset(5);
        make.top.equalTo(self.topImageView.mas_top).offset(3);
        make.width.height.mas_equalTo(40);
    }];

    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(49);
        make.trailing.equalTo(self.topImageView.mas_trailing).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];

    [self.captureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(49);
        make.trailing.equalTo(self.moreBtn.mas_leading).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.danmakuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(49);
        make.trailing.equalTo(self.captureBtn.mas_leading).offset(-10);
        make.centerY.equalTo(self.backBtn.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backBtn.mas_trailing).offset(5);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.trailing.equalTo(self.captureBtn.mas_leading).offset(-10);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
        make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-5);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-8);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.resolutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(45);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-8);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.fullScreenBtn.mas_leading);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(60);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(60);
    }];
    
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(32);
    }];
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.center.equalTo(self);
    }];
    
    [self.playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.equalTo(self);
    }];
    
    [self.activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.with.height.mas_equalTo(45);
    }];
    
    [self.middleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.mas_equalTo(33);
    }];
    
    [self.fastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.backLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.startBtn.mas_top).mas_offset(-15);
        make.width.mas_equalTo(70);
        make.centerX.equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIDeviceOrientationPortrait) {
        [self setOrientationPortraitConstraint];
    } else {
        [self setOrientationLandscapeConstraint];
    }
}


#pragma mark - Action

/**
 *  点击切换分别率按钮
 */
- (void)changeResolution:(UIButton *)sender {

    self.resoultionCurrentBtn.selected = NO;
    self.resoultionCurrentBtn.backgroundColor = [UIColor clearColor];
    self.resoultionCurrentBtn = sender;
    // 分辨率Btn改为normal状态
    self.resolutionBtn.selected = NO;
    // topImageView上的按钮的文字
    [self.resolutionBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(onControlView:resolutionAction:)]) {
        SuperPlayerUrl *model = [_resolutionArray objectAtIndex:sender.tag-MODEL_TAG_BEGIN];
        if (model) {
            [self.delegate onControlView:self resolutionAction:model];
        }
    }
    sender.selected = YES;
    if (sender.isSelected) {
        sender.backgroundColor = RGBA(34, 30, 24, 1);
    } else {
        sender.backgroundColor = [UIColor clearColor];
    }
    
    self.resolutionView.hidden = YES;
}

- (void)backBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(onControlView:backAction:)]) {
        [self.delegate onControlView:self backAction:sender];
    }
}

- (void)lockScrrenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.isLockScreen = sender.selected;
    [self showOrHideLockView];
    if ([self.delegate respondsToSelector:@selector(onControlView:lockScreenAction:)]) {
        [self.delegate onControlView:self lockScreenAction:sender];
    }
}

- (void)playBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(onControlView:playAction:)]) {
        [self.delegate onControlView:self playAction:sender];
    }
}

- (void)closeBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onControlView:closeAction:)]) {
        [self.delegate onControlView:self closeAction:sender];
    }
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(onControlView:fullScreenAction:)]) {
        [self.delegate onControlView:self fullScreenAction:sender];
    }
}

- (void)repeatBtnClick:(UIButton *)sender {
    // 重置控制层View
    [self playerResetControlView];
    [self playerShowControlView];
    if ([self.delegate respondsToSelector:@selector(onControlView:repeatPlayAction:)]) {
        [self.delegate onControlView:self repeatPlayAction:sender];
    }
}

- (void)captureBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onControlView:captureAction:)]) {
        [self.delegate onControlView:self captureAction:sender];
    }
}

- (void)danmakuBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(onControlView:captureAction:)]) {
        [self.delegate onControlView:self danmakuAction:sender];
    }
}

- (void)moreBtnClick:(UIButton *)sender {
    [self hideControlView];
    
    [self.moreContentView updateContents:self.isLive];
    self.moreView.contentSize = self.moreView.bounds.size;
    self.moreView.hidden = NO;
    [self.moreContentView updateData];
    
    [self playerCancelAutoFadeOutControlView];
}

- (void)playerShowResolutionView {
    [self hideControlView];
    // 显示隐藏分辨率View
    self.resolutionView.hidden = NO;
    [DataReport report:@"change_resolution" param:nil];
    
    [self playerCancelAutoFadeOutControlView];
}

- (void)centerPlayBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onControlView:cneterPlayAction:)]) {
        [self.delegate onControlView:self cneterPlayAction:sender];
    }
}

- (void)failBtnClick:(UIButton *)sender {
    sender.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(onControlView:failAction:)]) {
        [self.delegate onControlView:self failAction:sender];
    }
}

- (void)badNetBtnClick:(UIButton *)sender {
    sender.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(onControlView:badNetAction:)]) {
        [self.delegate onControlView:self badNetAction:sender];
    }
}

- (void)progressSliderTouchBegan:(UISlider *)sender {
    [self playerCancelAutoFadeOutControlView];
}

- (void)progressSliderValueChanged:(UISlider *)sender {
    if ([self.delegate respondsToSelector:@selector(onControlView:progressSliderValueChanged:)]) {
        [self.delegate onControlView:self progressSliderValueChanged:sender];
    }
}

- (void)progressSliderTouchEnded:(UISlider *)sender {
    self.showing = YES;
    if ([self.delegate respondsToSelector:@selector(onControlView:progressSliderTouchEnded:)]) {
        [self.delegate onControlView:self progressSliderTouchEnded:sender];
    }
}

- (void)backLiveClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onControlView:backLiveAction:)]) {
        [self.delegate onControlView:self backLiveAction:sender];
    }
}

- (void)pointJumpClick:(UIButton *)sender {
    // TODO: JUMP
    if ([self.delegate respondsToSelector:@selector(onControlView:progressSliderTap:)]) {
        PlayerPoint *point = [self.videoSlider.pointArray objectAtIndex:self.pointJumpBtn.tag];
        [self.delegate onControlView:self progressSliderTap:point.where];
    }
    [self playerHideControlView];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange {
    if (self.isLockScreen) { return; }
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationPortrait) {
        self.moreView.hidden = YES;
        self.resolutionView.hidden = YES;
        [self removePointJumpBtn];
    }
}

- (void)setOrientationLandscapeConstraint {
    self.fullScreen             = YES;
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    
    [self.backBtn setImage:SuperPlayerImage(@"back_full") forState:UIControlStateNormal];
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_top).offset(23);
        make.leading.equalTo(self.topImageView.mas_leading).offset(5);
        make.width.height.mas_equalTo(40);
    }];
    
    if (IsIPhoneX) {
        [self.startBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
            make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-25);
            make.width.height.mas_equalTo(30);
        }];
    }
    
    self.videoSlider.hiddenPoints = NO;
}
/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {
    self.fullScreen             = NO;
    self.lockBtn.hidden         = !self.isFullScreen;
    self.fullScreenBtn.selected = self.isFullScreen;
    
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topImageView.mas_top).offset(3);
        make.leading.equalTo(self.topImageView.mas_leading).offset(5);
        make.width.height.mas_equalTo(40);
    }];
    
    if (IsIPhoneX) {
        [self.startBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
            make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-5);
            make.width.height.mas_equalTo(30);
        }];
    }
    
    self.videoSlider.hiddenPoints = YES;
}

#pragma mark - Private Method

- (void)showControlView {
    self.showing = YES;

    if (!self.isLockScreen || !self.fullScreen) {
        self.topImageView.alpha    = 1;
        self.bottomImageView.alpha = 1;
        self.backLiveBtn.alpha     = 1;
    }
    self.backgroundColor       = RGBA(0, 0, 0, 0.3);
    self.lockBtn.alpha             = 1;
}

- (void)hideControlView {
    self.showing = NO;
    self.backgroundColor          = RGBA(0, 0, 0, 0);
    self.topImageView.alpha       = self.playeEnd;
    self.bottomImageView.alpha    = 0;
    self.lockBtn.alpha            = 0;
    self.backLiveBtn.alpha            = 0;
    self.moreView.hidden = YES;
    self.resolutionView.hidden = YES;
    [self removePointJumpBtn];
}

- (void)showOrHideLockView {
    self.topImageView.alpha    = !self.isLockScreen;
    self.bottomImageView.alpha = !self.isLockScreen;
    self.backLiveBtn.alpha     = !self.isLockScreen;
}
/**
 *  监听设备旋转通知
 */
- (void)listeningRotating {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}


- (void)autoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playerHideControlView) object:nil];
    [self performSelector:@selector(playerHideControlView) withObject:nil afterDelay:SuperPlayerAnimationTimeInterval];
}

- (void)playerHideFastView {
    self.fastView.hidden = YES;
}

- (void)autoFadeOutFastView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playerHideFastView) object:nil];
    [self performSelector:@selector(playerHideFastView) withObject:nil afterDelay:1];
}


#pragma mark - setter

- (void)setShrink:(BOOL)shrink {
    _shrink = shrink;
    self.closeBtn.hidden = !shrink;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
    
    self.fullScreenBtn.hidden = _fullScreen;
    if (_fullScreen) {
        NSUInteger resolutionSize = _resolutionArray.count;
        if (resolutionSize > 0) {
            self.resolutionBtn.hidden = NO;
        } else {
            self.resolutionBtn.hidden = YES;
        }
        
        [self.totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (resolutionSize > 0) {
                make.trailing.equalTo(self.resolutionBtn.mas_leading);
            } else {
                make.trailing.equalTo(self.bottomImageView.mas_trailing);
            }
            make.centerY.equalTo(self.startBtn.mas_centerY);
            make.width.mas_equalTo(self.isLive?10:60);
        }];
        
    } else {
        [self.totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.fullScreenBtn.mas_leading);
            make.centerY.equalTo(self.startBtn.mas_centerY);
            make.width.mas_equalTo(self.isLive?10:60);
        }];
        self.resolutionBtn.hidden = YES;
    }
    
    self.captureBtn.hidden = !_fullScreen || self.disableCaptureBtn;
    self.danmakuBtn.hidden = !_fullScreen || self.disableDanmakuBtn;
    self.moreBtn.hidden = !_fullScreen || self.disableMoreBtn;
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:SuperPlayerImage(@"back_full") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.alpha                  = 0;
        _topImageView.image                  = SuperPlayerImage(@"top_shadow");
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.alpha                  = 0;
        _bottomImageView.image                  = SuperPlayerImage(@"bottom_shadow");
    }
    return _bottomImageView;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:SuperPlayerImage(@"unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:SuperPlayerImage(@"lock-nor") forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockScrrenBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _lockBtn;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:SuperPlayerImage(@"play") forState:UIControlStateNormal];
        [_startBtn setImage:SuperPlayerImage(@"pause") forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:SuperPlayerImage(@"close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.hidden = YES;
    }
    return _closeBtn;
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
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];

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
        [_fullScreenBtn setImage:SuperPlayerImage(@"fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn setImage:SuperPlayerImage(@"fullscreen_pressed") forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (MMMaterialDesignSpinner *)activity {
    if (!_activity) {
        _activity = [[MMMaterialDesignSpinner alloc] init];
        _activity.lineWidth = 1;
        _activity.duration  = 1;
        _activity.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    }
    return _activity;
}

- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_repeatBtn setImage:SuperPlayerImage(@"repeat_video") forState:UIControlStateNormal];
        [_repeatBtn addTarget:self action:@selector(repeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repeatBtn;
}

- (UIButton *)captureBtn {
    if (!_captureBtn) {
        _captureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_captureBtn setImage:SuperPlayerImage(@"capture") forState:UIControlStateNormal];
        [_captureBtn setImage:SuperPlayerImage(@"capture_pressed") forState:UIControlStateSelected];
        [_captureBtn addTarget:self action:@selector(captureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captureBtn;
}

- (UIButton *)danmakuBtn {
    if (!_danmakuBtn) {
        _danmakuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_danmakuBtn setImage:SuperPlayerImage(@"danmu") forState:UIControlStateNormal];
        [_danmakuBtn setImage:SuperPlayerImage(@"danmu_pressed") forState:UIControlStateSelected];
        [_danmakuBtn addTarget:self action:@selector(danmakuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _danmakuBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:SuperPlayerImage(@"more") forState:UIControlStateNormal];
        [_moreBtn setImage:SuperPlayerImage(@"more_pressed") forState:UIControlStateSelected];
        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIScrollView *)moreView {
    if (!_moreView) {
        
        _moreView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _moreView.hidden = YES;
        [self addSubview:_moreView];
        [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(330);
            make.height.mas_equalTo(self.mas_height);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
        }];
        _moreView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _moreView;
}

- (void)resetMoreView {
    
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

- (UIButton *)playeBtn {
    if (!_playeBtn) {
        _playeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playeBtn setImage:SuperPlayerImage(@"play_btn") forState:UIControlStateNormal];
        [_playeBtn addTarget:self action:@selector(centerPlayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playeBtn;
}

- (UIButton *)middleBtn {
    if (!_middleBtn) {
        _middleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_middleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _middleBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _middleBtn.backgroundColor = RGBA(0, 0, 0, 0.7);
    }
    return _middleBtn;
}

- (SuperPlayerFastView *)fastView {
    if (!_fastView) {
        _fastView = [[SuperPlayerFastView alloc] init];
    }
    return _fastView;
}

- (UIImageView *)placeholderImageView {
    if (!_placeholderImageView) {
        _placeholderImageView = [[UIImageView alloc] init];
        _placeholderImageView.userInteractionEnabled = YES;
        _placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _placeholderImageView;
}

- (UIButton *)backLiveBtn {
    if (!_backLiveBtn) {
        _backLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backLiveBtn setTitle:@"返回直播" forState:UIControlStateNormal];
        _backLiveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        UIImage *image = SuperPlayerImage(@"qg_online_bg");
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        
        UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(height * 0.5, height * 0.5, height * 0.5, height * 0.5)];
        [_backLiveBtn setBackgroundImage:resizableImage forState:UIControlStateNormal];
        
        [_backLiveBtn addTarget:self action:@selector(backLiveClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backLiveBtn;
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

- (void)removePointJumpBtn
{
    [_pointJumpBtn removeFromSuperview];
    _pointJumpBtn = nil;
}

- (MoreContentView *)moreContentView {
    if (!_moreContentView) {
        _moreContentView = [[MoreContentView alloc] initWithFrame:CGRectZero];
        [self.moreView addSubview:self.moreContentView];
        _moreContentView.controlView = self;
    }
    return _moreContentView;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    
    if ([touch.view isKindOfClass:[UISlider class]]) { // 如果在滑块上点击就不响应pan手势
        return NO;
    }
    return YES;
}

#pragma mark - Public method

/** 重置ControlView */
- (void)playerResetControlView {
    [self.activity stopAnimating];
    self.videoSlider.value           = 0;
    self.videoSlider.progressView.progress = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.fastView.hidden             = YES;
    self.repeatBtn.hidden            = YES;
    self.playeBtn.hidden             = YES;
    self.resolutionView.hidden       = YES;
    self.moreView.hidden             = YES;
    self.backgroundColor             = [UIColor clearColor];
    self.moreBtn.enabled         = YES;
    self.shrink                      = NO;
    self.showing                     = NO;
    self.playeEnd                    = NO;
    self.lockBtn.hidden              = !self.isFullScreen;
    self.middleBtn.hidden              = YES;
    self.placeholderImageView.alpha  = 1;
    self.danmakuBtn.enabled = YES;
    self.captureBtn.enabled = YES;
    self.moreBtn.enabled = YES;
    self.backLiveBtn.hidden              = YES;
    [self hideControlView];
}

/**
 *  取消延时隐藏controlView的方法
 */
- (void)playerCancelAutoFadeOutControlView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playerHideControlView) object:nil];
}

/** 正在播放（隐藏placeholderImageView） */
- (void)playerIsPlaying {
    [UIView animateWithDuration:1.0 animations:^{
        self.placeholderImageView.alpha = 0;
    }];
}

- (void)playerShowOrHideControlView {
    if (!self.moreView.hidden || !self.resolutionView.hidden) {
        [self playerHideControlView];
        return;
    }
    if (self.isShowing) {
        [self playerHideControlView];
    } else {
        [self playerShowControlView];
    }
}


/**
 *  显示控制层
 */
- (void)playerShowControlView {
    [self playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:SuperPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self showControlView];
    } completion:^(BOOL finished) {
        self.showing = YES;
        [self autoFadeOutControlView];
    }];
}

/**
 *  隐藏控制层
 */
- (void)playerHideControlView {
    [self playerCancelAutoFadeOutControlView];
    [UIView animateWithDuration:SuperPlayerControlBarAutoFadeOutTimeInterval animations:^{
        [self hideControlView];
    } completion:^(BOOL finished) {
        self.showing = NO;
    }];
}

- (NSString *)timeFormat:(NSInteger)totalTime {
    if (totalTime < 0) {
        return @"";
    }
    NSInteger durHour = totalTime / 3600;
    NSInteger durMin = (totalTime / 60) % 60;
    NSInteger durSec = totalTime % 60;
    
    if (durHour > 0) {
        return [NSString stringWithFormat:@"%zd:%02zd:%02zd", durHour, durMin, durSec];
    } else {
        return [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    }
}

- (void)playerRemoveAllPoints {
    for (PlayerPoint *holder in self.videoSlider.pointArray) {
        [holder.holder removeFromSuperview];
    }
    [self.videoSlider.pointArray removeAllObjects];
}

- (void)playerAddVideoPoint:(CGFloat)where text:(NSString *)text time:(NSInteger)time {
    PlayerPoint *point = [self.videoSlider addPoint:where];
    point.content = text;
    point.timeOffset = time;
}

- (void)onPlayerPointSelected:(PlayerPoint *)point {
    // TODO: show
    
    NSString *text = [NSString stringWithFormat:@"  %@ %@  ", [self timeFormat:point.timeOffset/1000],
                      point.content];
    
    [self.pointJumpBtn setTitle:text forState:UIControlStateNormal];
    [self.pointJumpBtn sizeToFit];
    CGFloat x = self.videoSlider.mm_x + self.videoSlider.mm_w * point.where - self.pointJumpBtn.mm_halfW;
    if (x < 0)
        x = 0;
    if (x + self.pointJumpBtn.mm_halfW > ScreenWidth)
        x = ScreenWidth - self.pointJumpBtn.mm_halfW;
    self.pointJumpBtn.tag = [self.videoSlider.pointArray indexOfObject:point];
    self.pointJumpBtn.m_left(x).m_bottom(self.videoSlider.mm_h);
    
    [self autoFadeOutControlView];
    
    [DataReport report:@"player_point" param:nil];
}

- (void)playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    if (!self.isDragged) {
        // 更新slider
        self.videoSlider.value           = value;
        // 更新当前播放时间
        self.currentTimeLabel.text = [self timeFormat:currentTime];
    }
    
    // 更新总时间
    self.totalTimeLabel.text = [self timeFormat:totalTime];
}

- (void)playerDraggedTime:(NSInteger)draggedTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)sliderValue thumbnail:(UIImage *)thumbnail {
    // 快进快退时候停止菊花
    [self.activity stopAnimating];

    
    NSString *currentTimeStr = [self timeFormat:draggedTime];
    NSString *totalTimeStr   = [self timeFormat:totalTime];
    NSString *timeStr        = [NSString stringWithFormat:@"%@ / %@", currentTimeStr, totalTimeStr];
    if (self.isLive) {
        timeStr = [NSString stringWithFormat:@"%@", currentTimeStr];
    }
    
    // 更新slider的值
    self.videoSlider.value            = sliderValue;
    // 更新当前时间
    self.currentTimeLabel.text        = currentTimeStr;
    // 正在拖动控制播放进度
    self.dragged = YES;
    
    self.fastView.hidden           = NO;
    if (thumbnail) {
        self.fastView.videoRatio = self.videoRatio;
        [self.fastView showThumbnail:thumbnail withText:timeStr];
    } else {
        [self.fastView showText:timeStr withText:sliderValue];
    }
}

- (void)playerDraggedLight:(CGFloat)draggedValue {
    self.fastView.hidden           = NO;
    [self.fastView showImg:SuperPlayerImage(@"light_max") withProgress:draggedValue];
}

- (void)playerDraggedVolume:(CGFloat)draggedValue {
    self.fastView.hidden           = NO;
    [self.fastView showImg:SuperPlayerImage(@"sound_max") withProgress:draggedValue];
}

- (void)playerDraggedEnd {
    self.dragged = NO;
    // 结束滑动时候把开始播放按钮改为播放状态
    self.startBtn.selected = YES;
    // 滑动结束延时隐藏controlView
    [self autoFadeOutFastView];
}

/** progress显示缓冲进度 */
- (void)playerPlayableProgress:(CGFloat)progress {
    [self.videoSlider.progressView setProgress:progress animated:NO];
}

/** 视频加载失败 */
- (void)playerIsFailed:(NSString *)error {
    self.middleBtn.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenMiddleBtn) object:nil];
    [self.middleBtn setTitle:error forState:UIControlStateNormal];
    
    [self.middleBtn removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
    [self.middleBtn addTarget:self action:@selector(failBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self updateMiddleBtn];
}

- (void)playerBadNet:(NSString *)tips {
    self.middleBtn.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenMiddleBtn) object:nil];
    [self.middleBtn setTitle:tips forState:UIControlStateNormal];
    
    
    [self performSelector:@selector(hiddenMiddleBtn) withObject:nil afterDelay:5];
    
    [self.middleBtn removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
    [self.middleBtn addTarget:self action:@selector(badNetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self updateMiddleBtn];
}

- (void)playerShowTips:(NSString *)tips delay:(NSTimeInterval)delay {
    self.middleBtn.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenMiddleBtn) object:nil];
    [self.middleBtn setTitle:tips forState:UIControlStateNormal];
    if (delay > 0) {
        [self performSelector:@selector(hiddenMiddleBtn) withObject:nil afterDelay:delay];
    }
    
    [self.middleBtn removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
    [self.middleBtn addTarget:self action:@selector(hiddenMiddleBtn) forControlEvents:UIControlEventTouchUpInside];
    [self updateMiddleBtn];
}
     
- (void)updateMiddleBtn {
    self.middleBtn.titleLabel.text = [self.middleBtn titleForState:UIControlStateNormal];
    CGFloat width = self.middleBtn.titleLabel.attributedText.size.width;
    
    [self.middleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width+10));
    }];
 }

- (void)hiddenMiddleBtn {
    self.middleBtn.hidden = YES;
}

/** 加载的菊花 */
- (void)playerIsActivity:(BOOL)animated {
    if (animated) {
        [self.activity startAnimating];
        self.fastView.hidden = YES;
    } else {
        [self.activity stopAnimating];
    }
}

/** 播放完了 */
- (void)playerPlayEnd {
    self.repeatBtn.hidden = NO;
    self.playeEnd         = YES;
    self.showing          = NO;
    self.placeholderImageView.alpha = 1;
    // 隐藏controlView
    [self hideControlView];
    self.backgroundColor  = RGBA(0, 0, 0, .3);
    
    self.danmakuBtn.enabled = NO;
    self.captureBtn.enabled = NO;
    self.moreBtn.enabled = NO;
    
    [self.videoSlider cancelTrackingWithEvent:nil];
}

/**
 是否有切换分辨率功能
 */
- (void)playerResolutionArray:(NSArray<SuperPlayerUrl *> *)resolutionArray defaultIndex:(NSInteger)defualtIndex
{
    _resolutionArray = resolutionArray;
    for (UIView *subview in self.resolutionView.subviews)
        [subview removeFromSuperview];
    [_resolutionBtn setTitle:@"" forState:UIControlStateNormal];
    self.resolutionView.hidden = YES;
    if (resolutionArray == nil || resolutionArray.count == 0) {
        return;
    }
    if (defualtIndex < 0 || defualtIndex >= resolutionArray.count) {
        return;
    }
    [_resolutionBtn setTitle:resolutionArray[defualtIndex].title forState:UIControlStateNormal];

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
    for (NSInteger i = 0 ; i < resolutionArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:resolutionArray[i].title forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(252, 89, 81, 1) forState:UIControlStateSelected];
        if (i == defualtIndex) {
            self.resoultionCurrentBtn = btn;
            btn.selected = YES;
            btn.backgroundColor = RGBA(34, 30, 24, 1);
        }
        [self.resolutionView addSubview:btn];
        [btn addTarget:self action:@selector(changeResolution:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.resolutionView.mas_width);
            make.height.mas_equalTo(45);
            make.left.equalTo(self.resolutionView.mas_left);
            make.centerY.equalTo(self.resolutionView.mas_centerY).offset((i-resolutionArray.count/2.0+0.5)*45);
        }];
        btn.tag = MODEL_TAG_BEGIN+i;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeResolution:self.resoultionCurrentBtn];
    });
}

- (void)playerResolutionIndex:(NSInteger)defualtIndex
{
    UIButton *btn = [_resolutionView viewWithTag:MODEL_TAG_BEGIN+defualtIndex];
    if (btn) {
        [_resolutionBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
        _resoultionCurrentBtn.selected = NO;
        _resoultionCurrentBtn.backgroundColor = [UIColor clearColor];
        _resoultionCurrentBtn = btn;
        _resoultionCurrentBtn.selected = YES;
        _resoultionCurrentBtn.backgroundColor = RGBA(34, 30, 24, 1);
    }
}

- (void)playerIsLive:(BOOL)isLive {
    self.isLive = isLive;
    [self setFullScreen:_fullScreen];
}

/** 播放按钮状态 */
- (void)playerPlayBtnState:(BOOL)state {
    self.startBtn.selected = state;
    self.repeatBtn.hidden = YES;
}

/** 锁定屏幕方向按钮状态 */
- (void)playerLockBtnState:(BOOL)state {
    self.lockBtn.selected = state;
    self.isLockScreen = state;
}

- (void)playerBackLiveBtnHidden:(BOOL)hidden;
{
    self.backLiveBtn.hidden = hidden;
}

#pragma clang diagnostic pop

@end
