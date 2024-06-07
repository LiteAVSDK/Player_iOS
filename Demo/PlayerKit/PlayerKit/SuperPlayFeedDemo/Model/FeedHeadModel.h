//
//  FeedHeadModel.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/11/1.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedHeadModel : NSObject

@property (nonatomic, strong) NSString *headImageUrl;
@property (nonatomic, strong) NSString *videoNameStr;
@property (nonatomic, strong) NSString *videoSubTitleStr;
@property (nonatomic, strong) NSString *videoDesStr;

@end

NS_ASSUME_NONNULL_END
