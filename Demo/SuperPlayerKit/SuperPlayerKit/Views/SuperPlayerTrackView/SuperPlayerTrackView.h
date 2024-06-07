//
//  SuperPlayerTrackView.h
//  SuperPlayer-Player
//
//  Created by 路鹏 on 2022/10/11.
//  Copyright © 2022 Tencent. All rights reserved.

#import <UIKit/UIKit.h>
@class TXTrackInfo;

NS_ASSUME_NONNULL_BEGIN

@protocol SuperPlayerTrackViewDelegate <NSObject>

- (void)chooseTrackInfo:(TXTrackInfo *)info preTrackInfo:(TXTrackInfo *)preInfo;

@end

@interface SuperPlayerTrackView : UIView

@property (nonatomic, weak)   id<SuperPlayerTrackViewDelegate> delegate;

- (void)initTrackViewWithTrackArray:(NSMutableArray<TXTrackInfo *> *)trackArray currentTrackIndex:(NSInteger)currentTrackIndex;

@end

NS_ASSUME_NONNULL_END
