//
//  TXHomeTableViewCell.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TXHomeCellModel;

static NSString *TXHomeTableViewCellReuseIdentify = @"TXHomeTableViewCell";

@interface TXHomeTableViewCell : UITableViewCell

- (void)setHomeModel:(TXHomeCellModel *)model;

@end

NS_ASSUME_NONNULL_END
