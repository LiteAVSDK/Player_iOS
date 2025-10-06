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
    SPVideoFrameDescription *ret = [[SPVideoFrameDescription alloc] init];
    if ([keyFrameDesc isKindOfClass:[NSDictionary class]]) {
        ret.time                     = [J2Num([keyFrameDesc valueForKeyPath:@"timeOffset"]) intValue] / 1000.0;
        ret.text                     = [J2Str([keyFrameDesc valueForKey:@"content"]) stringByRemovingPercentEncoding];
    }
    return ret;
}
@end
