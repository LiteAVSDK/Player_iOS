//
//  UITableView+indexPath.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/9/11.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (indexPath)
- (NSIndexPath *)currentIndexPathForFullScreenCell;
@end

NS_ASSUME_NONNULL_END
