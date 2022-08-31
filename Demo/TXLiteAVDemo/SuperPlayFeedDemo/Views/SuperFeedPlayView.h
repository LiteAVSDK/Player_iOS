//
//  SuperFeedPlayView.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedHeadModel.h"
#import "FeedVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SuperFeedPlayViewDelegate <NSObject>

/**
 下拉刷新的处理
*/
- (void)refreshNewFeedData;

/**
 上拉加载的处理
 @param page   页数
*/
- (void)loadNewFeedDataWithPage:(NSInteger)page;

/**
 显示详情页的处理
*/
- (void)showFeedDetailViewWithHeadModel:(FeedHeadModel *)model videoModel:(FeedVideoModel *)videoModel playView:(UIView *)superPlayView;

@end

@interface SuperFeedPlayView : UIView

@property (nonatomic, weak) id<SuperFeedPlayViewDelegate> delegate;

/**
 * 初始化子组件
*/
- (void)initChildView;

/**
 * 设置数据
 * @param feedData               数据源
 * @param isNeedCleanData         是否清楚原有数据
*/
- (void)setFeedData:(NSArray *)feedData isCleanData:(BOOL)isNeedCleanData;

/**
 * 结束下拉刷新
*/
- (void)finishRefresh;

/**
 * 结束上拉加载
*/
- (void)finishLoadMore;

/**
 * 添加view到cell上
*/
- (void)addSuperPlayView:(UIView *)view;

/**
 * 移除正在播放的视频
*/
- (void)removeVideo;

@end

NS_ASSUME_NONNULL_END
