//  Copyright © 2024 Tencent. All rights reserved.
//

#ifndef TUIPSVDCommonDefine_h
#define TUIPSVDCommonDefine_h

#define TUIPSVD_COLOR_BLACK    [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]
// 1.强/弱引用
#define TUIPSVD_WEAK_SELF(object)            __weak __typeof__(object) weak##_##object = object;
#define TUIPSVD_STRONG_SELF(object)        __strong __typeof__(object) object = weak##_##object;
#endif /* TUIPSVDCommonDefine_h */
