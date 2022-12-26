//
//  TXConfigCellText.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXConfigCellText.h"
#import <Masonry/Masonry.h>

@implementation TXConfigCellText

+ (TXConfigCellText *)cellWithTitle:(NSString *)title placeholder:(NSString *)holder{
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
    if ([holder isEqualToString:@"请输入cache目录"]) {
        cell.textField.keyboardType = UIKeyboardTypeDefault;
    } else {
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
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
