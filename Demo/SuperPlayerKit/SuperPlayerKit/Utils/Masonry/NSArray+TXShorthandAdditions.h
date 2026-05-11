//
//  NSArray+TXShorthandAdditions.h
//  Masonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "NSArray+TXAdditions.h"

#ifdef TX_SHORTHAND

/**
 *	Shorthand array additions without the 'tx_' prefixes,
 *  only enabled if TX_SHORTHAND is defined
 */
@interface NSArray (TXShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(TXConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(TXConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(TXConstraintMaker *make))block;

@end

@implementation NSArray (TXShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(TXConstraintMaker *))block {
    return [self tx_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(^)(TXConstraintMaker *))block {
    return [self tx_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(^)(TXConstraintMaker *))block {
    return [self tx_remakeConstraints:block];
}

@end

#endif
