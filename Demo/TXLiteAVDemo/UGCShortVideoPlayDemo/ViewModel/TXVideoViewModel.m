//
//  TXVideoViewModel.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/18.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXVideoViewModel.h"
#import "TXVideoUtils.h"
#import "TXVideoRequest.h"
#import "TXVideoModel.h"
#import "TXVideoPlayMem.h"

@implementation TXVideoViewModel

#pragma mark - Public Method
- (void)refreshNewListWithindex:(NSInteger)index
                   requestCount:(NSInteger)count
                        success:(void (^)(NSMutableArray * _Nonnull))success
                        failure:(void (^)(NSError * _Nonnull))failure {
    // 获取短视频源数据URL
    NSArray *videoUrlArray = [TXVideoUtils loadDefaultVideoUrls];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    dispatch_group_t downloadVideoGroup = dispatch_group_create();
    for (NSInteger i = index; i < count; i++) {
        dispatch_group_enter(downloadVideoGroup);
        [TXVideoRequest requestWithtype:TXVideoRequestTypeGet urlString:videoUrlArray[i] parameters:nil headers:nil successBlock:^(id  _Nonnull responseObject) {
            TXVideoModel *model = [self assemblyVideoDate:responseObject];
            if (model != nil) {
                [resultArray addObject:model];
            }
            dispatch_group_leave(downloadVideoGroup);
        } failureBlock:^(NSError * _Nonnull error) {
            dispatch_group_leave(downloadVideoGroup);
        }];
        
    }
    
    dispatch_group_notify(downloadVideoGroup, dispatch_get_main_queue(), ^{
        if (success && resultArray.count > 0) {
            success(resultArray);
        }
    });
}

- (void)refreshNewListWithsuccess:(void(^)(NSArray *list))success failure:(void(^)(NSError *error))failure {
    // 获取短视频源数据URL
    NSArray *videoUrlArray = [TXVideoUtils loadDefaultVideoUrls];
    if (videoUrlArray.count <= 0) {
        return;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    dispatch_group_t downloadVideoGroup = dispatch_group_create();
    for (int i = 0; i < videoUrlArray.count; i++) {
        dispatch_group_enter(downloadVideoGroup);
        [TXVideoRequest requestWithtype:TXVideoRequestTypeGet urlString:videoUrlArray[i] parameters:nil headers:nil successBlock:^(id  _Nonnull responseObject) {
            TXVideoModel *model = [self assemblyVideoDate:responseObject];
            if (model != nil) {
                [resultArray addObject:model];
            }
            dispatch_group_leave(downloadVideoGroup);
        } failureBlock:^(NSError * _Nonnull error) {
            dispatch_group_leave(downloadVideoGroup);
        }];
    }
    
    dispatch_group_notify(downloadVideoGroup, dispatch_get_main_queue(), ^{
        if (success && resultArray.count > 0) {
            success(resultArray);
        }
    });
}

- (void)requestViewModelWithindex:(NSInteger)index
                          success:(void(^)(TXVideoModel *model))success
                          failure:(void(^)(NSError *error))failure {
    // 获取短视频源数据URL
    NSArray *videoUrlArray = [TXVideoUtils loadDefaultVideoUrls];
    if (index >= videoUrlArray.count) {
        return;
    }
    [TXVideoRequest requestWithtype:TXVideoRequestTypeGet urlString:videoUrlArray[index] parameters:nil headers:nil successBlock:^(id  _Nonnull responseObject) {
        TXVideoModel *model = [self assemblyVideoDate:responseObject];
        if (success && model != nil) {
            success(model);
        }
    } failureBlock:^(NSError * _Nonnull error) {
    
    }];
}

#pragma mark - Private Method
- (TXVideoModel *)assemblyVideoDate:(id)responseObject {
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
    if ([dic[@"code"] integerValue] == 0) {
        TXVideoModel *model = [TXVideoModel new];
        model.name = dic[@"media"][@"basicInfo"][@"name"];
        model.videourl = dic[@"media"][@"streamingInfo"][@"plainOutput"][@"url"];
        model.duration = dic[@"media"][@"basicInfo"][@"duration"];
        model.requestId = dic[@"requestId"];
        if ([[dic allKeys] containsObject:@"media"]) {
            model.coverUrl = dic[@"media"][@"basicInfo"][@"coverUrl"];
        }
        NSArray *bitrateArray = dic[@"media"][@"streamingInfo"][@"plainOutput"][@"subStreams"];
        [bitrateArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"type"] isEqualToString:@"video"]) {
                model.bitrateIndex = idx;
                model.width = obj[@"width"];
                model.height = obj[@"height"];
                *stop = YES;
            }
        }];
        return model;
    }
    
    return nil;
}

@end
