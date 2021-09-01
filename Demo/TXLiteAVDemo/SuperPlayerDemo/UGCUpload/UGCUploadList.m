//
//  UGCUploadList.m
//  TXLiteAVDemo
//
//  Created by cui on 2019/12/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import "UGCUploadList.h"

#import "AppLocalized.h"
#import "ListVideoCell.h"
#import "TCHttpUtil.h"
#import "TXMoviePlayerNetApi.h"
#import "TXPlayerAuthParams.h"

@interface UGCUploadList () {
}
@property TXMoviePlayerNetApi *              getInfoNetApi;
@property(strong, nonatomic) NSMutableArray *pendingRequestQueue;
@property(atomic, assign) BOOL               fetching;
@property(copy, nonatomic) void (^whenGotOneCell)(ListVideoModel *cell);
@property(copy, nonatomic) void (^completion)(int result, NSString *message);
@end

@implementation UGCUploadList
- (instancetype)init {
    self = [super init];
    if (self) {
        _pendingRequestQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)fetchList:(void (^)(ListVideoModel *model))whenGotOneModel completion:(void (^)(int result, NSString *message))completion;
{
    if (self.fetching) {
        completion(-1, @"previous fetching request in progress.");
        return;
    }
    self.fetching       = YES;
    self.completion     = completion;
    self.whenGotOneCell = whenGotOneModel;
    [TCHttpUtil asyncSendHttpRequest:@"api/v1/resource/videos"
                      httpServerAddr:kHttpUGCServerAddr
                          HTTPMethod:@"GET"
                               param:@{@"page_num" : @"0", @"page_size" : @"20"}
                             handler:^(int result, NSDictionary *resultDict) {
                                 if (result == 0) {
                                     NSDictionary *dataDict = resultDict[@"data"];
                                     if (dataDict) {
                                         NSArray *                             list       = dataDict[@"list"];
                                         NSMutableArray<TXPlayerAuthParams *> *paramArray = [[NSMutableArray alloc] initWithCapacity:list.count];
                                         for (NSDictionary *dic in list) {
                                             TXPlayerAuthParams *p = [TXPlayerAuthParams new];
                                             p.appId               = [UGCAppid intValue];
                                             p.fileId              = dic[@"fileId"];
                                             [paramArray addObject:p];
                                         }
                                         [self.pendingRequestQueue setArray:paramArray];
                                         [self getNextInfo];
                                     } else {
                                         NSString *message = LocalizeReplace(LivePlayerLocalize(@"SuperPlayerDemo.UGCUploadList.errorcodexxerrormsgyy"),
                                                                             [NSString stringWithFormat:@"%@", resultDict[@"code"]], [NSString stringWithFormat:@"%@", resultDict[@"message"]]);
                                         if (completion) {
                                             completion(result, message);
                                         }
                                         self.completion = nil;
                                         self.fetching   = NO;
                                     }
                                 }
                             }];
}

- (void)getNextInfo {
    if (_pendingRequestQueue.count == 0) return;
    TXPlayerAuthParams *p = [_pendingRequestQueue objectAtIndex:0];
    [_pendingRequestQueue removeObject:p];

    if (self.getInfoNetApi == nil) {
        self.getInfoNetApi = [[TXMoviePlayerNetApi alloc] init];
        //        self.getInfoNetApi.delegate = self;
        self.getInfoNetApi.https = NO;
    }
    __weak __typeof(self) wself = self;
    [self.getInfoNetApi getplayinfo:p.appId
                             fileId:p.fileId
                              psign:p.sign
                         completion:^(TXMoviePlayInfoResponse *resp, NSError *error) {
                             __strong __typeof(wself) self = wself;

                             if (error) {
                                 if (self.completion) {
                                     self.completion((int)error.code, error.localizedDescription);
                                     self.completion     = nil;
                                     self.whenGotOneCell = nil;
                                 }
                                 self.fetching = NO;
                             } else {
                                 if (nil == self) {
                                     return;
                                 }
                                 ListVideoModel *m = [[ListVideoModel alloc] init];
                                 m.appId           = resp.appId;
                                 m.fileId          = resp.fileId;
                                 m.duration        = resp.duration;
                                 m.title           = resp.videoDescription.length > 0 ? resp.videoDescription : resp.name;
                                 m.coverUrl        = resp.coverUrl;

                                 if (self.whenGotOneCell) {
                                     self.whenGotOneCell(m);
                                 }
                                 [self getNextInfo];
                             }
                         }];
}

@end
