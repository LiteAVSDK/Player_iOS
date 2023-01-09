//
//  SuperPlayerSubParamView.m
//  Pods
//
//  Created by 路鹏 on 2022/10/14.
//  Copyright © 2022 Tencent. All rights reserved.

#import "SuperPlayerSubParamView.h"
#import "SuperPlayerHelpers.h"
#import <Masonry/Masonry.h>

@interface SuperPlayerSubParamView()

// 左侧Label
@property (nonatomic, strong) UILabel  *label;

@property (nonatomic, strong) UIView   *contentView;

@property (nonatomic, strong) UIButton *chooseBtn;

@property (nonatomic, strong) UIImageView *imageView;

// block回调
@property (nonatomic, copy) SuperPlayerVoidBlock clickButtonCallback;

@end

@implementation SuperPlayerSubParamView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(0);
            make.width.mas_equalTo(120);
        }];
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.width.mas_equalTo(150);
        }];
        
        [self.contentView addSubview:self.chooseBtn];
        [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self).offset(-30);
        }];
        
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-5);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.mas_equalTo(25);
        }];
    }
    return self;
}

- (void)clickAction{
    if (self.clickButtonCallback){
        self.clickButtonCallback();
    }
}

- (void)clickButtonWithResultBlock:(SuperPlayerVoidBlock)block{
    self.clickButtonCallback = block;
}

#pragma mark - Public Method

- (void)setChooseTitle:(NSString *)title name:(NSString *)name {
    [self.chooseBtn setTitle:title forState:UIControlStateNormal];
    self.label.text = name;
}

#pragma mark - 懒加载

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = [UIFont systemFontOfSize:16];
    }
    return _label;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.cornerRadius = 2;
        _contentView.layer.borderWidth = 2;
        _contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _contentView;
}

- (UIButton *)chooseBtn {
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_chooseBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        _chooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _chooseBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    }
    return _chooseBtn;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = SuperPlayerImage(@"superplayer_dropdown");
    }
    return _imageView;
}

@end
