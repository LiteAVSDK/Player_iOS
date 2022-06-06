//
//  VideoCacheView.h
//  Pods
//
//  Created by 路鹏 on 2022/2/17.
//  Copyright © 2022年 Tencent. All rights reserved.

#import <UIKit/UIKit.h>
#import "SuperPlayerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoCacheView : UIView

- (void)setVideoModels:(NSArray *)models currentPlayingModel:(SuperPlayerModel *)currentModel;

@end

NS_ASSUME_NONNULL_END
