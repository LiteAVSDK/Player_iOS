//
//  TXCompositeConstraint.h
//  Masonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "TXConstraint.h"
#import "TXUtilities.h"

/**
 *	A group of TXConstraint objects
 */
@interface TXCompositeConstraint : TXConstraint

/**
 *	Creates a composite with a predefined array of children
 *
 *	@param	children	child TXConstraints
 *
 *	@return	a composite constraint
 */
- (id)initWithChildren:(NSArray *)children;

@end
