//  Copyright © 2025 Tencent. All rights reserved.

#import "AppLocalized.h"
#import "DRMPlayerControlModel.h"
#import "TXLiveBase.h"

@interface DRMPlayerControlModel ()

@end

@implementation DRMPlayerControlModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reset];
        _videoInfo = [[DRMPlayerVideoInfo alloc] init];
    }
    return self;
}

- (void)initPlayerLog {
    unsigned long long recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    int mil = recordTime % 1000;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"hh:mm:ss";
    NSString *time = [format stringFromDate:[NSDate date]];
    NSString *log = [NSString stringWithFormat:@"[%@.%-3.3d] %@", time, mil, playerLocalize(@"SuperPlayerDemo.OndemandPlayer.tapplaybutton")];
    NSString *ver = [TXLiveBase getSDKVersionStr];
    self.playerLog = [NSString stringWithFormat:@"liteav sdk version: %@\n%@", ver, log];
}

- (void)reset {
    self.status = DRMPlayerStatusIdle;
    self.mute = NO;
    self.hardware = NO;
    self.logSwitch = NO;
    self.cacheEnable = NO;
    self.screenMode = DRMPlayerScreenModePortrait;
    self.renderMode = RENDER_MODE_FILL_EDGE;
    self.hardware = YES;
    self.playerLog = @"";
}

- (void)appendLogWithParams:(NSDictionary *)params {
    long long time = [(NSNumber *)[params valueForKey:EVT_TIME] longLongValue];
    int mil = time % 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    NSString *messgae  = (NSString *)[params valueForKey:EVT_MSG];
    if (!messgae.length) {
        return;
    }
    static NSDateFormatter *format = nil;
    if (!format) {
        format = [[NSDateFormatter alloc] init];
    }
    format.dateFormat = @"hh:mm:ss";
    NSString *timeString = [format stringFromDate:date];
    NSString *logString = [NSString stringWithFormat:@"[%@.%-3.3d] %@", timeString, mil, messgae];
    if (!self.playerLog) {
        self.playerLog = @"";
    }
    self.playerLog = [NSString stringWithFormat:@"%@\n%@", self.playerLog, logString];
}

- (void)appendLog:(NSString *)log time:(NSDate *)time mills:(int)mills {
    if (!log.length) {
        return;
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"hh:mm:ss";
    NSString *timeString = [format stringFromDate:time];
    NSString *logString = [NSString stringWithFormat:@"[%@.%-3.3d] %@", timeString, mills, log];
    if (!self.playerLog) {
        self.playerLog = @"";
    }
    self.playerLog = [NSString stringWithFormat:@"%@\n%@", self.playerLog, logString];
}

@end

@implementation DRMPlayerVideoInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.videoURL = @"https://1500017640.vod2.myqcloud.com/439767a2vodtranscq1500017640/30eb640e243791578648828779/adp.1434418.m3u8";
        self.license = @"https://fairplay.drm.vod-qcloud.com/fairplay/getlicense/v2?drmToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9~eyJ0eXBlIjoiRHJtVG9rZW4iLCJhcHBJZCI6MTUwMDAxNzY0MCwiZmlsZUlkIjoiMjQzNzkxNTc4NjQ4ODI4Nzc5IiwiY3VycmVudFRpbWVTdGFtcCI6MCwiZXhwaXJlVGltZVN0YW1wIjoyMTQ3NDgzNjQ3LCJyYW5kb20iOjAsIm92ZXJsYXlLZXkiOiIiLCJvdmVybGF5SXYiOiIiLCJjaXBoZXJlZE92ZXJsYXlLZXkiOiIiLCJjaXBoZXJlZE92ZXJsYXlJdiI6IiIsImtleUlkIjowLCJzdHJpY3RNb2RlIjowLCJwZXJzaXN0ZW50IjoiT04iLCJyZW50YWxEdXJhdGlvbiI6MCwiZm9yY2VMMVRyYWNrVHlwZXMiOm51bGx9~bTRTEni3j96XeRa17olRo6KT_dvSNrjJCZQ4b7Wb-qw";
        self.certificate = @"https://cert.drm.vod-qcloud.com/cert/v1/816de426e6caa23d680a0198171aef89/fairplay.cer?updateTime=1673872343";
    }
    return self;
}

@end
