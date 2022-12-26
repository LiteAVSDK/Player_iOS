//
//  TXAppLocalized.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *LocalizeFromTable(NSString *key, NSString *table);
extern NSString *const Localize_TableName;
extern NSString *Localize(NSString *key);

NS_ASSUME_NONNULL_END
