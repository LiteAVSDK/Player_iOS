//  Copyright (c) 2023 Tencent. All rights reserved.

#import "TUIPSControlView.h"
#import "PlayerKitCommonHeaders.h"
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
#import "TUIPSDFullScreenViewController.h"
@interface TUIPSControlView ()<TUIPSDFullScreenViewControllerDelegate>
///当前播放器是否正在播放
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *loadingView;
@property (nonatomic, strong) UIButton *loveBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *adButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *themeLabel;
@property (nonatomic, strong) UILabel *preloadStateLabel;
@property (nonatomic, strong) UILabel *waterLabel;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, weak) UIView *videoWidget;
@property (nonatomic, weak) TUITXVodPlayer *player;
@property (nonatomic, strong) UIButton *renderModeButton;

@end
@implementation TUIPSControlView
@synthesize delegate = _delegate;
-(instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]){
        [self addSubview:self.durationLabel];
        [self addSubview:self.currentTimeLabel];
        [self addSubview:self.tipLabel];
        [self addSubview:self.loadingView];
        [self addSubview:self.loveBtn];
        [self addSubview:self.commentBtn];
        [self addSubview:self.iconImageView];
        [self addSubview:self.adButton];
        [self addSubview:self.nameLabel];
        [self addSubview:self.desLabel];
        [self addSubview:self.themeLabel];
        [self addSubview:self.preloadStateLabel];
        [self addSubview:self.waterLabel];
        [self addSubview:self.fullScreenButton];
        [self addSubview:self.renderModeButton];
        [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(70));
            make.height.equalTo(@(30));
            make.left.equalTo(self.mas_left).offset(5);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-5);
            } else {
                make.bottom.equalTo(self.mas_bottom).offset(-5);
            }
        }];
        [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(70));
            make.height.equalTo(@(30));
            make.right.equalTo(self.mas_right).offset(-5);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-5);
            } else {
                make.bottom.equalTo(self.mas_bottom).offset(-5);
            }
        }];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(70));
            make.height.equalTo(@(30));
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(70));
            make.height.equalTo(@(30));
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [self.loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(80));
            make.height.equalTo(@(40));
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_centerY);
        }];
        [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(80));
            make.height.equalTo(@(40));
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.loveBtn.mas_bottom).offset(20);
        }];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(40));
            make.height.equalTo(@(40));
            make.centerX.equalTo(self.loveBtn.mas_centerX);
            make.bottom.equalTo(self.loveBtn.mas_top).offset(-30);
        }];
        [self.adButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.durationLabel.mas_top);
            make.height.equalTo(@(30));
        }];
        [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.adButton.mas_top).offset(-5);
            make.left.equalTo(self.mas_left).offset(5);
        }];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.themeLabel.mas_top).offset(-5);
            make.left.equalTo(self.mas_left).offset(5);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.desLabel.mas_top).offset(-5);
            make.left.equalTo(self.mas_left).offset(5);
        }];
        [self.preloadStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(80));
            make.height.equalTo(@(40));
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.commentBtn.mas_bottom).offset(20);
        }];
        [self.renderModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(80));
            make.height.equalTo(@(40));
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.preloadStateLabel.mas_bottom).offset(20);
        }];
        self.waterLabel.hidden = YES;
        self.fullScreenButton.hidden = YES;
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:pinchGesture];
    }
    return self;
}
- (void)handlePinch:(UIPinchGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged) {
        // 获取缩放比例
        CGFloat scale = gesture.scale;
        
        // 在这里实现缩放逻辑
        // 可以根据缩放比例来调整视图的大小或进行其他操作
        // 例如：
        self.videoWidget.transform = CGAffineTransformMakeScale(scale, scale);
        
        
    }
}
-(void)setModel:(TUIPlayerVideoModel *)model {
    if ([_model observationInfo]) {
        [_model removeObserver:self forKeyPath:@"preloadState"];
    }
    _model = model;
    [model addObserver:self forKeyPath:@"preloadState" options:NSKeyValueObservingOptionNew context:nil];
    
    NSDictionary *dic = model.extInfo;
    NSString *iconUrl = [dic objectForKey:@"iconUrl"];
    NSString *advertise = [dic objectForKey:@"advertise"];
    NSString *name = [dic objectForKey:@"name"];
    NSString *title = [dic objectForKey:@"title"];
    NSString *topic = [dic objectForKey:@"topic"];
    self.iconImageView.image = [UIImage imageNamed:iconUrl];
    [self.adButton setTitle:advertise forState:UIControlStateNormal];
    self.nameLabel.text= name;
    self.themeLabel.text = topic;
    self.desLabel.text = title;
    
    [self updatePreloadState];
    
    [self updateLickCount];
    model.onExtInfoChangedBlock = ^(id  _Nonnull extInfo) {
        [self updateLickCount];
    };
}
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context {
    if ([keyPath isEqualToString:@"preloadState"]) {
        [self updatePreloadState];
    }
}
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (!newWindow) {
        if ([_model observationInfo]) {
            [_model removeObserver:self forKeyPath:@"preloadState"];
        }
    }
}
- (void)updatePreloadState {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.model.preloadState == TUIPlayerVideoPreloadStateFinished) {
            self.preloadStateLabel.backgroundColor = [UIColor blueColor];
            self.preloadStateLabel.text = @"Loaded";
        } else if (self.model.preloadState == TUIPlayerVideoPreloadStateStart){
            self.preloadStateLabel.backgroundColor = [UIColor redColor];
            self.preloadStateLabel.text = @"Loading";
        } else {
            self.preloadStateLabel.backgroundColor = [UIColor grayColor];
            self.preloadStateLabel.text = @"None";
        }
    });
    
}

