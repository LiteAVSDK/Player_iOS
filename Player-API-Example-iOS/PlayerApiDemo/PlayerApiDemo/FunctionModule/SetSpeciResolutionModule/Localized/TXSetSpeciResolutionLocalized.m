//
//  TXSetSpeciResolutionLocalized.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXSetSpeciResolutionLocalized.h"

NSString *SetSpeciResolutionLocalizeFromTable(NSString *key, NSString *table) {
    return [NSBundle.mainBundle localizedStringForKey:key value:@"" table:table];
}

NSString *const SetSpeciResolutionLocalize_TableName = @"TXSetSpeciResolutionLocalize";
NSString *SetSpeciResolutionLocalize(NSString *key) {
    return SetSpeciResolutionLocalizeFromTable(key, SetSpeciResolutionLocalize_TableName);
}
