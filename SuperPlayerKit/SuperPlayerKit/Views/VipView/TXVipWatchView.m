//
//  TXVipWatchView.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/8.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXVipWatchView.h"
#import "SuperPlayerHelpers.h"
#import "SuperPlayerLocalized.h"
#import "Masonry.h"

@interface TXVipWatchView()

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel  *watchEndLabel;

@property (nonatomic, strong) UIButton *openVipBtn;

@property (nonatomic, strong) UIButton *repeatBtn;

@end

@implementation TXVipWatchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - Public Method
- (void)initVipWatchSubViews {
    
    [self addSubview:self.backBtn];
    [self addSubview:self.openVipBtn];
    [self addSubview:self.watchEndLabel];
    [self addSubview:self.repeatBtn];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(VIP_WATCHVIEW_BACKBTN_LEFT);
        make.top.equalTo(self).offset(VIP_WATCHVIEW_BACKBTN_TOP);
        //make.size.mas_equalTo(CGSizeMake(VIP_WATCHVIEW_BACKBTN_WIDTH * self.scale, VIP_WATCHVIEW_BACKBTN_WIDTH * self.scale));
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
    
    [self.openVipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(VIP_WATCHVIEW_OPENVIPBTN_WIDTH * self.scale);
        make.height.mas_equalTo(VIP_WATCHVIEW_OPENVIPBTN_HEIGHT * self.scale);
    }];
    [_openVipBtn.titleLabel setFont:self.textFontSize > 0 ? [UIFont systemFontOfSize:self.textFontSize] : _openVipBtn.titleLabel.font];
    _openVipBtn.layer.cornerRadius = VIP_WATCHVIEW_OPENVIPBTN_HEIGHT * 0.5 * self.scale;
    _openVipBtn.layer.masksToBounds = YES;
    
    [self.watchEndLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(VIP_WATCHVIEW_ENDLABEL_HEIGHT * self.scale);
        make.centerY.equalTo(self.openVipBtn).offset(-((VIP_WATCHVIEW_REPEARTBTN_HEIGHT + VIP_WATCHVIEW_MARGIN + VIP_WATCHVIEW_ENDLABEL_HEIGHT * 0.5) * self.scale));
    }];
    self.watchEndLabel.font = self.textFontSize > 0 ? [UIFont systemFontOfSize:self.textFontSize] : self.watchEndLabel.font;
    
    [self.repeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.mas_equalTo(VIP_WATCHVIEW_REPEARTBTN_HEIGHT * self.scale);
        make.width.mas_equalTo(VIP_WATCHVIEW_REPEARTBTN_WIDTH * self.scale);
        make.centerY.equalTo(self.openVipBtn).offset((VIP_WATCHVIEW_MARGIN + VIP_WATCHVIEW_REPEARTBTN_HEIGHT + VIP_WATCHVIEW_REPEARTBTN_HEIGHT * 0.5) * self.scale);
    }];
    [_repeatBtn.titleLabel setFont:self.textFontSize > 0 ? [UIFont systemFontOfSize:self.textFontSize] : _repeatBtn.titleLabel.font];
}

- (void)setCurrentTime:(float)currentTime {
    if ([self canShowVipView:currentTime]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showVipView)]) {
            [self.delegate showVipView];
        }
    }
}

#pragma mark - Private Method

- (BOOL)canShowVipView:(float)currentTime {
    return (self.vipWatchModel != nil && currentTime >= self.vipWatchModel.canWatchTime) ? YES : NO;
}

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    CGFloat width = label.frame.size.width;
    return ceil(width);
}

#pragma mark - Click
- (void)backClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBackClick)]) {
        [self.delegate onBackClick];
    }
}

- (void)openVipClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onOpenVIPClick)]) {
        [self.delegate onOpenVIPClick];
    }
}

- (void)repeatClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onRepeatClick)]) {
        [self.delegate onRepeatClick];
    }
}

#pragma mark - 懒加载
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:SuperPlayerImage(@"back_full") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)watchEndLabel {
    if (!_watchEndLabel) {
        _watchEndLabel = [UILabel new];
        _watchEndLabel.text = superPlayerLocalized(@"SuperPlayer.trywactchend");
        _watchEndLabel.font = [UIFont systemFontOfSize:15];
        _watchEndLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _watchEndLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _watchEndLabel;
}

- (UIButton *)openVipBtn {
    if (!_openVipBtn) {
        _openVipBtn = [UIButton new];
        _openVipBtn.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:209.0/255.0 blue:101.0/255.0 alpha:1.0];
        [_openVipBtn setTitle:superPlayerLocalized(@"SuperPlayer.openvip") forState:UIControlStateNormal];
        [_openVipBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        _openVipBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_openVipBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_openVipBtn addTarget:self action:@selector(openVipClick) forControlEvents:UIControlEventTouchUpInside];
        _openVipBtn.layer.cornerRadius = 28;
        _openVipBtn.layer.masksToBounds = YES;
    }
    return _openVipBtn;
}

- (UIButton *)repeatBtn {
    if (!_repeatBtn) {
        _repeatBtn = [UIButton new];
        [_repeatBtn setTitle:superPlayerLocalized(@"SuperPlayer.tryagain") forState:UIControlStateNormal];
        [_repeatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_repeatBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _repeatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_repeatBtn addTarget:self action:@selector(repeatClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _repeatBtn;
}

@end
