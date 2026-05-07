//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUIPSupRefreshView : UIView

- (void)scrollViewDidScrollContentOffsetY:(CGFloat)y;
- (void)beginRefreshing;
- (void)endRefreshing;
@end

NS_ASSUME_NONNULL_END
