//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TUIPSDSettingViewDelegate <NSObject>

- (void)confirmActionVodResumeModel:(NSString *)resumeModel
                          loopModel:(NSString *)loopModel
                 audioNormalization:(NSString *)audioNormalization
                superResolutionType:(NSString *)superResolutionType
                           rendMode:(NSString *)rendMode;
- (void)confirmActionLivePip:(NSString *)pip
                    rendMode:(NSString *)rendMode;
- (void)removeButtonClickAction:(NSArray *)params;
- (void)addButtonClickAction:(NSArray *)params;
- (void)replaceButtonClickAction:(NSArray *)params;
- (void)closeAction;

/// test
- (void)test;
@end

@interface TUIPSDSettingView : UIView

@property (nonatomic, weak)id <TUIPSDSettingViewDelegate>delegate;

+ (instancetype)sharedInstance;
- (void)show:(UIView *)view delegate:(id)delegate;
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
