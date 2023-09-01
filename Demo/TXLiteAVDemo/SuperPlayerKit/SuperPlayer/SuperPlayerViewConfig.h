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
@property(nonatomic, assign) BOOL hwAcceleration;
/// Whether to automatically enable picture-in-picture in the backstage,
/// the default is NO
/// 退后台是否自动开启画中画，默认NO
@property(nonatomic, assign) BOOL pipAutomatic;
/// Play speed, default 1.0
/// 播放速度，默认1.0
@property CGFloat playRate;
/// 是否静音，默认NO
@property BOOL mute;
/// 填充模式，默认铺满。 参见 TXLiveSDKTypeDef.h
@property NSInteger renderMode;
/// http头，跟进情况自行设置
@property NSDictionary *headers;
/// 播放器最大缓存个数
@property(nonatomic) NSInteger maxCacheItem __attribute__((deprecated("This property is obsolete and the setting is invalid")));
///设置播放器最大缓存的Cache Size大小（单位MB）,默认500MB
///设置后会根据设定值自动清理Cache目录的文件
@property(nonatomic, assign)NSInteger maxCacheSizeMB;
/// 时移域名，默认为playtimeshift.live.myqcloud.com
@property NSString *playShiftDomain;
/// log打印
@property BOOL enableLog;
@end
