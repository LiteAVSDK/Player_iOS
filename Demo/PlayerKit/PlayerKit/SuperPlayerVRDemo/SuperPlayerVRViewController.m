//  Copyright © 2021 Tencent. All rights reserved.

#import "SuperPlayerVRViewController.h"
#import "TXTimeView.h"
#import "TXSliderView.h"
#import "PlayerKitCommonHeaders.h"

typedef NS_ENUM(NSInteger, TXVRPlayState) {
    TXVRPlayStateIdle = 0,
    TXVRPlayStatePlaying = 1,
    TXVRPlayStatePause = 2
};

@interface SuperPlayerVRViewController () <TXVodPlayListener, TXSliderViewDelegate>

@property (nonatomic, strong) UIView *videoView; // 视频播放的View
@property (nonatomic, strong) TXTimeView *timeView; // 当前播放时间/视频时长
@property (nonatomic, strong) TXSliderView *sliderView; // 播放进度条
@property (nonatomic, strong) UIImageView *playImageView; // 播放按钮
@property (nonatomic, strong) UIImageView *backwardImageView; // 上一个按钮
@property (nonatomic, strong) UIImageView *forwardImageView; // 下一个按钮

@property (nonatomic, strong) TXVodPlayer *player; // 播放器
@property (nonatomic, strong) NSArray *videoUrl; // 视频URL列表
@property (nonatomic, assign) NSInteger videoIndex; // 当前视频索引
@property (nonatomic, assign) TXVRPlayState playState; // 播放状态
@property (nonatomic, assign) BOOL isSeekDragging; // 进度条是否正在拖动
@property (nonatomic, assign) BOOL backgroundPause; // Paused due to enter background.

@end

@implementation SuperPlayerVRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self addNotification];
    self.playState = TXVRPlayStateIdle;
    [self.timeView setTXtimeLabel:[self detailCurrentTime:0 totalTime:0]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.player stopPlay];
}

- (void)initUI {
    self.view.backgroundColor = UIColor.blackColor;

    [self.view addSubview:self.videoView];
    [self.view addSubview:self.timeView];
    [self.view addSubview:self.sliderView];
    [self.view addSubview:self.playImageView];
    [self.view addSubview:self.backwardImageView];
    [self.view addSubview:self.forwardImageView];
    
    [self initConstraints];
}

- (void)initConstraints {
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.sliderView).offset(-20);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.playImageView.mas_top).offset(-10);
        make.width.equalTo(self.view).multipliedBy(0.8);
        make.height.mas_equalTo(80);
    }];
    
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.width.mas_equalTo(42);
        make.height.mas_equalTo(42);
    }];
    
    [self.backwardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playImageView);
        make.right.equalTo(self.playImageView.mas_left).offset(-20);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];

    [self.forwardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playImageView);
        make.left.equalTo(self.playImageView.mas_right).offset(20);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_width).multipliedBy(9.0 / 16.0);
        make.center.equalTo(self.view);
    }];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveWillEnterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (NSArray *)videoUrl {
    if (!_videoUrl) {
        _videoUrl = @[
            @"https://playertest-75538.gzc.vod.tencent-cloud.com/vr/360vrtest.mp4",
        ];
    }
    return _videoUrl;
}

- (TXVodPlayer *)player {
    if (!_player) {
        _player = [[TXVodPlayer alloc] init];
        _player.vodDelegate = self;
        [_player setupVideoWidget:self.videoView insertIndex:0];
        TXVodPlayConfig *playConfig = [[TXVodPlayConfig alloc] init];
        playConfig.autoRotate = true;
        playConfig.progressInterval = 200;
        playConfig.maxPreloadSize = 10;
        playConfig.smoothSwitchBitrate  = YES;
        playConfig.keepLastFrameWhenStop = YES;
        playConfig.enableRenderProcess = YES; // 如果要启用VR功能，需要当前配置
        [_player setConfig:playConfig];

        // 配置开启VR功能
        NSMutableDictionary *extInfoMap = [NSMutableDictionary dictionary];
        [extInfoMap setObject:@"11" forKey:@"PARAM_MODULE_TYPE"];
        [_player setExtentOptionInfo:extInfoMap];
    }
    return _player;
}

- (UIView *)videoView {
    if (!_videoView) {
        _videoView = [UIView new];
    }
    return _videoView;
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

- (TXSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [TXSliderView new];
        _sliderView.backgroundColor = [UIColor clearColor];
        _sliderView.delegate = self;
    }
    return _sliderView;
}

- (UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = [UIImageView new];
        _playImageView.image = [UIImage imageNamed:@"play_circle" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
        _playImageView.tintColor = UIColor.whiteColor;
        _playImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playImageViewTapped:)];
        [_playImageView addGestureRecognizer:tapGesture];
    }
    return _playImageView;
}

- (UIImageView *)backwardImageView {
    if (!_backwardImageView) {
        _backwardImageView = [UIImageView new];
        _backwardImageView.image = [UIImage imageNamed:@"keyboard_double_arrow_left" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
        _backwardImageView.tintColor = UIColor.whiteColor;
        _backwardImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backwardImageViewTapped:)];
        [_backwardImageView addGestureRecognizer:tapGesture];
    }
    return _backwardImageView;
}

