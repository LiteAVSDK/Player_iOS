//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
NS_ASSUME_NONNULL_BEGIN
@protocol TUIPSResolutionSwitchViewDelegate <NSObject>

- (void)switchWithResolution:(long)resolution
                       index:(NSInteger)index;

@end
@interface TUIPSResolutionSwitchView : UIView

@property (nonatomic, weak) id <TUIPSResolutionSwitchViewDelegate> delegate;
@property (nonatomic, strong) NSArray <TUIPlayerBitrateItem *>*resolutionArray;
@property (nonatomic, assign) NSInteger currentIndex;
@end

NS_ASSUME_NONNULL_END
