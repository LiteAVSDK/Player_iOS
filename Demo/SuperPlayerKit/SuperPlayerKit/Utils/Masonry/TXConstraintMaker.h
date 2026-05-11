//
//  TXConstraintMaker.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "TXConstraint.h"
#import "TXUtilities.h"

typedef NS_OPTIONS(NSInteger, TXAttribute) {
    TXAttributeLeft = 1 << NSLayoutAttributeLeft,
    TXAttributeRight = 1 << NSLayoutAttributeRight,
    TXAttributeTop = 1 << NSLayoutAttributeTop,
    TXAttributeBottom = 1 << NSLayoutAttributeBottom,
    TXAttributeLeading = 1 << NSLayoutAttributeLeading,
    TXAttributeTrailing = 1 << NSLayoutAttributeTrailing,
    TXAttributeWidth = 1 << NSLayoutAttributeWidth,
    TXAttributeHeight = 1 << NSLayoutAttributeHeight,
    TXAttributeCenterX = 1 << NSLayoutAttributeCenterX,
    TXAttributeCenterY = 1 << NSLayoutAttributeCenterY,
    TXAttributeBaseline = 1 << NSLayoutAttributeBaseline,

    TXAttributeFirstBaseline = 1 << NSLayoutAttributeFirstBaseline,
    TXAttributeLastBaseline = 1 << NSLayoutAttributeLastBaseline,
    
#if TARGET_OS_IPHONE || TARGET_OS_TV
    
    TXAttributeLeftMargin = 1 << NSLayoutAttributeLeftMargin,
    TXAttributeRightMargin = 1 << NSLayoutAttributeRightMargin,
    TXAttributeTopMargin = 1 << NSLayoutAttributeTopMargin,
    TXAttributeBottomMargin = 1 << NSLayoutAttributeBottomMargin,
    TXAttributeLeadingMargin = 1 << NSLayoutAttributeLeadingMargin,
    TXAttributeTrailingMargin = 1 << NSLayoutAttributeTrailingMargin,
    TXAttributeCenterXWithinMargins = 1 << NSLayoutAttributeCenterXWithinMargins,
    TXAttributeCenterYWithinMargins = 1 << NSLayoutAttributeCenterYWithinMargins,

#endif
    
};

/**
 *  Provides factory methods for creating TXConstraints.
 *  Constraints are collected until they are ready to be installed
 *
 */
@interface TXConstraintMaker : NSObject

/**
 *	The following properties return a new TXViewConstraint
 *  with the first item set to the makers associated view and the appropriate TXViewAttribute
 */
@property (nonatomic, strong, readonly) TXConstraint *left;
@property (nonatomic, strong, readonly) TXConstraint *top;
@property (nonatomic, strong, readonly) TXConstraint *right;
@property (nonatomic, strong, readonly) TXConstraint *bottom;
@property (nonatomic, strong, readonly) TXConstraint *leading;
@property (nonatomic, strong, readonly) TXConstraint *trailing;
@property (nonatomic, strong, readonly) TXConstraint *width;
@property (nonatomic, strong, readonly) TXConstraint *height;
@property (nonatomic, strong, readonly) TXConstraint *centerX;
@property (nonatomic, strong, readonly) TXConstraint *centerY;
@property (nonatomic, strong, readonly) TXConstraint *baseline;

@property (nonatomic, strong, readonly) TXConstraint *firstBaseline;
@property (nonatomic, strong, readonly) TXConstraint *lastBaseline;

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) TXConstraint *leftMargin;
@property (nonatomic, strong, readonly) TXConstraint *rightMargin;
@property (nonatomic, strong, readonly) TXConstraint *topMargin;
@property (nonatomic, strong, readonly) TXConstraint *bottomMargin;
@property (nonatomic, strong, readonly) TXConstraint *leadingMargin;
@property (nonatomic, strong, readonly) TXConstraint *trailingMargin;
@property (nonatomic, strong, readonly) TXConstraint *centerXWithinMargins;
@property (nonatomic, strong, readonly) TXConstraint *centerYWithinMargins;

#endif

/**
 *  Returns a block which creates a new TXCompositeConstraint with the first item set
 *  to the makers associated view and children corresponding to the set bits in the
 *  TXAttribute parameter. Combine multiple attributes via binary-or.
 */
@property (nonatomic, strong, readonly) TXConstraint *(^attributes)(TXAttribute attrs);

/**
 *	Creates a TXCompositeConstraint with type TXCompositeConstraintTypeEdges
 *  which generates the appropriate TXViewConstraint children (top, left, bottom, right)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) TXConstraint *edges;

/**
 *	Creates a TXCompositeConstraint with type TXCompositeConstraintTypeSize
 *  which generates the appropriate TXViewConstraint children (width, height)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) TXConstraint *size;

/**
 *	Creates a TXCompositeConstraint with type TXCompositeConstraintTypeCenter
 *  which generates the appropriate TXViewConstraint children (centerX, centerY)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) TXConstraint *center;

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *  Whether or not to remove existing constraints prior to installing
 */
@property (nonatomic, assign) BOOL removeExisting;

/**
 *	initialises the maker with a default view
 *
 *	@param	view	any TXConstraint are created with this view as the first item
 *
 *	@return	a new TXConstraintMaker
 */
- (id)initWithView:(TX_VIEW *)view;

/**
 *	Calls install method on any TXConstraints which have been created by this maker
 *
 *	@return	an array of all the installed TXConstraints
 */
- (NSArray *)install;

- (TXConstraint * (^)(dispatch_block_t))group;

@end
