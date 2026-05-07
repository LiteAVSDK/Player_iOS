// Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUIPlayerShortVideoUIManager.h"
#if __has_include(<TUIPlayerCore/TUIPlayerLiveManager.h>)
#import <TUIPlayerCore/TUIPlayerLiveManager.h>
#else
#import "TUIPlayerLiveManager.h"
#endif
#import "TUIShortVideoCellInterface.h"

@class TUIShortVideoItemLiveCell;

NS_ASSUME_NONNULL_BEGIN
@protocol TUIShortVideoItemLiveCellDelegate <NSObject>

/**
 * 自定义事件
 */
- (void)liveCustomCallbackEvent:(id)info;

@end

@interface TUIShortVideoItemLiveCell : UITableViewCell

@property (nonatomic, weak) id <TUIShortVideoItemLiveCellDelegate> delegate;

@property (nonatomic, weak) id<TUIShortVideoCellLayoutDelegate> layoutDelegate;

@property (nonatomic, strong) UIView *videoWidgetView;  /// 渲染容器

@property (nonatomic, strong) TUIPlayerLiveModel *model;/// 视频模型

+ (TUIShortVideoItemLiveCell *)cellWithtableView:(UITableView *)tableView
                                       uiManager:(TUIPlayerShortVideoUIManager *)uiManager
                                     liveManager:(TUIPlayerLiveManager *)liveManager;

/**
 * 设置背景图缩放模式
 * @param renderMode 缩放模式
*/
- (void)setBackgroundImageRenderMode:(V2TXLiveFillMode)renderMode;

@end

NS_ASSUME_NONNULL_END
