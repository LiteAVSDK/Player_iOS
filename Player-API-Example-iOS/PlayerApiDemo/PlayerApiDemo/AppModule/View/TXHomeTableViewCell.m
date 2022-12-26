//
//  TXHomeTableViewCell.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXHomeTableViewCell.h"
#import "TXHomeCellModel.h"
#import "TXAppLocalized.h"
#import <Masonry/Masonry.h>

@interface TXHomeTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIView  *containerView;

@property (nonatomic, strong) UILabel *centerTitleLabel;

@property (nonatomic, strong) UIView  *bgView;

@end

@implementation TXHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addChildView];
    }
    return self;
}

- (void)addChildView {
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(22);
        make.right.equalTo(self).offset(-22);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-13);
    }];
    
    [self.bgView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.right.equalTo(self.bgView).offset(-15);
        make.centerY.equalTo(self.bgView);
    }];
    
    [self.containerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView);
        make.height.mas_equalTo(20);
    }];
    
    [self.containerView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(12);
    }];
    
    [self.containerView addSubview:self.centerTitleLabel];
    [self.centerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView).offset(6);
        make.bottom.equalTo(self.containerView).offset(-8);
    }];
}

- (void)setHomeModel:(TXHomeCellModel *)model {
    if ([model.desc isEqualToString:@""]) {
        [self.centerTitleLabel setHidden: false];
        [self.descLabel setHidden: true];
        [self.titleLabel setHidden: true];
        self.centerTitleLabel.text = Localize(model.title);
    } else {
        [self.centerTitleLabel setHidden: true];
        [self.descLabel setHidden: false];
        [self.titleLabel setHidden: false];
        self.titleLabel.text = Localize(model.title);
        self.descLabel.text = Localize(model.desc);
    }
}

#pragma mark - 懒加载
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRed:52.0/255.0 green:199.0/255.0 blue:89.0/255.0 alpha:1.0];
    }
    return _bgView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        [_descLabel setTextColor:[UIColor whiteColor]];
        _descLabel.font = [UIFont systemFontOfSize:10];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _descLabel;
}

- (UILabel *)centerTitleLabel {
    if (!_centerTitleLabel) {
        _centerTitleLabel = [[UILabel alloc] init];
        [_centerTitleLabel setTextColor:[UIColor whiteColor]];
        _centerTitleLabel.font = [UIFont systemFontOfSize:16];
        _centerTitleLabel.textAlignment = NSTextAlignmentLeft;
        _centerTitleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _centerTitleLabel;
}

@end
