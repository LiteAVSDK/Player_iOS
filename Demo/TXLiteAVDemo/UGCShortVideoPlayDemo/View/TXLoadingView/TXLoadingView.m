//
//  TXLoadingView.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/9/2.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXLoadingView.h"
#import "TXVideoPlayMem.h"

@interface TXLoadingView()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation TXLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.indicatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.indicatorView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    self.indicatorView.transform = CGAffineTransformMakeScale(2.0, 2.0);
}

#pragma mark - Public Method
- (void)startLoading {
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}

- (void)stopLoading {
    self.indicatorView.hidden = YES;
    [self.indicatorView startAnimating];
}

#pragma mark - 懒加载
- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.color = [UIColor whiteColor];
        _indicatorView.hidesWhenStopped       = YES;
        _indicatorView.userInteractionEnabled = NO;
        _indicatorView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    }
    return _indicatorView;
}

@end
