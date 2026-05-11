//
//  NSArray+TXAdditions.m
//  
//
//  Created by Daniel Hammond on 11/26/13.
//
//

#import "NSArray+TXAdditions.h"
#import "View+TXAdditions.h"

@implementation NSArray (TXAdditions)

- (NSArray *)tx_makeConstraints:(void(^)(TXConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (TX_VIEW *view in self) {
        NSAssert([view isKindOfClass:[TX_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view tx_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)tx_updateConstraints:(void(^)(TXConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (TX_VIEW *view in self) {
        NSAssert([view isKindOfClass:[TX_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view tx_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)tx_remakeConstraints:(void(^)(TXConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (TX_VIEW *view in self) {
        NSAssert([view isKindOfClass:[TX_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view tx_remakeConstraints:block]];
    }
    return constraints;
}

- (void)tx_distributeViewsAlongAxis:(TXAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    TX_VIEW *tempSuperView = [self tx_commonSuperviewOfViews];
    if (axisType == TXAxisTypeHorizontal) {
        TX_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            TX_VIEW *v = self[i];
            [v tx_makeConstraints:^(TXConstraintMaker *make) {
                if (prev) {
                    make.width.equalTo(prev);
                    make.left.equalTo(prev.tx_right).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        TX_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            TX_VIEW *v = self[i];
            [v tx_makeConstraints:^(TXConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.tx_bottom).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }                    
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (void)tx_distributeViewsAlongAxis:(TXAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    TX_VIEW *tempSuperView = [self tx_commonSuperviewOfViews];
    if (axisType == TXAxisTypeHorizontal) {
        TX_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            TX_VIEW *v = self[i];
            [v tx_makeConstraints:^(TXConstraintMaker *make) {
                make.width.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.right.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
    else {
        TX_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            TX_VIEW *v = self[i];
            [v tx_makeConstraints:^(TXConstraintMaker *make) {
                make.height.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
}

- (TX_VIEW *)tx_commonSuperviewOfViews
{
    TX_VIEW *commonSuperview = nil;
    TX_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[TX_VIEW class]]) {
            TX_VIEW *view = (TX_VIEW *)object;
            if (previousView) {
                commonSuperview = [view tx_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
