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
    
    [self addSubview:[self soundCell]];
    [self addSubview:[self lightCell]];
    [self addSubview:[self speedCell]];
    [self addSubview:[self mirrorCell]];
    [self addSubview:[self hwCell]];
    
    return self;
}

- (void)updateContents:(BOOL)isLive
{
    _contentHeight = 20;
    
    _soundCell.m_top(_contentHeight);
    _contentHeight += _soundCell.mm_h;
    
    _ligthCell.m_top(_contentHeight);
    _contentHeight += _ligthCell.mm_h;

    
    if (!isLive) {
        _speedCell.m_top(_contentHeight);
        _contentHeight += _speedCell.mm_h;
        
        _mirrorCell.m_top(_contentHeight);
        _contentHeight += _mirrorCell.mm_h;
        
        _speedCell.hidden = NO;
        _mirrorCell.hidden = NO;
    } else {
        _speedCell.hidden = YES;
        _mirrorCell.hidden = YES;
    }
    
    _hwCell.m_top(_contentHeight);
    _contentHeight += _hwCell.mm_h;
    
    self.mm_h = _contentHeight;
    self.mm_w = MoreViewWidth;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIView *)soundCell
{
    if (_soundCell == nil) {
        _soundCell = [[UIView alloc] initWithFrame:CGRectZero];
        _soundCell.m_width(MoreViewWidth).m_height(50).m_left(10);
        
        // 声音
        UILabel *sound = [UILabel new];
        sound.text = @"声音";
        sound.textColor = [UIColor whiteColor];
        [sound sizeToFit];
        [_soundCell addSubview:sound];
        sound.m_centerY();

        
        UIImageView *soundImage1 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"sound_min")];
        [_soundCell addSubview:soundImage1];
        soundImage1.m_left(sound.mm_maxX+10).m_centerY();

        UIImageView *soundImage2 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"sound_max")];
        [_soundCell addSubview:soundImage2];
        soundImage2.m_right(50).m_centerY();
        
        
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
        soundSlider.m_centerY().m_left(soundImage1.mm_maxX).m_width(soundImage2.mm_minX-soundImage1.mm_maxX);
        
        self.soundSlider = soundSlider;
    }
    return _soundCell;
}

- (UIView *)lightCell
{
    if (_ligthCell == nil) {
        _ligthCell = [[UIView alloc] initWithFrame:CGRectZero];
        _ligthCell.m_width(MoreViewWidth).m_height(50).m_left(10);
        
        // 亮度
        UILabel *ligth = [UILabel new];
        ligth.text = @"亮度";
        ligth.textColor = [UIColor whiteColor];
        [ligth sizeToFit];
        [_ligthCell addSubview:ligth];
        ligth.m_centerY();
        
        UIImageView *ligthImage1 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"light_min")];
        [_ligthCell addSubview:ligthImage1];
        ligthImage1.m_left(ligth.mm_maxX+10).m_centerY();
        
        UIImageView *ligthImage2 = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"light_max")];
        [_ligthCell addSubview:ligthImage2];
        ligthImage2.m_right(50).m_centerY();
        
        
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
        lightSlider.m_centerY().m_left(ligthImage1.mm_maxX).m_width(ligthImage2.mm_minX-ligthImage1.mm_maxX);
        
        self.lightSlider = lightSlider;
    }

    
    return _ligthCell;
}

