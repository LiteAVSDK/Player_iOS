//
//  TCLog.h
//  TCLVBIMDemo
//
//  Created by kuenzhang on 16/9/5.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef ENABLE_TRTC
#import "TRTCCloud.h"
#define DelegateProtocol TRTCLogDelegate
#else
#ifdef LIVE
#import "V2TXLivePremier.h"
#define DelegateProtocol V2TXLivePremierObserver
#else
#import "TXLiveBase.h"
#define DelegateProtocol TXLiveBaseDelegate
#endif
#endif
/**
 * APPlog保存到沙箱路径：Library/Caches/rtmpsdk_日期.log
 *   其中日期以天为单位，每天保存一个文件，如rtmpsdk_20160901.log
 */
@interface AppLogMgr : NSObject <DelegateProtocol>

+ (instancetype)shareInstance;

- (void)log:(Boolean)bOnlyFile format:(NSString *)formatStr, ...;

#ifdef LIVE
- (void)onLog:(V2TXLiveLogLevel)level log:(NSString *)log;
#else
- (void)onLog:(NSString *)log LogLevel:(int)level WhichModule:(NSString *)module;
#endif

@end

#define AppDemoLog(fmt, ...)         [[AppLogMgr shareInstance] log:NO format:fmt, ##__VA_ARGS__]
#define AppDemoLogOnlyFile(fmt, ...) [[AppLogMgr shareInstance] log:YES format:fmt, ##__VA_ARGS__]
