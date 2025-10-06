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

/// display view
/// 显示view
- (void)showDynamicWateView;

/// Hide view
/// 隐藏view
- (void)hideDynamicWateView;

/// release resources
/// 释放资源
- (void)releaseDynamicWater;


@end

NS_ASSUME_NONNULL_END
