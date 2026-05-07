//  Copyright © 2025 Tencent. All rights reserved.

#import "DRMPlayerLandscapeController.h"
#import "TXAppInstance.h"
#import "UIView+Layout.h"

@interface DRMPlayerLandscapeController ()

@property (nonatomic, strong) UIButton *backButton;

@end

@implementation DRMPlayerLandscapeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backButton];
    id delegate = [UIApplication sharedApplication].delegate;
    [delegate setValue:@(UIInterfaceOrientationMaskLandscape) forKey:@"interfaceOrientationMask"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.backButton];
    self.backButton.frame = CGRectMake(self.view.safeAreaInsets.left, self.view.safeAreaInsets.top, 35, 35);
    self.widget.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.widget.transform = CGAffineTransformIdentity;
        self.widget.frame = self.view.bounds;
    }];
}

- (void)setWidget:(UIView *)widget {
    _widget = widget;
    if (!_widget) {
        return;
    }
    [self.view addSubview:self.widget];
    self.widget.transform = CGAffineTransformMakeRotation(- M_PI_2);
}

- (void)rotateToPortrait {
    self.backButton.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
            self.widget.transform = CGAffineTransformMakeRotation(M_PI_2);
        } else {
            self.widget.transform = CGAffineTransformMakeRotation(- M_PI_2);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            self.widget.transform = CGAffineTransformIdentity;
            id delegate = [UIApplication sharedApplication].delegate;
            [delegate setValue:@(UIInterfaceOrientationMaskPortrait) forKey:@"interfaceOrientationMask"];
            [self dismissViewControllerAnimated:NO completion:^{
                self.dismissBlock ? self.dismissBlock() : nil;
            }];
        }
    }];
}

#pragma mark - Initialize

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.backgroundColor = UIColor.clearColor;
        [_backButton setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"返回"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(rotateToPortrait) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

@end
