// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TUIPlayerCore/TUITXLivePlayer.h>
@class TUIPlayerLiveModel;
NS_ASSUME_NONNULL_BEGIN
@protocol TUIPlayerShortVideoLiveControlDelegate <NSObject>

/**
 * 暂停
 */
- (void)pause;

/**
 * 继续播放
 */
- (void)resume;
/**
 * 重置视频播放容器
 * - 用于视频播放容器被移除后需要重置的场景
 */
- (void)resetVideoWeigetContainer;
@optional
/**
 * 自定义回调事件
 */
- (void)customCallbackEvent:(id)info;
@end

@protocol TUIPlayerShortVideoLiveControl <NSObject>
@required
@property (nonatomic, weak) id<TUIPlayerShortVideoLiveControlDelegate>delegate; ///代理
@property (nonatomic, strong) TUIPlayerLiveModel *model; ///当前播放的视频模型

/**
 * 刷新视图
 */
- (void)reloadControlData;



#pragma mark - Player
/**
 * 获取播放器对象
 */
- (void)getPlayer:(TUITXLivePlayer *)player;
/**
 * 获取视频图层区域
 * @param rect 视频图层区域
 */
- (void)getVideoLayerRect:(CGRect)rect;

/**
 * 获取视频渲染图层
 * @param view 视频渲染图层
 */
- (void)getVideoWidget:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
