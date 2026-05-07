//
//  TUIPSControlCustomView.h
//  TUIPlayerShortVideoDemo
//
//  Created by hefeima on 2024/1/18.
//

#import <UIKit/UIKit.h>
#import <TUIPlayerShortVideo/TUIPlayerShortVideo-umbrella.h>
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
NS_ASSUME_NONNULL_BEGIN

@interface TUIPSControlCustomView : UIView <TUIPlayerShortVideoCustomControl>
@property (nonatomic, strong) TUIPlayerDataModel *model; ///当前播放的视频模型

@end

NS_ASSUME_NONNULL_END
