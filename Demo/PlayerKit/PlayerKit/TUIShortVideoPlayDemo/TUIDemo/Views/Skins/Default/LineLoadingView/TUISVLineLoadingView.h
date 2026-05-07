// Copyright (c) 2023 Tencent. All rights reserved.
//  视频加载的控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUISVLineLoadingView : UIView

/**
 *  显示线性loadingView
 *
 *  @param view                   需要加载的父view
 *  @param lineHeight      loadView的高度
 */
+ (void)showLoadingInView:(UIView *)view withLineHeight:(CGFloat)lineHeight;

/**
 *  隐藏线性loadingView
 *
 *  @param view                   需要隐藏的父view
 */
+ (void)hideLoadingInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
