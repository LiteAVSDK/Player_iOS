// Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUIPlayerShortVideoCustomControl.h"
NS_ASSUME_NONNULL_BEGIN

@interface TUIPlayerShortVideoPlaceholderCustomControlView : UIView <TUIPlayerShortVideoCustomControl>
@property (nonatomic, weak) id<TUIPlayerShortVideoCustomControlDelegate>delegate; ///代理
@property (nonatomic, strong) TUIPlayerDataModel *model; ///当前页面数据模型


- (void)reloadControlData;
@end

NS_ASSUME_NONNULL_END
