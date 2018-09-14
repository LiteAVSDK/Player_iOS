//
//  NetWatcher.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/7/31.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "NetWatcher.h"

@implementation NetWatcher {
    NSDate  *_startTime;
    int     _loadingCount;
    dispatch_source_t _timer1;
    BOOL    _onFire;
}

- (void)dealloc
{
    
}

- (void)startWatch
{
    [self stopWatch];
    
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
        if (self.notifyBlock) {
            self.notifyBlock(@"检测到你的网络较差，建议切换清晰度");
        }
        _loadingCount = 0;
        [self stopWatch];
        return YES;
    }
    
    return NO;
}

@end
