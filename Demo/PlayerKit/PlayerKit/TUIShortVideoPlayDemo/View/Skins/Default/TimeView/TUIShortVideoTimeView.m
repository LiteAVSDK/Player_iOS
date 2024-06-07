// Copyright (c) 2023 Tencent. All rights reserved.

#import "TUIShortVideoTimeView.h"
#import "PlayerKitCommonHeaders.h"

@interface TUIShortVideoTimeView()

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation TUIShortVideoTimeView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(6);
            make.top.equalTo(self).offset(4);
            make.right.equalTo(self).offset(-6);
            make.bottom.equalTo(self).offset(-4);
        }];
    }
    return self;
}

#pragma mark - Public

- (void)setShortVideoTimeLabel:(NSString *)playTime {
    self.timeLabel.text = playTime;
}

#pragma mark - Lazy loading

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC" size:14];
        _timeLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

@end
