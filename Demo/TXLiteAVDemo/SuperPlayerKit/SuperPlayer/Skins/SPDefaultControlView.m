#import "SPDefaultControlView.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "DataReport.h"
#import "PlayerSlider.h"
#import "StrUtils.h"
#import "SuperPlayerControlView.h"
#import "SuperPlayerFastView.h"
#import "SuperPlayerSettingsView.h"
#import "SuperPlayerView+Private.h"
#import "UIView+Fade.h"
#import "UIView+MMLayout.h"
#import "SuperPlayerLocalized.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#define MODEL_TAG_BEGIN          20
#define BOTTOM_IMAGE_VIEW_HEIGHT 50

@interface     SPDefaultControlView () <UIGestureRecognizerDelegate, PlayerSliderDelegate,
SuperPlayerTrackViewDelegate, SuperPlayerSubtitlesViewDelegate>
@property BOOL isLive;
@end

@implementation SPDefaultControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        [self.bottomImageView addSubview:self.startBtn];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.videoSlider];
        [self.bottomImageView addSubview:self.resolutionBtn];
        [self.bottomImageView addSubview:self.fullScreenBtn];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        [self.bottomImageView addSubview:self.nextBtn];

        [self.topImageView addSubview:self.captureBtn];
        [self.topImageView addSubview:self.danmakuBtn];
        [self.topImageView addSubview:self.offlineBtn];
        [self.topImageView addSubview:self.trackBtn];
        [self.topImageView addSubview:self.subtitlesBtn];
        [self.topImageView addSubview:self.moreBtn];
        [self addSubview:self.lockBtn];
        [self addSubview:self.pipBtn];
        [self.topImageView addSubview:self.backBtn];

        [self addSubview:self.playeBtn];

        [self.topImageView addSubview:self.titleLabel];

        [self addSubview:self.backLiveBtn];

        // 添加子控件的约束
        [self makeSubViewsConstraints];

        self.captureBtn.hidden      = YES;
        self.pipBtn.hidden          = YES;
        self.danmakuBtn.hidden      = YES;
        self.offlineBtn.hidden      = YES;
        self.trackBtn.hidden        = YES;
        self.subtitlesBtn.hidden    = YES;
        self.moreBtn.hidden         = YES;
        self.resolutionBtn.hidden   = YES;
        self.moreContentView.hidden = YES;
        self.trackView.hidden       = YES;
        self.subtitlesView.hidden   = YES;
        self.nextBtn.hidden         = YES;
        // 初始化时重置controlView
        [self playerResetControlView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)makeSubViewsConstraints {
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
    
    NSArray *buttonStatusArr = @[[NSNumber numberWithBool:self.disableDanmakuBtn],
                                 [NSNumber numberWithBool:self.disableOfflineBtn],
                                 [NSNumber numberWithBool:self.disableSubtitlesBtn],
                                 [NSNumber numberWithBool:self.disableTrackBtn]];
    [self setTopButtonConstranintsWithStatus:buttonStatusArr];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backBtn.mas_trailing).offset(5);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.trailing.equalTo(self.captureBtn.mas_leading).offset(-10);
    }];

    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(BOTTOM_IMAGE_VIEW_HEIGHT);
    }];

    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
        make.top.equalTo(self.bottomImageView.mas_top).offset(10);
        make.width.height.mas_equalTo(30);
    }];

    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(50);
    }];

    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-5);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];

    [self.resolutionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(45);
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-5);
        make.centerY.equalTo(self.startBtn.mas_centerY);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-35);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.height.mas_equalTo(30);
    }];

    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.nextBtn.hidden) {
            make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-35);
        } else {
            make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-65);
        }
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(50);
    }];
    

    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.currentTimeLabel.mas_trailing);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
    }];

    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(32);
    }];
    
    [self.pipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.mas_trailing).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(32);
    }];

    [self.playeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.center.equalTo(self);
    }];

    [self.backLiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.startBtn.mas_top).mas_offset(-15);
        make.width.mas_equalTo(150);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - Action

/**
 *  点击切换分别率按钮
 */
