//
//  ResolutionModel.h
//  Pods
//
//  Created by 路鹏 on 2022/2/28.
//  Copyright © 2022年 Tencent. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResolutionModel : NSObject

@property (nonatomic, strong) NSString *resolution;

@property (nonatomic, assign) BOOL isCurrentPlay;

@end

NS_ASSUME_NONNULL_END
