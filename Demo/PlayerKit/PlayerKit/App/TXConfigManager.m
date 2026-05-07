//
//  TXConfigManager.m
//  TXLiteAVDemo
//
//  Created by origin 李 on 2021/9/6.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXLiveBase.h"
#import "AppLocalized.h"
#import "AppLogMgr.h"
#import "TCUtil.h"
#import "TXConfigManager.h"

static TXConfigManager *_shareInstance = nil;

@interface TXConfigManager ()

@property(nonatomic, strong) NSDictionary *config;
@property(nonatomic, weak) id actionTarget;
@property(nonatomic, strong) NSMutableArray *routeArray;

@end

@implementation TXConfigManager

+ (instancetype)shareInstance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _shareInstance = [[TXConfigManager alloc] init];
        _shareInstance.routeArray = [NSMutableArray arrayWithCapacity:2];
        [_shareInstance loadConfig];
    });
    return _shareInstance;
}

- (void)setMenuActionTarget:(id)object {
    self.actionTarget = object;
}

- (void)loadConfig {
    NSString *plistName = @"Player";
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"];
    NSBundle *playerKitBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *filePath = [playerKitBundle pathForResource:plistName ofType:@"plist"];
    _config = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
}

- (NSDictionary *)licenceConfig {
    return [_config objectForKey:@"licenceConfig"];
}

- (NSArray *)menusConfig {
    return [_config objectForKey:@"menuConfig"];
}

- (BOOL)isRelease {
    return [[_config objectForKey:@"isRelease"] boolValue];
}

- (BOOL)needCheckDevOpsVersion {
    if (_config[@"needCheckDevOpsVersion"]) {
        return [[_config objectForKey:@"needCheckDevOpsVersion"] boolValue];
    }
    return NO;
}

- (NSString *)devOpsAppName{
    NSDictionary *devOpsInfo = _config[@"devOpsConfig"];
    if (devOpsInfo && [devOpsInfo isKindOfClass:[NSDictionary class]]) {
        return devOpsInfo[@"appName"] ?: @"";
    }
    return @"";
}

- (NSString *)devOpsDownloadURL{
    NSDictionary *devOpsInfo = _config[@"devOpsConfig"];
    if (devOpsInfo && [devOpsInfo isKindOfClass:[NSDictionary class]]) {
        return devOpsInfo[@"downloadUrl"] ?: @"";
    }
    return @"";
}

- (void)setLicence {
    NSString *licenceUrl = [self.licenceConfig objectForKey:@"licenceUrl"];
    NSString *licenceKey = [self.licenceConfig objectForKey:@"licenceKey"];
    [TXLiveBase setLicenceURL:licenceUrl key:licenceKey];
}

- (void)setLogConfig {
    [TXLiveBase sharedInstance].delegate = [AppLogMgr shareInstance];
    [TXLiveBase setConsoleEnabled:NO];
    [TXLiveBase setAppID:@"1252463788"];
}


- (void)initDebug {
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:kIsFirstStart];
    if (isFirstStart) {
        //只设置一次
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsFirstStart];
    if ([self isRelease]) {
        //发布包默认关闭debug
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kMainMenuDEBUGSwitch];
    } else {
        //非发布包默认打开debug
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMainMenuDEBUGSwitch];
    }
}
- (void)setupBugly {
}

- (NSMutableArray<CellInfo *> *)getMenuConfig {
    NSMutableArray<CellInfo *> *cellInfos = [[NSMutableArray alloc] initWithCapacity:2];
    NSArray *menusConfig = [self menusConfig];
    for (NSDictionary *menu in menusConfig) {
        bool debug = [menu objectForKey:@"debug"];
        if (debug && ![TCUtil getDEBUGSwitch]) {
            continue;
        }
        NSString *title = [menu objectForKey:@"title"];
        CellInfo *cellInfo = [[CellInfo alloc] init];
        bool isTrtc = [menu objectForKey:@"TRTC"];
        cellInfo.title = V2Localize(title);
        NSArray *subMenus = [menu objectForKey:@"subMenus"];
        NSMutableArray *subCells = [NSMutableArray array];
        for (NSDictionary *subMenu in subMenus) {
            NSString *subTitle = [subMenu objectForKey:@"title"];
            NSString *classStr = [subMenu objectForKey:@"class"];
            NSString *routeName = [subMenu objectForKey:@"route"];
            bool debug = [subMenu objectForKey:@"debug"];
            if (debug && ![TCUtil getDEBUGSwitch]) {
                continue;
            }
            if (isTrtc) {
                subTitle = TRTCLocalize(subTitle);
            } else {
                subTitle = V2Localize(subTitle);
            }
            if (classStr.length > 0) {
                CellInfo *subCellInfo = [CellInfo cellInfoWithTitle:subTitle
                                                controllerClassName:classStr];
                [subCells addObject:subCellInfo];
            } else {
                __weak __typeof(self) weakSelf = self;
                CellInfo *subCellInfo =
                [CellInfo cellInfoWithTitle:subTitle
                                actionBlock:^{
                    NSString *method = [subMenu objectForKey:@"method"];
                    SEL sel = NSSelectorFromString(method);
                    if ([weakSelf.actionTarget respondsToSelector:sel]) {
                        IMP imp = [weakSelf.actionTarget methodForSelector:sel];
                        void (*func)(id, SEL) = (void *)imp;
                        func(weakSelf.actionTarget, sel);
                    }
                }];
                [subCells addObject:subCellInfo];
            }
        }
        cellInfo.subCells = subCells;
        [cellInfos addObject:cellInfo];
    }
    return cellInfos;
}

@end