- (void)changeResolution:(UIButton *)sender {
    self.resoultionCurrentBtn.selected        = NO;
    self.resoultionCurrentBtn.backgroundColor = [UIColor clearColor];
    self.resoultionCurrentBtn                 = sender;
    self.resoultionCurrentBtn.selected        = YES;
    self.resoultionCurrentBtn.backgroundColor = RGBA(34, 30, 24, 1);

    // topImageView上的按钮的文字
    NSString *titleString = sender.titleLabel.text;
    NSArray *titlesArray = [titleString componentsSeparatedByString:@"（"];
    NSArray *resoluArray = [titlesArray.lastObject componentsSeparatedByString:@"）"];
    NSString *title = titlesArray.firstObject;
    [self.resolutionBtn setTitle:title.length > 0 ? title : resoluArray.firstObject forState:UIControlStateNormal];
    [self.delegate controlViewSwitch:self withDefinition:titleString];

}

- (void)backBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewBack:)]) {
        [self.delegate controlViewBack:self];
    }
}

- (void)exitFullScreen:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(controlViewChangeScreen:withFullScreen:)]) {
        [self.delegate controlViewChangeScreen:self withFullScreen:NO];
    }
}

- (void)lockScrrenBtnClick:(UIButton *)sender {
    sender.selected             = !sender.selected;
    self.isLockScreen           = sender.selected;
    self.topImageView.hidden    = self.isLockScreen;
    self.bottomImageView.hidden = self.isLockScreen;
    if (self.isLive) {
        self.backLiveBtn.hidden = self.isLockScreen;
    }
    [self.delegate controlViewLockScreen:self withLock:self.isLockScreen];
    [self fadeOut:3];
}

- (void)pipBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewPip:)]) {
        [self.delegate controlViewPip:self];
    }
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
    self.fullScreen = !self.fullScreen;
    [self.delegate controlViewChangeScreen:self withFullScreen:YES];
    [self fadeOut:3];
}

- (void)captureBtnClick:(UIButton *)sender {
    [self.delegate controlViewSnapshot:self];
    [self fadeOut:3];
}

- (void)danmakuBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self fadeOut:3];
}

- (void)offlineBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self fadeOut:3];
}

- (void)trackBtnClick:(UIButton *)sender {
    self.topImageView.hidden    = YES;
    self.bottomImageView.hidden = YES;
    self.lockBtn.hidden         = YES;
    self.pipBtn.hidden          = YES;
    self.moreContentView.hidden = YES;
    self.subtitlesView.hidden   = YES;
    self.trackView.hidden       = NO;
    
    [self cancelFadeOut];
    self.isShowSecondView = YES;
}

- (void)subtitlesBtnClick:(UIButton *)sender {
    self.topImageView.hidden    = YES;
    self.bottomImageView.hidden = YES;
    self.lockBtn.hidden         = YES;
    self.pipBtn.hidden          = YES;
    self.moreContentView.hidden = YES;
    self.trackView.hidden       = YES;
    self.subtitlesView.hidden   = NO;
    
    [self cancelFadeOut];
    self.isShowSecondView = YES;
}

- (void)moreBtnClick:(UIButton *)sender {
    self.topImageView.hidden    = YES;
    self.bottomImageView.hidden = YES;
    self.lockBtn.hidden         = YES;
    self.pipBtn.hidden          = YES;
    self.trackView.hidden       = YES;
    self.subtitlesView.hidden   = YES;

    self.moreContentView.playerConfig = self.playerConfig;
    [self.moreContentView update];
    self.moreContentView.hidden = NO;

    [self cancelFadeOut];
    self.isShowSecondView = YES;
}

