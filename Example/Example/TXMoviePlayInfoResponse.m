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
    
    return self;
}

- (NSArray<TXMoviePlayInfoStream *> *)streamList
{
    NSArray *videoClassification = J2Array([self.responseDict valueForKeyPath:@"playerInfo.videoClassification"]);
    NSArray *transcodeList = J2Array([self.responseDict valueForKeyPath:@"videoInfo.transcodeList"]);
    
    NSMutableArray<TXMoviePlayInfoStream *> *result = [NSMutableArray new];
    
            for (NSDictionary *transcode in transcodeList) {
                TXMoviePlayInfoStream *stream = [[TXMoviePlayInfoStream alloc] init];
        stream.url = J2Str(transcode[@"url"]);
        NSNumber *theDefinition = J2Num(transcode[@"definition"]);
        for (NSDictionary *definition in videoClassification) {
            for (NSObject *definition2 in J2Array([definition valueForKeyPath:@"definitionList"])) {
                if ([definition2 isEqual:theDefinition]) {
                    stream.definition = J2Str([definition valueForKeyPath:@"name"]);
                    stream.definitionId = J2Str([definition valueForKeyPath:@"id"]);
                    break;
                }
                }
                }
        
                [result addObject:stream];
            }
    
    return result;
}

- (NSString *)coverUrl {
    return J2Str([self.responseDict valueForKeyPath:@"coverInfo.coverUrl"]);
        }

- (NSString *)name {
    return J2Str([self.responseDict valueForKeyPath:@"videoInfo.basicInfo.name"]);
            }

- (NSString *)videoDescription {
    return J2Str([self.responseDict valueForKeyPath:@"videoInfo.basicInfo.description"]);
            }

- (int)duration {
    return J2Num([self.responseDict valueForKeyPath:@"videoInfo.sourceVideo.duration"]).intValue;
        }

- (NSString *)title {
    return self.videoDescription?:self.name;
    }
@end
