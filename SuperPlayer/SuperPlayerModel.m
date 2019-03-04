#import "SuperPlayerModel.h"
#import "SuperPlayer.h"
#import "AFNetworking/AFNetworking.h"
#import "J2Obj.h"

NSNotificationName kSuperPlayerModelReady = @"kSuperPlayerModelReady";

@implementation SuperPlayerUrl
@end

@implementation SuperPlayerVideoId
@end

@interface SuperPlayerModel()
@property NSURLSessionDataTask *getInfoHttpTask;
@end

@implementation SuperPlayerModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    
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

/// !!!: data request
- (NSString*)makeParamtersString:(NSDictionary*)parameters withEncoding:(NSStringEncoding)encoding
{
    if (nil == parameters || [parameters count] == 0)
        return nil;
    
    NSMutableString* stringOfParamters = [[NSMutableString alloc] init];
    NSEnumerator *keyEnumerator = [parameters keyEnumerator];
    id key = nil;
    while ((key = [keyEnumerator nextObject]))
    {
        [stringOfParamters appendFormat:@"%@=%@&", key, [parameters valueForKey:key]];
    }
    
    // Delete last character of '&'
    NSRange lastCharRange = {[stringOfParamters length] - 1, 1};
    [stringOfParamters deleteCharactersInRange:lastCharRange];
    return stringOfParamters;
}

- (void)requestPlayInfo:(SuperPlayerView *)playerView
{
    if (self.videoId.version == FileIdV2)
        [self getPlayInfoV2:playerView];
    if (self.videoId.version == FileIdV3)
        [self getPlayInfoV3:playerView];
}

- (void)getPlayInfoV2:(SuperPlayerView *)playerView {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://playvideo.qcloud.com/getplayinfo/v2/%ld/%@", self.videoId.appId, self.videoId.fileId];
    
    // 防盗链参数
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (self.videoId.timeout) {
        [params setValue:self.videoId.timeout forKey:@"t"];
    }
    if (self.videoId.us) {
        [params setValue:self.videoId.us forKey:@"us"];
    }
    if (self.videoId.sign) {
        [params setValue:self.videoId.sign forKey:@"sign"];
    }
    if (self.videoId.exper >= 0) {
        [params setValue:@(self.videoId.exper) forKey:@"exper"];
    }
    NSString *httpBodyString = [self makeParamtersString:params withEncoding:NSUTF8StringEncoding];
    if (httpBodyString) {
        url = [url stringByAppendingFormat:@"?%@", httpBodyString];
    }
    
    __weak SuperPlayerModel *weakSelf = self;
    __weak SuperPlayerView  *weakPlayerView = playerView;
    self.getInfoHttpTask = [manager GET:url parameters:nil progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    
                                    __strong SuperPlayerModel *self = weakSelf;
                                    
                                    NSString *masterUrl = J2Str([responseObject valueForKeyPath:@"videoInfo.masterPlayList.url"]);
                                    //    masterUrl = nil;
                                    if (masterUrl.length > 0) {
                                        // 1. 如果有master url，优先用这个
                                        self.videoURL = masterUrl;
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
                                                            if (![self.videoURL containsString:@".mp4"])
                                                                self.videoURL = subModel.url;
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
                                        self.multiVideoURLs = result;
                                    }
                                    // 3. 以上都没有，用原始地址
                                    if (self.videoURL == nil) {
                                        NSString *source = J2Str([responseObject valueForKeyPath:@"videoInfo.sourceVideo.url"]);
                                        self.videoURL = source;
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
                                        weakPlayerView.imageSprite = imageSprite;
                                    } else {
                                        weakPlayerView.imageSprite = nil;
                                    }
                                    
                                    NSArray *keyFrameDescList = J2Array([responseObject valueForKeyPath:@"keyFrameDescInfo.keyFrameDescList"]);
                                    if (keyFrameDescList.count > 0) {
                                        weakPlayerView.keyFrameDescList = keyFrameDescList;
                                    } else {
                                        weakPlayerView.keyFrameDescList = nil;
                                    }
                                    
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:kSuperPlayerModelReady
                                                                                        object:self
                                                                                      userInfo:@{
                                                                                                 @"message": @"success"
                                                                                                 }];
                                    
                                    [manager invalidateSessionCancelingTasks:YES];
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:kSuperPlayerModelReady
                                                                                        object:self
                                                                                      userInfo:@{
                                                                                                 @"error": error,
                                                                                                 @"message": @"请求失败"                                          }];
                                    [manager invalidateSessionCancelingTasks:YES];
                                }];
    
}

- (void)getPlayInfoV3:(SuperPlayerView *)playerView {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"https://playvideo.qcloud.com/getplayinfo/v3/%ld/%@/%@", self.videoId.appId, self.videoId.fileId, self.videoId.playDefinition];
    
    // 防盗链参数
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (self.videoId.playerId) {
        [params setValue:self.videoId.playerId forKey:@"playerid"];
    }
    if (self.videoId.timeout) {
        [params setValue:self.videoId.timeout forKey:@"t"];
    }
    if (self.videoId.us) {
        [params setValue:self.videoId.us forKey:@"us"];
    }
    if (self.videoId.sign) {
        [params setValue:self.videoId.sign forKey:@"sign"];
    }
    if (self.videoId.rlimit > 0) {
        [params setValue:@(self.videoId.rlimit) forKey:@"rlimit"];
    }
    NSString *httpBodyString = [self makeParamtersString:params withEncoding:NSUTF8StringEncoding];
    if (httpBodyString) {
        url = [url stringByAppendingFormat:@"?%@", httpBodyString];
    }
    
    __weak SuperPlayerModel *weakSelf = self;
    __weak SuperPlayerView  *weakPlayerView = playerView;
    self.getInfoHttpTask = [manager GET:url parameters:nil progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    
                                    __strong SuperPlayerModel *self = weakSelf;
                                    
                                    
                                    
                                    NSArray *adaptiveStreamingInfoList = J2Array([responseObject valueForKeyPath:@"mediaInfo.dynamicStreamingInfo.adaptiveStreamingInfoList"]);
                                    
                                    for (NSDictionary *transcode in adaptiveStreamingInfoList) {
                                        NSString *package = J2Str([transcode valueForKeyPath:@"package"]);
                                        if ([package isEqualToString:@"hls"]) {
                                            self.videoURL = J2Str([transcode valueForKeyPath:@"url"]);
                                            // TODO: drmType
                                        }
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
                                        weakPlayerView.imageSprite = imageSprite;
                                    } else {
                                        weakPlayerView.imageSprite = nil;
                                    }
                                    
                                    NSArray *keyFrameDescList = J2Array([responseObject valueForKeyPath:@"keyFrameDescInfo.keyFrameDescList"]);
                                    if (keyFrameDescList.count > 0) {
                                        weakPlayerView.keyFrameDescList = keyFrameDescList;
                                    } else {
                                        weakPlayerView.keyFrameDescList = nil;
                                    }
                                    
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:kSuperPlayerModelReady
                                                                                        object:self
                                                                                      userInfo:@{
                                                                                                 @"message": @"success"
                                                                                                 }];
                                    
                                    [manager invalidateSessionCancelingTasks:YES];
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:kSuperPlayerModelReady
                                                                                        object:self
                                                                                      userInfo:@{
                                                                                                 @"error": error,
                                                                                                 @"message": @"请求失败"                                          }];
                                    [manager invalidateSessionCancelingTasks:YES];
                                }];
}

@end
