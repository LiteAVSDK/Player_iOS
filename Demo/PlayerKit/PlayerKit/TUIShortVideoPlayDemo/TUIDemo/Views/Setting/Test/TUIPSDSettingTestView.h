//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TUIPSDSettingTestViewDelegate <NSObject>

- (void)test;

@end
@interface TUIPSDSettingTestView : UIView
@property (nonatomic, weak)id <TUIPSDSettingTestViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
