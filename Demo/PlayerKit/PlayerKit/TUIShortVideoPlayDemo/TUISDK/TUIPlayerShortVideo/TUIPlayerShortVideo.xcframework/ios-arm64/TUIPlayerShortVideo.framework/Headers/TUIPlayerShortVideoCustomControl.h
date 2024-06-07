// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TUIPlayerVideoModel;
@protocol TUIPlayerShortVideoCustomControlDelegate <NSObject>
@optional
/**
 * 自定义回调事件
 */
- (void)customCallbackEvent:(id)info;
@end

@protocol TUIPlayerShortVideoCustomControl <NSObject>
@required
@property (nonatomic, weak) id<TUIPlayerShortVideoCustomControlDelegate>delegate; ///代理
@property (nonatomic, strong) TUIPlayerVideoModel *videoModel; ///当前播放的视频模型

/**
 * 刷新视图
 */
- (void)reloadControlData;
@end

