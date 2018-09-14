#import <Foundation/NSObject.h>
#import <UIKit/UIKit.h>


@interface TXCAVRoomConfig : NSObject

// 开启视频硬件加速
@property(nonatomic, assign) BOOL enableVideoHWAcceleration;

// 开启音频硬件加速
@property(nonatomic, assign) BOOL enableAudioHWAcceleration;

// home键所在方向，用来切换横竖屏推流，取值设置为枚举值: TXEAVRoomHomeOrientation
@property(nonatomic, assign) int homeOrientation;

// 视频的渲染模式，取值设置为枚举值: TXEAVRoomRenderMode
@property(nonatomic, assign) int renderMode;

// 视频采集帧率
@property(nonatomic, assign) int videoFPS;

// 视频上行码率
@property(nonatomic, assign) int videoBitrate;

// 视频分辨率的比例，取值设置为枚举值:TXEAVRoomVideoAspect，默认是9:16
@property(nonatomic, assign) int videoAspect;

// 是否前置camera
@property(nonatomic, assign) BOOL frontCamera;

// 后台推流帧率，最小值为1，最大值为20，默认5
@property(nonatomic, assign) int pauseFps;

// 后台推流图片，图片最大尺寸不能超过1920*1920
@property(nonatomic, strong) UIImage *pauseImg;

// 是否纯音频推流，默认为NO
@property(nonatomic, assign) BOOL enablePureAudioPush;

@end
