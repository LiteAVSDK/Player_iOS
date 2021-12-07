//
//  TXConfigManager.h
//  TXLiteAVDemo
//
//  Created by origin 李 on 2021/9/6.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTableViewCell.h"
#import "TXAppInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXConfigManager : NSObject
+ (instancetype)shareInstance;
//加载配置文件
- (void)loadConfig;
//licence
- (void)setLicence;
//配置日志
- (void)setLogConfig;
//配置bugly
- (void)setupBugly;
//初始化debug模式
- (void)initDebug;
//是否发布包会根据流水线参数：APP_MODE来设置：RELEASE 为Yes
- (BOOL)isRelease;
//是否需要检测蓝盾更新
- (BOOL)needCheckDevOpsVersion;
//获取蓝盾构建版本检测appName
- (NSString *)devOpsAppName;
//获取蓝盾构建版本下载地址
- (NSString *)devOpsDownloadURL;
//获取菜单配置
- (NSMutableArray<CellInfo *> *)getMenuConfig;
//设置事件响应对象
- (void)setMenuActionTarget:(id)object;

@end

NS_ASSUME_NONNULL_END

