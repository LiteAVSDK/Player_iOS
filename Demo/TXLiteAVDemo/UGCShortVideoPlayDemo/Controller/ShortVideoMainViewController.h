//
//  ShortVideoMainViewController.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/9/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXVideoUtils.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^GetVideoDataBlock)(NSMutableArray *videoArray);

@interface ShortVideoMainViewController : UIViewController

@property (nonatomic, copy)   GetVideoDataBlock videoDataBlock;

@property (nonatomic, assign) NSInteger videoCount;

@property (nonatomic, assign) TXVideoPlayMode         playmode;

- (void)pause;

- (void)resume;

- (void)jumpToCellWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