- (UIView *)speedCell {
    if (!_speedCell) {
        _speedCell = [UIView new];
        _speedCell.m_width(MoreViewWidth).m_height(50).m_left(10);
        
        // 倍速
        UILabel *speed = [UILabel new];
        speed.text = @"倍速播放";
        speed.textColor = [UIColor whiteColor];
        [speed sizeToFit];
        [_speedCell addSubview:speed];
        speed.m_centerY();
        
        UIButton *speed1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [speed1 setTitle:@"1.0X" forState:UIControlStateNormal];
        [speed1 setTitleColor:TintColor forState:UIControlStateSelected];
        speed1.selected = YES;
        speed1.tag = TAG_1_SPEED;
        [speed1 sizeToFit];
        [_speedCell addSubview:speed1];
        [speed1 addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        speed1.m_left(speed.mm_maxX+10).m_centerY();

        
        UIButton *speed2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [speed2 setTitle:@"1.25X" forState:UIControlStateNormal];
        [speed2 setTitleColor:TintColor forState:UIControlStateSelected];
        speed2.tag = TAG_2_SPEED;
        [speed2 sizeToFit];
        [_speedCell addSubview:speed2];
        [speed2 addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        speed2.m_left(speed1.mm_maxX+12).m_centerY();
  
        
        UIButton *speed3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [speed3 setTitle:@"1.5X" forState:UIControlStateNormal];
        [speed3 setTitleColor:TintColor forState:UIControlStateSelected];
        speed3.tag = TAG_3_SPEED;
        [speed3 sizeToFit];
        [_speedCell addSubview:speed3];
        [speed3 addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
        
        speed3.m_left(speed2.mm_maxX+12).m_centerY();
        
        UIButton *speed4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [speed4 setTitle:@"2.0X" forState:UIControlStateNormal];
        [speed4 setTitleColor:TintColor forState:UIControlStateSelected];
        speed4.tag = TAG_4_SPEED;
        [speed4 sizeToFit];
        [_speedCell addSubview:speed4];
        [speed4 addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchUpInside];
        speed4.m_left(speed3.mm_maxX+12).m_centerY();
    }
    return _speedCell;
}

- (UIView *)mirrorCell {
    if (!_mirrorCell) {
        _mirrorCell = [UIView new];
        _mirrorCell.m_width(MoreViewWidth).m_height(50).m_left(10);
        
        
        UILabel *mirror = [UILabel new];
        mirror.text = @"镜像";
        mirror.textColor = [UIColor whiteColor];
        [mirror sizeToFit];
        [_mirrorCell addSubview:mirror];
        mirror.m_centerY();

        UISwitch *switcher = [UISwitch new];
        _mirrorSwitch = switcher;
        switcher.on = SuperPlayerGlobleConfigShared.mirror;
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
        hd.text = @"硬件加速";
        
        hd.textColor = [UIColor whiteColor];
        [hd sizeToFit];
        [_hwCell addSubview:hd];
        hd.m_centerY();
        
        UISwitch *switcher = [UISwitch new];
        _hwSwitch = switcher;
        switcher.on = SuperPlayerGlobleConfigShared.enableHWAcceleration;
        [switcher addTarget:self action:@selector(changeHW:) forControlEvents:UIControlEventValueChanged];
        [_hwCell addSubview:switcher];
        switcher.m_right(30).m_centerY();
    }
    return _hwCell;
}

- (void)soundSliderTouchBegan:(UISlider *)sender {
    
}

- (void)soundSliderValueChanged:(UISlider *)sender {
    [SuperPlayerView volumeViewSlider].value = sender.value;
}

- (void)soundSliderTouchEnded:(UISlider *)sender {
    
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
    

    if (sender.tag == TAG_1_SPEED) {
        [self.controlView.delegate controlViewSetSpeed:self withSpeed:1];
        SuperPlayerGlobleConfigShared.playRate = 1;
    }
    if (sender.tag == TAG_2_SPEED) {
        [self.controlView.delegate controlViewSetSpeed:self withSpeed:1.25];
        SuperPlayerGlobleConfigShared.playRate = 1.25;
    }
    if (sender.tag == TAG_3_SPEED) {
        [self.controlView.delegate controlViewSetSpeed:self withSpeed:1.5];
        SuperPlayerGlobleConfigShared.playRate = 1.5;
    }
    if (sender.tag == TAG_4_SPEED) {
        [self.controlView.delegate controlViewSetSpeed:self withSpeed:2];
        SuperPlayerGlobleConfigShared.playRate = 2;
    }
    
    
    [DataReport report:@"change_speed" param:nil];
}

- (void)changeMirror:(UISwitch *)sender {
    [self.controlView.delegate controlViewSetMirror:self.controlView withMirror:sender.on];
    SuperPlayerGlobleConfigShared.mirror = sender.on;
    if (sender.on) {
        [DataReport report:@"mirror" param:nil];
    }
}

- (void)changeHW:(UISwitch *)sender {
    SuperPlayerGlobleConfigShared.enableHWAcceleration = sender.on;
    [self.controlView.delegate controlViewReload:self.controlView];
    [DataReport report:sender.on?@"hw_decode":@"soft_decode" param:nil];
}

- (void)updateData
{
    self.soundSlider.value = [SuperPlayerView volumeViewSlider].value;
    self.lightSlider.value = [UIScreen mainScreen].brightness;
    
    CGFloat rate = SuperPlayerGlobleConfigShared.playRate;
    
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
    
    _mirrorSwitch.on = SuperPlayerGlobleConfigShared.mirror;
    _hwSwitch.on = SuperPlayerGlobleConfigShared.enableHWAcceleration;
}

@end
