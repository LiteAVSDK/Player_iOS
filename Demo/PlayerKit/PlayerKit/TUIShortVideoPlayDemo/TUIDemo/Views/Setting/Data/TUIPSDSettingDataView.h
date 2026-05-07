//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TUIPSDSettingDataViewDelegate <NSObject>

- (void)removeButtonClickAction:(NSString *)paramStr;
- (void)addButtonClickAction:(NSString *)paramStr;
- (void)replaceButtonClickAction:(NSString *)paramStr;

@end

@interface TUIPSDSettingDataView : UIView

@property (nonatomic, weak)id <TUIPSDSettingDataViewDelegate> delegate;
- (void)registKeyboard;
@end

NS_ASSUME_NONNULL_END
