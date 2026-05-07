// Copyright (c) 2023 Tencent. All rights reserved.
// 菊花Loading控件

#import <UIKit/UIKit.h>
#import <TUIPlayerShortVideo/TUIPlayerShortVideoLoadingViewProtocol.h>
//#import "TUIPlayerShortVideoLoadingViewProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface TUIPSDLoadingView : UIView <TUIPlayerShortVideoLoadingViewProtocol>

/**
 *  开始加载
 */
- (void)startLoading;

/**
 *  停止加载
 */
- (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
