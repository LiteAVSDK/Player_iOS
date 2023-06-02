//
//  FeedTableViewCell.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/10/29.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedBaseView.h"
#import "FeedVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FeedCellStyle) {
    FeedUnreachCellStyleUp   = 1,    // 顶部不可及
    FeedUnreachCellStyleDown = 2,    // 底部不可及
    FeedUnreachCellStyleNone = 3,    // 播放滑动可及cell
};

@class FeedTableViewCell;

@protocol FeedTableViewCellDelegate <NSObject>
@optional
/**
 点击进入详情页的Click
*/
- (void)headViewClickWithCell:(FeedTableViewCell *)cell;

/**
 视频播放开始
*/
- (void)superPlayerDidStartWithCell:(FeedTableViewCell *)cell;
/**
 全屏
 */
- (void)showFullScreenViewWithPlayView:(SuperPlayerView *)superPlayerView cell:(FeedTableViewCell *)cell;
///屏幕旋转
- (void)screenRotation:(BOOL)fullScreen;
@end

@interface FeedTableViewCell : UITableViewCell

@property (nonatomic, weak)   id<FeedTableViewCellDelegate>  delegate;

@property (nonatomic, strong) FeedBaseView                   *baseView;

@property (nonatomic, strong) FeedVideoModel                 *model;

@property (nonatomic, assign) FeedCellStyle                  cellStyle;

@property (nonatomic, strong) NSIndexPath                    *indexPath;

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
- (void)playVideo;

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
