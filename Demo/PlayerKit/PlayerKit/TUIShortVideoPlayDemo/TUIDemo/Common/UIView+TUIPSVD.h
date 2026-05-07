//  Copyright © 2023 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TUIPSVD)

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;


- (void)tuipsvd_setCornerRadius:(CGFloat)cornerRadius
              forCorner:(UIRectCorner)corner ;

- (void)tuipsvd_setGradientColor:(NSArray *)colors
              startPoint:(CGPoint)startPoint
                endPoint:(CGPoint)endPoint;

- (UIViewController *)tuipsvd_viewController;

- (void)tuipsvd_alert:(NSString *)content ;

@end

NS_ASSUME_NONNULL_END
