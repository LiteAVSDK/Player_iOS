//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import "TUIPADConfigSettingButton.h"
#import "PlayerKitCommonHeaders.h"
@interface TUIPADConfigSettingButton ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *button;
@end
@implementation TUIPADConfigSettingButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.button];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@(120));
        }];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.titleLabel.mas_right).offset(3);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(40));
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}
- (void)setOptions:(NSArray<NSString *> *)options {
    _options = options;
}
- (void)setCurrentSelected:(NSString *)currentSelected {
    _currentSelected = currentSelected;
    [self.button setTitle:currentSelected forState:UIControlStateNormal];
}
#pragma mark - lazyload
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}
- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_button setTitle:@"NONE" forState:UIControlStateNormal];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)buttonClick {
    NSLog(@"");
    NSArray *options = self.options;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    for (NSString *optionTitle in options) {
        UIAlertAction *optionAction = [UIAlertAction actionWithTitle:optionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.button setTitle:action.title forState:UIControlStateNormal];
            self.currentSelected = action.title;
            if (self.selectedCallBack) {
                self.selectedCallBack(action.title);
            }
        }];
        [alertController addAction:optionAction];
    }

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];

    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}
@end
