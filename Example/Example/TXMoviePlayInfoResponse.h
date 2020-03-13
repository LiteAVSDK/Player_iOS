//
//  TXMoviePlayInfoResponse.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/4/13.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXMoviePlayInfoResponse : NSObject

@property (nonatomic, readonly) NSDictionary *responseDict;

@property (nonatomic, readonly) NSString *coverUrl;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *videoDescription;
@property (nonatomic, readonly) int      duration;
@property (nonatomic, readonly) NSString *title;

@property NSInteger appId;
@property NSString *fileId;

- (instancetype)initWithResponse:(NSDictionary *)dict;

@end
