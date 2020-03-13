//
//  SPSubStreamInfo.m
//  SuperPlayer
//
//  Created by Steven Choi on 2020/2/11.
//  Copyright © 2020 annidy. All rights reserved.
//

#import "SPSubStreamInfo.h"
#import "J2Obj.h"
@implementation SPSubStreamInfo
+ (instancetype)infoWithDictionary:(NSDictionary *)dict {
    SPSubStreamInfo *info = [[SPSubStreamInfo alloc] init];
    double width = [J2Num(dict[@"width"]) doubleValue];
    double height = [J2Num(dict[@"height"]) doubleValue];
    info.size = CGSizeMake(width, height);
    info.resolutionName = J2Str(dict[@"name"]);
    info.type = J2Str(dict[@"type"]);
    return info;
}
@end
