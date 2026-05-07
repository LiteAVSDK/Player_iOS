//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
NS_ASSUME_NONNULL_BEGIN
@protocol TUIPSDLiveRoomViewControllerDelegate <NSObject>
- (void)viewControllerDismissed;
@optional
- (void)pause;
- (void)resume;
@end
@interface TUIPSDLiveRoomViewController : UIViewController
@property (nonatomic, weak) id<TUIPSDLiveRoomViewControllerDelegate> delegate;
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, assign) CGRect videoLayoutRect;
@property (nonatomic, weak) TUITXLivePlayer *livePlayer;
@end

NS_ASSUME_NONNULL_END
