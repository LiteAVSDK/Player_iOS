//
//  TXUpSlideGuideView.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/30.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXUpSlideGuideView.h"
#import "AppLocalized.h"
#import "PlayerKitCommonHeaders.h"

@interface TXUpSlideGuideView()

@property (nonatomic, strong) UIImageView  *upImageView;

@property (nonatomic, strong) UILabel      *describeLabel;

@property (nonatomic, strong) UIButton     *knowBtn;

@end

@implementation TXUpSlideGuideView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.596017263986014/1.0];
        [self addSubview:self.upImageView];
        [self addSubview:self.describeLabel];
        [self addSubview:self.knowBtn];
        
        [self.upImageView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    if (_upSlideViewHidden) {
        _upSlideViewHidden(YES);
    }
}

#pragma mark - 懒加载

- (UIImageView *)upImageView {
    if (!_upImageView) {
        _upImageView = [UIImageView new];
        _upImageView.image = [UIImage imageNamed:@"upSlide.png"];
        _upImageView.contentMode = UIViewContentModeBottom;
        _upImageView.clipsToBounds = YES;
    }
    return _upImageView;
}

- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [UILabel new];
        _describeLabel.text = playerLocalize(@"SuperPlayerDemo.ShortVideo.swipeup");
        _describeLabel.textAlignment = NSTextAlignmentCenter;
        _describeLabel.font = [UIFont fontWithName:@"PingFangSC" size:16];
        _describeLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    return _describeLabel;
}

- (UIButton *)knowBtn {
    if (!_knowBtn) {
        _knowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_knowBtn setTitle:playerLocalize(@"SuperPlayerDemo.ShortVideo.gotit") forState:UIControlStateNormal];
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
