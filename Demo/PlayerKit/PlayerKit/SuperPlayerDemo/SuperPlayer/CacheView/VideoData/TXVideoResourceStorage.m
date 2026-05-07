//  Copyright © 2025 Tencent. All rights reserved.
//

#import "PlayerKitCommonHeaders.h"
#import "TXVideoResourceStorage.h"

static NSArray<VideoCacheModel *> * videoResourceList = nil;

@interface TXVideoResourceStorage ()

@property (nonatomic, copy, class) NSArray<VideoCacheModel *> * videoResourceList;

@end

@implementation TXVideoResourceStorage

+ (NSArray<VideoCacheModel *> *)cacheVideoResource {
    return self.videoResourceList;
}

+ (NSString *)videoTitleWithURL:(NSString *)videoURL {
    if (!videoURL.length) {
        return @"";
    }
    for (VideoCacheModel *model in self.videoResourceList) {
        if ([model.url isEqualToString:videoURL]) {
            return model.videoTitle;
        }
        if ([model.drmBuilder.playUrl isEqualToString:videoURL]) {
            return model.videoTitle;
        }
    }
    return @"";
}

+ (NSString *)videoCoverWithURL:(NSString *)videoURL {
    return @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/4fc091e4387702299774545556/387702299947278317.png";
}

+ (NSArray<VideoCacheModel *> *)videoResourceList {
    if (!videoResourceList) {
        NSMutableArray *videoList = [NSMutableArray array];
        [videoList addObject:[self fairPlayVideo]];
        // 视频链接无效，无替代视频先屏蔽
//        [videoList addObject:[self shortValidityPeriodVideo]];
        videoResourceList = videoList.copy;
    }
    return videoResourceList;
}

+ (void)setVideoResourceList:(NSArray<VideoCacheModel *> *)newResourceList {
    videoResourceList = newResourceList;
}

#pragma mark - Video Resource

+ (VideoCacheModel *)fairPlayVideo {
    VideoCacheModel *cacheModel = [[VideoCacheModel alloc] init];
    TXPlayerDrmBuilder *drmBuilder = [[TXPlayerDrmBuilder alloc] init];
    drmBuilder.playUrl = @"https://1500017640.vod2.myqcloud.com/439767a2vodtranscq1500017640/30eb640e243791578648828779/adp.1434418.m3u8";
    drmBuilder.keyLicenseUrl = @"https://fairplay.drm.vod-qcloud.com/fairplay/getlicense/v2?drmToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9~eyJ0eXBlIjoiRHJtVG9rZW4iLCJhcHBJZCI6MTUwMDAxNzY0MCwiZmlsZUlkIjoiMjQzNzkxNTc4NjQ4ODI4Nzc5IiwiY3VycmVudFRpbWVTdGFtcCI6MCwiZXhwaXJlVGltZVN0YW1wIjoyMTQ3NDgzNjQ3LCJyYW5kb20iOjAsIm92ZXJsYXlLZXkiOiIiLCJvdmVybGF5SXYiOiIiLCJjaXBoZXJlZE92ZXJsYXlLZXkiOiIiLCJjaXBoZXJlZE92ZXJsYXlJdiI6IiIsImtleUlkIjowLCJzdHJpY3RNb2RlIjowLCJwZXJzaXN0ZW50IjoiT04iLCJyZW50YWxEdXJhdGlvbiI6MCwiZm9yY2VMMVRyYWNrVHlwZXMiOm51bGx9~bTRTEni3j96XeRa17olRo6KT_dvSNrjJCZQ4b7Wb-qw";
    drmBuilder.deviceCertificateUrl = @"https://cert.drm.vod-qcloud.com/cert/v1/816de426e6caa23d680a0198171aef89/fairplay.cer?updateTime=1673872343";
    cacheModel.drmBuilder = drmBuilder;
    cacheModel.videoTitle = @"FairPlay HLS(license 长期有效)";
    return cacheModel;
}

+ (VideoCacheModel *)shortValidityPeriodVideo {
    VideoCacheModel *cacheModel = [[VideoCacheModel alloc] init];
    TXPlayerDrmBuilder *drmBuilder = [[TXPlayerDrmBuilder alloc] init];
    drmBuilder.deviceCertificateUrl = @"https://cert.drm.vod-qcloud.com/cert/v1/59ca267fdd87903b933cb845b844eda2/fairplay.cer";
    drmBuilder.keyLicenseUrl = @"https://fairplay.drm.vod-qcloud.com/fairplay/getlicense/v2?drmToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9~eyJ0eXBlIjoiRHJtVG9rZW4iLCJhcHBJZCI6MTUwMDAxMzc4OCwiZmlsZUlkIjoiNTI4Nzg1MjEwOTg0OTE1NDY1OSIsImN1cnJlbnRUaW1lU3RhbXAiOjAsImV4cGlyZVRpbWVTdGFtcCI6Mjk2MDk5NTE3MCwicmFuZG9tIjowLCJvdmVybGF5S2V5IjoiIiwib3ZlcmxheUl2IjoiIiwiY2lwaGVyZWRPdmVybGF5S2V5IjoiIiwiY2lwaGVyZWRPdmVybGF5SXYiOiIiLCJrZXlJZCI6MCwic3RyaWN0TW9kZSI6MCwicGVyc2lzdGVudCI6Ik9OIiwicmVudGFsRHVyYXRpb24iOjYwMH0~Wnj6epGrf_drf9AOTGBfF1QOIEQVGN0A0_Hjty_kOUk";
    drmBuilder.playUrl = @"https://1500013788.vod2.myqcloud.com/43953aebvodtranscq1500013788/e57605175287852109849154659/adp.153829.m3u8";
    cacheModel.drmBuilder = drmBuilder;
    cacheModel.videoTitle = @"FairPlay HLS(license 有效期为10分钟)";
    return cacheModel;
}

@end
