//
//  TXSliderView.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/9/2.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXSliderView.h"
#import "PlayerKitCommonHeaders.h"

@implementation TXSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.slider];
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

#pragma mark - Public Method
- (void)setProgress:(float)value {
    CGFloat finishValue = self.slider.maximumValue * value;
    
    [self.slider setValue:finishValue];
}

- (void)showSlider {
    _slider.hidden = NO;
}

- (void)hideSlider {
    _slider.hidden = YES;
}

#pragma mark - action
-(void)onSeekBegin:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSeekBegin:)]) {
        [self.delegate onSeekBegin:slider];
    }
}

-(void)onSeek:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSeek:)]) {
        [self.delegate onSeek:slider];
    }
}

-(void)onSeekEnd:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSeekEnd:)]) {
        [self.delegate onSeekEnd:slider];
    }
}

-(void)onSeekOutSide:(UISlider *)slider {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSeekOutSide:)]) {
        [self.delegate onSeekOutSide:slider];
    }
}

#pragma mark - Private Method
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:size.width/2] addClip];
    [img drawInRect:rect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;
}

#pragma mark - 懒加载
- (UISlider *)slider {
    if (!_slider) {
        _slider = [UISlider new];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        _slider.maximumTrackTintColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:0.29952469405594406/1.0];
        [_slider setThumbImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
        _slider.maximumValue = 1;
        _slider.minimumValue = 0;
        _slider.value = 0;
        _slider.continuous = NO;
        [_slider addTarget:self action:@selector(onSeekBegin:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(onSeek:) forControlEvents:(UIControlEventValueChanged)];
        [_slider addTarget:self action:@selector(onSeekEnd:) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(onSeekOutSide:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _slider;
}


@end
