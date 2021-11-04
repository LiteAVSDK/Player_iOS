//
//  TXTimeView.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/9/1.
//  Copyright © 2021 Tencent. All rights reserved.
//  视频播放时长和总时长的显示控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXTimeView : UIView

/**
 *  设置显示的播放时长和总视频总时长
 *
 *  @param time                 需要label显示的字符串
 */
- (void)setTXtimeLabel:(NSString *)time;

@end

NS_ASSUME_NONNULL_END
