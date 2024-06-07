//
//  TXVideoCell.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/29.
//  Copyright © 2021 Tencent. All rights reserved.
//  视频列表的cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TXVideoModel;

@interface TXVideoCell : UICollectionViewCell

@property (nonatomic, strong) TXVideoModel *videoModel;

@end

NS_ASSUME_NONNULL_END
