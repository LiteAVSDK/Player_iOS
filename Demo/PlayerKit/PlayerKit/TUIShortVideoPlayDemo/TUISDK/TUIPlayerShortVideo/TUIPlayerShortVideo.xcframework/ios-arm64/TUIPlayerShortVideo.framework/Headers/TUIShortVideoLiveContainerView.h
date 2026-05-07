// Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<TUIPlayerCore/TUIPlayerCore-umbrella.h>)
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
#else
#import "TUIPlayerCore-umbrella.h"
#endif
#import "TUIPlayerShortVideoUIManager.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TUIShortVideoLiveContainerViewDelegate <NSObject>

- (void)layoutSubviewsChange;

@end

@interface TUIShortVideoLiveContainerView : UIView

@property (nonatomic, weak) id <TUIShortVideoLiveContainerViewDelegate> delegate; ///代理
@property (nonatomic, strong) UIView *videoWidgetView;  /// 渲染容器
@property (nonatomic, strong) TUIPlayerLiveModel *model;/// 视频模型


/**
 * 初始化
 * uiManager 自定义ui管理类
 */
- (instancetype)initWithUIManager:(TUIPlayerShortVideoUIManager *)uiManager ;
/**
 * 设置背景图缩放模式
 * @param renderMode 缩放模式
*/
- (void)setBackgroundImageRenderMode:(V2TXLiveFillMode)renderMode;

@end

NS_ASSUME_NONNULL_END
