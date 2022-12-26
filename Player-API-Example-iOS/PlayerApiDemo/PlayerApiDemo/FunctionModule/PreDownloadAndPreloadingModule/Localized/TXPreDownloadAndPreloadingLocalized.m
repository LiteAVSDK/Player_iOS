//
//  TXPreDownloadAndPreloadingLocalized.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXPreDownloadAndPreloadingLocalized.h"

NSString *PreDownloadAndPreloadingLocalizeFromTable(NSString *key, NSString *table) {
    return [NSBundle.mainBundle localizedStringForKey:key value:@"" table:table];
}

NSString *const PreDownloadAndPreloadingLocalize_TableName = @"TXPreDownloadAndPreloadingLocalize";
NSString *PreDownloadAndPreloadingLocalize(NSString *key) {
    return PreDownloadAndPreloadingLocalizeFromTable(key, PreDownloadAndPreloadingLocalize_TableName);
}
