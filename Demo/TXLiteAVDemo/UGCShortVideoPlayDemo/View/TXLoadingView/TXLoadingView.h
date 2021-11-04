//
//  TXLoadingView.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/9/2.
//  Copyright © 2021 Tencent. All rights reserved.
//  菊花UI

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXLoadingView : UIView

/**
 *  开始加载
 */
- (void)startLoading;

/**
 *  停止加载
 */
- (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
