//
//  TXMoviePlayInfoResponse.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/4/13.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TXMoviePlayInfoResponse : NSObject

@property (copy) NSDictionary *responseDict;

@property (readonly) NSString *coverUrl;
@property (readonly) NSString *name;
@property (readonly) NSString *videoDescription;
@property (readonly) int      duration;
@property (readonly) NSString *title;

@property NSInteger appId;
@property NSString *fileId;

- (instancetype)initWithResponse:(NSDictionary *)dict;


@end
