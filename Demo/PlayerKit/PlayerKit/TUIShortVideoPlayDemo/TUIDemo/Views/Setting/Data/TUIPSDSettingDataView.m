//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import "TUIPSDSettingDataView.h"
#import "PlayerKitCommonHeaders.h"
#import "TUIPSVDCommonDefine.h"
@interface TUIPSDSettingDataView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *removeButton;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *replaceButton;
@property (nonatomic, strong) UIStackView *stackView;

@end
@implementation TUIPSDSettingDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.desLabel];
        [self addSubview:self.textView];
        [self addSubview:self.stackView];
        [self.stackView addArrangedSubview:self.removeButton];
        [self.stackView addArrangedSubview:self.addButton];
        [self.stackView addArrangedSubview:self.replaceButton];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
        }];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
        }];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.desLabel.mas_bottom).offset(3);
            make.height.equalTo(@(50));
        }];
        [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@(40));
            make.top.equalTo(self.textView.mas_bottom).offset(5);
        }];
        
    }
    return self;
}

- (void)registKeyboard {
    [self.textView resignFirstResponder];
}

#pragma mark - lazyload
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.text = @"Data operations";
    }
    return _titleLabel;
}
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:14];
        _desLabel.numberOfLines = 0;
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.text = @"0-1 means 1 element starting from 0, and separating the numbers with commas means deleting by pressing the subscript. Such as: '0-5', '1,2,3'";
    }
    return _desLabel;
}
-(UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.text = @"";
        _textView.font = [UIFont systemFontOfSize:17.0]; // 设置字体大小
        _textView.layer.borderWidth = 2.0; // 设置边框宽度
        _textView.layer.borderColor = [UIColor whiteColor].CGColor;
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textView;
}
- (UIButton *)removeButton {
    if (!_removeButton) {
        _removeButton = [[UIButton alloc] init];
        _removeButton.backgroundColor = [UIColor whiteColor];
        [_removeButton setTitle:@"Remove" forState:UIControlStateNormal];
        [_removeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_removeButton addTarget:self action:@selector(removeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _removeButton.layer.cornerRadius = 3.0;
        _removeButton.clipsToBounds = YES;
    }
    return _removeButton;
}
- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        _addButton.backgroundColor = [UIColor whiteColor];
        [_addButton setTitle:@"Add" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _addButton.layer.cornerRadius = 3.0;
        _addButton.clipsToBounds = YES;
    }
    return _addButton;
}
- (UIButton *)replaceButton {
    if (!_replaceButton) {
        _replaceButton = [[UIButton alloc] init];
        _replaceButton.backgroundColor = [UIColor whiteColor];
        [_replaceButton setTitle:@"Replace" forState:UIControlStateNormal];
        [_replaceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_replaceButton addTarget:self action:@selector(replaceButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _replaceButton.layer.cornerRadius = 3.0;
        _replaceButton.clipsToBounds = YES;
    }
    return _replaceButton;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFillEqually;
        _stackView.spacing = 5;
    }
    return _stackView;
}
#pragma mark - actions
- (void)removeButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeButtonClickAction:)]) {
        [self.delegate removeButtonClickAction:self.textView.text];
    }
    self.textView.text = @"";
}
- (void)addButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addButtonClickAction:)]) {
        [self.delegate addButtonClickAction:self.textView.text];
    }
    self.textView.text = @"";
}
- (void)replaceButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(replaceButtonClickAction:)]) {
        [self.delegate replaceButtonClickAction:self.textView.text];
    }
    self.textView.text = @"";
}

@end
