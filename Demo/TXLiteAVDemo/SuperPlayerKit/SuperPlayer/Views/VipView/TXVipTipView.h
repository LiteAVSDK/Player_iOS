//
//  TXVipTipView.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/8.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXVipWatchModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TXVipTipViewDelegate <NSObject>

/**
 * 调用关闭按钮，关闭tipView
*/
- (void)onCloseClick;

@end

@interface TXVipTipView : UIView

@property (nonatomic, weak) id<TXVipTipViewDelegate> delegate;

@property (nonatomic, assign) CGFloat textFontSize;

/**
 * 试看提示View
 * @param vipWatchModel  试看模型
*/
- (void)setVipWatchModel:(TXVipWatchModel *)vipWatchModel;

@end

NS_ASSUME_NONNULL_END
