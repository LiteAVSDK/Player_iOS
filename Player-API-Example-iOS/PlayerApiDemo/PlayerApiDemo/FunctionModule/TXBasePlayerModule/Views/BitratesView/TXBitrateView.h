//
//  TXBitrateView.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TXLiteAVSDK_Player/TXBitrateItem.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXBitrateViewDelegate <NSObject>

/**
 *  点击分辨率的事件
 */
- (void)onSelectBitrateIndex;

@end

@interface TXBitrateView : UIView

@property (nonatomic, weak) id<TXBitrateViewDelegate> delegate;

// 分辨率数据源
@property (nonatomic, copy) NSArray<TXBitrateItem *>  *dataSource;

// 选中的index
@property (nonatomic, assign) NSInteger  selectedIndex;

// 视频源url
@property (nonatomic, strong) NSString   *videoUrl;

@end

NS_ASSUME_NONNULL_END
