//
//  TXMoviePlayInfoResponse.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/4/13.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "TXMoviePlayInfoResponse.h"
#import "J2Obj.h"


@interface TXMoviePlayInfoStream : NSObject
@property NSString *url;
@property NSString *definition;
@property NSString *definitionId;
@end

@implementation TXMoviePlayInfoStream
@end

// ------------------------------------------------------------------

@implementation TXMoviePlayInfoResponse

- (instancetype)initWithResponse:(NSDictionary *)dict {
    self = [super init];
    
    _responseDict = [NSDictionary dictionaryWithDictionary:dict];
    int ver = dict[@"version"] ? J2Num(dict[@"version"]).intValue : 2;
    if (ver == 2) {
        _name = J2Str([dict valueForKeyPath:@"videoInfo.basicInfo.name"]);
        _coverUrl = J2Str([dict valueForKeyPath:@"coverInfo.coverUrl"]);
        _videoDescription = J2Str([dict valueForKeyPath:@"videoInfo.basicInfo.description"]);
        _duration = J2Num([dict valueForKeyPath:@"videoInfo.sourceVideo.duration"]).intValue;
    } else {
        _name = J2Str([dict valueForKeyPath:@"media.basicInfo.name"]);
        _coverUrl = J2Str([dict valueForKeyPath:@"media.basicInfo.coverUrl"]);
        _videoDescription = J2Str([dict valueForKeyPath:@"media.basicInfo.description"]);
        _duration = J2Num([dict valueForKeyPath:@"media.basicInfo.duration"]).intValue;
    }
    return self;
}

- (NSString *)title {
    return self.videoDescription?:self.name;
}

@end
