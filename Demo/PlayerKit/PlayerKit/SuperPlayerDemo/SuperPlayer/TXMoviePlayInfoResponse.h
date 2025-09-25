//
//  TXMoviePlayInfoResponse.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/4/13.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerKitCommonHeaders.h"

@interface TXMoviePlayInfoResponse : NSObject

@property(nonatomic, readonly) NSDictionary *responseDict;

@property(nonatomic, strong) NSString *coverUrl;
@property(nonatomic, strong)   NSString *name;
@property(nonatomic, readonly) NSString *videoDescription;
@property(nonatomic, readonly) int       duration;
@property(nonatomic, readonly) NSString *title;

@property (nonatomic, assign) NSInteger appId;
@property (nonatomic, strong) NSString *fileId;
@property (nonatomic, strong) NSString *pSign;
@property (nonatomic, assign) BOOL isCache;
@property (nonatomic, strong) NSString *videoUrl;

@property (nonatomic, strong) TXPlayerDrmBuilder *drmBuilder;

///ghost watermark Info
///幽灵水印信息
@property (nonatomic, strong) NSString *ghostWatermarkInfo;
- (instancetype)initWithResponse:(NSDictionary *)dict;

@end
