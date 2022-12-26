//
//  TXBasePlayerTopView.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXBasePlayerTopViewDelegate <NSObject>

/**
 *   触发扫码事件
 */
- (void)onScanClick;

@end

@interface TXBasePlayerTopView : UIView

@property(nonatomic,weak) id<TXBasePlayerTopViewDelegate> delegate;

// 输入url的textField
@property (nonatomic, strong) UITextField *urlTextField;



@end

NS_ASSUME_NONNULL_END
