//
//  TXConfigBlockButton.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXConfigBlockButton : UIButton

typedef void(^VoidBlock)(void);

//点击事件回调
- (void)clickButtonWithResultBlock:(VoidBlock)block;

//返回一个带标题的按钮
+ (instancetype)btnWithTitle:(NSString*)title;

//返回一个带标签的按钮 样式又点区别
+ (instancetype)tagWithTitle:(NSString*)title;

@end

NS_ASSUME_NONNULL_END
