//
//  DynamicWatermarkView.h
//  Pods
//
//  Created by 路鹏 on 2021/12/9.
//

#import <UIKit/UIKit.h>
#import "DynamicWaterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicWatermarkView : UIView

@property (nonatomic, strong) DynamicWaterModel *dynamicWaterModel;

/**
 * 显示view
 */
- (void)showDynamicWateView;

/**
 * 隐藏view
 */
- (void)hideDynamicWateView;

/**
 * 释放资源
 */
- (void)releaseDynamicWater;

/**
 * size改变
 *
 * @param rect 新的size
 */
- (void)onSizeChange:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
