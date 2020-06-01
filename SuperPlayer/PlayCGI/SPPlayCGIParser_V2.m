//
//  SPPlayCGIParser_V2.m
//  SuperPlayer
//
//  Created by cui on 2019/12/25.
//  Copyright © 2019 annidy. All rights reserved.
//

#import "SPPlayCGIParser_V2.h"
#import "J2Obj.h"
#import "SuperPlayerUrl.h"
#import "TXImageSprite.h"

@implementation SPPlayCGIParser_V2
+ (SPPlayCGIParseResult *)parseResponse:(NSDictionary *)responseObject {
    SPPlayCGIParseResult *ret = [[SPPlayCGIParseResult alloc] init];
    NSString *masterUrl = J2Str([responseObject valueForKeyPath:@"videoInfo.masterPlayList.url"]);
    //    masterUrl = nil;
    if (masterUrl.length > 0) {
        // 1. 如果有master url，优先用这个
        ret.url = masterUrl;
    } else {
        NSString *mainDefinition = J2Str([responseObject valueForKeyPath:@"playerInfo.defaultVideoClassification"]);

        NSArray *videoClassification = J2Array([responseObject valueForKeyPath:@"playerInfo.videoClassification"]);
        NSArray *transcodeList = J2Array([responseObject valueForKeyPath:@"videoInfo.transcodeList"]);

        NSMutableArray<SuperPlayerUrl *> *result = [NSMutableArray new];

        // 2. 如果有转码的清晰度，用转码流
        for (NSDictionary *transcode in transcodeList) {
            SuperPlayerUrl *subModel = [SuperPlayerUrl new];
            subModel.url = J2Str(transcode[@"url"]);
            NSNumber *theDefinition = J2Num(transcode[@"definition"]);

            for (NSDictionary *definition in videoClassification) {
                for (NSObject *definition2 in J2Array([definition valueForKeyPath:@"definitionList"])) {

                    if ([definition2 isEqual:theDefinition]) {
                        subModel.title = J2Str([definition valueForKeyPath:@"name"]);
                        NSString *definitionId = J2Str([definition valueForKeyPath:@"id"]);
                        // 初始播放清晰度
                        if ([definitionId isEqualToString:mainDefinition]) {
                            if (![ret.url containsString:@".mp4"])
                                ret.url = subModel.url;
                        }
                        break;
                    }
                }
            }
            // 同一个清晰度可能存在多个转码格式，这里只保留一种格式，且优先mp4类型
            for (SuperPlayerUrl *item in result) {
                if ([item.title isEqual:subModel.title]) {
                    if (![item.url containsString:@".mp4"]) {
                        item.url = subModel.url;
                    }
                    subModel = nil;
                    break;
                }
            }

            if (subModel) {
                [result addObject:subModel];
            }
        }
        ret.multiVideoURLs = result;
    }
    // 3. 以上都没有，用原始地址
    if (ret.url == nil) {
        NSString *source = J2Str([responseObject valueForKeyPath:@"videoInfo.sourceVideo.url"]);
        ret.url = source;
    }

    NSArray *imageSprites = J2Array([responseObject valueForKeyPath:@"imageSpriteInfo.imageSpriteList"]);
    if (imageSprites.count > 0) {
        //                 id imageSpriteObj = imageSprites[0];
        id imageSpriteObj = imageSprites.lastObject;
        NSString *vtt = J2Str([imageSpriteObj valueForKeyPath:@"webVttUrl"]);
        NSArray *imgUrls = J2Array([imageSpriteObj valueForKeyPath:@"imageUrls"]);
        NSMutableArray *imgUrlArray = @[].mutableCopy;
        for (NSString *url in imgUrls) {
            NSURL *nsurl = [NSURL URLWithString:url];
            if (nsurl) {
                [imgUrlArray addObject:nsurl];
            }
        }

        TXImageSprite *imageSprite = [[TXImageSprite alloc] init];
        [imageSprite setVTTUrl:[NSURL URLWithString:vtt] imageUrls:imgUrlArray];
        ret.imageSprite = imageSprite;
    } 

    NSArray *keyFrameDescList = J2Array([responseObject valueForKeyPath:@"keyFrameDescInfo.keyFrameDescList"]);
    if (keyFrameDescList.count > 0) {
        NSMutableArray<SPVideoFrameDescription *> *checkPoints = [[NSMutableArray alloc] initWithCapacity:keyFrameDescList.count];
        for (NSDictionary *info in keyFrameDescList) {
            SPVideoFrameDescription *checkPoint = [SPVideoFrameDescription instanceFromDictionary:info];
            [checkPoints addObject:checkPoint];
        }
        ret.keyFrameDescList = checkPoints;
    }
    return ret;
}
@end
