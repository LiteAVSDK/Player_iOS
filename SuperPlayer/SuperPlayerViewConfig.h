//
//  SuperPlayerViewConfig.h
//  SuperPlayer
//
//  Created by annidyfeng on 2018/10/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SuperPlayerViewConfig : NSObject
/// 是否镜像，默认NO
@property BOOL mirror;
/// 是否硬件加速，默认YES
@property BOOL hwAcceleration;
@property BOOL hwAccelerationChanged;
/// 播放速度，默认1.0
@property CGFloat playRate;
/// 是否静音，默认NO
@property BOOL mute;
/// 填充模式，默认铺满。 参见 TXLiveSDKTypeDef.h
@property NSInteger renderMode;
@end
