//
//  TXPauseGuideView.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/30.
//  Copyright © 2021 Tencent. All rights reserved.
//  遮罩View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PauseGuideViewShowBlock)(BOOL isHidden);

@interface TXPauseGuideView : UIView

@property (nonatomic, copy) PauseGuideViewShowBlock pauseViewHidden;

@end

NS_ASSUME_NONNULL_END
