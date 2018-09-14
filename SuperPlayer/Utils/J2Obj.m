//
//  J2Obj.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/6/25.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "J2Obj.h"


NSArray *J2Array(id value) {
    id obj = value;
    id ret;
    if ([obj isKindOfClass:[NSArray class]])
    {
        ret = obj;
    }
    else
    {
        ret = @[];
    }
    return ret;
}

NSString * J2Str(id value) {
    id obj = value;
    id ret;
    if ([obj isKindOfClass:[NSString class]])
    {
        ret = obj;
    }
    else if ([obj isKindOfClass:[NSNumber class]])
    {
        ret = [obj stringValue];
    }
    else
    {
        ret = @"";
    }
    return ret;
}

NSNumber *J2Num(id value) {
    id obj = value;
    id ret;
    if ([obj isKindOfClass:[NSString class]])
    {
        ret = [NSNumber numberWithDouble:[obj doubleValue]];
    }
    else if ([obj isKindOfClass:[NSNumber class]])
    {
        ret = obj;
    }
    else
    {
        ret = @0;
    }
    return ret;
}
