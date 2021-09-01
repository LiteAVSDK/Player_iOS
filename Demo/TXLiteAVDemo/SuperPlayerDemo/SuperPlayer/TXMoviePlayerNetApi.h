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
//@property (weak) id<TXMoviePlayerNetDelegate> delegate;
@property TXMoviePlayInfoResponse *playInfo;
@property BOOL                     https;

- (int)getplayinfo:(NSInteger)appId fileId:(NSString *)fileId psign:(NSString *)psign completion:(void (^)(TXMoviePlayInfoResponse *resp, NSError *error))completion;

@end
