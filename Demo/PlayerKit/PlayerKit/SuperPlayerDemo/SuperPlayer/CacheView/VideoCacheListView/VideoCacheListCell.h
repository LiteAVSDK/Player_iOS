//
//  VideoCacheListCell.h
//  Pods
//
//  Created by 路鹏 on 2022/3/7.
//  Copyright © 2022年 Tencent. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VideoCacheListModel;
@class SuperPlayerModel;

@interface VideoCacheListCell : UITableViewCell

@property (nonatomic, strong) VideoCacheListModel *model;

- (void)startDownload;

- (void)stopDownload;

- (SuperPlayerModel *)getSuperPlayModel;

@end

NS_ASSUME_NONNULL_END
