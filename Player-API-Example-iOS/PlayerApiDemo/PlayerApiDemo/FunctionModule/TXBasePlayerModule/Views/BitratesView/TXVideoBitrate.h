//
//  TXVideoBitrate.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXVideoBitrate : NSObject

// 清晰度名称
@property (nonatomic, strong) NSString *title;

// 分辨率下标
@property (nonatomic, assign) NSInteger quality;

@end

NS_ASSUME_NONNULL_END
