//
//  ShortVideoPlayViewController.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/18.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShortVideoPlayViewController : UIViewController

// 整屏想要显示的视频个数，默认为1，宽度默认为屏幕宽度
@property (nonatomic, assign) NSInteger videoCount;

// 是否需要显示遮罩，默认在第一次进入显示遮罩
@property (nonatomic, assign) BOOL  isShowGuideView;

// 视频播放是否列表循环，默认是
@property (nonatomic, assign) BOOL  isListLoop;

// 播放器缓存个数，默认3个
@property (nonatomic, assign) NSInteger  playerCacheCount;

@end

NS_ASSUME_NONNULL_END
