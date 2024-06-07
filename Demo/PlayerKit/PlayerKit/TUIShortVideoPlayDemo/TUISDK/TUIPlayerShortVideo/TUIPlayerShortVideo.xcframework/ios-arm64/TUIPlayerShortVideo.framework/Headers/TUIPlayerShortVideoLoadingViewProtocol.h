// Copyright (c) 2023 Tencent. All rights reserved.
// loading协议

#import <Foundation/Foundation.h>

@protocol TUIPlayerShortVideoLoadingViewProtocol <NSObject>

/**
 *  开始加载
 */
- (void)startLoading;

/**
 *  停止加载
 */
- (void)stopLoading;
@end


