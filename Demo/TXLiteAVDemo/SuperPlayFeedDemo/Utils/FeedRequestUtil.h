//
//  FeedRequestUtil.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2022/6/17.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedRequestUtil : NSObject

+ (void)getPlayInfo:(int)appId
             fileId:(NSString *)fileId
              psign:(NSString *)psign
         completion:(void (^)(NSMutableDictionary *dic, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
