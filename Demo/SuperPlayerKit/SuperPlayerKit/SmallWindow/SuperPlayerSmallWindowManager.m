// Copyright (c) 2024 Tencent. All rights reserved.
//

#import "SuperPlayerSmallWindowManager.h"
#import "SuperPlayerSmallWindow.h"
#import "SuperPlayerSmallWindowViewController.h"
#import "SuperPlayer.h"
#import "UIView+Fade.h"
#import "UIView+MMLayout.h"

#import "DataReport.h"
#import "Masonry.h"
#define FLOAT_VIEW_WIDTH  200
#define FLOAT_VIEW_HEIGHT 112

@interface SuperPlayerSmallWindowManager ()
@property (nonatomic, strong) SuperPlayerSmallWindow *SuperPlayerWindow;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, assign) CGRect floatViewRect;
@property (nonatomic,weak) UIView *origFatherView;

@end
@implementation SuperPlayerSmallWindowManager

+ (instancetype)sharedInstance  {
    static SuperPlayerSmallWindowManager *instance;
    static dispatch_once_t    onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SuperPlayerSmallWindowManager alloc] init];
        CGRect rect = CGRectMake(ScreenWidth - FLOAT_VIEW_WIDTH, ScreenHeight - FLOAT_VIEW_HEIGHT, FLOAT_VIEW_WIDTH, FLOAT_VIEW_HEIGHT);
        if (IsIPhoneX) {
            rect.origin.y -= 44;
        }
        instance.floatViewRect = rect;
    });
    return instance;
}

- (void)show {
    self.rootView.frame = self.floatViewRect;
    self.closeBtn.frame = CGRectMake(0, 0, 42, 42);
    [self.rootView addSubview:self.closeBtn];
    [self.SuperPlayerWindow addSubview:self.rootView];
    
    self.SuperPlayerWindow.hidden = NO;
    
    self.origFatherView = self.superPlayer.fatherView;
    if (self.origFatherView != self.rootView) {
        self.superPlayer.fatherView = self.rootView;
    }
    
    [self.superPlayer.controlView fadeOut:0.01];
    
    [self.rootView bringSubviewToFront:self.closeBtn];
    
    _isShowing = YES;
    
    [DataReport report:@"floatmode" param:nil];
}

- (void)hide {
    self.floatViewRect = self.rootView.frame;
    
    [self.rootView removeFromSuperview];
    
    self.SuperPlayerWindow.hidden = YES;

    self.superPlayer.fatherView = self.origFatherView;

    _isShowing = NO;
}


#pragma mark - GestureRecognizer
// 拖动手势
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture {
    if (UIGestureRecognizerStateBegan == panGesture.state) {
    } else if (UIGestureRecognizerStateChanged == panGesture.state) {
        CGPoint translation = [panGesture translationInView:self.SuperPlayerWindow];

        CGPoint center = self.rootView.center;
        center.x += translation.x;
        center.y += translation.y;
        self.rootView.center = center;

        UIEdgeInsets effectiveEdgeInsets = UIEdgeInsetsZero;  // 边距可以自己调

        CGFloat leftMinX   = 0.0f + effectiveEdgeInsets.left;
        CGFloat topMinY    = 0.0f + effectiveEdgeInsets.top;
        CGFloat rightMaxX  = self.SuperPlayerWindow.bounds.size.width - self.rootView.bounds.size.width + effectiveEdgeInsets.right;
        CGFloat bottomMaxY = self.SuperPlayerWindow.bounds.size.height - self.rootView.bounds.size.height + effectiveEdgeInsets.bottom;

        CGRect frame    = _rootView.frame;
        frame.origin.x  = frame.origin.x > rightMaxX ? rightMaxX : frame.origin.x;
        frame.origin.x  = frame.origin.x < leftMinX ? leftMinX : frame.origin.x;
        frame.origin.y  = frame.origin.y > bottomMaxY ? bottomMaxY : frame.origin.y;
        frame.origin.y  = frame.origin.y < topMinY ? topMinY : frame.origin.y;
        self.rootView.frame = frame;

        // zero
        [panGesture setTranslation:CGPointZero inView:self.SuperPlayerWindow];
    } else if (UIGestureRecognizerStateEnded == panGesture.state) {
    }
}
/// 点击事件
- (void)viewTapped:(UITapGestureRecognizer *)gesture {
    [self backBtnClick:nil];
}

- (void)closeBtnClick:(id)sender {
    if (self.closeHandler) {
        self.closeHandler();
    } else {
        [self hide];
        [self.superPlayer resetPlayer];
        self.backController = nil;
    }
}

- (void)backBtnClick:(id)sender {
    if (self.backHandler) {
        self.backHandler();
    } else {
        [self hide];
        [self.topNavigationController pushViewController:self.backController animated:YES];
        self.backController = nil;
    }
}
- (UINavigationController *)topNavigationController {
    UIWindow *        window            = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController       = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController.navigationController;
}


#pragma mark - lazyload
- (SuperPlayerSmallWindow *)SuperPlayerWindow {
    if (!_SuperPlayerWindow){
        _SuperPlayerWindow = [[SuperPlayerSmallWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _SuperPlayerWindow.windowLevel = UIWindowLevelStatusBar - 1;
        _SuperPlayerWindow.hidden = YES;
        _SuperPlayerWindow.rootViewController = [SuperPlayerSmallWindowViewController new];
        _SuperPlayerWindow.rootViewController.view.backgroundColor        = [UIColor clearColor];
        _SuperPlayerWindow.rootViewController.view.userInteractionEnabled = NO;
        _SuperPlayerWindow.rootView = self.rootView;
    }
    return _SuperPlayerWindow;
}

- (UIView *)rootView {
    if (!_rootView) {
        _rootView = [[UIView alloc] init];
        _rootView.backgroundColor = [UIColor blackColor];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
        [_rootView addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [_rootView addGestureRecognizer:tapGesture];
    }
    return _rootView;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:SuperPlayerImage(@"close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn sizeToFit];
    }
    return _closeBtn;
}
@end
