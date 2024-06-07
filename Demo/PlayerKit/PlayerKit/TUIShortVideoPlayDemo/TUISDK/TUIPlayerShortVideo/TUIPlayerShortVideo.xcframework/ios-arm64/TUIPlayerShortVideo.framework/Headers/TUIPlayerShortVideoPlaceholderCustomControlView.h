// Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUIPlayerShortVideoCustomControl.h"
NS_ASSUME_NONNULL_BEGIN

@interface TUIPlayerShortVideoPlaceholderCustomControlView : UIView <TUIPlayerShortVideoCustomControl>
@property (nonatomic, weak) id<TUIPlayerShortVideoCustomControlDelegate>delegate; ///代理
@property (nonatomic, strong) TUIPlayerVideoModel *videoModel; ///当前播放的视频模型


- (void)reloadControlData;
@end

NS_ASSUME_NONNULL_END
