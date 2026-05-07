// Copyright (c) 2025 Tencent. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TUIShortVideoCellLayoutDelegate <NSObject>

@optional

/**
 * @brief 获取当前cell中widget的frame
 * @param shortVideoItem cell
 * @param containerSize widget superView的size
 * @return CGRect widget的frame
 */
- (CGRect)shortVideoItem:(UITableViewCell *)shortVideoItem widgetFrameWithContainerSize:(CGSize)containerSize;

@end

NS_ASSUME_NONNULL_END
