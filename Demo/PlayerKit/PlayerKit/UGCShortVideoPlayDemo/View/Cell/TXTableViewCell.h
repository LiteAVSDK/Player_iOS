//
//  TXTableViewCell.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/9/10.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXVideoModel.h"
#import "TXVideoPlayer.h"
#import "TXVideoBaseView.h"
#import "TXVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TXTableViewCell;

@protocol TXTableViewCellDelegate <NSObject>

/**
点击手势的处理
@param cell   TXTableViewCell类
*/
- (void)controlViewDidClickSelf:(TXTableViewCell *)cell;

/**
滑动滚动条的处理
@param time   滑动的距离
*/
- (void)seekToTime:(float)time;

@end

@interface TXTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TXTableViewCellDelegate> delegate;

@property (nonatomic, strong) TXVideoBaseView *baseView;

@property (nonatomic, strong) TXVideoModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)setProgress:(float)progress;

- (void)setTXtimeLabel:(NSString *)time;

- (void)startLoading;

- (void)stopLoading;

- (void)showPlayBtn;

- (void)hidePlayBtn;

@end

NS_ASSUME_NONNULL_END
