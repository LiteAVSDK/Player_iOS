//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "TUIPSupRefreshView.h"
#import "PlayerKitCommonHeaders.h"
@interface TUIPSupRefreshView ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end
@implementation TUIPSupRefreshView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.label];
        [self addSubview:self.activityIndicator];
        

        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@(30));
        }];
        [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.label.mas_top);
            make.top.equalTo(self.mas_top);
            make.width.equalTo(self.activityIndicator.mas_height);
        }];
    }
    return self;
}

- (void)scrollViewDidScrollContentOffsetY:(CGFloat)y {
    NSInteger count = y/8;
    NSMutableString *str = [[NSMutableString alloc] initWithString:@"Loading"];
    for (int i = 0; i < count; i++) {
        [str appendString:@"."];
    }
    self.label.text = str;
}
- (void)beginRefreshing {
    [self.activityIndicator startAnimating];
}
- (void)endRefreshing {
    [self.activityIndicator stopAnimating];
}
#pragma mark - lazyload
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"Loading...";
    }
    return _label;
}
- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] init];
        _activityIndicator.hidesWhenStopped = NO;
    }
    return _activityIndicator;
}
@end
