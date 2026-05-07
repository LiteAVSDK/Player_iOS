//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import "TUIPSDToolBar.h"
#import "PlayerKitCommonHeaders.h"
#import "TUIPSResolutionSwitchView.h"

@interface TUIPSDToolBar ()<TUIPSResolutionSwitchViewDelegate>

@property (nonatomic, strong) TUIPSResolutionSwitchView *resolutionSwitchView;
@property (nonatomic, strong) UIButton *preloadPauseButton;
@end
@implementation TUIPSDToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.resolutionSwitchView];
        [self addSubview:self.preloadPauseButton];
        
        [self.resolutionSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
           // make.top.equalTo(self.mas_top).offset(80);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(5);
            } else {
                make.top.equalTo(self.mas_top).offset(5);
            }
        }];
        [self.preloadPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.resolutionSwitchView.mas_bottom).offset(30);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(45));
        }];
    }
    return self;
}


#pragma mark - TUIPSResolutionSwitchViewDelegate
- (void)switchWithResolution:(long)resolution index:(NSInteger)index {
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(switchWithResolution:index:)]) {
        [self.delegate switchWithResolution:resolution index:index];
    }
}

#pragma mark - setter
- (void)setResolutionArray:(NSArray<TUIPlayerBitrateItem *> *)resolutionArray {
    self.resolutionSwitchView.resolutionArray = resolutionArray;
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    self.resolutionSwitchView.currentIndex = currentIndex;
}
#pragma mark - lazyload
- (TUIPSResolutionSwitchView *)resolutionSwitchView {
    if (!_resolutionSwitchView) {
        _resolutionSwitchView = [[TUIPSResolutionSwitchView alloc] init];
        _resolutionSwitchView.delegate = self;
    }
    return _resolutionSwitchView;
}
- (UIButton *)preloadPauseButton {
    if (!_preloadPauseButton) {
        _preloadPauseButton = [[UIButton alloc] init];
        _preloadPauseButton.titleLabel.font = [UIFont systemFontOfSize:10];
        _preloadPauseButton.backgroundColor = [UIColor grayColor];
        [_preloadPauseButton setTitle:@"PausePreload" forState:UIControlStateNormal];
        [_preloadPauseButton setTitle:@"ResumePreload" forState:UIControlStateSelected];
        [_preloadPauseButton addTarget:self action:@selector(preloadPauseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preloadPauseButton;
}

- (void)preloadPauseButtonClick:(UIButton *)button {
    button.selected = !button.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(preloadPause:)]) {
        [self.delegate preloadPause:button.selected];
    }
}

@end
