//
//  UIViewController+TXAdditions.h
//  Masonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "TXUtilities.h"
#import "TXConstraintMaker.h"
#import "TXViewAttribute.h"

#ifdef TX_VIEW_CONTROLLER

@interface TX_VIEW_CONTROLLER (TXAdditions)

/**
 *	following properties return a new TXViewAttribute with appropriate UILayoutGuide and NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) TXViewAttribute *tx_topLayoutGuide NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_bottomLayoutGuide NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_topLayoutGuideTop NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_topLayoutGuideBottom NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_bottomLayoutGuideTop NS_DEPRECATED_IOS(8.0, 11.0);
@property (nonatomic, strong, readonly) TXViewAttribute *tx_bottomLayoutGuideBottom NS_DEPRECATED_IOS(8.0, 11.0);

@end

#endif
