//
//  TXApiConfigManager.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXAppHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXApiConfigManager : NSObject

+ (instancetype)shareInstance;

// 加载配置文件
- (void)loadConfig;

//获取菜单配置
- (NSMutableArray<TXAppHomeModel *> *)getMenuConfig;

@end

NS_ASSUME_NONNULL_END
