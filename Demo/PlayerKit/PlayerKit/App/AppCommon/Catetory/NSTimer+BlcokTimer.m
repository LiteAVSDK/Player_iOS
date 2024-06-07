//
//  NSTimer+BlcokTimer.m
//  TXLiteAVDemo
//
//  Created by origin 李 on 2021/12/24.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "NSTimer+BlcokTimer.h"

@implementation NSTimer (BlcokTimer)
+ (NSTimer *)tx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(tx_blockSelector:) userInfo:[block copy] repeats:repeats];
}

+ (void)tx_blockSelector:(NSTimer *)timer {
    void(^block)(void) = timer.userInfo;
    if (block) {
        block();
    }
}
@end
