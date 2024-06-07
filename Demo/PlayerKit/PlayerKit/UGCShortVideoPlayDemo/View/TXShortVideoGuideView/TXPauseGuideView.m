//
//  TXPauseGuideView.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/30.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXPauseGuideView.h"
#import "AppLocalized.h"
#import "PlayerKitCommonHeaders.h"

@interface TXPauseGuideView()

@property (nonatomic, strong) UIImageView  *pauseImageView;

@property (nonatomic, strong) UILabel      *describeLabel;

@property (nonatomic, strong) UIButton     *knowBtn;

@end

@implementation TXPauseGuideView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.596017263986014/1.0];
        [self addSubview:self.pauseImageView];
        [self addSubview:self.describeLabel];
        [self addSubview:self.knowBtn];
        
        [self.pauseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(88);
            make.height.mas_equalTo(140);
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
    if (_pauseViewHidden) {
        _pauseViewHidden(YES);
    }
}

#pragma mark - 懒加载

- (UIImageView *)pauseImageView {
    if (!_pauseImageView) {
        _pauseImageView = [UIImageView new];
        _pauseImageView.image = [UIImage imageNamed:@"click.png"];
        _pauseImageView.contentMode = UIViewContentModeBottom;
        _pauseImageView.clipsToBounds = YES;
    }
    return _pauseImageView;
}

- (UILabel *)describeLabel {
    if (!_describeLabel) {
        _describeLabel = [UILabel new];
        _describeLabel.text = playerLocalize(@"SuperPlayerDemo.ShortVideo.tap");
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
