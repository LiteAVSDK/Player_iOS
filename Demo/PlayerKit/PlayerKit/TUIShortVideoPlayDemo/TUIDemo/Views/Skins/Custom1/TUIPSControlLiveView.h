//
//  TUIPSControlLiveView.h
//  TUIPlayerShortVideoDemo
//
//  Created by hefeima on 2024/1/18.
//

#import <UIKit/UIKit.h>
#import <TUIPlayerShortVideo/TUIPlayerShortVideo-umbrella.h>
NS_ASSUME_NONNULL_BEGIN

@interface TUIPSControlLiveView : UIView <TUIPlayerShortVideoLiveControl>
@property (nonatomic, strong) TUIPlayerLiveModel *model; ///当前播放的视频模型

@end

NS_ASSUME_NONNULL_END
