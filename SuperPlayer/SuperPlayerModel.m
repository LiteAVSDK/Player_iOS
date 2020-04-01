#import "SuperPlayerModel.h"
#import "SuperPlayer.h"
#import "AFNetworking/AFNetworking.h"
#import "J2Obj.h"
#import "AdaptiveStream.h"
#import "SPPlayCGIParser.h"
#import "SuperPlayerModelInternal.h"

const NSString *kPlayCGIHostname = @"playvideo.qcloud.com";

@implementation SuperPlayerVideoId
@end

@implementation SuperPlayerModel {
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _defaultPlayIndex = NSUIntegerMax;
    }
    return self;
}

- (void)dealloc {
    [_sessionManager invalidateSessionCancelingTasks:YES resetSession:YES];
}

- (NSString *)playingDefinitionUrl
{
    NSString *url;
    for (int i = 0; i < self.multiVideoURLs.count; i++) {
        if ([self.multiVideoURLs[i].title isEqualToString:self.playingDefinition]) {
            url = self.multiVideoURLs[i].url;
        }
    }
    if (url == nil)
        url = self.videoURL;
    if (url == nil) {
        if (self.multiVideoURLs.count > 0)
            url = self.multiVideoURLs.firstObject.url;
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

- (NSArray *)playDefinitions
{
    NSMutableArray *array = @[].mutableCopy;
    for (int i = 0; i < self.multiVideoURLs.count; i++) {
        [array addObject:self.multiVideoURLs[i].title];
    }
    return array;
}

- (NSInteger)playingDefinitionIndex
{
    for (int i = 0; i < self.multiVideoURLs.count; i++) {
        if ([self.multiVideoURLs[i].title isEqualToString:self.playingDefinition]) {
            return i;
        }
    }
    return 0;
}

- (NSURLSessionTask *)requestWithCompletion:
        (void(^)(NSError *, SuperPlayerModel *model))completion
{
    AFHTTPSessionManager *manager = self.sessionManager;
    int ver = self.videoId ? 4 : 2;
    NSString *url = [NSString stringWithFormat:@"https://%@/getplayinfo/v%d/%ld/%@",
                     kPlayCGIHostname, ver, self.appId, self.videoId ? self.videoId.fileId : self.videoIdV2.fileId];

    // 防盗链参数
    NSDictionary *params = [self _buildParams];
    
    __weak SuperPlayerModel *weakSelf = self;
    return [manager GET:url
             parameters:params
                headers:nil
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong SuperPlayerModel *self = weakSelf;
#if DEBUG
        NSLog(@"%@", responseObject);
#endif
        NSInteger code = [responseObject[@"code"] integerValue];
        if (code != 0) {
            NSString *msg = responseObject[@"message"];
            NSString *requestID = responseObject[@"requestId"];
            NSString *warning = responseObject[@"warning"];
            NSError *error = [NSError errorWithDomain:@"SuperPlayerCGI"
                                                 code:code
                                             userInfo:@{NSLocalizedDescriptionKey: msg,
                                                        @"requestID": requestID ?: @"",
                                                        @"warning": warning ?: @""
                                             }];
            if (completion) {
                completion(error, self);
                return;
            }
            return;
        }
        
        NSInteger responseVersion = [responseObject[@"version"] integerValue];
        if (responseVersion == 0) {
            responseVersion = 2;
        }
        Class<SPPlayCGIParserProtocol> parser = [SPPlayCGIParser parserOfVersion:responseVersion];
        SPPlayCGIParseResult *result = [parser parseResponse:responseObject];
        
        self.videoURL = result.url;
        self.multiVideoURLs = result.multiVideoURLs;
        self.keyFrameDescList = result.keyFrameDescList;
        self.imageSprite = result.imageSprite;
        if (responseVersion == 4) {
            self.originalDuration = result.originalDuration;
        }
        if (completion) {
            completion(nil, self);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) {
            if (completion) {
                completion(error, self);
            }
        }
    }];
}

- (NSDictionary *)_buildParams {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (self.videoId) {
        if (self.videoId.psign) {
            params[@"psign"] = self.videoId.psign;
        }
    } else if (self.videoIdV2) {
        if (self.videoIdV2.timeout) {
            params[@"t"] = self.videoIdV2.timeout;
        }
        if (self.videoIdV2.us) {
            params[@"us"] = self.videoIdV2.us;
        }
        if (self.videoIdV2.sign) {
            params[@"sign"] = self.videoIdV2.sign;
        }
        if (self.videoIdV2.exper >= 0) {
            params[@"exper"] = @(self.videoIdV2.exper);
        }
    }
    return params;
}

@end

@implementation SuperPlayerVideoIdV2
@end
