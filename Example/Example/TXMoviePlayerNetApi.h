//
//  TXMoviePlayerNetApi.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/4/13.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXMoviePlayInfoResponse.h"
#import "TXMoviePlayerNetDelegate.h"

@interface TXMoviePlayerNetApi : NSObject
@property (weak) id<TXMoviePlayerNetDelegate> delegate;
@property TXMoviePlayInfoResponse *playInfo;
@property BOOL https;

- (int)getplayinfo:(NSInteger)appid fileId:(NSString *)fileId timeout:(NSString *)timeout us:(NSString *)us exper:(int)exper sign:(NSString *)sign;
@end
