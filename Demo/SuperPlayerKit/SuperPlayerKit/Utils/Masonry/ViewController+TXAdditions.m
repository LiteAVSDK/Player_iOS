//
//  UIViewController+TXAdditions.m
//  Masonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "ViewController+TXAdditions.h"

#ifdef TX_VIEW_CONTROLLER

@implementation TX_VIEW_CONTROLLER (TXAdditions)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (TXViewAttribute *)tx_topLayoutGuide {
    return [[TXViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (TXViewAttribute *)tx_topLayoutGuideTop {
    return [[TXViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (TXViewAttribute *)tx_topLayoutGuideBottom {
    return [[TXViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (TXViewAttribute *)tx_bottomLayoutGuide {
    return [[TXViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (TXViewAttribute *)tx_bottomLayoutGuideTop {
    return [[TXViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (TXViewAttribute *)tx_bottomLayoutGuideBottom {
    return [[TXViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

#pragma clang diagnostic pop

@end

#endif
