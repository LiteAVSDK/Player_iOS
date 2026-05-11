//
//  TXConstraint.h
//  Masonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "TXUtilities.h"

/**
 *	Enables Constraints to be created with chainable syntax
 *  Constraint can represent single NSLayoutConstraint (TXViewConstraint) 
 *  or a group of NSLayoutConstraints (TXCompositeConstraint)
 */
@interface TXConstraint : NSObject

// Chaining Support

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects TXConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (TXConstraint * (^)(TXEdgeInsets insets))insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects TXConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (TXConstraint * (^)(CGFloat inset))inset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects TXConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (TXConstraint * (^)(CGSize offset))sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects TXConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (TXConstraint * (^)(CGPoint offset))centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (TXConstraint * (^)(CGFloat offset))offset;

/**
 *  Modifies the NSLayoutConstraint constant based on a value type
 */
- (TXConstraint * (^)(NSValue *value))valueOffset;

/**
 *	Sets the NSLayoutConstraint multiplier property
 */
- (TXConstraint * (^)(CGFloat multiplier))multipliedBy;

/**
 *	Sets the NSLayoutConstraint multiplier to 1.0/dividedBy
 */
- (TXConstraint * (^)(CGFloat divider))dividedBy;

/**
 *	Sets the NSLayoutConstraint priority to a float or TXLayoutPriority
 */
- (TXConstraint * (^)(TXLayoutPriority priority))priority;

/**
 *	Sets the NSLayoutConstraint priority to TXLayoutPriorityLow
 */
- (TXConstraint * (^)(void))priorityLow;

/**
 *	Sets the NSLayoutConstraint priority to TXLayoutPriorityMedium
 */
- (TXConstraint * (^)(void))priorityMedium;

/**
 *	Sets the NSLayoutConstraint priority to TXLayoutPriorityHigh
 */
- (TXConstraint * (^)(void))priorityHigh;

/**
 *	Sets the constraint relation to NSLayoutRelationEqual
 *  returns a block which accepts one of the following:
 *    TXViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (TXConstraint * (^)(id attr))equalTo;

/**
 *	Sets the constraint relation to NSLayoutRelationGreaterThanOrEqual
 *  returns a block which accepts one of the following:
 *    TXViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (TXConstraint * (^)(id attr))greaterThanOrEqualTo;

/**
 *	Sets the constraint relation to NSLayoutRelationLessThanOrEqual
 *  returns a block which accepts one of the following:
 *    TXViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (TXConstraint * (^)(id attr))lessThanOrEqualTo;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (TXConstraint *)with;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (TXConstraint *)and;

/**
 *	Creates a new TXCompositeConstraint with the called attribute and reciever
 */
- (TXConstraint *)left;
- (TXConstraint *)top;
- (TXConstraint *)right;
- (TXConstraint *)bottom;
- (TXConstraint *)leading;
- (TXConstraint *)trailing;
- (TXConstraint *)width;
- (TXConstraint *)height;
- (TXConstraint *)centerX;
- (TXConstraint *)centerY;
- (TXConstraint *)baseline;

- (TXConstraint *)firstBaseline;
- (TXConstraint *)lastBaseline;

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (TXConstraint *)leftMargin;
- (TXConstraint *)rightMargin;
- (TXConstraint *)topMargin;
- (TXConstraint *)bottomMargin;
- (TXConstraint *)leadingMargin;
- (TXConstraint *)trailingMargin;
- (TXConstraint *)centerXWithinMargins;
- (TXConstraint *)centerYWithinMargins;

#endif


/**
 *	Sets the constraint debug name
 */
- (TXConstraint * (^)(id key))key;

// NSLayoutConstraint constant Setters
// for use outside of tx_updateConstraints/tx_makeConstraints blocks

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects TXConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInsets:(TXEdgeInsets)insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects TXConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInset:(CGFloat)inset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects TXConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (void)setSizeOffset:(CGSize)sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects TXConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (void)setCenterOffset:(CGPoint)centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (void)setOffset:(CGFloat)offset;


// NSLayoutConstraint Installation support

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
/**
 *  Whether or not to go through the animator proxy when modifying the constraint
 */
@property (nonatomic, copy, readonly) TXConstraint *animator;
#endif

/**
 *  Activates an NSLayoutConstraint if it's supported by an OS. 
 *  Invokes install otherwise.
 */
- (void)activate;

/**
 *  Deactivates previously installed/activated NSLayoutConstraint.
 */
- (void)deactivate;

/**
 *	Creates a NSLayoutConstraint and adds it to the appropriate view.
 */
- (void)install;

/**
 *	Removes previously installed NSLayoutConstraint
 */
- (void)uninstall;

@end


/**
 *  Convenience auto-boxing macros for TXConstraint methods.
 *
 *  Defining TX_SHORTHAND_GLOBALS will turn on auto-boxing for default syntax.
 *  A potential drawback of this is that the unprefixed macros will appear in global scope.
 */
#define tx_equalTo(...)                 equalTo(TXBoxValue((__VA_ARGS__)))
#define tx_greaterThanOrEqualTo(...)    greaterThanOrEqualTo(TXBoxValue((__VA_ARGS__)))
#define tx_lessThanOrEqualTo(...)       lessThanOrEqualTo(TXBoxValue((__VA_ARGS__)))

#define tx_offset(...)                  valueOffset(TXBoxValue((__VA_ARGS__)))


#ifdef TX_SHORTHAND_GLOBALS

#define equalTo(...)                     tx_equalTo(__VA_ARGS__)
#define greaterThanOrEqualTo(...)        tx_greaterThanOrEqualTo(__VA_ARGS__)
#define lessThanOrEqualTo(...)           tx_lessThanOrEqualTo(__VA_ARGS__)

#define offset(...)                      tx_offset(__VA_ARGS__)

#endif


@interface TXConstraint (AutoboxingSupport)

/**
 *  Aliases to corresponding relation methods (for shorthand macros)
 *  Also needed to aid autocompletion
 */
- (TXConstraint * (^)(id attr))tx_equalTo;
- (TXConstraint * (^)(id attr))tx_greaterThanOrEqualTo;
- (TXConstraint * (^)(id attr))tx_lessThanOrEqualTo;

/**
 *  A dummy method to aid autocompletion
 */
- (TXConstraint * (^)(id offset))tx_offset;

@end
