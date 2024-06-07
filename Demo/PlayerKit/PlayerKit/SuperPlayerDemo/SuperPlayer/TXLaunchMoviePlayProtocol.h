//
//  TXLaunchMoviePlayProtocol.h
//  TXLiteAVDemo
//
//  Created by coddyliu on 2020/7/7.
//  Copyright © 2020 Tencent. All rights reserved.
//

#ifndef TXLaunchMoviePlayProtocol_h
#define TXLaunchMoviePlayProtocol_h

@protocol TXLaunchMoviePlayProtocol <NSObject>

- (void)startPlayVideoFromLaunchInfo:(NSDictionary *)launchInfo complete:(void (^)(BOOL succ))complete;

@end

#endif /* TXLaunchMoviePlayProtocol_h */
