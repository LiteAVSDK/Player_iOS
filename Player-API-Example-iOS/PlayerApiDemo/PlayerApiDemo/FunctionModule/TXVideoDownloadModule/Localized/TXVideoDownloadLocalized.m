//
//  TXVideoDownloadLocalized.m
//  PlayerApiDemo
//
//  Created by 路鹏 on 2022/8/2.
//

#import "TXVideoDownloadLocalized.h"

NSString *TXDownloadLocalizeFromTable(NSString *key, NSString *table) {
    return [NSBundle.mainBundle localizedStringForKey:key value:@"" table:table];
}

NSString *const Download_Localize_TableName = @"TXVideoDownloadLocalize";
NSString *TXVideoDownloadLocalize(NSString *key) {
    return TXDownloadLocalizeFromTable(key, Download_Localize_TableName);
}
