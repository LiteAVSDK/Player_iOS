//
//  VideoCacheModel.h
//  Pods
//
//  Created by 路鹏 on 2022/2/17.
//  Copyright © 2022年 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import "TXPlayerDrmBuilder.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoCacheModel : NSObject

@property (nonatomic, strong) NSString *videoTitle;

@property (nonatomic, assign) BOOL isCache;

@property (nonatomic, assign) BOOL isCurrentPlay;

@property (nonatomic, assign) int appId;

@property (nonatomic, strong) NSString *fileId;

@property (nonatomic, strong) NSString *pSign;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) TXPlayerDrmBuilder *drmBuilder;

@end

NS_ASSUME_NONNULL_END
