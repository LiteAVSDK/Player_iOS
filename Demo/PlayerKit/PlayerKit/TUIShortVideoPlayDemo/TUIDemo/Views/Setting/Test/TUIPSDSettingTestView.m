//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import "TUIPSDSettingTestView.h"
#import "PlayerKitCommonHeaders.h"
@interface TUIPSDSettingTestView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *testButton;
@end
@implementation TUIPSDSettingTestView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.testButton];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5);
        }];
        [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left).offset(-5);
            make.right.equalTo(self.mas_right).offset(8);
            make.height.equalTo(@(45));
            make.bottom.equalTo(self.mas_bottom).offset(-5);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"自测用";
    }
    return _titleLabel;
}
- (UIButton *)testButton {
    if (!_testButton) {
        _testButton = [[UIButton alloc] init];
        _testButton.backgroundColor = [UIColor whiteColor];
        [_testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_testButton setTitle:@"Test(自测用)" forState:UIControlStateNormal];
        [_testButton addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testButton;
}

- (void)testButtonClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(test)]) {
        [self.delegate test];
    }
}
@end