- (void)updateLickCount{
    NSDictionary *dic = self.model.extInfo;
    NSInteger loveCount =  [dic[@"lickCount"] integerValue];
    [self.loveBtn setTitle:[NSString stringWithFormat:@"%ld",(long)loveCount] forState:UIControlStateNormal];
}
#pragma mark - lazyload
- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.backgroundColor = [UIColor greenColor];
        _durationLabel.textAlignment = NSTextAlignmentCenter;
        _durationLabel.text = @"00:00";
        _durationLabel.textColor = [UIColor blackColor];
    }
    return _durationLabel;
}
- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.backgroundColor = [UIColor greenColor];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.text = @"00:00";
        _currentTimeLabel.textColor = [UIColor blackColor];
    }
    return _currentTimeLabel;
}
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.backgroundColor = [UIColor redColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"paused";
        _tipLabel.textColor = [UIColor blackColor];
        _tipLabel.hidden = YES;
    }
    return _tipLabel;
}
- (UILabel *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UILabel alloc] init];
        _loadingView.backgroundColor = [UIColor yellowColor];
        _loadingView.textAlignment = NSTextAlignmentCenter;
        _loadingView.text = @"Loading...";
        _loadingView.textColor = [UIColor blackColor];
        _loadingView.hidden = YES;
    }
    return _loadingView;
}
- (UIButton *)loveBtn {
    if (!_loveBtn) {
        _loveBtn = [[UIButton alloc] init];
        //_loveBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _loveBtn.backgroundColor = [UIColor whiteColor];
        _loveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loveBtn setTitle:@"Like" forState:UIControlStateNormal];
        [_loveBtn setTitle:@"Liked" forState:UIControlStateSelected];
        [_loveBtn addTarget:self action:@selector(loveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _loveBtn.layer.borderWidth = 2.0;
        _loveBtn.layer.borderColor = [UIColor yellowColor].CGColor;
    }
    return _loveBtn;
}
-(UIButton *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[UIButton alloc] init];
        _commentBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_commentBtn setTitle:@"Comment" forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.layer.borderWidth = 2.0;
        _commentBtn.layer.borderColor = [UIColor yellowColor].CGColor;
    }
    return _commentBtn;
}
-(UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.borderWidth = 2.0;
        _iconImageView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _iconImageView;
}
- (UIButton *)adButton {
    if (!_adButton) {
        _adButton = [[UIButton alloc] init];
        _adButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _adButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [_adButton addTarget:self action:@selector(adButtonclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _adButton;
}
-(UILabel *)themeLabel {
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] init];
        _themeLabel.textColor = [UIColor whiteColor];
        _themeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _themeLabel;
}
-(UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.font = [UIFont systemFontOfSize:15];
    }
    return _desLabel;
}
-(UILabel *)nameLabel {
    if (!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:20];
    }
    return _nameLabel;
}
-(UILabel *)preloadStateLabel {
    if (!_preloadStateLabel){
        _preloadStateLabel = [[UILabel alloc] init];
        _preloadStateLabel.textColor = [UIColor blackColor];
        _preloadStateLabel.font = [UIFont systemFontOfSize:20];
    }
    return _preloadStateLabel;
}
- (UILabel *)waterLabel {
    if (!_waterLabel) {
        _waterLabel = [[UILabel alloc] init];
        _waterLabel.backgroundColor = [UIColor whiteColor];
        _waterLabel.textColor = [UIColor blackColor];
        _waterLabel.text = @"[Tencent Cloud]";
    }
    return _waterLabel;
}
- (UIButton *)fullScreenButton {
    if (!_fullScreenButton) {
        _fullScreenButton = [[UIButton alloc] init];
        _fullScreenButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _fullScreenButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_fullScreenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_fullScreenButton setTitle:@"View full screen" forState:UIControlStateNormal];
        [_fullScreenButton addTarget:self action:@selector(fullScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _fullScreenButton.layer.cornerRadius = 14;
        _fullScreenButton.layer.borderWidth = 0.5;
        _fullScreenButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _fullScreenButton;
}
-(UIButton *)renderModeButton {
    if (!_renderModeButton) {
        _renderModeButton = [[UIButton alloc] init];
        _renderModeButton.backgroundColor = [UIColor whiteColor];
        _renderModeButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_renderModeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_renderModeButton setTitle:@"FILL_SCREEN" forState:UIControlStateNormal];
        [_renderModeButton setTitle:@"FILL_EDGE" forState:UIControlStateSelected];
        [_renderModeButton addTarget:self action:@selector(renderModeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _renderModeButton.layer.borderWidth = 2.0;
        _renderModeButton.layer.borderColor = [UIColor yellowColor].CGColor;
    }
    return _renderModeButton;
}
#pragma mark - TUIPlayerShortVideoControl
- (void)hiddenLoadingView {
    self.loadingView.hidden = YES;
}

- (void)hideCenterView {
    self.tipLabel.hidden = YES;
}

- (void)hideSlider {
    
}

- (void)setCurrentTime:(float)time {
    self.currentTimeLabel.text = [self convertTime:time];
}

- (void)setDurationTime:(float)time {
    self.durationLabel.text = [self convertTime:time];
}

- (void)setProgress:(float)progress {
    
}

- (void)showLoadingView {
    self.loadingView.hidden = NO;
}

- (void)showCenterView {
    self.tipLabel.hidden = NO;
}

- (void)showSlider {
    
}
- (void)reloadControlData {
    
}
- (void)getPlayer:(TUITXVodPlayer *)player {
    /// Get current player
    self.player = player;
}
- (void)onPlayEvent:(TUITXVodPlayer *)player
              event:(int)EvtID
          withParam:(NSDictionary *)param {
    ///Get the real-time status of the player
    if (EvtID == EVT_VIDEO_PLAY_BEGIN) {
        [player selectTrack:0];
    }
}
- (void)getVideoLayerRect:(CGRect)rect {
    self.waterLabel.hidden = NO;
    [self.waterLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(rect.origin.y);
        make.left.equalTo(self.mas_left).offset(rect.origin.x);
    }];
    if (rect.size.width >= rect.size.height) {
        self.fullScreenButton.hidden = NO;
        [self.fullScreenButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).offset(rect.origin.y+rect.size.height+3);
        }];
    } else {
        self.fullScreenButton.hidden = YES;
    }
    
}
- (void)getVideoWidget:(UIView *)view {
    self.videoWidget = view;
}

