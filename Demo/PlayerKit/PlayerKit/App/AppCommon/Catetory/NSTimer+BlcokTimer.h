//
//  NSTimer+BlcokTimer.h
//  TXLiteAVDemo
//
//  Created by origin 李 on 2021/12/24.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (BlcokTimer)
+ (NSTimer *)tx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(void))block repeats:(BOOL)repeats;
@end

NS_ASSUME_NONNULL_END
