//
//  TXConfigCheckBox.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXConfigCheckBox : UIControl

typedef void(^VoidBlockTPCheck)(void);

//点击事件回调
- (void)clickButtonWithResultBlock:(VoidBlockTPCheck)block;

+ (instancetype)boxWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
