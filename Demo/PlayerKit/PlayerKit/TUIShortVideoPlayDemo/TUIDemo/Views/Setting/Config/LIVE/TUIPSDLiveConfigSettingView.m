//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import "TUIPSDLiveConfigSettingView.h"
#import "PlayerKitCommonHeaders.h"
#import "TUIPADConfigSettingButton.h"
#import "TUIPADConfigManager.h"
@interface TUIPSDLiveConfigSettingView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) TUIPADConfigSettingButton *pipButton;
@property (nonatomic, strong) TUIPADConfigSettingButton *renderModeButton;

@end
@implementation TUIPSDLiveConfigSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.pipButton];
        [self addSubview:self.renderModeButton];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
        }];
        [self.pipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        }];
        [self.renderModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.pipButton.mas_bottom).offset(5);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}

- (NSString *)pip {
    return self.pipButton.currentSelected;
}
- (NSString *)rendModel {
    return self.renderModeButton.currentSelected;
}
#pragma mark - lazyload
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.text = @"Configuration modification(LIVE)";
    }
    return _titleLabel;
}
- (TUIPADConfigSettingButton *)pipButton {
    if (!_pipButton) {
        _pipButton = [[TUIPADConfigSettingButton alloc] init];
        _pipButton.titleStr = @"pip:";
        _pipButton.options = @[@"OFF",@"ON"];
        _pipButton.currentSelected = [TUIPADConfigManager sharedManager].livePip;
        _pipButton.selectedCallBack = ^(NSString * _Nonnull currentSelected) {
            [TUIPADConfigManager sharedManager].livePip = currentSelected;
        };
    }
    return _pipButton;
}
- (TUIPADConfigSettingButton *)renderModeButton {
    if (!_renderModeButton) {
        _renderModeButton = [[TUIPADConfigSettingButton alloc] init];
        _renderModeButton.titleStr = @"renderMode:";
        _renderModeButton.options = @[@"Fill",@"Fit",@"ScaleFill"];
        _renderModeButton.currentSelected = [TUIPADConfigManager sharedManager].liveRendMode;
        _renderModeButton.selectedCallBack = ^(NSString * _Nonnull currentSelected) {
            [TUIPADConfigManager sharedManager].liveRendMode = currentSelected;
        };
    }
    return _renderModeButton;
}
@end
