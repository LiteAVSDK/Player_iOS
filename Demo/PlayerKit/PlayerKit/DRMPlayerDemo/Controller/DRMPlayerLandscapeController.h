//  Copyright © 2025 Tencent. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRMPlayerLandscapeController : UIViewController

@property (nonatomic, strong) UIView *widget;

@property (nonatomic, copy) void(^dismissBlock)(void);

@end

NS_ASSUME_NONNULL_END
