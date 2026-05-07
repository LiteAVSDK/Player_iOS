//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TUIPADConfigSettingButton : UIControl

@property (nonatomic, strong) NSString *currentSelected;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSArray <NSString *> *options;
@property (nonatomic, copy) void (^selectedCallBack)(NSString *currentSelected);
@end

NS_ASSUME_NONNULL_END
