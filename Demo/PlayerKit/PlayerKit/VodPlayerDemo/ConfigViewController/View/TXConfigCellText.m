//
//  TXConfigCellText.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXConfigCellText.h"
#import "PlayerKitCommonHeaders.h"

@implementation TXConfigCellText

+ (TXConfigCellText *)cellWithTitle:(NSString *)title placeholder:(NSString *)holder isNumber:(BOOL)isNumber {
    TXConfigCellText *cell = [[TXConfigCellText alloc] init];
    
    cell.lab = [[UILabel alloc] init];
    cell.lab.text = title;
    cell.lab.font = [UIFont systemFontOfSize:14];
    [cell addSubview:cell.lab];
    [cell.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(30);
    }];
    
    cell.textField = [[TXConfigText alloc] init];
    cell.textField.placeholder = holder;
    cell.textField.font = [UIFont systemFontOfSize:14];
    if (isNumber) {
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
    } else {
        cell.textField.keyboardType = UIKeyboardTypeDefault;
    }
    [cell addSubview:cell.textField];
    [cell.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(cell.lab.mas_right);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(30);
    }];
    return cell;
}

@end
