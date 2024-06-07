//
//  TXLeftSlideGuideView.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/30.
//  Copyright © 2021 Tencent. All rights reserved.
//  遮罩View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LeftSlideGuideViewShowBlock)(BOOL isHidden);

@interface TXLeftSlideGuideView : UIView

@property (nonatomic, copy) LeftSlideGuideViewShowBlock leftSlideViewHidden;

@end

NS_ASSUME_NONNULL_END
