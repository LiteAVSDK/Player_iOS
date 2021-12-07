//
//  FeedDetailViewController.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/11/4.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedHeadModel.h"
#import "FeedVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedDetailViewController : UIViewController

@property (nonatomic, strong) FeedHeadModel  *headModel;

@property (nonatomic, strong) FeedVideoModel *videoModel;

@property (nonatomic, strong) UIView         *superPlayView;

@property (nonatomic, strong) NSMutableArray *detailListData;

@end

NS_ASSUME_NONNULL_END
