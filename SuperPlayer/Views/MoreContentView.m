//
//  SuperPlayerMoreView.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/7/4.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "MoreContentView.h"
#import "UIView+MMLayout.h"
#import "SuperPlayer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "SuperPlayerControlView.h"
#import "SuperPlayerView+Private.h"
#import "DataReport.h"

#define TAG_1_SPEED 1001
#define TAG_2_SPEED 1002
#define TAG_3_SPEED 1003
#define TAG_4_SPEED 1004

@interface MoreContentView()
@property (nonatomic) UIView *soundCell;
@property (nonatomic) UIView *ligthCell;
@property (nonatomic) UIView *speedCell;
@property (nonatomic) UIView *mirrorCell;
@property (nonatomic) UIView *hwCell;
@property BOOL isVolume;
@property NSDate *volumeEndTime;
@end

@implementation MoreContentView {
    NSInteger  _contentHeight;
    NSInteger  _speedTag;
    
    UISwitch *_mirrorSwitch;
    UISwitch *_hwSwitch;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.mm_h = ScreenHeight;
    self.mm_w = MoreViewWidth;
    
    [self addSubview:[self soundCell]];
    [self addSubview:[self lightCell]];
    [self addSubview:[self speedCell]];
    [self addSubview:[self mirrorCell]];
    [self addSubview:[self hwCell]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)         name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)volumeChanged:(NSNotification *)notify
{
    if (!self.isVolume) {
        if (self.volumeEndTime != nil && -[self.volumeEndTime timeIntervalSinceNow] < 2.f)
            return;
        float volume = [[[notify userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
        self.soundSlider.value = volume;
    }
}

- (void)sizeToFit
{
    _contentHeight = 20;
    
    _soundCell.mm_top(_contentHeight);
    _contentHeight += _soundCell.mm_h;
    
    _ligthCell.mm_top(_contentHeight);
    _contentHeight += _ligthCell.mm_h;

    
    if (!self.isLive) {
        _speedCell.mm_top(_contentHeight);
        _contentHeight += _speedCell.mm_h;
        
        _mirrorCell.mm_top(_contentHeight);
        _contentHeight += _mirrorCell.mm_h;
        
        _speedCell.hidden = NO;
        _mirrorCell.hidden = NO;
    } else {
        _speedCell.hidden = YES;
        _mirrorCell.hidden = YES;
    }
    
    _hwCell.mm_top(_contentHeight);
    _contentHeight += _hwCell.mm_h;
}

- (UIView *)soundCell
{
    if (_soundCell == nil) {
        _soundCell = [[UIView alloc] initWithFrame:CGRectZero];
        _soundCell.mm_width(MoreViewWidth).mm_height(50).mm_left(10);
        
        // 声音
        UILabel *sound = [UILabel new];
        sound.text = @"声音";
        sound.textColor = [UIColor whiteColor];
        [sound sizeToFit];
        [_soundCell addSubview:sound];
        sound.mm__centerY(_soundCell.mm_h/2);

        
        UIImageView *soundImage1 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"sound_min")];
        [_soundCell addSubview:soundImage1];
        soundImage1.mm_left(sound.mm_maxX+10).mm__centerY(_soundCell.mm_h/2);

        UIImageView *soundImage2 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"sound_max")];
        [_soundCell addSubview:soundImage2];
        soundImage2.mm_right(50).mm__centerY(_soundCell.mm_h/2);
        
        
        UISlider *soundSlider                       = [[UISlider alloc] init];
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
        soundSlider.mm__centerY(_soundCell.mm_centerY).mm_left(soundImage1.mm_maxX).mm_width(soundImage2.mm_minX-soundImage1.mm_maxX);
        
        self.soundSlider = soundSlider;
    }
    return _soundCell;
}

- (UIView *)lightCell
{
    if (_ligthCell == nil) {
        _ligthCell = [[UIView alloc] initWithFrame:CGRectZero];
        _ligthCell.mm_width(MoreViewWidth).mm_height(50).mm_left(10);
        
        // 亮度
        UILabel *ligth = [UILabel new];
        ligth.text = @"亮度";
        ligth.textColor = [UIColor whiteColor];
        [ligth sizeToFit];
        [_ligthCell addSubview:ligth];
        ligth.mm__centerY(_ligthCell.mm_h/2);
        
        UIImageView *ligthImage1 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"light_min")];
        [_ligthCell addSubview:ligthImage1];
        ligthImage1.mm_left(ligth.mm_maxX+10).mm__centerY(_ligthCell.mm_h/2);
        
        UIImageView *ligthImage2 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"light_max")];
        [_ligthCell addSubview:ligthImage2];
        ligthImage2.mm_right(50).mm__centerY(_ligthCell.mm_h/2);
        
        
        UISlider *lightSlider                       = [[UISlider alloc] init];
        
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
        lightSlider.mm__centerY(_ligthCell.mm_h/2).mm_left(ligthImage1.mm_maxX).mm_width(ligthImage2.mm_minX-ligthImage1.mm_maxX);
        
        self.lightSlider = lightSlider;
    }

    
    return _ligthCell;
}

