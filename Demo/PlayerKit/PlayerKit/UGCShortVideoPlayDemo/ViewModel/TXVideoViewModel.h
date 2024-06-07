//
//  TXVideoViewModel.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/18.
//  Copyright © 2021 Tencent. All rights reserved.
//  视频源请求

#import <Foundation/Foundation.h>
#import "TXVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TXVideoViewModel : NSObject

/**
 *  请求视频数据
 *
 *  @param index                 请求元数据的起始位置
 *  @param count                 请求的个数
 *  @param success            请求成功回调
 *  @param failure            请求失败回调
 */
- (void)refreshNewListWithindex:(NSInteger)index
                    requestCount:(NSInteger)count
                        success:(void(^)(NSMutableArray *list))success
                        failure:(void(^)(NSError *error))failure;
/**
 *  请求所有视频数据
 *
 *  @param success            请求成功回调
 *  @param failure            请求失败回调
 */
- (void)refreshNewListWithsuccess:(void(^)(NSArray *list))success failure:(void(^)(NSError *error))failure;

/**
 *  请求单个视频数据
 *
 *  @param index                 请求元数据的位置
 *  @param success            请求成功回调
 *  @param failure            请求失败回调
 */
- (void)requestViewModelWithindex:(NSInteger)index
                          success:(void(^)(TXVideoModel *model))success
                          failure:(void(^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