- (UIView *)resolutionView {
    if (!_resolutionView) {
        // 添加分辨率按钮和分辨率下拉列表

        _resolutionView        = [[UIView alloc] initWithFrame:CGRectZero];
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

- (void)resolutionBtnClick:(UIButton *)sender {
    self.topImageView.hidden    = YES;
    self.bottomImageView.hidden = YES;
    self.lockBtn.hidden         = YES;
    self.pipBtn.hidden          = YES;
    
    // 显示隐藏分辨率View
    self.resolutionView.hidden = NO;
    [DataReport report:@"change_resolution" param:nil];

    [self fadeShow];
    self.isShowSecondView = YES;
}

- (void)progressSliderTouchBegan:(UISlider *)sender {
    self.isDragging = YES;
    [self cancelFadeOut];
}

- (void)progressSliderValueChanged:(UISlider *)sender {
    if (self.maxPlayableRatio > 0 && sender.value > self.maxPlayableRatio) {
        sender.value = self.maxPlayableRatio;
    }
    [self.delegate controlViewPreview:self where:sender.value];
}

- (void)progressSliderTouchEnded:(UISlider *)sender {
    [self.delegate controlViewSeek:self where:sender.value];
    self.isDragging = NO;
    [self fadeOut:5];
}

- (void)backLiveClick:(UIButton *)sender {
    [self.delegate controlViewReload:self];
}

- (void)pointJumpClick:(UIButton *)sender {
    self.pointJumpBtn.hidden = YES;
    PlayerPoint *point       = [self.videoSlider.pointArray objectAtIndex:self.pointJumpBtn.tag];
    [self.delegate controlViewSeek:self where:point.where];
    [self fadeOut:0.1];
}

- (void)setDisableBackBtn:(BOOL)disableBackBtn {
    _disableBackBtn     = disableBackBtn;
    self.backBtn.hidden = disableBackBtn;
}

- (void)setDisableMoreBtn:(BOOL)disableMoreBtn {
    _disableMoreBtn = disableMoreBtn;
    if (self.fullScreen) {
        self.moreBtn.hidden = disableMoreBtn;
    }
}

- (void)setDisableResolutionBtn:(BOOL)disableResolutionBtn {
    _disableResolutionBtn = disableResolutionBtn;
    if (self.fullScreen) {
        self.resolutionBtn.hidden = disableResolutionBtn;
    }
}

- (void)setDisableCaptureBtn:(BOOL)disableCaptureBtn {
    _disableCaptureBtn = disableCaptureBtn;
    if (self.fullScreen) {
        self.captureBtn.hidden = disableCaptureBtn;
    }
}

- (void)setDisablePipBtn:(BOOL)disablePipBtn {
    _disablePipBtn = disablePipBtn;
    if (self.fullScreen) {
        self.pipBtn.hidden = YES;
    }
}

- (void)setDisableDanmakuBtn:(BOOL)disableDanmakuBtn {
    _disableDanmakuBtn = disableDanmakuBtn;
    if (self.fullScreen) {
        self.danmakuBtn.hidden = disableDanmakuBtn;
    }
}

- (void)setDisableOfflineBtn:(BOOL)disableOfflineBtn {
    _disableOfflineBtn = disableOfflineBtn;
    if (self.fullScreen) {
        self.offlineBtn.hidden = disableOfflineBtn;
    }
}

- (void)setDisableTrackBtn:(BOOL)disableTrackBtn {
    _disableTrackBtn = disableTrackBtn;
    if (self.fullScreen) {
        self.trackBtn.hidden = disableTrackBtn;
    }
}

- (void)setDisableSubtitlesBtn:(BOOL)disableSubtitlesBtn {
    _disableSubtitlesBtn = disableSubtitlesBtn;
    if (self.fullScreen) {
        self.subtitlesBtn.hidden = disableSubtitlesBtn;
    }
}

- (void)nextJumpClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewNextClick:)]) {
        [self.delegate controlViewNextClick:self];
    }
}
/**
 *  屏幕方向发生变化会调用这里
 */
