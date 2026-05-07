//  Copyright (c) 2023 Tencent. All rights reserved.

#import <UIKit/UIKit.h>
#import <TUIPlayerShortVideo/TUIPlayerShortVideo-umbrella.h>
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
NS_ASSUME_NONNULL_BEGIN

@interface TUIPSControlView : UIView<TUIPlayerShortVideoControl>
@property (nonatomic, strong) TUIPlayerVideoModel *model; ///当前播放的视频模型
///当前播放器的播放状态
@property (nonatomic, assign) TUITXVodPlayerStatus currentPlayerStatus;
@end

NS_ASSUME_NONNULL_END
