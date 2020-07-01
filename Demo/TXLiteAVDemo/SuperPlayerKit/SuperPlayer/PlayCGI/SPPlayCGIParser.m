//
//  SPPlayCGIParser.m
//  SuperPlayer
//
//  Created by cui on 2019/12/26.
//  Copyright © 2019 annidy. All rights reserved.
//

#import "SPPlayCGIParser.h"
#import "SPPlayCGIParser_V2.h"
#import "SPPlayCGIParser_V4.h"

@implementation SPPlayCGIParser
+ (Class<SPPlayCGIParserProtocol>)parserOfVersion:(NSInteger)version {
    if (version == 2) {
        return [SPPlayCGIParser_V2 class];
    } else if (version == 4) {
        return [SPPlayCGIParser_V4 class];
    }
    return Nil;
}
@end
