// Copyright (c) 2023 Tencent. All rights reserved.
// 短视频时间戳控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface TUIShortVideoTimeView : UIView

/**
 *  设置显示的播放时长和视频总时长
 *  @param time  需要label显示的字符串
 */
- (void)setShortVideoTimeLabel:(NSString *)time;

@end

NS_ASSUME_NONNULL_END
