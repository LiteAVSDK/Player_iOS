//
//  TXApiConfigManager.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXApiConfigManager.h"
#import "TXHomeCellModel.h"

static TXApiConfigManager *_shareInstance = nil;

@interface TXApiConfigManager()

@property (nonatomic, strong) NSDictionary *configDic;
@property(nonatomic, weak) id actionTarget;

@end

@implementation TXApiConfigManager

+ (instancetype)shareInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _shareInstance = [[TXApiConfigManager alloc] init];
    });
    return _shareInstance;
}

- (void)loadConfig {
    NSString *plistName = @"Player";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    _configDic = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
}

- (NSMutableArray<TXAppHomeModel *> *)getMenuConfig {
    NSMutableArray<TXAppHomeModel *> *cellInfos = [NSMutableArray array];
    NSArray *menusConfig = [self menusConfig];
    for (NSDictionary *menu in menusConfig) {
        
        TXAppHomeModel *homeModel = [[TXAppHomeModel alloc] init];
        homeModel.type = [menu objectForKey:@"type"];

        NSArray *subMenus = [menu objectForKey:@"module"];
        NSMutableArray *subCells = [NSMutableArray array];
        for (NSDictionary *subMenu in subMenus) {
            TXHomeCellModel *cellModel = [[TXHomeCellModel alloc] init];
            cellModel.title     = [subMenu objectForKey:@"title"];
            cellModel.desc      = [subMenu objectForKey:@"desc"];
            cellModel.classStr  = [subMenu objectForKey:@"class"];
            
            [subCells addObject:cellModel];
        }
        
        homeModel.homeModels = subCells;
        [cellInfos addObject:homeModel];
    }
    
    return cellInfos;
}

- (NSArray *)menusConfig {
    return [_configDic objectForKey:@"menuConfig"];
}

@end
