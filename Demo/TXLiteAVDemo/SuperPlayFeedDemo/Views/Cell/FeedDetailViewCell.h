//
//  FeedDetailViewCell.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/11/3.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedDetailViewCell : UITableViewCell

@property (nonatomic, strong) FeedDetailModel *model;

@end

NS_ASSUME_NONNULL_END
