//
//  TXControlPanelLocalized.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXControlPanelLocalized.h"

NSString *TXControlPanelLocalizeFromTable(NSString *key, NSString *table) {
    return [NSBundle.mainBundle localizedStringForKey:key value:@"" table:table];
}

NSString *const ControlPanel_Localize_TableName = @"TXControlPanelLocalize";
NSString *TXControlPanelLocalize(NSString *key) {
    return TXControlPanelLocalizeFromTable(key, ControlPanel_Localize_TableName);
}
