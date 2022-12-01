//
//  SuperPlayerLocalized.m
//  Pods
//
//  Copyright © 2022年 Tencent. All rights reserved.
//

#import "SuperPlayerLocalized.h"

NSString *superPlayerLocalizeFromTable(NSString *key, NSString *table) {
    NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    if ([languages count] <= 0) {  // 语言包判断
        return key;
    }
    
    NSString *preferredLang = [languages objectAtIndex:0]; // zh-Hant-GB
    NSString *languageProj = [preferredLang stringByReplacingOccurrencesOfString:@"-GB" withString:@""];
    NSString *resourceDict = [[NSBundle mainBundle] pathForResource:@"SuperPlayerKitBundle" ofType:@"bundle"];
    if (resourceDict.length == 0) { // 资源Bundle文件目录
        return key;
    }
    
    NSString *bundleOfPath = [NSBundle pathForResource:languageProj ofType:@"lproj" inDirectory:resourceDict];
    NSBundle *bundle = [NSBundle bundleWithPath:bundleOfPath];
    if (!bundle) { // 语言lproj的判断
        return key;
    }
    
    return [bundle localizedStringForKey:key value:@"" table:table];
}

NSString *const SuperPlayer_Localize_TableName = @"SuperPlayerLocalized";
NSString *      superPlayerLocalized(NSString *key) {
    return superPlayerLocalizeFromTable(key, SuperPlayer_Localize_TableName);
}
