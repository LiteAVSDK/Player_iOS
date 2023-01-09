//
//  SuperPlayerSubParamView.h
//  Pods
//
//  Created by 路鹏 on 2022/10/14.
//  Copyright © 2022 Tencent. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuperPlayerVoidBlock)(void);

@interface SuperPlayerSubParamView : UIView

//点击事件回调
- (void)clickButtonWithResultBlock:(SuperPlayerVoidBlock)block;

// 更改显示内容
- (void)setChooseTitle:(NSString *)title name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
