//
//  SuperPlayerSettingsView.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/7/4.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "SuperPlayerSettingsView.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "DataReport.h"
#import "SuperPlayer.h"
#import "SuperPlayerControlView.h"
#import "SuperPlayerView+Private.h"
#import "UIView+MMLayout.h"
#import "SuperPlayerLocalized.h"

#define TAG_1_SPEED 1001
#define TAG_2_SPEED 1002
#define TAG_3_SPEED 1003
#define TAG_4_SPEED 1004

@interface                   SuperPlayerSettingsView ()
@property(nonatomic) UIView *soundCell;
@property(nonatomic) UIView *ligthCell;
@property(nonatomic) UIView *speedCell;
@property(nonatomic) UIView *mirrorCell;
@property(nonatomic) UIView *hwCell;
@property (nonatomic, strong) UIView *pipCell;
@property (nonatomic, strong) UISwitch *pipSwitch;
@property BOOL               isVolume;
@property NSDate *volumeEndTime;
@end

@implementation SuperPlayerSettingsView {
    NSInteger _contentHeight;
    NSInteger _speedTag;

    UISwitch *_mirrorSwitch;
    UISwitch *_hwSwitch;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    self.mm_h = ScreenHeight;
    self.mm_w = MoreViewWidth;

    [self addSubview:[self soundCell]];
    [self addSubview:[self lightCell]];
    [self addSubview:[self speedCell]];
    [self addSubview:[self mirrorCell]];
    [self addSubview:[self hwCell]];
    [self addSubview:[self pipCell]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeSettingChanged:) name:VOLUME_NOTIFICATION_NAME object:nil];

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)volumeSettingChanged:(NSNotification *)notify {
    if (!self.isVolume) {
        if (self.volumeEndTime != nil && -[self.volumeEndTime timeIntervalSinceNow] < 2.f) return;
        float volume           = [[[notify userInfo] objectForKey:VOLUME_CHANGE_KEY] floatValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.soundSlider.value = volume;
        });
    }
}

- (void)sizeToFit {
    _contentHeight = 20;

    _soundCell.m_top(_contentHeight);
    _contentHeight += _soundCell.mm_h;

    _ligthCell.m_top(_contentHeight);
    _contentHeight += _ligthCell.mm_h;

    if (self.enableSpeedAndMirrorControl) {
        _speedCell.m_top(_contentHeight);
        _contentHeight += _speedCell.mm_h;

        _mirrorCell.m_top(_contentHeight);
        _contentHeight += _mirrorCell.mm_h;

        _speedCell.hidden  = NO;
        _mirrorCell.hidden = NO;
    } else {
        _speedCell.hidden  = YES;
        _mirrorCell.hidden = YES;
    }

    _hwCell.m_top(_contentHeight);
    _contentHeight += _hwCell.mm_h;
    
    _pipCell.m_top(_contentHeight);
    _contentHeight += _pipCell.mm_h;
}