#pragma mark - touchbgan
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
- (NSString *)convertTime:(float)time {
    
    /// 错误时间戳设置
    if (time <= 0) {
        return @"00:00";
    }
    /// 返回正常时间戳设置
    return  [NSString stringWithFormat:@"%02d:%02d", ((int)time / 60), ((int)time % 60)];
}
-(BOOL)isPlaying {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(isPlaying)]) {
        return [self.delegate isPlaying];
    }
    return NO;
}
/**
 * You can handle your current video business like this, such as likes
 */
-(void)loveBtnClick:(UIButton *)button {
    NSDictionary *oDic = self.model.extInfo;
    NSInteger count = [oDic[@"lickCount"] integerValue];
    count++;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:oDic];
    dic[@"lickCount"] = [NSString stringWithFormat:@"%ld",(long)count];
    self.model.extInfo = dic;
    [self.model extInfoChangeNotify];
}
/**
 * You can handle your current video business like this, such as comment
 */
- (void)commentBtnClick:(UIButton *)button {
    NSString *commentStr =  [NSString stringWithFormat:@"【comment】 videoUrl=%@",self.model.videoUrl];
    [self alert:commentStr];
    [self.delegate customCallbackEvent:@"vodComment"];
}

- (void)adButtonclick:(UIButton *)button {
    NSString *ad = [NSString stringWithFormat:@"【ad】 ad=%@",button.titleLabel.text];
    [self alert:ad];
}

- (void)fullScreenButtonClick:(UIButton *)button {
    self.hidden = YES;
    TUIPSDFullScreenViewController *vc = [[TUIPSDFullScreenViewController alloc] init];
    vc.playerView = self.videoWidget;
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.window.rootViewController presentViewController:vc animated:NO completion:^{
        
    }];
}
- (void)renderModeButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    //RENDER_MODE_FILL_SCREEN = 0
    //RENDER_MODE_FILL_EDGE = 1,
    if (button.selected == YES) {
        [self.player setRenderMode:TUI_RENDER_MODE_FILL_SCREEN];
    } else {
        [self.player setRenderMode:TUI_RENDER_MODE_FILL_EDGE];
        
    }
}
#pragma mark - TUIPSDFullScreenViewControllerDelegate
- (void)viewControllerDismissed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(resetVideoWeigetContainer)]) {
        [self.delegate resetVideoWeigetContainer];
    }
    self.hidden = NO;
}

#pragma mark - alert
- (void)alert:(NSString *)content {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:content preferredStyle:UIAlertControllerStyleAlert];
    [[self viewControllerForView:self] presentViewController:alert animated:YES completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}
- (UIViewController *)viewControllerForView:(UIView *)view {
    UIResponder *responder = view;
    while (responder && ![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
    }
    return (UIViewController *)responder;
}
@end