- (UIView *)speedCell {
    if (!_speedCell) {
        _speedCell = [UIView new];
        _speedCell.mm_width(MoreViewWidth).mm_height(50).mm_left(10);
        
        // 倍速
        UILabel *speed = [UILabel new];
        speed.text = @"倍速播放";
        speed.textColor = [UIColor whiteColor];
        [speed sizeToFit];
        [_speedCell addSubview:speed];
        speed.mm__centerY(_speedCell.mm_h/2);
        
        UIButton *speed1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [speed1 setTitle:@"1.0X" forState:UIControlStateNormal];
        [speed1 setTitleColor:TintColor forState:UIControlStateSelected];
        speed1.selected = YES;
        speed1.tag = TAG_1_SPEED;
        [speed1 sizeToFit];
        [_speedCell addSubview:speed1];
        [speed1 addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        speed1.mm_left(speed.mm_maxX+10).mm__centerY(_speedCell.mm_h/2);

        
        UIButton *speed2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [speed2 setTitle:@"1.25X" forState:UIControlStateNormal];
        [speed2 setTitleColor:TintColor forState:UIControlStateSelected];
        speed2.tag = TAG_2_SPEED;
        [speed2 sizeToFit];
        [_speedCell addSubview:speed2];
        [speed2 addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        speed2.mm_left(speed1.mm_maxX+12).mm__centerY(_speedCell.mm_h/2);
  
        
        UIButton *speed3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [speed3 setTitle:@"1.5X" forState:UIControlStateNormal];
        [speed3 setTitleColor:TintColor forState:UIControlStateSelected];
        speed3.tag = TAG_3_SPEED;
        [speed3 sizeToFit];
        [_speedCell addSubview:speed3];
        [speed3 addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        speed3.mm_left(speed2.mm_maxX+12).mm__centerY(_speedCell.mm_h/2);
        
        UIButton *speed4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [speed4 setTitle:@"2.0X" forState:UIControlStateNormal];
        [speed4 setTitleColor:TintColor forState:UIControlStateSelected];
        speed4.tag = TAG_4_SPEED;
        [speed4 sizeToFit];
        [_speedCell addSubview:speed4];
        [speed4 addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
        speed4.mm_left(speed3.mm_maxX+12).mm__centerY(_speedCell.mm_h/2);
    }
    return _speedCell;
}

- (UIView *)mirrorCell {
    if (!_mirrorCell) {
        _mirrorCell = [UIView new];
        _mirrorCell.mm_width(MoreViewWidth).mm_height(50).mm_left(10);
        
        
        UILabel *mirror = [UILabel new];
        mirror.text = @"镜像";
        mirror.textColor = [UIColor whiteColor];
        [mirror sizeToFit];
        [_mirrorCell addSubview:mirror];
        mirror.mm__centerY(_mirrorCell.mm_h/2);

        UISwitch *switcher = [UISwitch new];
        _mirrorSwitch = switcher;
        [switcher addTarget:self action:@selector(changeMirror:) forControlEvents:UIControlEventValueChanged];
        [_mirrorCell addSubview:switcher];
        switcher.mm_right(30).mm__centerY(_mirrorCell.mm_h/2);
    }
    return _mirrorCell;
}

- (UIView *)hwCell {
    if (!_hwCell) {
        _hwCell = [UIView new];
        _hwCell.mm_width(MoreViewWidth).mm_height(50).mm_left(10);
        
        
        UILabel *hd = [UILabel new];
        hd.text = @"硬件加速";
        
        hd.textColor = [UIColor whiteColor];
        [hd sizeToFit];
        [_hwCell addSubview:hd];
        hd.mm__centerY(_hwCell.mm_centerY);
        
        UISwitch *switcher = [UISwitch new];
        _hwSwitch = switcher;
        [switcher addTarget:self action:@selector(changeHW:) forControlEvents:UIControlEventValueChanged];
        [_hwCell addSubview:switcher];
        switcher.mm_right(30).mm__centerY(_hwCell.mm_h/2);
    }
    return _hwCell;
}

- (void)soundSliderTouchBegan:(UISlider *)sender {
    self.isVolume = YES;
}

- (void)soundSliderValueChanged:(UISlider *)sender {
    if (self.isVolume)
        [SuperPlayerView volumeViewSlider].value = sender.value;
}

- (void)soundSliderTouchEnded:(UISlider *)sender {
    self.isVolume = NO;
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
        if (b.isSelected && b != sender)
            b.selected = NO;
    }
    sender.selected = YES;
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
    [DataReport report:sender.on?@"hw_decode":@"soft_decode" param:nil];
}

- (void)update
{
    self.soundSlider.value = [SuperPlayerView volumeViewSlider].value;
    self.lightSlider.value = [UIScreen mainScreen].brightness;
    
    CGFloat rate = self.playerConfig.playRate;
    
    for (int i = TAG_1_SPEED; i <= TAG_4_SPEED; i++) {
        UIButton *b = [_speedCell viewWithTag:i];
        b.selected = NO;
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
    _hwSwitch.on = self.playerConfig.hwAcceleration;
    
    [self sizeToFit];
}

@end
