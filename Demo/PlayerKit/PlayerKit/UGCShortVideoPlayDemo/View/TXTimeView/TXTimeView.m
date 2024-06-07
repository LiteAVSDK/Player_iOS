//
//  TXTimeView.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/9/1.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXTimeView.h"
#import "PlayerKitCommonHeaders.h"

@interface TXTimeView()

@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation TXTimeView

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

#pragma mark - Public Method
- (void)setTXtimeLabel:(NSString *)currentPlayTime {
    self.timeLabel.text = currentPlayTime;
}

#pragma mark - 懒加载
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
