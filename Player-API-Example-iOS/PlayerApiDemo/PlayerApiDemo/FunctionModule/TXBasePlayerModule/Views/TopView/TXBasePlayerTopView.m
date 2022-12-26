//
//  TXBasePlayerTopView.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXBasePlayerTopView.h"
#import "TXBasePlayerLocalized.h"
#import "TXBasePlayerMacro.h"
#import <Masonry/Masonry.h>

@interface TXBasePlayerTopView()<UITextFieldDelegate>

// 扫码按钮
@property (nonatomic, strong) UIButton *btnScan;

@end

@implementation TXBasePlayerTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initChildView];
    }
    return self;
}

#pragma mark - Private Method
// 初始化View
- (void)initChildView {
    // 添加输入url的View
    [self addSubview:self.urlTextField];
    [self.urlTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-(25 + TX_BasePlayer_Bottom_Btn_Width));
        make.height.mas_equalTo(TX_BasePlayer_Bottom_Btn_Height);
    }];
    
    // 添加扫码View
    [self addSubview:self.btnScan];
    [self.btnScan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self);
        make.height.mas_equalTo(TX_BasePlayer_Bottom_Btn_Height);
        make.width.mas_equalTo(TX_BasePlayer_Bottom_Btn_Width);
    }];
}

#pragma-- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Click

// 点击触发扫码事件
- (void)clickScan {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onScanClick)]) {
        [self.delegate onScanClick];
    }
}

#pragma mark - 懒加载

- (UITextField *)urlTextField {
    if (!_urlTextField) {
        _urlTextField = [[UITextField alloc] init];
        [_urlTextField setBorderStyle:UITextBorderStyleRoundedRect];
        _urlTextField.placeholder = TXBasePlayerLocalize(@"BASE_PLAYER-Module.enterorscan");
        _urlTextField.text                   = @"http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/48d0f1f9387702299774251236/adp.10.m3u8";
        _urlTextField.background             = [UIImage imageNamed:@"Input_box"];
        _urlTextField.alpha                  = 0.5;
        _urlTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _urlTextField.delegate               = self;
    }
    return _urlTextField;
}

- (UIButton *)btnScan {
    if (!_btnScan) {
        _btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnScan setImage:[UIImage imageNamed:@"QR_code"] forState:UIControlStateNormal];
        [_btnScan addTarget:self action:@selector(clickScan) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnScan;
}
@end