- (UIImageView *)forwardImageView {
    if (!_forwardImageView) {
        _forwardImageView = [UIImageView new];
        _forwardImageView.image = [UIImage imageNamed:@"keyboard_double_arrow_right" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
        _forwardImageView.tintColor = UIColor.whiteColor;
        _forwardImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardImageViewTapped:)];
        [_forwardImageView addGestureRecognizer:tapGesture];
    }
    return _forwardImageView;
}

- (void)startPlay {
    NSInteger videoIndex = self.videoIndex % self.videoUrl.count;
    NSString *url = self.videoUrl[videoIndex];
    if (url && self.player) {
        [self.player startVodPlay:url];
    }
}

- (void)playNext {
    self.videoIndex++;
    if (self.videoIndex == self.videoUrl.count) {
        self.videoIndex = 0;
    }
    if (self.playState != TXVRPlayStateIdle) {
        [self startPlay];
    }
}

- (void)playPrevious {
    self.videoIndex--;
    if (self.videoIndex < 0) {
        self.videoIndex = self.videoUrl.count - 1;
    }
    if (self.playState != TXVRPlayStateIdle) {
        [self startPlay];
    }
}

- (NSString *)detailCurrentTime:(int)currentTime totalTime:(int)totalTime {
    if (currentTime <= 0) {
        return [NSString stringWithFormat:@"00:00/%02d:%02d",(int)(totalTime / 60), (int)(totalTime % 60)];
    }
    return  [NSString stringWithFormat:@"%02d:%02d/%02d:%02d", (int)(currentTime / 60), (int)(currentTime % 60), (int)(totalTime / 60), (int)(totalTime % 60)];
}

#pragma mark - TXSliderViewDelegate

- (void)onSeekBegin:(UISlider *)slider {
    self.isSeekDragging = YES;
}

- (void)onSeek:(UISlider *)slider {
    int duration = (int) self.player.duration;
    int currentTime = (int) (slider.value * duration);
    [self.timeView setTXtimeLabel:[self detailCurrentTime:currentTime totalTime:duration]];
    [self.sliderView.slider setValue:slider.value];
}

- (void)onSeekEnd:(UISlider *)slider {
    self.isSeekDragging = NO;
    float sliderValue;
    if (slider.value >= slider.maximumValue) {
        sliderValue = slider.maximumValue;
    } else {
        sliderValue = slider.value;
    }
    [self.player seek:slider.value * self.player.duration];
}

- (void)onSeekOutSide:(UISlider *)slider {
    self.isSeekDragging = NO;
}

#pragma mark - TXVodPlayListener

- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
    switch (EvtID) {
        case EVT_VIDEO_PLAY_BEGIN:
        {
            self.playState = TXVRPlayStatePlaying;
            self.playImageView.image = [UIImage imageNamed:@"pause_circle" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
        }
            break;
        case EVT_VIDEO_PLAY_PROGRESS:
        {
            if (self.isSeekDragging) {
                break;
            }
            float currentTime = [param[EVT_PLAY_PROGRESS] floatValue];
            [self.timeView setTXtimeLabel:[self detailCurrentTime:currentTime totalTime:self.player.duration]];
            [self.sliderView.slider setValue:currentTime / self.player.duration];
        }
            break;
        case EVT_VIDEO_PLAY_END:
        {
            self.playState = TXVRPlayStateIdle;
            self.playImageView.image = [UIImage imageNamed:@"play_circle" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
            [self.timeView setTXtimeLabel:[self detailCurrentTime:self.player.duration totalTime:player.duration]];
        }
            break;
    }
}

#pragma mark - Tap Event

- (void)playImageViewTapped:(UITapGestureRecognizer *)gesture {
    switch (self.playState) {
        case TXVRPlayStateIdle:
            {
                [self startPlay];
                self.playState = TXVRPlayStatePlaying;
                self.playImageView.image = [UIImage imageNamed:@"pause_circle" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
            }
            break;
        case TXVRPlayStatePlaying:
            {
                [self.player pause];
                self.playState = TXVRPlayStatePause;
                self.playImageView.image = [UIImage imageNamed:@"play_circle" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
            }
            break;
        case TXVRPlayStatePause:
            {
                [self.player resume];
                self.playState = TXVRPlayStatePlaying;
                self.playImageView.image = [UIImage imageNamed:@"pause_circle" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
            }
            break;
        default:
            break;
    }
}

- (void)backwardImageViewTapped:(UITapGestureRecognizer *)gesture {
    [self.player stopPlay];
    [self playPrevious];
}

- (void)forwardImageViewTapped:(UITapGestureRecognizer *)gesture {
    [self.player stopPlay];
    [self playNext];
}

#pragma mark - Notification

- (void)didReceiveWillEnterForegroundNotification:(NSNotification *)notification {
    if (self.backgroundPause) {
        [self.player resume];
        self.backgroundPause = NO;
    }
}

- (void)didReceiveDidEnterBackgroundNotification:(NSNotification *)notification {
    if (self.playState == TXVRPlayStatePlaying) {
        [self.player pause];
        self.backgroundPause = YES;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
