//
//  TXViewConstraint.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "TXViewAttribute.h"
#import "TXConstraint.h"
#import "TXLayoutConstraint.h"
#import "TXUtilities.h"

/**
 *  A single constraint.
 *  Contains the attributes neccessary for creating a NSLayoutConstraint and adding it to the appropriate view
 */
@interface TXViewConstraint : TXConstraint <NSCopying>

/**
 *	First item/view and first attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) TXViewAttribute *firstViewAttribute;

/**
 *	Second item/view and second attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) TXViewAttribute *secondViewAttribute;

/**
 *	initialises the TXViewConstraint with the first part of the equation
 *
 *	@param	firstViewAttribute	view.tx_left, view.tx_width etc.
 *
 *	@return	a new view constraint
 */
- (id)initWithFirstViewAttribute:(TXViewAttribute *)firstViewAttribute;

/**
 *  Returns all TXViewConstraints installed with this view as a first item.
 *
 *  @param  view  A view to retrieve constraints for.
 *
 *  @return An array of TXViewConstraints.
 */
+ (NSArray *)installedConstraintsForView:(TX_VIEW *)view;

@end
