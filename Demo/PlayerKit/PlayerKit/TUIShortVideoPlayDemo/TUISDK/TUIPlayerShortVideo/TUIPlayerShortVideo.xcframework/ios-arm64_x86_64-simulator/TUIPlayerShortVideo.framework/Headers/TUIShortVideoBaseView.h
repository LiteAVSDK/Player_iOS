// Copyright (c) 2023 Tencent. All rights reserved.

#import <UIKit/UIKit.h>

#if __has_include(<TUIPlayerCore/TUIPlayerCore-umbrella.h>)
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
#else
#import "TUIPlayerCore-umbrella.h"
#endif
#import "TUIPlayerShortVideoUIManager.h"
NS_ASSUME_NONNULL_BEGIN
///视频控件baseView代理
@class TUIShortVideoBaseView;
@protocol TUIShortVideoBaseViewDelegate <NSObject>

- (void)layoutSubviewsChange;

@optional
/**
 * @brief 获取widget的frame
 * @param containerSize widget父view的size
 */
- (CGRect)widgetFrameWithContainerSize:(CGSize)containerSize;

@end

///视频控件baseView
@interface TUIShortVideoBaseView : UIView
///代理
@property (nonatomic, weak) id<TUIShortVideoBaseViewDelegate> delegate;

@property (nonatomic, strong, nullable) UIView *videoContainerView; /// 播放器容器View
@property (nonatomic, strong) TUIPlayerVideoModel *model;/// 视频模型

/**
 * 初始化
 * uiManager 自定义ui管理类
 */
- (instancetype)initWithUIManager:(TUIPlayerShortVideoUIManager *)uiManager ;
/**
 * 设置背景图缩放模式
 * @param renderMode 缩放模式
*/
- (void)setBackgroundImageRenderMode:(TUI_Enum_Type_RenderMode)renderMode;
/**
 * 隐藏/显示背景图
 */
- (void)hiddenCoverImage:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
