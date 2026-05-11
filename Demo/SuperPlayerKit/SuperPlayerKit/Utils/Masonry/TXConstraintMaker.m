//
//  TXConstraintMaker.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "TXConstraintMaker.h"
#import "TXViewConstraint.h"
#import "TXCompositeConstraint.h"
#import "TXConstraint+Private.h"
#import "TXViewAttribute.h"
#import "View+TXAdditions.h"

@interface TXConstraintMaker () <TXConstraintDelegate>

@property (nonatomic, weak) TX_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation TXConstraintMaker

- (id)initWithView:(TX_VIEW *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [TXViewConstraint installedConstraintsForView:self.view];
        for (TXConstraint *constraint in installedConstraints) {
            [constraint uninstall];
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (TXConstraint *constraint in constraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
    [self.constraints removeAllObjects];
    return constraints;
}

#pragma mark - TXConstraintDelegate

- (void)constraint:(TXConstraint *)constraint shouldBeReplacedWithConstraint:(TXConstraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (TXConstraint *)constraint:(TXConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    TXViewAttribute *viewAttribute = [[TXViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];
    TXViewConstraint *newConstraint = [[TXViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];
    if ([constraint isKindOfClass:TXViewConstraint.class]) {
        //replace with composite constraint
        NSArray *children = @[constraint, newConstraint];
        TXCompositeConstraint *compositeConstraint = [[TXCompositeConstraint alloc] initWithChildren:children];
        compositeConstraint.delegate = self;
        [self constraint:constraint shouldBeReplacedWithConstraint:compositeConstraint];
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];
    }
    return newConstraint;
}

- (TXConstraint *)addConstraintWithAttributes:(TXAttribute)attrs {
    __unused TXAttribute anyAttribute = (TXAttributeLeft | TXAttributeRight | TXAttributeTop | TXAttributeBottom | TXAttributeLeading
                                          | TXAttributeTrailing | TXAttributeWidth | TXAttributeHeight | TXAttributeCenterX
                                          | TXAttributeCenterY | TXAttributeBaseline
                                          | TXAttributeFirstBaseline | TXAttributeLastBaseline
#if TARGET_OS_IPHONE || TARGET_OS_TV
                                          | TXAttributeLeftMargin | TXAttributeRightMargin | TXAttributeTopMargin | TXAttributeBottomMargin
                                          | TXAttributeLeadingMargin | TXAttributeTrailingMargin | TXAttributeCenterXWithinMargins
                                          | TXAttributeCenterYWithinMargins
#endif
                                          );
    
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    if (attrs & TXAttributeLeft) [attributes addObject:self.view.tx_left];
    if (attrs & TXAttributeRight) [attributes addObject:self.view.tx_right];
    if (attrs & TXAttributeTop) [attributes addObject:self.view.tx_top];
    if (attrs & TXAttributeBottom) [attributes addObject:self.view.tx_bottom];
    if (attrs & TXAttributeLeading) [attributes addObject:self.view.tx_leading];
    if (attrs & TXAttributeTrailing) [attributes addObject:self.view.tx_trailing];
    if (attrs & TXAttributeWidth) [attributes addObject:self.view.tx_width];
    if (attrs & TXAttributeHeight) [attributes addObject:self.view.tx_height];
    if (attrs & TXAttributeCenterX) [attributes addObject:self.view.tx_centerX];
    if (attrs & TXAttributeCenterY) [attributes addObject:self.view.tx_centerY];
    if (attrs & TXAttributeBaseline) [attributes addObject:self.view.tx_baseline];
    if (attrs & TXAttributeFirstBaseline) [attributes addObject:self.view.tx_firstBaseline];
    if (attrs & TXAttributeLastBaseline) [attributes addObject:self.view.tx_lastBaseline];
    
#if TARGET_OS_IPHONE || TARGET_OS_TV
    
    if (attrs & TXAttributeLeftMargin) [attributes addObject:self.view.tx_leftMargin];
    if (attrs & TXAttributeRightMargin) [attributes addObject:self.view.tx_rightMargin];
    if (attrs & TXAttributeTopMargin) [attributes addObject:self.view.tx_topMargin];
    if (attrs & TXAttributeBottomMargin) [attributes addObject:self.view.tx_bottomMargin];
    if (attrs & TXAttributeLeadingMargin) [attributes addObject:self.view.tx_leadingMargin];
    if (attrs & TXAttributeTrailingMargin) [attributes addObject:self.view.tx_trailingMargin];
    if (attrs & TXAttributeCenterXWithinMargins) [attributes addObject:self.view.tx_centerXWithinMargins];
    if (attrs & TXAttributeCenterYWithinMargins) [attributes addObject:self.view.tx_centerYWithinMargins];
    
#endif
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];
    
    for (TXViewAttribute *a in attributes) {
        [children addObject:[[TXViewConstraint alloc] initWithFirstViewAttribute:a]];
    }
    
    TXCompositeConstraint *constraint = [[TXCompositeConstraint alloc] initWithChildren:children];
    constraint.delegate = self;
    [self.constraints addObject:constraint];
    return constraint;
}

#pragma mark - standard Attributes

- (TXConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute];
}

- (TXConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (TXConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (TXConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (TXConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (TXConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (TXConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (TXConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (TXConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (TXConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (TXConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (TXConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

- (TXConstraint *(^)(TXAttribute))attributes {
    return ^(TXAttribute attrs){
        return [self addConstraintWithAttributes:attrs];
    };
}

- (TXConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}

- (TXConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (TXConstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (TXConstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (TXConstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (TXConstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (TXConstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (TXConstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (TXConstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (TXConstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif


#pragma mark - composite Attributes

- (TXConstraint *)edges {
    return [self addConstraintWithAttributes:TXAttributeTop | TXAttributeLeft | TXAttributeRight | TXAttributeBottom];
}

- (TXConstraint *)size {
    return [self addConstraintWithAttributes:TXAttributeWidth | TXAttributeHeight];
}

- (TXConstraint *)center {
    return [self addConstraintWithAttributes:TXAttributeCenterX | TXAttributeCenterY];
}

#pragma mark - grouping

- (TXConstraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        NSInteger previousCount = self.constraints.count;
        group();

        NSArray *children = [self.constraints subarrayWithRange:NSMakeRange(previousCount, self.constraints.count - previousCount)];
        TXCompositeConstraint *constraint = [[TXCompositeConstraint alloc] initWithChildren:children];
        constraint.delegate = self;
        return constraint;
    };
}

@end
