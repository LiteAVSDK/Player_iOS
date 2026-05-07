// Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<TUIPlayerCore/TUIPlayerDataModel.h>)
#import <TUIPlayerCore/TUIPlayerDataModel.h>
#else
#import "TUIPlayerDataModel.h"
#endif
#import "TUIPlayerShortVideoUIManager.h"
NS_ASSUME_NONNULL_BEGIN
@protocol TUIShortVideoItemCustomCellDelegate <NSObject>

/**
 * 自定义事件
 */
- (void)customCustomCallbackEvent:(id)info;

@end
@interface TUIShortVideoItemCustomCell : UITableViewCell
@property (nonatomic, weak)id <TUIShortVideoItemCustomCellDelegate>delegate;///代理
@property (nonatomic, strong) TUIPlayerDataModel *model;/// 数据模型


+ (TUIShortVideoItemCustomCell *)cellWithtableView:(UITableView *)tableView
                                          uiManager:(TUIPlayerShortVideoUIManager *)uiManager ;

@end

NS_ASSUME_NONNULL_END
