//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import "TUIPSDSettingView.h"
#import "PlayerKitCommonHeaders.h"
#import "TUIPSDSettingDataView.h"
#import "TUIPSDVodConfigSettingView.h"
#import "TUIPSDLiveConfigSettingView.h"
#import "TUIPSVDCommonDefine.h"
#import "TUIPSVDResourceManager.h"
#import "UIView+TUIPSVD.h"
#import "TUIPSDSettingTestView.h"
@interface TUIPSDSettingView () <TUIPSDSettingDataViewDelegate,
TUIPSDSettingTestViewDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) TUIPSDSettingDataView *dataView;
@property (nonatomic, strong) TUIPSDVodConfigSettingView *vodConfigSettingView;
@property (nonatomic, strong) TUIPSDLiveConfigSettingView *liveConfigSettingView;
@property (nonatomic, strong) TUIPSDSettingTestView *testView;
@property (nonatomic, strong) UIView *keyboardMaskView;
@property (nonatomic, strong) UIButton *toolButton;
@end
@implementation TUIPSDSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.scrollView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.confirmButton];
        [self.scrollView addSubview:self.dataView];
        [self.scrollView addSubview:self.vodConfigSettingView];
        [self.scrollView addSubview:self.liveConfigSettingView];
        [self.scrollView addSubview:self.testView];
        [self addSubview:self.toolButton];
        [self addSubview:self.keyboardMaskView];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_left).offset(300);
            make.width.equalTo(@(300));
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_safeAreaLayoutGuideTop).offset(5);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-5);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(@(80));
            make.height.equalTo(@(40));
        }];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView).offset(-5);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.bottom.equalTo(self.confirmButton.mas_top);
        }];
        [self.dataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_top).offset(20);
            make.width.equalTo(self.scrollView.mas_width);
        }];
        [self.toolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(32));
            make.height.equalTo(@(100));
            make.left.equalTo(self.contentView.mas_right).offset(0);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.vodConfigSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dataView.mas_bottom).offset(20);
            make.width.equalTo(self.dataView.mas_width);
        }];
        [self.liveConfigSettingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vodConfigSettingView.mas_bottom).offset(20);
            make.width.equalTo(self.dataView.mas_width);
        }];
        [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.liveConfigSettingView.mas_bottom).offset(20);
            make.width.equalTo(self.dataView.mas_width);
            make.bottom.equalTo(self.scrollView.mas_bottom).offset(-5);
        }];
        [self layoutIfNeeded];
        [self.toolButton tuipsvd_setCornerRadius:45 forCorner:UIRectCornerTopRight|UIRectCornerBottomRight];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}


#pragma mark - lazyload
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_bgView addGestureRecognizer:tapGesture];
    }
    return _bgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = TUIPSVD_COLOR_BLACK;
    }
    return _contentView;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bounces = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"TUI Menu";
    }
    return _titleLabel;
}
- (UIButton *)confirmButton {
    if (!_confirmButton){
        _confirmButton = [[UIButton alloc] init];
        _confirmButton.backgroundColor = [UIColor whiteColor];
        [_confirmButton setTitle:@"Done" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 3.0;
        _confirmButton.clipsToBounds = YES;
    }
    return _confirmButton;
}
- (TUIPSDSettingDataView *)dataView {
    if (!_dataView) {
        _dataView = [[TUIPSDSettingDataView alloc] init];
        _dataView.delegate = self;
    }
    return _dataView;
}
- (TUIPSDVodConfigSettingView *)vodConfigSettingView {
    if (!_vodConfigSettingView) {
        _vodConfigSettingView = [[TUIPSDVodConfigSettingView alloc] init];
    }
    return _vodConfigSettingView;
}
- (TUIPSDLiveConfigSettingView *)liveConfigSettingView {
    if (!_liveConfigSettingView) {
        _liveConfigSettingView = [[TUIPSDLiveConfigSettingView alloc] init];
    }
    return _liveConfigSettingView;
}
- (TUIPSDSettingTestView *)testView {
    if (!_testView) {
        _testView = [[TUIPSDSettingTestView alloc] init];
        _testView.delegate = self;
    }
    return _testView;
}
- (UIView *)keyboardMaskView {
    if (!_keyboardMaskView) {
        _keyboardMaskView = [[UIView alloc] init];
        _keyboardMaskView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardMaskViewHandleTap:)];
        [_keyboardMaskView addGestureRecognizer:tapGesture];
    }
    return _keyboardMaskView;
}
- (UIButton *)toolButton {
    if (!_toolButton) {
        _toolButton = [[UIButton alloc] init];
        [_toolButton setBackgroundColor:TUIPSVD_COLOR_BLACK];
        [_toolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_toolButton setImage:[TUIPSVDResourceManager assetImageWithName:@"tuipsvd_settings"] forState:UIControlStateNormal];
        [_toolButton addTarget:self action:@selector(toolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolButton;
}
#pragma mark - actions
- (void)toolButtonClick:(UIButton *)button{
    [self hidden];
}
- (void)confirmButtonClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmActionVodResumeModel:loopModel:audioNormalization:superResolutionType:rendMode:)]) {
        [self.delegate confirmActionVodResumeModel:self.vodConfigSettingView.resumeModel
                                         loopModel:self.vodConfigSettingView.loopModel
                                audioNormalization:self.vodConfigSettingView.audioNormalization
                               superResolutionType:self.vodConfigSettingView.superResolutionType
                                          rendMode:self.vodConfigSettingView.rendMode];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmActionLivePip:rendMode:)]) {
        [self.delegate confirmActionLivePip:self.liveConfigSettingView.pip
                                   rendMode:self.liveConfigSettingView.rendModel];
    }
    [self hidden];
}
- (void)handleTap:(UITapGestureRecognizer *)gesture {
    [self hidden];
}
- (void)keyboardMaskViewHandleTap:(UITapGestureRecognizer *)gesture {
    self.keyboardMaskView.hidden = YES;
    [self.dataView registKeyboard];
}
#pragma mark - Pubick Methods
+ (instancetype)sharedInstance {
    static TUIPSDSettingView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)show:(UIView *)view  delegate:(id)delegate{
    self.delegate = delegate;
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
}

