//
//  TXMoviePlayerNetDelegate.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/4/13.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#ifndef TXMoviePlayerNetDelegate_h
#define TXMoviePlayerNetDelegate_h

@class TXMoviePlayerNetApi;

@protocol TXMoviePlayerNetDelegate <NSObject>

- (void)onNetSuccess:(TXMoviePlayerNetApi *)obj;
- (void)onNetFailed:(TXMoviePlayerNetApi *)obj reason:(NSString *)reason code:(int)code;

@end

#endif /* TXMoviePlayerNetDelegate_h */
