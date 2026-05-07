// Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUIPlayerShortVideoLiveControl.h"
NS_ASSUME_NONNULL_BEGIN

@interface TUIPlayerShortVideoPlaceholderLiveControlView : UIView <TUIPlayerShortVideoLiveControl>
@property (nonatomic, weak) id<TUIPlayerShortVideoLiveControlDelegate>delegate; ///代理
@property (nonatomic, strong) TUIPlayerLiveModel *model; ///当前播放的视频模型


- (void)reloadControlData;
@end

NS_ASSUME_NONNULL_END
