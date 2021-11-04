//
//  TXLeftSlideGuideView.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/30.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXLeftSlideGuideView.h"
#import <Masonry/Masonry.h>

@interface TXLeftSlideGuideView()

@property (nonatomic, strong) UIImageView  *leftImageView;

@property (nonatomic, strong) UILabel      *describeLabel;

@property (nonatomic, strong) UIButton     *knowBtn;

@end

@implementation TXLeftSlideGuideView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.596017263986014/1.0];
        [self addSubview:self.leftImageView];
        [self addSubview:self.describeLabel];
        [self addSubview:self.knowBtn];
        
        [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(150);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        [self.knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(94);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-192);
        }];
        
        [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(22);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.knowBtn).offset(-70);
        }];
    }
    return self;
}

- (void)knowClick {
    if (_leftSlideViewHidden) {
        _leftSlideViewHidden(YES);
    }
}

#pragma mark - 懒加载

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        _leftImageView.image = [UIImage imageNamed:@"leftSlide.png"];
        _leftImageView.contentMode = UIViewContentModeBottom;
        _leftImageView.clipsToBounds = YES;
    }
    return _leftImageView;
}

- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [UILabel new];
        _describeLabel.text = @"左滑进入视频列表";
        _describeLabel.textAlignment = NSTextAlignmentCenter;
        _describeLabel.font = [UIFont fontWithName:@"PingFangSC" size:16];
        _describeLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    return _describeLabel;
}

- (UIButton *)knowBtn {
    if (!_knowBtn) {
        _knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_knowBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [_knowBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_knowBtn addTarget:self action:@selector(knowClick) forControlEvents:UIControlEventTouchUpInside];
        _knowBtn.layer.cornerRadius = 20;
        _knowBtn.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
        _knowBtn.layer.borderWidth = 1;
        _knowBtn.layer.masksToBounds = YES;
    }
    return _knowBtn;
}

@end
