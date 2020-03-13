//
//  PlayCGIV4Parser.m
//  SuperPlayer
//
//  Created by cui on 2019/12/25.
//  Copyright © 2019 annidy. All rights reserved.
//

#import "SPPlayCGIParser_V4.h"
//#import "SPResolutionDefination.h"
#import "SPSubStreamInfo.h"
#import "AdaptiveStream.h"
#import "TXImageSprite.h"
#import "J2Obj.h"

@implementation SPPlayCGIParser_V4

+ (SPPlayCGIParseResult *)parseResponse:(NSDictionary *)jsonResp {
    SPPlayCGIParseResult *ret = [[SPPlayCGIParseResult alloc] init];

    // 获取媒体信息
    NSDictionary *media = jsonResp[@"media"];
    if ([media isKindOfClass:[NSDictionary class]]) {
        do {
            //解析视频名称
            ret.name = [media valueForKeyPath:@"basicInfo.name"];
            NSDictionary *streamInfo = [media valueForKeyPath:@"streamingInfo.plainOutput"];
            if (streamInfo == nil) {
                break;
            }
            NSNumber *duration = [media valueForKeyPath:@"basicInfo.duration"];
            if ([duration isKindOfClass:[NSNumber class]]) {
                ret.originalDuration = duration.doubleValue;
            }
            // 解析分辨率名称
            NSArray *subStreamDictArray = J2Array(streamInfo[@"subStreams"]);
            NSMutableArray *subStreamInfoArray = [NSMutableArray arrayWithCapacity:subStreamDictArray.count];
            for (NSDictionary *resInfo in subStreamDictArray) {
                SuperPlayerUrl *url = [[SuperPlayerUrl alloc] init];
                url.title = J2Str(resInfo[@"resolutionName"]);
//                SPSubStreamInfo *info = [SPSubStreamInfo infoWithDictionary:resInfo];
                [subStreamInfoArray addObject:url];
            }
            ret.multiVideoURLs = subStreamInfoArray;
            
            //解析视频播放url
            NSString *url = streamInfo[@"url"];
            if ([url isKindOfClass:[NSString class]] && url.length > 0) {
                //未加密直接解析出视频url
                ret.url = url;
            } else {
                //有加密，url为空，则解析drm加密的url信息
                NSArray *urlArray = streamInfo[@"drmUrls"];
                if ([urlArray isKindOfClass:[NSArray class]] &&
                    urlArray.count > 0) {
                    NSMutableArray *drmURLArray = [NSMutableArray arrayWithCapacity:urlArray.count];
                    for (NSDictionary *dict in urlArray) {
                        if ([dict isKindOfClass:[NSDictionary class]]) {
                            continue;
                        }
                        AdaptiveStream *stream = [[AdaptiveStream alloc] init];
                        stream.url = dict[@"url"];
                        stream.drmType = dict[@"type"];
                        [drmURLArray addObject:stream];
                    }
                    ret.adaptiveStreamArray = drmURLArray;
                }
            }

            //解析略缩图信息
            NSDictionary *imageSpriteInfo = media[@"imageSpriteInfo"];

            if ([imageSpriteInfo isKindOfClass:[NSDictionary class]]) {
                NSString *vttURLString = J2Str(imageSpriteInfo[@"webVttUrl"]);
                NSURL *vttURL = [NSURL URLWithString:vttURLString];
                NSArray *imageURLStrings = J2Array(imageSpriteInfo[@"imageUrls"]);
                NSMutableArray<NSURL *> *imageURLs = [NSMutableArray arrayWithCapacity:imageURLStrings.count];
                for (NSString *urlString in imageURLStrings) {
                    NSURL *url = [NSURL URLWithString:urlString];
                    if (url) {
                        [imageURLs addObject:url];
                    }
                }
                TXImageSprite *sprite = [[TXImageSprite alloc] init];
                [sprite setVTTUrl:vttURL imageUrls:imageURLs];
                ret.imageSprite = sprite;
            }

            //解析关键帧信息
            NSDictionary *keyFrameDescInfo = media[@"keyFrameDescInfo"];
            if ([keyFrameDescInfo  isKindOfClass:[NSDictionary class]]) {
                NSArray *keyFrameDescList = keyFrameDescInfo[@"keyFrameDescList"];
                if ([keyFrameDescList isKindOfClass:[NSArray class]] &&
                    keyFrameDescList.count > 0) {
                    NSMutableArray<SPVideoFrameDescription *> *videoPoints = [NSMutableArray array];
                    for (NSDictionary *jsonObject in keyFrameDescList) {
                        SPVideoFrameDescription *point = [SPVideoFrameDescription instanceFromDictionary:jsonObject];
                        if (point) {
                            [videoPoints addObject:point];
                        }
                    }
                    ret.keyFrameDescList = videoPoints;
                }
            }
        } while (0);
    }
    return ret;
}

@end
