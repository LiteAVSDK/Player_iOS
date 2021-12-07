//
//  FeedHeadView.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/11/1.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedHeadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedHeadView : UIView

/**
 * 设置头部数据
 * @param model               头部数据模型
*/
- (void)setHeadModel:(FeedHeadModel *)model;

@end

NS_ASSUME_NONNULL_END
