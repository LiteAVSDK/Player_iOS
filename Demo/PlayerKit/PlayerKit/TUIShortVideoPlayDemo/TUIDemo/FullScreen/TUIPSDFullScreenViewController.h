//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
NS_ASSUME_NONNULL_BEGIN
@protocol TUIPSDFullScreenViewControllerDelegate <NSObject>
- (void)viewControllerDismissed;
@optional
- (void)pause;
- (void)resume;
@end
@interface TUIPSDFullScreenViewController : UIViewController
@property (nonatomic, weak) id<TUIPSDFullScreenViewControllerDelegate> delegate;
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, weak) TUITXVodPlayer *vodPlayer;
@property (nonatomic, weak) TUITXLivePlayer *livePlayer;
@property (nonatomic, assign) NSInteger type; ///1  点播 2直播
@end

NS_ASSUME_NONNULL_END
