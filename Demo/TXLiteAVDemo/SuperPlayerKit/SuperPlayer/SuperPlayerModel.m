#import "SuperPlayerModel.h"

#import "AFNetworking/AFNetworking.h"
#import "AdaptiveStream.h"
#import "J2Obj.h"
#import "SuperPlayer.h"
#import "SuperPlayerModelInternal.h"
#import "TXVodPlayer.h"

const NSString *kPlayCGIHostname          = @"playvideo.qcloud.com";
NSString *const kErrorDomain              = @"SuperPlayerCGI";
const NSInteger kInvalidResponseErrorCode = -100;

@implementation SuperPlayerVideoId
@end

@implementation SuperPlayerModel {
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _defaultPlayIndex = NSUIntegerMax;
    }
    return self;
}

- (NSString *)playingDefinitionUrl {
    NSString *url;
    // 获取初始播放清晰度url
    for (int i = 0; i < self.multiVideoURLs.count; i++) {
        if ([self.multiVideoURLs[i].title isEqualToString:self.playingDefinition]) {
            url = self.multiVideoURLs[i].url;
            break;
        }
    }
    // 初始播放清晰度url获取失败，获取第一条转码流
    if (url == nil) {
        if (self.multiVideoURLs.count > 0) {
            url = self.multiVideoURLs.lastObject.url;
            if (url) {
                self.playingDefinition = self.multiVideoURLs.lastObject.title;
            }
        }
    }
    // 转码流获取失败，用原始地址
    if (url == nil) {
        url = self.videoURL;
    }
    return url;
}

- (void)setDefaultPlayIndex:(NSUInteger)defaultPlayIndex {
    _defaultPlayIndex = defaultPlayIndex;
    if (defaultPlayIndex < _multiVideoURLs.count) {
        self.playingDefinition = _multiVideoURLs[defaultPlayIndex].title;
    }
}

- (void)setMultiVideoURLs:(NSArray<SuperPlayerUrl *> *)multiVideoURLs {
    _multiVideoURLs = multiVideoURLs;
    if (_defaultPlayIndex < multiVideoURLs.count) {
        self.playingDefinition = _multiVideoURLs[_defaultPlayIndex].title;
    }
}

- (NSArray *)playDefinitions {
    NSMutableArray *array = @[].mutableCopy;
    for (int i = 0; i < self.multiVideoURLs.count; i++) {
        [array addObject:self.multiVideoURLs[i].title ?: @""];
    }
    return array;
}

- (NSInteger)playingDefinitionIndex {
    for (int i = 0; i < self.multiVideoURLs.count; i++) {
        if ([self.multiVideoURLs[i].title isEqualToString:self.playingDefinition]) {
            return i;
        }
    }
    return 0;
}

@end

@implementation SuperPlayerVideoIdV2
@end
