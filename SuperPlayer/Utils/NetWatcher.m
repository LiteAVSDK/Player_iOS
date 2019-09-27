//
//  NetWatcher.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/7/31.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "NetWatcher.h"
#import "AFNetworking/AFNetworking.h"

@interface NetWatcher()
@property NSArray *definitions;
@end

@implementation NetWatcher {
    NSDate  *_startTime;
    int     _loadingCount;
    dispatch_source_t _timer1;
    BOOL    _onFire;
}

- (void)setPlayerModel:(SuperPlayerModel *)playerModel
{
    _playerModel = playerModel;
    
    self.definitions = [self.playerModel.playDefinitions sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [NetWatcher weightOfDefinition:obj1] < [NetWatcher weightOfDefinition:obj2];
    }];
    
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        self.adviseDefinition = self.definitions.lastObject;
    } else {
        self.adviseDefinition = self.definitions.firstObject;
    }
}

- (void)startWatch
{
    [self stopWatch];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];

    if (self.definitions.count <= 1) {
        return;
    }
    
    _startTime = [NSDate date];
    _loadingCount = 0;

    NSLog(@"NetWatcher: startWatch");
}

- (void)stopWatch
{
    _startTime = nil;
    if (_timer1) {
        if (!_onFire) {
            dispatch_resume(_timer1);
        }
        dispatch_source_cancel(_timer1);
        _timer1 = nil;
    }
    _onFire = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadingEvent
{
    if (!_startTime)
        return;
    NSLog(@"NetWatcher: loadingEvent");
    if (_timer1 == nil) {
        _timer1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_timer1, DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        __weak NetWatcher *weakSelf = self;
        dispatch_source_set_event_handler(_timer1, ^{
            NetWatcher *strongSelf = weakSelf;
            NSLog(@"NetWatcher: time out");
            if (strongSelf) {
                strongSelf->_loadingCount++;
                [strongSelf testNotify];
            }
        });
    }
    if (!_onFire) {
        dispatch_resume(_timer1);
    }
    _onFire = YES;
}

- (void)loadingEndEvent
{
    if (_onFire) {
        dispatch_suspend(_timer1);
        _onFire = NO;
        _loadingCount++;
    }
    NSLog(@"NetWatcher: loadingEndEvent");
}

- (BOOL)testNotify
{
    if (-[_startTime timeIntervalSinceNow] > 30) {
        [self stopWatch];   // 超过30秒不检测了
        return NO;
    }
    
    // 暂定30秒缓冲次数超过2次，为网络不好
    if (_loadingCount >= 2) {
        
        NSUInteger i = [self.definitions indexOfObject:self.adviseDefinition];
        if (i < self.definitions.count-1) {
            self.adviseDefinition = self.definitions[i+1];
        }
        
        if (self.notifyTipsBlock) {
            self.notifyTipsBlock(@"检测到你的网络较差，建议切换清晰度");
        }
        _loadingCount = 0;
        [self stopWatch];
        return YES;
    }
    
    return NO;
}

- (void)networkChanged:(NSNotification *)noti
{
    if (AFNetworkReachabilityManager.sharedManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        self.adviseDefinition = self.definitions.lastObject;
        if (self.adviseDefinition && ![self.playerModel.playingDefinition isEqualToString:self.adviseDefinition]) {
            self.notifyTipsBlock([@"当前网络为4G，建议切换到" stringByAppendingString:self.adviseDefinition]);
        }
    }
}

+(int)weightOfDefinition:(NSString *)def
{
    if ([def isEqualToString:@"流畅"]) {
        return 10;
    }
    if ([def isEqualToString:@"标清"]) {
        return 15;
    }
    if ([def isEqualToString:@"高清"]) {
        return 20;
    }
    if ([def isEqualToString:@"全高清"]) {
        return 40;
    }
    if ([def isEqualToString:@"超清"]) {
        return 50;
    }
    if ([def isEqualToString:@"原画"]) {
        return 60;
    }
    if ([def isEqualToString:@"2K"]) {
        return 70;
    }
    if ([def isEqualToString:@"4K"]) {
        return 80;
    }
    return 10000;
}


@end