- (void)setOrientationLandscapeConstraint {
    self.fullScreen             = YES;
    self.lockBtn.hidden         = NO;
    self.pipBtn.hidden          = YES;
    self.fullScreenBtn.selected = self.isLockScreen;
    self.fullScreenBtn.hidden   = YES;
    if (self.disableResolutionBtn) {
        self.resolutionBtn.hidden   = YES;
    } else {
        self.resolutionBtn.hidden   = self.resolutionArray.count == 0;
    }
    self.moreBtn.hidden         = self.disableMoreBtn;
    self.captureBtn.hidden      = self.disableCaptureBtn;
    self.danmakuBtn.hidden      = self.disableDanmakuBtn;
    self.offlineBtn.hidden      = self.disableOfflineBtn;
    self.trackBtn.hidden        = self.disableTrackBtn;
    self.subtitlesBtn.hidden    = self.disableSubtitlesBtn;

    NSArray *buttonStatusArr = @[[NSNumber numberWithBool:self.danmakuBtn.hidden],
                                 [NSNumber numberWithBool:self.offlineBtn.hidden],
                                 [NSNumber numberWithBool:self.subtitlesBtn.hidden],
                                 [NSNumber numberWithBool:self.trackBtn.hidden]];
    [self setTopButtonConstranintsWithStatus:buttonStatusArr];

    [self.backBtn setImage:SuperPlayerImage(@"back_full") forState:UIControlStateNormal];
    
    if (!self.nextBtn.hidden) {
        [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.resolutionArray.count > 0) {
                make.trailing.equalTo(self.resolutionBtn.mas_leading);
            } else {
                make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-5);
            }
            make.centerY.equalTo(self.startBtn.mas_centerY);
            make.width.height.mas_equalTo(30);
        }];
    }
    
    [self.totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.nextBtn.hidden) {
            make.trailing.equalTo(self.nextBtn.mas_leading);
        } else {
            if (self.resolutionArray.count > 0) {
                make.trailing.equalTo(self.resolutionBtn.mas_leading);
            } else {
                make.trailing.equalTo(self.bottomImageView.mas_trailing).offset(-5);
            }
        }
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(self.isLive ? 10 : 60);
    }];

    [self.bottomImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat b = self.superview.mm_safeAreaBottomGap;
        make.height.mas_equalTo(BOTTOM_IMAGE_VIEW_HEIGHT + b);
    }];

    self.videoSlider.hiddenPoints = NO;
}
/**
 *  设置竖屏的约束
 */
- (void)setOrientationPortraitConstraint {
    self.fullScreen             = NO;
    self.lockBtn.hidden         = YES;
    self.pipBtn.hidden          = self.disablePipBtn;
    self.fullScreenBtn.selected = NO;
    self.fullScreenBtn.hidden   = NO;
    self.resolutionBtn.hidden   = YES;
    self.moreBtn.hidden         = YES;
    self.captureBtn.hidden      = YES;
    self.danmakuBtn.hidden      = YES;
    self.offlineBtn.hidden      = YES;
    self.trackBtn.hidden        = YES;
    self.subtitlesBtn.hidden    = YES;
    self.moreContentView.hidden = YES;
    self.trackView.hidden       = YES;
    self.subtitlesView.hidden   = YES;
    self.resolutionView.hidden  = YES;

    [self.totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (!self.nextBtn.hidden) {
            make.trailing.equalTo(self.nextBtn.mas_leading);
        } else {
            make.trailing.equalTo(self.fullScreenBtn.mas_leading);
        }
        
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(self.isLive ? 10 : 60);
    }];

    [self.bottomImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(BOTTOM_IMAGE_VIEW_HEIGHT);
    }];

    self.videoSlider.hiddenPoints = YES;
    self.pointJumpBtn.hidden      = YES;
}

#pragma mark - Private Method

- (void)setTopButtonConstranintsWithStatus:(NSArray *)buttonStatusArr {
    NSArray *buttonArray = @[self.danmakuBtn, self.offlineBtn, self.subtitlesBtn, self.trackBtn];
    
    int k = 0;
    for (int i = 0; i < buttonStatusArr.count; i++) {
        NSNumber *status = buttonStatusArr[i];
        if (![status boolValue]) {
            UIButton *btn = buttonArray[i];
            [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(49);
                make.trailing.equalTo(self.captureBtn.mas_leading).offset(-((k * 40) + ((k + 1) * 10)));
                make.centerY.equalTo(self.backBtn.mas_centerY);
            }];
            k++;
        }
    }
    
}

