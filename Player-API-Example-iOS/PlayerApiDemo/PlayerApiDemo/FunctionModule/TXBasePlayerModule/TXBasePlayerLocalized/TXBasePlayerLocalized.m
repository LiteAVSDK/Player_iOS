//
//  TXBasePlayerLocalized.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXBasePlayerLocalized.h"

NSString *TXBasePlayerLocalizeFromTable(NSString *key, NSString *table) {
    return [NSBundle.mainBundle localizedStringForKey:key value:@"" table:table];
}

NSString *const BasePlayer_Localize_TableName = @"TXBasePlayerLocalize";
NSString *TXBasePlayerLocalize(NSString *key) {
    return TXBasePlayerLocalizeFromTable(key, BasePlayer_Localize_TableName);
}
