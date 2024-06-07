//
//  TXUpSlideGuideView.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/30.
//  Copyright © 2021 Tencent. All rights reserved.
//  遮罩View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^UpSlideGuideViewShowBlock)(BOOL isHidden);

@interface TXUpSlideGuideView : UIView

@property (nonatomic, copy) UpSlideGuideViewShowBlock upSlideViewHidden;

@end

NS_ASSUME_NONNULL_END
