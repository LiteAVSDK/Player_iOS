//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
NS_ASSUME_NONNULL_BEGIN
@protocol TUIPSDToolBarDelegate <NSObject>

- (void)switchWithResolution:(long)resolution
                       index:(NSInteger)index;
- (void)preloadPause:(BOOL)isPause;
@end
@interface TUIPSDToolBar : UIView
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, weak) id <TUIPSDToolBarDelegate> delegate;
@property (nonatomic, strong) NSArray <TUIPlayerBitrateItem *>*resolutionArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
