//
//  UITableView+indexPath.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/9/11.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "UITableView+indexPath.h"

@implementation UITableView (indexPath)

- (NSIndexPath *)currentIndexPathForFullScreenCell {
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = self.contentOffset;
    visibleRect.size = self.frame.size;

    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect),
                                       CGRectGetMidY(visibleRect));

    return [self indexPathForRowAtPoint:visiblePoint];
}

@end
