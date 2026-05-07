//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TUIPSDLiveRoomControlViewDelegate <NSObject>

- (void)closeAction;
- (void)fullScreenButtonAction;
- (void)commentAction;
@end
@interface TUIPSDLiveRoomControlView : UIView

@property (nonatomic, weak) id <TUIPSDLiveRoomControlViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
