//
//  TXAppLocalized.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXAppLocalized.h"

NSString *LocalizeFromTable(NSString *key, NSString *table) {
    return [NSBundle.mainBundle localizedStringForKey:key value:@"" table:table];
}

NSString *const Localize_TableName = @"TXHomeModuleLocalize";
NSString *Localize(NSString *key) {
    return LocalizeFromTable(key, Localize_TableName);
}
