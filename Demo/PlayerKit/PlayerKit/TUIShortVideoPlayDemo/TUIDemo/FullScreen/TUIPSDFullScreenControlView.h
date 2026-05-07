//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TUIPSDFullScreenControlViewDelegate <NSObject>
- (void)backAction;
- (void)pause;
- (void)resume;
- (void)seekToTime:(float)time;
@end
@interface TUIPSDFullScreenControlView : UIView
@property (nonatomic, weak)id<TUIPSDFullScreenControlViewDelegate>delegate;
- (void)progressViewHidden:(BOOL)hidden;
- (void)setCurrentTime:(float)time;
- (void)setDurationTime:(float)time;
- (void)setProgress:(float)progress;
- (void)setPlayerStatus:(BOOL)isPlay;
@end

NS_ASSUME_NONNULL_END
