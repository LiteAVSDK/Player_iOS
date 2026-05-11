//
//  UIView+TXAdditions.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "TXUtilities.h"
#import "TXConstraintMaker.h"
#import "TXViewAttribute.h"

/**
 *	Provides constraint maker block
 *  and convience methods for creating TXViewAttribute which are view + NSLayoutAttribute pairs
 */
@interface TX_VIEW (TXAdditions)

/**
 *	following properties return a new TXViewAttribute with current view and appropriate NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) TXViewAttribute *tx_left;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_top;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_right;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_bottom;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_leading;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_trailing;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_width;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_height;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_centerX;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_centerY;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_baseline;
@property (nonatomic, strong, readonly) TXViewAttribute *(^tx_attribute)(NSLayoutAttribute attr);

@property (nonatomic, strong, readonly) TXViewAttribute *tx_firstBaseline;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_lastBaseline;

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) TXViewAttribute *tx_leftMargin;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_rightMargin;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_topMargin;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_bottomMargin;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_leadingMargin;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_trailingMargin;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_centerXWithinMargins;
@property (nonatomic, strong, readonly) TXViewAttribute *tx_centerYWithinMargins;

@property (nonatomic, strong, readonly) TXViewAttribute *tx_safeAreaLayoutGuide NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_safeAreaLayoutGuideLeading NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_safeAreaLayoutGuideTrailing NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_safeAreaLayoutGuideLeft NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_safeAreaLayoutGuideRight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_safeAreaLayoutGuideTop NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_safeAreaLayoutGuideBottom NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_safeAreaLayoutGuideWidth NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_safeAreaLayoutGuideHeight NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_safeAreaLayoutGuideCenterX NS_AVAILABLE_IOS(11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_safeAreaLayoutGuideCenterY NS_AVAILABLE_IOS(11.0);

#endif

/**
 *	a key to associate with this view
 */
@property (nonatomic, strong) id tx_key;

/**
 *	Finds the closest common superview between this view and another view
 *
 *	@param	view	other view
 *
 *	@return	returns nil if common superview could not be found
 */
- (instancetype)tx_closestCommonSuperview:(TX_VIEW *)view;

/**
 *  Creates a TXConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created TXConstraints
 */
- (NSArray *)tx_makeConstraints:(void(NS_NOESCAPE ^)(TXConstraintMaker *make))block;

/**
 *  Creates a TXConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated TXConstraints
 */
- (NSArray *)tx_updateConstraints:(void(NS_NOESCAPE ^)(TXConstraintMaker *make))block;

/**
 *  Creates a TXConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated TXConstraints
 */
- (NSArray *)tx_remakeConstraints:(void(NS_NOESCAPE ^)(TXConstraintMaker *make))block;

@end
