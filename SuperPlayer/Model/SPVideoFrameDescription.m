//
//  SPVideoFrameDescription.m
//  SuperPlayer
//
//  Created by cui on 2019/12/25.
//  Copyright © 2019 annidy. All rights reserved.
//

#import "SPVideoFrameDescription.h"
#import "J2Obj.h"

@implementation SPVideoFrameDescription
+ (instancetype)instanceFromDictionary:(NSDictionary *)keyFrameDesc {
    if (![keyFrameDesc isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    SPVideoFrameDescription *ret = [[SPVideoFrameDescription alloc] init];
    ret.time = [J2Num([keyFrameDesc valueForKeyPath:@"timeOffset"]) intValue]/1000.0;
    ret.text = [J2Str([keyFrameDesc valueForKeyPath:@"content"]) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return ret;
}
@end
