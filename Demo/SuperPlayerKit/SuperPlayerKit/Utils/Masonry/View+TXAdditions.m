//
//  UIView+TXAdditions.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "View+TXAdditions.h"
#import <objc/runtime.h>

@implementation TX_VIEW (TXAdditions)

- (NSArray *)tx_makeConstraints:(void(^)(TXConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    TXConstraintMaker *constraintMaker = [[TXConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)tx_updateConstraints:(void(^)(TXConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    TXConstraintMaker *constraintMaker = [[TXConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)tx_remakeConstraints:(void(^)(TXConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    TXConstraintMaker *constraintMaker = [[TXConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - NSLayoutAttribute properties

- (TXViewAttribute *)tx_left {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (TXViewAttribute *)tx_top {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (TXViewAttribute *)tx_right {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (TXViewAttribute *)tx_bottom {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (TXViewAttribute *)tx_leading {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (TXViewAttribute *)tx_trailing {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (TXViewAttribute *)tx_width {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (TXViewAttribute *)tx_height {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (TXViewAttribute *)tx_centerX {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (TXViewAttribute *)tx_centerY {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (TXViewAttribute *)tx_baseline {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}

- (TXViewAttribute *(^)(NSLayoutAttribute))tx_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[TXViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}

- (TXViewAttribute *)tx_firstBaseline {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (TXViewAttribute *)tx_lastBaseline {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLastBaseline];
}

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (TXViewAttribute *)tx_leftMargin {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}

- (TXViewAttribute *)tx_rightMargin {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}

- (TXViewAttribute *)tx_topMargin {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}

- (TXViewAttribute *)tx_bottomMargin {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}

- (TXViewAttribute *)tx_leadingMargin {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (TXViewAttribute *)tx_trailingMargin {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (TXViewAttribute *)tx_centerXWithinMargins {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (TXViewAttribute *)tx_centerYWithinMargins {
    return [[TXViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

- (TXViewAttribute *)tx_safeAreaLayoutGuide {
    return [[TXViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeNotAnAttribute];
}

- (TXViewAttribute *)tx_safeAreaLayoutGuideLeading {
    return [[TXViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeading];
}

- (TXViewAttribute *)tx_safeAreaLayoutGuideTrailing {
    return [[TXViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTrailing];
}

- (TXViewAttribute *)tx_safeAreaLayoutGuideLeft {
    return [[TXViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeft];
}

- (TXViewAttribute *)tx_safeAreaLayoutGuideRight {
    return [[TXViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeRight];
}

- (TXViewAttribute *)tx_safeAreaLayoutGuideTop {
    return [[TXViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}

- (TXViewAttribute *)tx_safeAreaLayoutGuideBottom {
    return [[TXViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (TXViewAttribute *)tx_safeAreaLayoutGuideWidth {
    return [[TXViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeWidth];
}

- (TXViewAttribute *)tx_safeAreaLayoutGuideHeight {
    return [[TXViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeHeight];
}

- (TXViewAttribute *)tx_safeAreaLayoutGuideCenterX {
    return [[TXViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeCenterX];
}

- (TXViewAttribute *)tx_safeAreaLayoutGuideCenterY {
    return [[TXViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeCenterY];
}

#endif

#pragma mark - associated properties

- (id)tx_key {
    return objc_getAssociatedObject(self, @selector(tx_key));
}

- (void)setTx_key:(id)key {
    objc_setAssociatedObject(self, @selector(tx_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - heirachy

- (instancetype)tx_closestCommonSuperview:(TX_VIEW *)view {
    TX_VIEW *closestCommonSuperview = nil;

    TX_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        TX_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end
