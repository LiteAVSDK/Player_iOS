//  Copyright © 2023 Tencent. All rights reserved.

#if __has_include(<TUIPlayerCore/TUIPlayerLog.h>)
#import <TUIPlayerCore/TUIPlayerLog.h>
#else
#import "TUIPlayerLog.h"
#endif
#ifndef TUIPlayerViewCommonDefine_h
#define TUIPlayerViewCommonDefine_h

// 1.强/弱引用
#define TUIPV_WEAK_SELF(object)            __weak __typeof__(object) weak##_##object = object;
#define TUIPV_STRONG_SELF(object)        __strong __typeof__(object) object = weak##_##object;

// 浮点数是否为0
#define TUI_FLOAT_EQUAL_TO_ZERO(x) (fabs(x) < FLT_EPSILON)

#endif /* TUIPlayerViewCommonDefine_h */
