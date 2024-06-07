
//  Copyright © 2023 Tencent. All rights reserved.
//

#import "TUIShortVideoPlayerViewNavView.h"
#import "PlayerKitCommonHeaders.h"
#import "AppLocalized.h"
#import "TXAppInstance.h"
@interface TUIShortVideoPlayerViewNavView ()
@property (nonatomic, strong) UIButton *backBtn;     ///返回键
@property (nonatomic, strong) UILabel  *titleLabel; ///标题
@end
@implementation TUIShortVideoPlayerViewNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.backBtn];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(11);
        } else {
            make.top.equalTo(self.mas_top).offset(22);
        }
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.centerX.equalTo(self);
        make.height.equalTo(@(30));
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}


#pragma mark - lazyload
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = playerLocalize(@"SuperPlayerDemo.TUIShortVideo.title");
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC" size:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"back.png"]  forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

#pragma mark - action
-(void)backBtnClick {
    if (self.backBtnAction) {
        self.backBtnAction();
    }
}

@end
