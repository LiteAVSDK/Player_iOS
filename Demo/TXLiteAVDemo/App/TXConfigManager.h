//
//  TXConfigManager.h
//  TXLiteAVDemo
//
//  Created by origin 李 on 2021/9/6.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXConfigManager : NSObject
+ (instancetype)shareInstance;
- (void)loadConfig;
- (void)setLicence;
- (void)setLogConfig;
- (void)setupBugly;
- (NSMutableArray<CellInfo *> *)getMenuConfig;
- (void)setMenuActionTarget:(id)object;

@end

NS_ASSUME_NONNULL_END