- (void)hidden {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeAction)]) {
        [self.delegate closeAction];
    }
    [self removeFromSuperview];
}

#pragma mark - Observer
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    NSLog(@"");
    self.keyboardMaskView.hidden = NO;
    [self.keyboardMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(keyboardHeight);
    }];
    
}


#pragma mark - TUIPSDSettingDataViewDelegate
- (void)removeButtonClickAction:(NSString *)paramStr {
    if (!paramStr) {
        return;
    }
    if (paramStr && paramStr.length <= 0) {
        return;
    }
    NSArray *array = [self parameterAnalysis:paramStr];
    if (array.count <= 0) {
        return;
    }
    NSString *type = array[0];
    if ([type isEqualToString:@"-"]) {
        if (array.count < 3) {
            return;
        }
    } else {
        if (array.count < 2) {
            return;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeButtonClickAction:)]) {
        [self.delegate removeButtonClickAction:array];
    }
    [self hidden];
}
- (void)addButtonClickAction:(NSString *)paramStr {
    if (!paramStr) {
        return;
    }
    if (paramStr && paramStr.length <= 0) {
        return;
    }
    NSArray *array = [self parameterAnalysis:paramStr];
    if (array.count <= 0) {
        return;
    }
    NSString *type = array[0];
    if ([type isEqualToString:@"-"]) {
        if (array.count < 3) {
            return;
        }
    } else {
        if (array.count < 2) {
            return;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(addButtonClickAction:)]) {
        [self.delegate addButtonClickAction:array];
    }
    [self hidden];
}
- (void)replaceButtonClickAction:(NSString *)paramStr {
    if (!paramStr) {
        return;
    }
    if (paramStr && paramStr.length <= 0) {
        return;
    }
    NSArray *array = [self parameterAnalysis:paramStr];
    if (array.count <= 0) {
        return;
    }
    NSString *type = array[0];
    if ([type isEqualToString:@"-"]) {
        if (array.count < 3) {
            return;
        }
    } else {
        if (array.count < 2) {
            return;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(replaceButtonClickAction:)]) {
        [self.delegate replaceButtonClickAction:array];
    }
    [self hidden];
}

- (NSArray *)parameterAnalysis:(NSString *)des {
    NSMutableArray *array = [NSMutableArray array];
    if ([des containsString:@"-"]) { ///范围
        [array addObject:@"-"];
        [array addObjectsFromArray:[des componentsSeparatedByString:@"-"]];
    } else { ///独立参数
        [array addObject:@","];
        [array addObjectsFromArray:[des componentsSeparatedByString:@","]];
    }
    return array;
}


#pragma mark - TUIPSDSettingTestViewDelegate
- (void)test {
    if (self.delegate && [self.delegate respondsToSelector:@selector(test)]) {
        [self.delegate test];
    }
    [self hidden];
}
@end
