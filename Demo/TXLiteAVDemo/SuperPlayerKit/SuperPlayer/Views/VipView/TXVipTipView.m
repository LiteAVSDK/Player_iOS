//
//  TXVipTipView.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/8.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXVipTipView.h"
#import "SuperPlayerHelpers.h"
#import <Masonry/Masonry.h>

@interface TXVipTipView()

@property (nonatomic, strong) UIView             *tipView;

@property (nonatomic, strong) UILabel            *promptLabel;

@property (nonatomic, strong) UIButton           *closeBtn;

@property (nonatomic, strong) TXVipWatchModel      *vipWatchModel;

@end

@implementation TXVipTipView

#pragma mark - Public Method
- (void)setVipWatchModel:(TXVipWatchModel *)vipWatchModel {
    _vipWatchModel = vipWatchModel;
    // 计算内容宽度，根据宽度设置控件的宽度
    UIFont *font = self.textFontSize <= 0 ? self.promptLabel.font : [UIFont systemFontOfSize:self.textFontSize];
    CGFloat tipWidth = [self getWidthWithTitle:vipWatchModel.tipTtitle font:font];
    
    [self addSubview:self.tipView];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(self);
        make.width.mas_equalTo(tipWidth + VIP_TIPVIEW_MARGIN * 3 + VIP_TIPVIEW_CLOSEBTN_WIDTH);
    }];
    
    [self.tipView addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipView).offset(VIP_TIPVIEW_MARGIN);
        make.bottom.equalTo(self.tipView).offset(-VIP_TIPVIEW_MARGIN);
        make.top.equalTo(self.tipView).offset(VIP_TIPVIEW_MARGIN);
        make.width.mas_equalTo(tipWidth);
    }];
    
    [self.tipView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tipView).offset(-VIP_TIPVIEW_MARGIN);
        make.top.equalTo(self.tipView).offset(VIP_TIPVIEW_CLOSEBTN_TOP);
        make.height.mas_equalTo(VIP_TIPVIEW_CLOSEBTN_WIDTH);
        make.width.mas_equalTo(VIP_TIPVIEW_CLOSEBTN_WIDTH);
    }];
    
    self.promptLabel.text = vipWatchModel.tipTtitle;
    self.promptLabel.font = self.textFontSize <= 0 ? self.promptLabel.font : [UIFont systemFontOfSize:self.textFontSize];
}

#pragma mark - Private Method

- (void)closeTipViewClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCloseClick)]) {
        [self.delegate onCloseClick];
    }
}

#pragma mark - Utils
- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    CGFloat width = label.frame.size.width;
    return ceil(width);
}

#pragma mark - 懒加载
- (UIView *)tipView {
    if (!_tipView) {
        _tipView = [UIView new];
        _tipView.backgroundColor = [UIColor grayColor];
        _tipView.clipsToBounds = YES;
        _tipView.layer.cornerRadius = 5;
        _tipView.layer.masksToBounds = YES;
    }
    return _tipView;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [UILabel new];
        _promptLabel.numberOfLines = 1;
        _promptLabel.font = [UIFont systemFontOfSize:12];
        _promptLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _promptLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _promptLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        _closeBtn.clipsToBounds = YES;
        _closeBtn.backgroundColor = [UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1.0];
        [_closeBtn setImage:SuperPlayerImage(@"close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeTipViewClick) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.layer.cornerRadius = 10;
        _closeBtn.layer.masksToBounds = YES;
    }
    return _closeBtn;
}

@end
