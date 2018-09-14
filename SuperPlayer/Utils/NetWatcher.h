//
//  NetWatcher.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/7/31.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWatcher : NSObject

@property (copy) void (^notifyBlock)(NSString *);

- (void)startWatch;
- (void)stopWatch;

- (void)loadingEvent;
- (void)loadingEndEvent;

@end
