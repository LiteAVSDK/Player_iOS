//  Copyright © 2025 Tencent. All rights reserved.

#import "DRMPlayerSlider.h"
#import "UIView+Layout.h"

const static CGFloat gDRMPlayerSliderMargin = 8.0;

@interface DRMPlayerSlider ()

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UISlider *slider;

@end

@implementation DRMPlayerSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.slider];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftLabel sizeToFit];
    self.leftLabel.left = 0;
    self.leftLabel.top = 0;
    self.leftLabel.height = self.height;
    
    [self.rightLabel sizeToFit];
    self.rightLabel.right = self.width;
    self.rightLabel.top = 0;
    self.rightLabel.height = self.height;
    
    self.slider.left = self.leftLabel.right + gDRMPlayerSliderMargin;
    self.slider.width = self.rightLabel.left - self.leftLabel.right - 2 * gDRMPlayerSliderMargin;
    self.slider.height = self.height;
    self.slider.centerY = self.height / 2.0;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(text))]) {
        [self setNeedsLayout];
    }
}

#pragma mark - Initialize

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectZero];
        _slider.minimumValue = 0.0;
        _slider.maximumValue = 1.0;
        _slider.value = 0.0;
        _slider.continuous = NO;
        UIImage *image = [DRMPlayerSlider imageWithColor:UIColor.whiteColor size:CGSizeMake(16.0, 16.0)];
        [_slider setThumbImage:image forState:UIControlStateNormal];
    }
    return _slider;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftLabel.textAlignment = NSTextAlignmentRight;
        _leftLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _leftLabel.textColor = UIColor.whiteColor;
        [_leftLabel addObserver:self
                     forKeyPath:NSStringFromSelector(@selector(text))
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.textAlignment = NSTextAlignmentLeft;
        _rightLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _rightLabel.textColor = UIColor.whiteColor;
        [_rightLabel addObserver:self
                      forKeyPath:NSStringFromSelector(@selector(text))
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    }
    return _rightLabel;
}

#pragma mark - Helper

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGRect circleRect = CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(context, circleRect);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
