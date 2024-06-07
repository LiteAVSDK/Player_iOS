//
//  TXVideoModel.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/19.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXVideoModel.h"

@implementation TXVideoModel
@synthesize name;
@synthesize videourl;
@synthesize width;
@synthesize height;
@synthesize duration;
@synthesize requestId;
@synthesize coverUrl;
@synthesize bitrateIndex;

#pragma mark NSCoping
- (id)copyWithZone:(NSZone *)zone {
    TXVideoModel *copy = [[[self class] allocWithZone:zone] init];
    copy.name = [self.name copyWithZone:zone];
    copy.videourl = [self.videourl copyWithZone:zone];
    copy.width = [self.width copyWithZone:zone];
    copy.height = [self.height copyWithZone:zone];
    copy.duration = [self.duration copyWithZone:zone];
    copy.requestId = [self.requestId copyWithZone:zone];
    copy.coverUrl = [self.coverUrl copyWithZone:zone];
    copy.bitrateIndex = self.bitrateIndex;
    return copy;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:videourl forKey:@"videourl"];
    [aCoder encodeObject:width forKey:@"width"];
    [aCoder encodeObject:height forKey:@"height"];
    [aCoder encodeObject:duration forKey:@"duration"];
    [aCoder encodeObject:requestId forKey:@"requestId"];
    [aCoder encodeObject:coverUrl forKey:@"coverUrl"];
    [aCoder encodeObject:@(bitrateIndex) forKey:@"bitrateIndex"];
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.videourl = [aDecoder decodeObjectForKey:@"videourl"];
        self.width = [aDecoder decodeObjectForKey:@"width"];
        self.height = [aDecoder decodeObjectForKey:@"height"];
        self.duration = [aDecoder decodeObjectForKey:@"duration"];
        self.requestId = [aDecoder decodeObjectForKey:@"requestId"];
        self.coverUrl = [aDecoder decodeObjectForKey:@"coverUrl"];
        self.bitrateIndex = [[aDecoder decodeObjectForKey:@"bitrateIndex"] integerValue];
    }
    return self;
}

@end