- (UIView *)soundCell {
    if (_soundCell == nil) {
        _soundCell = [[UIView alloc] initWithFrame:CGRectZero];
        _soundCell.m_width(MoreViewWidth).m_height(50).m_left(10);

        // 声音
        UILabel *sound  = [UILabel new];
        sound.text      = superPlayerLocalized(@"SuperPlayer.volume");
        sound.textColor = [UIColor whiteColor];
        [sound sizeToFit];
        [_soundCell addSubview:sound];
        sound.m_centerY();

        UIImageView *soundImage1 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"sound_min")];
        [_soundCell addSubview:soundImage1];
        soundImage1.m_left(sound.mm_maxX + 10).m_centerY();

        UIImageView *soundImage2 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"sound_max")];
        [_soundCell addSubview:soundImage2];
        soundImage2.m_right(50).m_centerY();

        UISlider *soundSlider = [[UISlider alloc] init];
        [soundSlider setThumbImage:SuperPlayerImage(@"slider_thumb") forState:UIControlStateNormal];

        soundSlider.maximumValue          = 1;
        soundSlider.minimumTrackTintColor = TintColor;
        soundSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];

        // slider开始滑动事件
        [soundSlider addTarget:self action:@selector(soundSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [soundSlider addTarget:self action:@selector(soundSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [soundSlider addTarget:self action:@selector(soundSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        [_soundCell addSubview:soundSlider];
        soundSlider.m_centerY().m_left(soundImage1.mm_maxX).m_width(soundImage2.mm_minX - soundImage1.mm_maxX);

        self.soundSlider = soundSlider;
    }
    return _soundCell;
}

- (UIView *)lightCell {
    if (_ligthCell == nil) {
        _ligthCell = [[UIView alloc] initWithFrame:CGRectZero];
        _ligthCell.m_width(MoreViewWidth).m_height(50).m_left(10);

        // 亮度
        UILabel *ligth  = [UILabel new];
        ligth.text      = superPlayerLocalized(@"SuperPlayer.brightness");
        ligth.textColor = [UIColor whiteColor];
        [ligth sizeToFit];
        [_ligthCell addSubview:ligth];
        ligth.m_centerY();

        UIImageView *ligthImage1 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"light_min")];
        [_ligthCell addSubview:ligthImage1];
        ligthImage1.m_left(ligth.mm_maxX + 10).m_centerY();

        UIImageView *ligthImage2 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"light_max")];
        [_ligthCell addSubview:ligthImage2];
        ligthImage2.m_right(50).m_centerY();

        UISlider *lightSlider = [[UISlider alloc] init];

        [lightSlider setThumbImage:SuperPlayerImage(@"slider_thumb") forState:UIControlStateNormal];

        lightSlider.maximumValue          = 1;
        lightSlider.minimumTrackTintColor = TintColor;
        lightSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];

        // slider开始滑动事件
        [lightSlider addTarget:self action:@selector(lightSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [lightSlider addTarget:self action:@selector(lightSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [lightSlider addTarget:self action:@selector(lightSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];

        [_ligthCell addSubview:lightSlider];
        lightSlider.m_centerY().m_left(ligthImage1.mm_maxX).m_width(ligthImage2.mm_minX - ligthImage1.mm_maxX);

        self.lightSlider = lightSlider;
    }

    return _ligthCell;
}

- (UIView *)speedCell {
    if (!_speedCell) {
        _speedCell = [UIView new];
        _speedCell.m_width(MoreViewWidth).m_height(50).m_left(10);

        // 倍速
        UILabel *speed  = [UILabel new];
        speed.text      = superPlayerLocalized(@"SuperPlayer.speed");
        speed.textColor = [UIColor whiteColor];
        [speed sizeToFit];
        [_speedCell addSubview:speed];
        speed.m_centerY();

        UIButton *speed1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [speed1 setTitle:superPlayerLocalized(@"SuperPlayer.speed1p0") forState:UIControlStateNormal];
        [speed1 setTitleColor:TintColor forState:UIControlStateSelected];
        speed1.selected = YES;
        speed1.tag      = TAG_1_SPEED;
        [speed1 sizeToFit];
        [_speedCell addSubview:speed1];
        [speed1 addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];

        speed1.m_left(speed.mm_maxX + 10).m_centerY();

        UIButton *speed2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [speed2 setTitle:superPlayerLocalized(@"SuperPlayer.speed1p25") forState:UIControlStateNormal];
        [speed2 setTitleColor:TintColor forState:UIControlStateSelected];
        speed2.tag = TAG_2_SPEED;
        [speed2 sizeToFit];
        [_speedCell addSubview:speed2];
        [speed2 addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];

        speed2.m_left(speed1.mm_maxX + 12).m_centerY();

        UIButton *speed3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [speed3 setTitle:superPlayerLocalized(@"SuperPlayer.speed1p5") forState:UIControlStateNormal];
        [speed3 setTitleColor:TintColor forState:UIControlStateSelected];
        speed3.tag = TAG_3_SPEED;
        [speed3 sizeToFit];
        [_speedCell addSubview:speed3];
        [speed3 addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];

        speed3.m_left(speed2.mm_maxX + 12).m_centerY();

        UIButton *speed4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [speed4 setTitle:superPlayerLocalized(@"SuperPlayer.speed2p0") forState:UIControlStateNormal];
        [speed4 setTitleColor:TintColor forState:UIControlStateSelected];
        speed4.tag = TAG_4_SPEED;
        [speed4 sizeToFit];
        [_speedCell addSubview:speed4];
        [speed4 addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
        speed4.m_left(speed3.mm_maxX + 12).m_centerY();
    }
    return _speedCell;
}

- (UIView *)mirrorCell {
    if (!_mirrorCell) {
        _mirrorCell = [UIView new];
        _mirrorCell.m_width(MoreViewWidth).m_height(50).m_left(10);

        UILabel *mirror  = [UILabel new];
        mirror.text      = superPlayerLocalized(@"SuperPlayer.mirror");
        mirror.textColor = [UIColor whiteColor];
        [mirror sizeToFit];
        [_mirrorCell addSubview:mirror];
        mirror.m_centerY();

        UISwitch *switcher = [UISwitch new];
        _mirrorSwitch      = switcher;
        [switcher addTarget:self action:@selector(changeMirror:) forControlEvents:UIControlEventValueChanged];
        [_mirrorCell addSubview:switcher];
        switcher.m_right(30).m_centerY();
    }
    return _mirrorCell;
}

- (UIView *)hwCell {
    if (!_hwCell) {
        _hwCell = [UIView new];
        _hwCell.m_width(MoreViewWidth).m_height(50).m_left(10);

        UILabel *hd = [UILabel new];
        hd.text     = superPlayerLocalized(@"SuperPlayer.handware");

        hd.textColor = [UIColor whiteColor];
        [hd sizeToFit];
        [_hwCell addSubview:hd];
        hd.m_centerY();

        UISwitch *switcher = [UISwitch new];
        _hwSwitch          = switcher;
        [switcher addTarget:self action:@selector(changeHW:) forControlEvents:UIControlEventValueChanged];
        [_hwCell addSubview:switcher];
        switcher.m_right(30).m_centerY();
    }
    return _hwCell;
}

- (UIView *)pipCell {
    if (!_pipCell) {
        _pipCell = [UIView new];
        _pipCell.m_width(MoreViewWidth).m_height(50).m_left(10);
        
        UILabel *hd = [UILabel new];
        hd.text     = superPlayerLocalized(@"SuperPlayer.pipAutomatic");
        
        hd.textColor = [UIColor whiteColor];
        [hd sizeToFit];
        [_pipCell addSubview:hd];
        hd.m_centerY();
        
        UISwitch *switcher = [UISwitch new];
        _pipSwitch          = switcher;
        [switcher addTarget:self action:@selector(changePip:) forControlEvents:UIControlEventValueChanged];
        [_pipCell addSubview:switcher];
        switcher.m_right(30).m_centerY();
    }
    return _pipCell;
}
- (void)soundSliderTouchBegan:(UISlider *)sender {
    self.isVolume = YES;
}

- (void)soundSliderValueChanged:(UISlider *)sender {
    if (self.isVolume) [SuperPlayerView volumeViewSlider].value = sender.value;
}

- (void)soundSliderTouchEnded:(UISlider *)sender {
    self.isVolume      = NO;
    self.volumeEndTime = [NSDate date];
}

- (void)lightSliderTouchBegan:(UISlider *)sender {
}

- (void)lightSliderValueChanged:(UISlider *)sender {
    [UIScreen mainScreen].brightness = sender.value;
}

- (void)lightSliderTouchEnded:(UISlider *)sender {
}

- (void)changeSpeed:(UIButton *)sender {
    for (int i = TAG_1_SPEED; i <= TAG_4_SPEED; i++) {
        UIButton *b = [_speedCell viewWithTag:i];
        if (b.isSelected && b != sender) b.selected = NO;
    }
    sender.selected            = YES;
    self.playerConfig.playRate = [sender.titleLabel.text floatValue];
    [self.controlView.delegate controlViewConfigUpdate:self.controlView withReload:NO];
    [DataReport report:@"change_speed" param:nil];
}

- (void)changeMirror:(UISwitch *)sender {
    self.playerConfig.mirror = sender.on;
    [self.controlView.delegate controlViewConfigUpdate:self.controlView withReload:NO];
    if (sender.on) {
        [DataReport report:@"mirror" param:nil];
    }
}

- (void)changeHW:(UISwitch *)sender {
    self.playerConfig.hwAcceleration = sender.on;
    [self.controlView.delegate controlViewConfigUpdate:self.controlView withReload:YES];
    [DataReport report:sender.on ? @"hw_decode" : @"soft_decode" param:nil];
}

- (void)changePip:(UISwitch *)sender {
    self.playerConfig.pipAutomatic = sender.on;
    [self.controlView.delegate controlViewConfigUpdate:self.controlView withReload:YES];
   // [DataReport report:sender.on ? @"pipAutomatic_on" : @"pipAutomatic_off" param:nil];
}
- (void)update {
    self.soundSlider.value = [SuperPlayerView volumeViewSlider].value;
    self.lightSlider.value = [UIScreen mainScreen].brightness;

    CGFloat rate = self.playerConfig.playRate;

    for (int i = TAG_1_SPEED; i <= TAG_4_SPEED; i++) {
        UIButton *b = [_speedCell viewWithTag:i];
        b.selected  = NO;
    }

    if (rate == 1.0) {
        [[_speedCell viewWithTag:TAG_1_SPEED] setSelected:YES];
    }
    if (rate == 1.25) {
        [[_speedCell viewWithTag:TAG_2_SPEED] setSelected:YES];
    }
    if (rate == 1.5) {
        [[_speedCell viewWithTag:TAG_3_SPEED] setSelected:YES];
    }
    if (rate == 2.0) {
        [[_speedCell viewWithTag:TAG_4_SPEED] setSelected:YES];
    }

    _mirrorSwitch.on = self.playerConfig.mirror;
    _hwSwitch.on     = self.playerConfig.hwAcceleration;
    if (self.playerConfig.forcedPIP) {
        [self.pipSwitch setOn:YES];
        [self.pipSwitch setEnabled:NO];
    } else {
        [self.pipSwitch setOn:self.playerConfig.pipAutomatic];
        [self.pipSwitch setEnabled:YES];
    }
    [self sizeToFit];
}

@end
