//  Copyright (c) 2024 Tencent. All rights reserved.//

#import "TUIPSDLiveRoomControlView.h"
#import "TUIPSVDResourceManager.h"
#import "PlayerKitCommonHeaders.h"

@interface TUIPSDLiveRoomControlView ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UILabel *placehoderLabel;
@property (nonatomic, strong) UILabel *lickLabel;
@property (nonatomic, strong) UILabel *numberlabel;
@property (nonatomic, strong) UIButton *fullScreenButton;

@end
@implementation TUIPSDLiveRoomControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.closeButton];
        [self addSubview:self.iconImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.moreButton];
        [self addSubview:self.textView];
        [self addSubview:self.lickLabel];
        [self.textView addSubview:self.placehoderLabel];
        [self addSubview:self.numberlabel];
        [self addSubview:self.fullScreenButton];
        
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(3);
            make.right.equalTo(self.mas_right).offset(3);
            make.width.equalTo(@(40));
            make.height.equalTo(@(40));
        }];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(3);
            make.centerY.equalTo(self.closeButton.mas_centerY);
            make.width.equalTo(@(35));
            make.height.equalTo(@(35));
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_top);
            make.left.equalTo(self.iconImageView.mas_right).offset(2);
        }];
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-3);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            make.width.equalTo(@(35));
            make.height.equalTo(@(35));
        }];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(3);
            make.centerY.equalTo(self.moreButton.mas_centerY);
            make.height.equalTo(@(40));
            make.right.equalTo(self.moreButton.mas_left).offset(-3);
        }];
        [self.lickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(1);
        }];
        [self.placehoderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textView.mas_left).offset(5);
            make.centerY.equalTo(self.textView.mas_centerY);
        }];
        [self.numberlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.closeButton.mas_centerY);
            make.right.equalTo(self.closeButton.mas_left).offset(5);
        }];
        
        [self.fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).offset(-150);
        }];
        
    }
    return self;
}

#pragma mark - lazyload
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[TUIPSVDResourceManager assetImageWithName:@"close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [TUIPSVDResourceManager assetImageWithName:@"qq"];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 16;
        _iconImageView.layer.borderWidth = 1.0;
        _iconImageView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _iconImageView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.text = @"@Mars";
    }
    return _nameLabel;
}
- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:[TUIPSVDResourceManager assetImageWithName:@"more"] forState:UIControlStateNormal];
    }
    return _moreButton;
}
- (UIView *)textView {
    if (!_textView) {
        _textView = [[UIView alloc] init];
        _textView.layer.cornerRadius = 15;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = [UIColor whiteColor].CGColor;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapped)];
        _textView.userInteractionEnabled = YES;
        [_textView addGestureRecognizer:tapGesture];
    }
    return _textView;
}
-(UILabel *)lickLabel {
    if (!_lickLabel) {
        _lickLabel = [[UILabel alloc] init];
        _lickLabel.textColor = [UIColor whiteColor];
        _lickLabel.font = [UIFont systemFontOfSize:10];
        _lickLabel.text = @"301.5万本场点赞";
    }
    return _lickLabel;
}
-(UILabel *)placehoderLabel {
    if (!_placehoderLabel) {
        _placehoderLabel = [[UILabel alloc] init];
        _placehoderLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        _placehoderLabel.font = [UIFont systemFontOfSize:12];
        _placehoderLabel.text = @"善语结善缘，恶语伤人心～";
    }
    return _placehoderLabel;
}
- (UILabel *)numberlabel {
    if (!_numberlabel) {
        _numberlabel = [[UILabel alloc] init];
        _numberlabel.textColor = [UIColor whiteColor];
        _numberlabel.font = [UIFont systemFontOfSize:14];
        _numberlabel.textAlignment = NSTextAlignmentRight;
        _numberlabel.text = @"9999万人在线";
    }
    return _numberlabel;
}
- (UIButton *)fullScreenButton {
    if (!_fullScreenButton) {
        _fullScreenButton = [[UIButton alloc] init];
        _fullScreenButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _fullScreenButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_fullScreenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_fullScreenButton setTitle:@"View full screen" forState:UIControlStateNormal];
        [_fullScreenButton addTarget:self action:@selector(fullScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _fullScreenButton.layer.cornerRadius = 14;
        _fullScreenButton.layer.borderWidth = 0.5;
        _fullScreenButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return _fullScreenButton;
}
#pragma mark - action
- (void)fullScreenButtonClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreenButtonAction)]) {
        [self.delegate fullScreenButtonAction];
    }
}
- (void)closeButtonClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeAction)]) {
        [self.delegate closeAction];
    }
}
-(void)commentTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentAction)]) {
        [self.delegate commentAction];
    }
}
@end