#pragma mark - setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel           = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font      = [UIFont systemFontOfSize:15.0];
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
        _topImageView.image                  = SuperPlayerImage(@"top_shadow");
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image                  = SuperPlayerImage(@"bottom_shadow");
    }
    return _bottomImageView;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
        _lockBtn.exclusiveTouch = YES;
        [_lockBtn setImage:SuperPlayerImage(@"unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:SuperPlayerImage(@"lock-nor") forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockScrrenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockBtn;
}

- (UIButton *)pipBtn {
    if (!_pipBtn) {
        _pipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pipBtn setImage:SuperPlayerImage(@"pip_play_icon") forState:UIControlStateNormal];
        [_pipBtn addTarget:self action:@selector(pipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pipBtn;
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
        _videoSlider = [[PlayerSlider alloc] init];
        [_videoSlider setThumbImage:SuperPlayerImage(@"slider_thumb") forState:UIControlStateNormal];
        _videoSlider.minimumTrackTintColor = TintColor;
        // slider开始滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [_videoSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [_videoSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
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
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
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

- (UIButton *)offlineBtn {
    if (!_offlineBtn) {
        _offlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_offlineBtn setImage:SuperPlayerImage(@"offline_download") forState:UIControlStateNormal];
        [_offlineBtn addTarget:self action:@selector(offlineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _offlineBtn;
}

- (UIButton *)trackBtn {
    if (!_trackBtn) {
        _trackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_trackBtn setImage:SuperPlayerImage(@"track") forState:UIControlStateNormal];
        [_trackBtn addTarget:self action:@selector(trackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _trackBtn;
}

- (UIButton *)subtitlesBtn {
    if (!_subtitlesBtn) {
        _subtitlesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subtitlesBtn setImage:SuperPlayerImage(@"subtitles") forState:UIControlStateNormal];
        [_subtitlesBtn addTarget:self action:@selector(subtitlesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subtitlesBtn;
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

- (UIButton *)resolutionBtn {
    if (!_resolutionBtn) {
        _resolutionBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
        _resolutionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _resolutionBtn.backgroundColor = [UIColor clearColor];
        [_resolutionBtn addTarget:self action:@selector(resolutionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resolutionBtn;
}

- (UIButton *)backLiveBtn {
    if (!_backLiveBtn) {
        _backLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backLiveBtn setTitle:superPlayerLocalized(@"SuperPlayer.backtolive") forState:UIControlStateNormal];
        _backLiveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        UIImage *image               = SuperPlayerImage(@"qg_online_bg");

        UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(33 * 0.5, 33 * 0.5, 33 * 0.5, 33 * 0.5)];
        [_backLiveBtn setBackgroundImage:resizableImage forState:UIControlStateNormal];

        [_backLiveBtn addTarget:self action:@selector(backLiveClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backLiveBtn;
}

- (UIButton *)pointJumpBtn {
    if (!_pointJumpBtn) {
        _pointJumpBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image          = SuperPlayerImage(@"copywright_bg");
        UIImage *resizableImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20) resizingMode:UIImageResizingModeStretch];
        [_pointJumpBtn setBackgroundImage:resizableImage forState:UIControlStateNormal];
        _pointJumpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_pointJumpBtn addTarget:self action:@selector(pointJumpClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pointJumpBtn];
    }
    return _pointJumpBtn;
}

- (SuperPlayerSettingsView *)moreContentView {
    if (!_moreContentView) {
        _moreContentView             = [[SuperPlayerSettingsView alloc] initWithFrame:CGRectZero];
        _moreContentView.controlView = self;
        _moreContentView.hidden      = YES;
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

- (SuperPlayerTrackView *)trackView {
    if (!_trackView) {
        _trackView = [[SuperPlayerTrackView alloc] initWithFrame:CGRectZero];
        _trackView.hidden = YES;
        [self addSubview:_trackView];
        [_trackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(330);
            make.height.mas_equalTo(self.mas_height);
            make.trailing.equalTo(self.mas_trailing).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
        _trackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _trackView.delegate = self;
    }
    return _trackView;
}

- (SuperPlayerSubtitlesView *)subtitlesView {
    if (!_subtitlesView) {
        _subtitlesView = [[SuperPlayerSubtitlesView alloc] initWithFrame:CGRectZero];
        _subtitlesView.hidden = YES;
        [self addSubview:_subtitlesView];
        [_subtitlesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(330);
            make.height.mas_equalTo(self.mas_height);
            make.trailing.equalTo(self.mas_trailing).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
        _subtitlesView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _subtitlesView.delegate = self;
    }
    return _subtitlesView;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.hidden = YES;
        [_nextBtn setImage:SuperPlayerImage(@"play_next") forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextJumpClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UISlider class]]) {  // 如果在滑块上点击就不响应pan手势
        return NO;
    }
    return YES;
}

#pragma mark - SuperPlayerTrackViewDelegate

- (void)chooseTrackInfo:(TXTrackInfo *)info preTrackInfo:(TXTrackInfo *)preInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewSwitch:withTrackInfo:preTrackInfo:)]) {
        [self.delegate controlViewSwitch:self withTrackInfo:info preTrackInfo:preInfo];
    }
}

#pragma mark - SuperPlayerSubtitlesViewDelegate

- (void)chooseSubtitlesInfo:(TXTrackInfo *)info preSubtitlesInfo:(TXTrackInfo *)preInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewSwitch:withSubtitlesInfo:preSubtitlesInfo:)]) {
        [self.delegate controlViewSwitch:self withSubtitlesInfo:info preSubtitlesInfo:preInfo];
    }
}

#pragma mark - Public method

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        self.resolutionView.hidden  = YES;
        self.moreContentView.hidden = YES;
        self.trackView.hidden       = YES;
        self.subtitlesView.hidden   = YES;
        if (!self.isLockScreen) {
            self.topImageView.hidden    = NO;
            self.bottomImageView.hidden = NO;
        }
    }

    self.lockBtn.hidden      = !self.isFullScreen;
    if (self.disablePipBtn) {
        self.pipBtn.hidden = YES;
    } else {
        self.pipBtn.hidden       = self.isFullScreen;
    }
    
    self.isShowSecondView    = NO;
    self.pointJumpBtn.hidden = YES;
}

/** 重置ControlView */
- (void)playerResetControlView {
    self.videoSlider.value                 = 0;
    self.videoSlider.progressView.progress = 0;
    self.currentTimeLabel.text             = @"00:00";
    self.totalTimeLabel.text               = @"00:00";
    self.playeBtn.hidden                   = YES;
    self.resolutionView.hidden             = YES;
    self.backgroundColor                   = [UIColor clearColor];
    self.moreBtn.enabled                   = !self.disableMoreBtn;
    self.lockBtn.hidden                    = !self.isFullScreen;
    if (self.disablePipBtn) {
        self.pipBtn.hidden = YES;
    } else {
        self.pipBtn.hidden                     = self.isFullScreen;
    }
    
    self.danmakuBtn.enabled = YES;
    self.offlineBtn.enabled = YES;
    self.trackBtn.enabled   = YES;
    self.subtitlesBtn.enabled = YES;
    self.captureBtn.enabled = YES;
    self.backLiveBtn.hidden = YES;
}

- (void)setPointArray:(NSArray *)pointArray {
    [super setPointArray:pointArray];

    for (PlayerPoint *holder in self.videoSlider.pointArray) {
        [holder.holder removeFromSuperview];
    }
    [self.videoSlider.pointArray removeAllObjects];

    for (SPVideoFrameDescription *p in pointArray) {
        PlayerPoint *point = [self.videoSlider addPoint:p.where];
        point.content      = p.text;
        point.timeOffset   = p.time;
    }
}

- (void)onPlayerPointSelected:(PlayerPoint *)point {
    NSString *text = [NSString stringWithFormat:@"  %@ %@  ", [StrUtils timeFormat:point.timeOffset], point.content];

    [self.pointJumpBtn setTitle:text forState:UIControlStateNormal];
    [self.pointJumpBtn sizeToFit];
    CGFloat x = self.videoSlider.mm_x + self.videoSlider.mm_w * point.where - self.pointJumpBtn.mm_h / 2;
    if (x < 0) x = 0;
    if (x + self.pointJumpBtn.mm_h / 2 > ScreenWidth) x = ScreenWidth - self.pointJumpBtn.mm_h / 2;
    self.pointJumpBtn.tag = [self.videoSlider.pointArray indexOfObject:point];
    self.pointJumpBtn.m_left(x).m_bottom(60);
    self.pointJumpBtn.hidden = NO;

    [DataReport report:@"player_point" param:nil];
}

- (void)setProgressTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime progressValue:(CGFloat)progress playableValue:(CGFloat)playable {
    if (!self.isDragging) {
        // 更新slider
        self.videoSlider.value = progress;
    }
    // 更新当前播放时间
    self.currentTimeLabel.text = [StrUtils timeFormat:currentTime];
    // 更新总时间
    self.totalTimeLabel.text = [StrUtils timeFormat:totalTime];
    [self.videoSlider.progressView setProgress:playable animated:NO];
}

- (void)resetWithResolutionNames:(NSArray<NSString *> *)resolutionNames
          currentResolutionIndex:(NSUInteger)currentResolutionIndex
                          isLive:(BOOL)isLive
                  isTimeShifting:(BOOL)isTimeShifting
                       isPlaying:(BOOL)isPlaying {
    NSAssert(resolutionNames.count == 0 || currentResolutionIndex < resolutionNames.count, @"Invalid argument when reseeting %@", NSStringFromClass(self.class));
    
    if (self.disableResolutionBtn) {
        return;
    }
    
    [self setPlayState:isPlaying];
    self.backLiveBtn.hidden                          = !isTimeShifting;
    self.moreContentView.enableSpeedAndMirrorControl = !isLive;

    for (UIView *subview in self.resolutionView.subviews) [subview removeFromSuperview];

    _resolutionArray = resolutionNames;
    if (_resolutionArray.count > 0) {
        NSArray *titlesArray = [resolutionNames[currentResolutionIndex] componentsSeparatedByString:@"（"];
        NSArray *resoluArray = [titlesArray.lastObject componentsSeparatedByString:@"）"];
        NSString *title = titlesArray.firstObject;
        [self.resolutionBtn setTitle:title.length > 0 ? title : resoluArray.firstObject forState:UIControlStateNormal];

    }
    UILabel *lable      = [UILabel new];
    lable.text          = superPlayerLocalized(@"SuperPlayer.videoquality");
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor     = [UIColor whiteColor];
    [self.resolutionView addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.resolutionView.mas_width);
        make.height.mas_equalTo(30);
        make.left.equalTo(self.resolutionView.mas_left);
        make.top.equalTo(self.resolutionView.mas_top).mas_offset(20);
    }];

    // 分辨率View上边的Btn
    for (NSInteger i = 0; i < _resolutionArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:_resolutionArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(252, 89, 81, 1) forState:UIControlStateSelected];
        [self.resolutionView addSubview:btn];
        [btn addTarget:self action:@selector(changeResolution:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.resolutionView.mas_width);
            make.height.mas_equalTo(45);
            make.left.equalTo(self.resolutionView.mas_left);
            make.centerY.equalTo(self.resolutionView.mas_centerY).offset((i - self.resolutionArray.count / 2.0 + 0.5) * 45);
        }];
        btn.tag = MODEL_TAG_BEGIN + i;

        if (i == currentResolutionIndex) {
            btn.selected              = YES;
            btn.backgroundColor       = RGBA(34, 30, 24, 1);
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

- (void)resetWithTracks:(NSMutableArray *)tracks
      currentTrackIndex:(NSInteger)trackIndex
              subtitles:(NSMutableArray *)subtitles
  currentSubtitlesIndex:(NSInteger)subtitleIndex {
    [self.trackView removeFromSuperview];
    self.trackView = nil;
    
    [self.subtitlesView removeFromSuperview];
    self.subtitlesView = nil;
    [self.trackView initTrackViewWithTrackArray:tracks currentTrackIndex:trackIndex];
    
    if (subtitles.count <= 0) {
        return;
    }
    
    [self.subtitlesView initSubtitlesViewWithTrackArray:subtitles currentSubtitlesIndex:subtitleIndex];
}

/** 播放按钮状态 */
- (void)setPlayState:(BOOL)state {
    self.startBtn.selected = state;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.titleLabel.text = title;
}

- (void)showOrHideBackBtn:(BOOL)isShow {
    self.backBtn.hidden = !isShow;
}

- (void)setSliderState:(BOOL)isEnable {
    self.videoSlider.enabled = isEnable;
}

- (void)setTopViewState:(BOOL)isShow {
    self.topImageView.hidden = !isShow;
}

- (void)setResolutionViewState:(BOOL)isShow {
    self.resolutionView.hidden = !isShow;
}

- (void)setNextBtnState:(BOOL)isShow {
    self.nextBtn.hidden = !isShow;
}

- (void)setTrackBtnState:(BOOL)isShow {
    self.trackBtn.hidden = !isShow;
    self.disableTrackBtn = !isShow;
}

- (void)setSubtitlesBtnState:(BOOL)isShow {
    self.subtitlesBtn.hidden = !isShow;
    self.disableSubtitlesBtn = !isShow;
}

- (void)setOfflineBtnState:(BOOL)isShow {
    self.disableOfflineBtn = !isShow;
}

#pragma clang diagnostic pop

@end
