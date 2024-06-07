//
//  TXConfigCellText.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXConfigText.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXConfigCellText : UIView

// 输入框
@property (nonatomic, strong) TXConfigText *textField;

// 文案
@property (nonatomic, strong) UILabel  *lab;

+ (TXConfigCellText *)cellWithTitle:(NSString *)title placeholder:(NSString *)holder isNumber:(BOOL)isNumber;

@end

NS_ASSUME_NONNULL_END
