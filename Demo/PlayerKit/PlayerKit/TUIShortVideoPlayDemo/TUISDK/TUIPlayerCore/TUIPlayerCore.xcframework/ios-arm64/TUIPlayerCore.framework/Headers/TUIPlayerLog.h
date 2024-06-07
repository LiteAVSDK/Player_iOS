
//  Copyright © 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///log enum
typedef enum TUIPlayerLogLevel {
    TUIPlayer_LOG_VERBOSE = 0,  //  VERBOSE
    TUIPlayer_LOG_DEBUG   = 1,  //  DEBUG
    TUIPlayer_LOG_INFO    = 2,  //  INFO
    TUIPlayer_LOG_WARNING = 3,  //  WARNING
    TUIPlayer_LOG_ERROR   = 4,  //  ERROR
    TUIPlayer_LOG_FATAL   = 5,  //  FATAL
    TUIPlayer_LOG_NONE    = 6,  //  NONE
} TUIPlayerLogLevel;

#define TUILOGV(fmt, ...) \
[TUIPlayerLog tuiLogLevel:TUIPlayer_LOG_VERBOSE \
                     file:__FILE__ \
                     line:__LINE__ \
                 function:__FUNCTION__ \
                     info:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];
#define TUILOGD(fmt, ...) \
[TUIPlayerLog tuiLogLevel:TUIPlayer_LOG_DEBUG \
                     file:__FILE__ \
                     line:__LINE__ \
                 function:__FUNCTION__ \
                     info:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];
#define TUILOGI(fmt, ...) \
[TUIPlayerLog tuiLogLevel:TUIPlayer_LOG_INFO \
                     file:__FILE__ \
                     line:__LINE__ \
                 function:__FUNCTION__ \
                     info:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];
#define TUILOGW(fmt, ...) \
[TUIPlayerLog tuiLogLevel:TUIPlayer_LOG_WARNING \
                     file:__FILE__ \
                     line:__LINE__ \
                 function:__FUNCTION__ \
                     info:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];
#define TUILOGE(fmt, ...) \
[TUIPlayerLog tuiLogLevel:TUIPlayer_LOG_ERROR \
                     file:__FILE__ \
                     line:__LINE__ \
                 function:__FUNCTION__ \
                     info:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];

/// log
@interface TUIPlayerLog : NSObject

/**
 * 日志打印
 * @param level 方法
 * @param file 文件名
 * @param line 行
 * @param function 方法
 * @param info 信息
 */
+ (void)tuiLogLevel:(TUIPlayerLogLevel)level
               file:(const char *)file
               line:(int)line
           function:(const char *)function
               info:(NSString *)info ;
@end

NS_ASSUME_NONNULL_END
