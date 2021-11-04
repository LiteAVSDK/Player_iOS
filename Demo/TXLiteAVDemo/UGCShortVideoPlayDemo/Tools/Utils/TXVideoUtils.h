//
//  TXVideoUtils.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/25.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 播放模式
typedef NS_ENUM(NSUInteger, TXVideoPlayMode) {
    TXVideoPlayModeOneLoop,       // 单个循环
    TXVideoPlayModeListLoop       // 列表循环
};

@interface TXVideoUtils : NSObject

+ (NSArray *)loadDefaultVideoUrls;

@end

NS_ASSUME_NONNULL_END
