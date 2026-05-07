// Copyright (c) 2025 Tencent. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUITableView : UITableView

- (void)reloadDataWithCompleteBlock:(void(^)(void))completeBlock;

@end

NS_ASSUME_NONNULL_END
