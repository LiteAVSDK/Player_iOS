
//  Copyright © 2023 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
///Navbar
@interface TUIShortVideoPlayerViewNavView : UIView
///backBtnAction
@property (nonatomic, copy) void (^backBtnAction)(void);
@end

NS_ASSUME_NONNULL_END
