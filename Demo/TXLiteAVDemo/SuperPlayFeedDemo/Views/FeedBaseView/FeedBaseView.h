//
//  FeedBaseView.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperPlayer.h"
#import "FeedHeadView.h"

#import "FeedVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FeedBaseViewDelegate <NSObject>

/**
 点击进入详情页的Click
*/
- (void)headViewClick;

/**
 视频播放开始
*/
- (void)superPlayerDidStart;
/**
 全屏
 */
- (void)showFullScreenViewWithPlayView:(SuperPlayerView *)superPlayerView;
///屏幕旋转
- (void)screenRotation:(BOOL)fullScreen;

@end

@interface FeedBaseView : UIView

@property (nonatomic, weak)   id<FeedBaseViewDelegate>  delegate;

@property (nonatomic, strong, nullable) SuperPlayerView           *superPlayView;

@property (nonatomic, strong) FeedHeadView              *headView;

@property (nonatomic, strong) FeedVideoModel            *model;

/**
 * 预加载
*/
- (void)prepare;

/**
 * 暂停
*/
- (void)pause;

/**
 * 播放
*/
- (void)resume;

/**
 * 移除视频
*/
- (void)removeVideo;

/**
 * 重置player
 */
- (void)resetPlayer;

/**
 * 添加播放器view
 * @param view               播放器view
*/
- (void)addSuperPlayView:(UIView *)view;

@end


NS_ASSUME_NONNULL_END
