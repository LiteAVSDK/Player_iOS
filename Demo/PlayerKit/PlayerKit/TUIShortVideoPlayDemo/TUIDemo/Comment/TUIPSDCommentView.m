//
//  TUIPSDCommentView.m
//  Masonry
//
//  Created by Mars on 2024/4/14.
//

#import "TUIPSDCommentView.h"
#import "TUIPSVDCommonDefine.h"
#import "UIView+TUIPSVD.h"
#import "PlayerKitCommonHeaders.h"
#import "TUIPSVDResourceManager.h"
@interface TUIPSDCommentView ()
@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *tipLabel;
@end
@implementation TUIPSDCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        [self initUI];
    }
    return self;
}
- (void)layoutSubviews {
    [self tuipsvd_setCornerRadius:30 forCorner:UIRectCornerTopRight|UIRectCornerTopLeft];
}
- (void)initUI {
    [self addSubview:self.titlelabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.tipLabel];
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(8);
        make.left.right.equalTo(self);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titlelabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-8);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (UILabel *)titlelabel {
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc] init];
        _titlelabel.text = @"999条评论";
        _titlelabel.font = [UIFont systemFontOfSize:14];
        _titlelabel.textColor = [UIColor whiteColor];
        _titlelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titlelabel;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[TUIPSVDResourceManager assetImageWithName:@"close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.text = @"(无数据，UI样例展示)";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
-(void)closeButtonClick:(UIButton*)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeAction)]) {
        [self.delegate closeAction];
    }
}



@end
