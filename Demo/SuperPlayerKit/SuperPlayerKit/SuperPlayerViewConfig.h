//
//  SuperPlayerViewConfig.h
//  SuperPlayer
//
//  Created by annidyfeng on 2018/10/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SuperPlayerViewConfig : NSObject
/// Whether to mirror, the default is NO
/// 是否镜像，默认NO
@property BOOL mirror;
/// Whether hardware acceleration, default YES
/// 是否硬件加速，默认YES
@property(nonatomic, assign) BOOL hwAcceleration;
/// /// Whether to automatically enable picture-in-picture in the backstage,
/// the default is NO
/// 退后台是否自动开启画中画，默认NO
@property(nonatomic, assign) BOOL pipAutomatic;
/// Play speed, default 1.0
/// 播放速度，默认1.0
@property CGFloat playRate;
/// Whether to mute, default NO
/// 是否静音，默认NO
@property BOOL mute;
/// Filling mode, the default is full. See TXLiveSDKTypeDef.h
/// 填充模式，默认铺满。 参见 TXLiveSDKTypeDef.h
@property NSInteger renderMode;
/// http header, follow up the situation and set it yourself
/// http头，跟进情况自行设置
@property NSDictionary *headers;
/// The maximum number of buffers for the player
/// 播放器最大缓存个数
@property(nonatomic) NSInteger maxCacheItem __attribute__((deprecated("This property is obsolete and the setting is invalid")));
///Set the Cache Size of the player's maximum cache (in MB), the default is 500MB
///After setting, the files in the Cache directory will be automatically cleaned up according to the set value
///设置播放器最大缓存的Cache Size大小（单位MB）,默认500MB
///设置后会根据设定值自动清理Cache目录的文件
@property(nonatomic, assign)NSInteger maxCacheSizeMB;
/// Time shift domain name, the default is playtimeshift.live.myqcloud.com
/// 时移域名，默认为playtimeshift.live.myqcloud.com
@property NSString *playShiftDomain;
/// log print
/// log打印
@property BOOL enableLog;
@end
