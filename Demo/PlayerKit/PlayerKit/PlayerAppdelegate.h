//
//  PlayerAppdelegate.h
//  PlayerKit
//
//  Created by hefeima on 2023/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerAppdelegate : UIResponder<UIApplicationDelegate>
///页面支持的旋转方向
@property(nonatomic, assign)UIInterfaceOrientationMask interfaceOrientationMask;
@end

NS_ASSUME_NONNULL_END
