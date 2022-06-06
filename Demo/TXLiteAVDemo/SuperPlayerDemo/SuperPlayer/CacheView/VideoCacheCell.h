//
//  VideoCacheCell.h
//  Pods
//
//  Created by 路鹏 on 2022/2/17.
//  Copyright © 2022年 Tencent. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoCacheModel;

@interface VideoCacheCell : UITableViewCell

@property (nonatomic, strong) VideoCacheModel *cacheModel;

@end

NS_ASSUME_NONNULL_END
