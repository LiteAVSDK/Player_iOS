//
//  FeedPlayViewController.h
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerKitCommonHeaders.h"
NS_ASSUME_NONNULL_BEGIN

@interface FeedPlayViewController : UIViewController

@end
///全屏窗口
@interface FeedBaseFullScreenViewController : UIViewController
///视频窗口
@property (nonatomic, strong) SuperPlayerView *playerView;
@end
NS_ASSUME_NONNULL_END
