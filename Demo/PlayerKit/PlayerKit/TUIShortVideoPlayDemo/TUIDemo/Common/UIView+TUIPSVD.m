//  Copyright © 2023 Tencent. All rights reserved.
//

#import "UIView+TUIPSVD.h"
#import <objc/runtime.h>
@implementation UIView (TUIPSVD)

- (void)tuipsvd_setCornerRadius:(CGFloat)cornerRadius
              forCorner:(UIRectCorner)corner {
    
    if (corner == UIRectCornerAllCorners) {
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
    } else {
        [self.shapeLayer removeFromSuperlayer];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                       byRoundingCorners:corner
                                                             cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.path = maskPath.CGPath;
        
        self.layer.mask = self.shapeLayer;
    }
}

- (void)tuipsvd_setGradientColor:(NSArray *)colors
              startPoint:(CGPoint)startPoint
                endPoint:(CGPoint)endPoint {
    
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.colors           = colors;
    self.gradientLayer.startPoint       = startPoint;
    self.gradientLayer.endPoint         = endPoint;
    self.gradientLayer.frame            = self.bounds;
    [self.layer insertSublayer:self.gradientLayer atIndex:0];
    
}

- (UIViewController *)tuipsvd_viewController {
    UIView *view = self;
    while (view) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        view = view.superview;
    }
    return nil;
}

- (void)tuipsvd_alert:(NSString *)content {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:content preferredStyle:UIAlertControllerStyleAlert];
    [[self tuipsvd_viewController] presentViewController:alert animated:YES completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma make - getter & setter
- (CAGradientLayer *)gradientLayer {
    return objc_getAssociatedObject(self, @selector(gradientLayer));
}

- (void)setGradientLayer:(CAGradientLayer *)gradientLayer {
    objc_setAssociatedObject(self, @selector(gradientLayer), gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)shapeLayer {
    return objc_getAssociatedObject(self, @selector(shapeLayer));
}

- (void)setShapeLayer:(CAShapeLayer *)shapeLayer {
    objc_setAssociatedObject(self, @selector(shapeLayer), shapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
