//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "TUIPSLoadingView.h"
#import "PlayerKitCommonHeaders.h"
@interface TUIPSLoadingView ()
@property (nonatomic, strong)UILabel *loadingView;
@end
@implementation TUIPSLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self addSubview:self.loadingView];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(70));
            make.height.equalTo(@(30));
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

#pragma mark - lazyload
- (UILabel *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UILabel alloc] init];
        _loadingView.backgroundColor = [UIColor yellowColor];
        _loadingView.textAlignment = NSTextAlignmentCenter;
        _loadingView.text = @"Loading...";
        _loadingView.textColor = [UIColor blackColor];
        _loadingView.hidden = YES;
    }
    return _loadingView;
}

#pragma mark - TUIPlayerShortVideoLoadingViewProtocol
- (void)startLoading {
    self.loadingView.hidden = NO;
}

- (void)stopLoading {
    self.loadingView.hidden = YES;
}



@end
