//
//  TXSetStartTimeLocalized.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXSetStartTimeLocalized.h"

NSString *SetStartTimeLocalizeFromTable(NSString *key, NSString *table) {
    return [NSBundle.mainBundle localizedStringForKey:key value:@"" table:table];
}

NSString *const SetStartTimeLocalize_TableName = @"TXSetStartTimeLocalize";
NSString *SetStartTimeLocalize(NSString *key) {
    return SetStartTimeLocalizeFromTable(key, SetStartTimeLocalize_TableName);
}
