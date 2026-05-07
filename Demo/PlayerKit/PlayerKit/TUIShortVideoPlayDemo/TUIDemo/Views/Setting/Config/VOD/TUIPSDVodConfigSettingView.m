//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import "TUIPSDVodConfigSettingView.h"
#import "PlayerKitCommonHeaders.h"
#import "TUIPADConfigSettingButton.h"
#import "TUIPADConfigManager.h"
@interface TUIPSDVodConfigSettingView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) TUIPADConfigSettingButton *resumeModelButton;
@property (nonatomic, strong) TUIPADConfigSettingButton *loopModelButton;
@property (nonatomic, strong) TUIPADConfigSettingButton *audioNormalizationButton;
@property (nonatomic, strong) TUIPADConfigSettingButton *superResolutionTypeButton;
@property (nonatomic, strong) TUIPADConfigSettingButton *renderModeButton;

@end
@implementation TUIPSDVodConfigSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.resumeModelButton];
        [self addSubview:self.loopModelButton];
        [self addSubview:self.audioNormalizationButton];
        [self addSubview:self.superResolutionTypeButton];
        [self addSubview:self.renderModeButton];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
        }];
        [self.resumeModelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        }];
        [self.loopModelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.resumeModelButton.mas_bottom).offset(5);
        }];
        [self.audioNormalizationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.loopModelButton.mas_bottom).offset(5);
        }];
        [self.superResolutionTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.audioNormalizationButton.mas_bottom).offset(5);
        }];
        [self.renderModeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.superResolutionTypeButton.mas_bottom).offset(5);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
    }
    return self;
}
- (NSString *)resumeModel {
    return self.resumeModelButton.currentSelected;
}
- (NSString *)loopModel {
    return self.loopModelButton.currentSelected;
}
- (NSString *)audioNormalization {
    return self.audioNormalizationButton.currentSelected;
}
- (NSString *)superResolutionType {
    return self.superResolutionTypeButton.currentSelected;
}
- (NSString *)rendMode {
    return self.renderModeButton.currentSelected;
}
#pragma mark - lazyload
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.text = @"Configuration modification(VOD)";
    }
    return _titleLabel;
}
- (TUIPADConfigSettingButton *)resumeModelButton {
    if (!_resumeModelButton) {
        _resumeModelButton = [[TUIPADConfigSettingButton alloc] init];
        _resumeModelButton.titleStr = @"Resume mode:";
        _resumeModelButton.options = @[@"NONE",@"LAST",@"PLAYED"];
        _resumeModelButton.currentSelected = [TUIPADConfigManager sharedManager].vodResumeMode;
        _resumeModelButton.selectedCallBack = ^(NSString * _Nonnull currentSelected) {
            [TUIPADConfigManager sharedManager].vodResumeMode = currentSelected;
        };
    }
    return _resumeModelButton;
}
- (TUIPADConfigSettingButton *)loopModelButton {
    if (!_loopModelButton) {
        _loopModelButton = [[TUIPADConfigSettingButton alloc] init];
        _loopModelButton.titleStr = @"Loop mode:";
        _loopModelButton.options = @[@"ONE_LOOP",@"LIST_LOOP",@"CUSTOM_LOOP"];
        _loopModelButton.currentSelected = [TUIPADConfigManager sharedManager].vodLoopMode;
        _loopModelButton.selectedCallBack = ^(NSString * _Nonnull currentSelected) {
            [TUIPADConfigManager sharedManager].vodLoopMode = currentSelected;
        };
    }
    return _loopModelButton;
}
- (TUIPADConfigSettingButton *)audioNormalizationButton {
    if (!_audioNormalizationButton) {
        _audioNormalizationButton = [[TUIPADConfigSettingButton alloc] init];
        _audioNormalizationButton.titleStr = @"audioNormalization:";
        _audioNormalizationButton.options = @[@"OFF",@"STANDARD",@"LOW",@"HIGH"];
        _audioNormalizationButton.currentSelected = [TUIPADConfigManager sharedManager].vodAudioNormalization;
        _audioNormalizationButton.selectedCallBack = ^(NSString * _Nonnull currentSelected) {
            [TUIPADConfigManager sharedManager].vodAudioNormalization = currentSelected;
        };
    }
    return _audioNormalizationButton;
}
- (TUIPADConfigSettingButton *)superResolutionTypeButton {
    if (!_superResolutionTypeButton) {
        _superResolutionTypeButton = [[TUIPADConfigSettingButton alloc] init];
        _superResolutionTypeButton.titleStr = @"superResolutionType:";
        _superResolutionTypeButton.options = @[@"OFF", @"TSR"];
        _superResolutionTypeButton.currentSelected = [TUIPADConfigManager sharedManager].vodSuperResolutionType;
        _superResolutionTypeButton.selectedCallBack = ^(NSString * _Nonnull currentSelected) {
            [TUIPADConfigManager sharedManager].vodSuperResolutionType = currentSelected;
        };
    }
    return _superResolutionTypeButton;
}
- (TUIPADConfigSettingButton *)renderModeButton {
    if (!_renderModeButton) {
        _renderModeButton = [[TUIPADConfigSettingButton alloc] init];
        _renderModeButton.titleStr = @"renderMode:";
        _renderModeButton.options = @[@"FILL_EDGE",@"FILL_SCREEN"];
        _renderModeButton.currentSelected = [TUIPADConfigManager sharedManager].vodRenderMode;
        _renderModeButton.selectedCallBack = ^(NSString * _Nonnull currentSelected) {
            [TUIPADConfigManager sharedManager].vodRenderMode = currentSelected;
        };
    }
    return _renderModeButton;
}
@end
