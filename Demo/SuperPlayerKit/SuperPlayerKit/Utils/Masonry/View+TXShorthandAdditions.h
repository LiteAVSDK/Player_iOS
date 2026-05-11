//
//  UIView+TXShorthandAdditions.h
//  Masonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "View+TXAdditions.h"

#ifdef TX_SHORTHAND

/**
 *	Shorthand view additions without the 'tx_' prefixes,
 *  only enabled if TX_SHORTHAND is defined
 */
@interface TX_VIEW (TXShorthandAdditions)

@property (nonatomic, strong, readonly) TXViewAttribute *left;
@property (nonatomic, strong, readonly) TXViewAttribute *top;
@property (nonatomic, strong, readonly) TXViewAttribute *right;
@property (nonatomic, strong, readonly) TXViewAttribute *bottom;
@property (nonatomic, strong, readonly) TXViewAttribute *leading;
@property (nonatomic, strong, readonly) TXViewAttribute *trailing;
@property (nonatomic, strong, readonly) TXViewAttribute *width;
@property (nonatomic, strong, readonly) TXViewAttribute *height;
@property (nonatomic, strong, readonly) TXViewAttribute *centerX;
@property (nonatomic, strong, readonly) TXViewAttribute *centerY;
@property (nonatomic, strong, readonly) TXViewAttribute *baseline;
@property (nonatomic, strong, readonly) TXViewAttribute *(^attribute)(NSLayoutAttribute attr);

@property (nonatomic, strong, readonly) TXViewAttribute *firstBaseline;
@property (nonatomic, strong, readonly) TXViewAttribute *lastBaseline;

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) TXViewAttribute *leftMargin;
@property (nonatomic, strong, readonly) TXViewAttribute *rightMargin;
@property (nonatomic, strong, readonly) TXViewAttribute *topMargin;
@property (nonatomic, strong, readonly) TXViewAttribute *bottomMargin;
@property (nonatomic, strong, readonly) TXViewAttribute *leadingMargin;
@property (nonatomic, strong, readonly) TXViewAttribute *trailingMargin;
@property (nonatomic, strong, readonly) TXViewAttribute *centerXWithinMargins;
@property (nonatomic, strong, readonly) TXViewAttribute *centerYWithinMargins;

#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) TXViewAttribute *safeAreaLayoutGuideLeading NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *safeAreaLayoutGuideTrailing NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *safeAreaLayoutGuideLeft NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *safeAreaLayoutGuideRight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *safeAreaLayoutGuideTop NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *safeAreaLayoutGuideBottom NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *safeAreaLayoutGuideWidth NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *safeAreaLayoutGuideHeight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *safeAreaLayoutGuideCenterX NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *safeAreaLayoutGuideCenterY NS_AVAILABLE_IOS(11.0);

#endif

- (NSArray *)makeConstraints:(void(^)(TXConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(TXConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(TXConstraintMaker *make))block;

@end

#define TX_ATTR_FORWARD(attr)  \
- (TXViewAttribute *)attr {    \
    return [self tx_##attr];   \
}

#define TX_ATTR_FORWARD_AVAILABLE(attr, available)  \
- (TXViewAttribute *)attr available {    \
    return [self tx_##attr];   \
}

@implementation TX_VIEW (TXShorthandAdditions)

TX_ATTR_FORWARD(top);
TX_ATTR_FORWARD(left);
TX_ATTR_FORWARD(bottom);
TX_ATTR_FORWARD(right);
TX_ATTR_FORWARD(leading);
TX_ATTR_FORWARD(trailing);
TX_ATTR_FORWARD(width);
TX_ATTR_FORWARD(height);
TX_ATTR_FORWARD(centerX);
TX_ATTR_FORWARD(centerY);
TX_ATTR_FORWARD(baseline);

TX_ATTR_FORWARD(firstBaseline);
TX_ATTR_FORWARD(lastBaseline);

#if TARGET_OS_IPHONE || TARGET_OS_TV

TX_ATTR_FORWARD(leftMargin);
TX_ATTR_FORWARD(rightMargin);
TX_ATTR_FORWARD(topMargin);
TX_ATTR_FORWARD(bottomMargin);
TX_ATTR_FORWARD(leadingMargin);
TX_ATTR_FORWARD(trailingMargin);
TX_ATTR_FORWARD(centerXWithinMargins);
TX_ATTR_FORWARD(centerYWithinMargins);

TX_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideLeading, NS_AVAILABLE_IOS(11.0));
TX_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideTrailing, NS_AVAILABLE_IOS(11.0));
TX_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideLeft, NS_AVAILABLE_IOS(11.0));
TX_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideRight, NS_AVAILABLE_IOS(11.0));
TX_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideTop, NS_AVAILABLE_IOS(11.0));
TX_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideBottom, NS_AVAILABLE_IOS(11.0));
TX_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideWidth, NS_AVAILABLE_IOS(11.0));
TX_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideHeight, NS_AVAILABLE_IOS(11.0));
TX_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideCenterX, NS_AVAILABLE_IOS(11.0));
TX_ATTR_FORWARD_AVAILABLE(safeAreaLayoutGuideCenterY, NS_AVAILABLE_IOS(11.0));

#endif

- (TXViewAttribute *(^)(NSLayoutAttribute))attribute {
    return [self tx_attribute];
}

- (NSArray *)makeConstraints:(void(NS_NOESCAPE ^)(TXConstraintMaker *))block {
    return [self tx_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(NS_NOESCAPE ^)(TXConstraintMaker *))block {
    return [self tx_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(NS_NOESCAPE ^)(TXConstraintMaker *))block {
    return [self tx_remakeConstraints:block];
}

@end

#endif
