#import <Foundation/NSObject.h>
#import <UIKit/UIKit.h>
#import "TXLiveSDKTypeDef.h"

#define CUSTOM_MODE_AUDIO_CAPTURE                   0X001   //客户自定义音频采集
#define CUSTOM_MODE_VIDEO_CAPTURE                   0X002   //客户自定义视频采集
#define CUSTOM_MODE_AUDIO_PREPROCESS                0X004   //客户自定义音频预处理逻辑
#define CUSTOM_MODE_VIDEO_PREPROCESS                0X008   //客户自定义视频预处理逻辑


#define TXRTMPSDK_LINKMIC_STREAMTYPE_MAIN           1       //连麦模式下主播的流
#define TXRTMPSDK_LINKMIC_STREAMTYPE_SUB            2       //连麦模式下连麦观众的流

@interface TXLivePushConfig : NSObject

// 客户自定义模式
@property(nonatomic, assign) int customModeType;

// 美颜强度 0 ~ 9, 默认值为0
@property(nonatomic, assign) float beautyFilterDepth;

// 美白强度:0 ~ 9, 默认值为0
@property(nonatomic, assign) float whiteningFilterDepth;

// 开启硬件加速, iOS系统版本>8.0 默认开启
@property(nonatomic, assign) BOOL enableHWAcceleration;

/* home键所在方向，用来切换横竖屏推流（tips：此参数的设置可能会改变推流端本地视频流方向，此参数设置后，请调用TXLivePush 里的setRenderRotation 来修正推流端本地视频流方向，具体请参考demo设置 ）,默认值为HOME_ORIENTATION_DOWN
* 1,homeOrientation=HOME_ORIENTATION_RIGHT Home键在下竖屏推流
* 2,homeOrientation=HOME_ORIENTATION_RIGHT Home键在右横屏推流
* 3.homeOrientation=HOME_ORIENTATION_LEFT  Home键在左横屏推流
*/
@property(nonatomic, assign) int homeOrientation;

// 视频采集帧率, 默认值为15
@property(nonatomic, assign) int videoFPS;

// 视频分辨率, 默认值为VIDEO_RESOLUTION_TYPE_360_640
@property(nonatomic, assign) int videoResolution;

// 视频固定码率，默认值为700
@property(nonatomic, assign) int videoBitratePIN;

// 视频编码GOP，单位second 秒， 默认值为3
@property(nonatomic, assign) int videoEncodeGop;

// 音频采样率 , 取值设置为 枚举值 TX_Enum_Type_AudioSampleRate，也可直接设置为对应的采样率 ，比如 audioSampleRate = AUDIO_SAMPLE_RATE_48000 或  audioSampleRate = 48000, 默认值为AUDIO_SAMPLE_RATE_48000
@property(nonatomic, assign) int audioSampleRate;

// 音频声道数, 默认值为1
@property(nonatomic, assign) int audioChannels;

// 码率自适应: SDK会根据网络情况自动调节视频码率, 调节范围在 (videoBitrateMin - videoBitrateMax)， 默认值为NO
@property(nonatomic, assign) BOOL enableAutoBitrate;
//

// 码率自适应: SDK会根据网络情况自动调节视频码率，同时自动调整分辨率, 默认值为AUTO_ADJUST_BITRATE_STRATEGY_1
@property(nonatomic, assign) int autoAdjustStrategy;

// 视频最大码率，仅当enableAutoBitrate = YES时有效， 默认值为1000
@property(nonatomic, assign) int videoBitrateMax;

// 视频最小码率，仅当enableAutoBitrate = YES时有效， 默认值为400
@property(nonatomic, assign) int videoBitrateMin;

// 噪音抑制, 默认值为YES
@property(nonatomic, assign) BOOL enableNAS;

// 是否前置camera, 默认值为YES
@property(nonatomic, assign) BOOL frontCamera;

// 是否允许点击曝光聚焦, 默认为YES
@property(nonatomic, assign) BOOL touchFocus;

// 是否允许双指手势放大预览画面，默认为NO
@property(nonatomic, assign) BOOL enableZoom;

//推流器连接重试次数 : 最小值为 1， 最大值为 10, 默认值为 3
@property(nonatomic, assign) int connectRetryCount;

//推流器连接重试间隔 : 单位秒，最小值为 3, 最大值为 30， 默认值为 3
@property(nonatomic, assign) int connectRetryInterval;

//设置水印图片. 设为nil等同于关闭水印
@property(nonatomic, retain) UIImage *watermark;

//设置水印图片位置，水印大小为图片实际大小
@property(nonatomic, assign) CGPoint watermarkPos;

/**
 * @desc 水印相对于推流分辨率的归一化坐标，x,y,width,height 取值范围 0~1；height不用设置，sdk内部会根据水印宽高比自动计算height；
 * eg: 推流分辨率为（540，960） watermarkNormalization设置为（0.1，0.1，0.1,0）,水印的实际像素坐标为（540 * 0.1，960 * 0.1，540 * 0.1 ，540 *
   0.1 * waterMark.size.height / waterMark.size.width）
 * @note watermarkNormalization坐标与watermarkPos坐标只能设置一种，如果设置了watermarkNormalization则优先使用归一化坐标
 */
@property(nonatomic, assign) CGRect watermarkNormalization;

/**
 *  视频预处理Hook
 */
@property(nonatomic, assign) PVideoProcessHookFunc pVideoFuncPtr;

/**
 *  音频预处理Hook
 */
@property(nonatomic, assign) PAudioProcessHookFunc pAudioFuncPtr;

/**
 * 发送自定义CMSampleBuffer的输出分辨率
 * 当设置此属性时，videoResolution自动失效
 * @warn 此值设置需与源SampleBuffer的画面比例一致，否则会引起画面变形
 * @warn 调用sendVideoSampleBuffer必须设置此值，或者设置autoSampleBufferSize＝YES
 */
@property(assign) CGSize sampleBufferSize;

/**
 * 设置YES时，调用sendVideoSampleBuffer输出分辨率等于输入分辨率, 默认值为NO
 */
@property BOOL autoSampleBufferSize;

// 开启音频硬件加速， 默认值为YES
@property(nonatomic, assign) BOOL enableAudioAcceleration;

/**
 *  后台推流时长，单位秒，默认300秒
 */
@property(nonatomic, assign) int pauseTime;
/**
 *  后台推流帧率，最小值为3，最大值为8，默认5
 */
@property(nonatomic, assign) int pauseFps;
/**
 *  后台推流图片,图片最大尺寸不能超过1920*1920
 */
@property(nonatomic, retain) UIImage *pauseImg;

/**
 *  是否开启回声消除, 默认值为YES
 */
@property(nonatomic, assign) BOOL enableAEC;

/**
 *  是否开启耳返, 默认值为NO
 */
@property(nonatomic, assign) BOOL enableAudioPreview;

/**
 *  是否纯音频推流, 默认值为NO
 */
@property(nonatomic, assign) BOOL enablePureAudioPush;

/**
 *  是否就近选路， 默认值为YES.
 */
@property(nonatomic, assign) BOOL enableNearestIP;

/**
 *  RTMP传输通道的类型，取值为枚举值：TX_Enum_Type_RTMPChannel， 默认值为RTMP_CHANNEL_TYPE_AUTO
 *  RTMP_CHANNEL_TYPE_AUTO          = 0,    //自动
 *  RTMP_CHANNEL_TYPE_STANDARD      = 1,    //标准的RTMP协议，网络层采用TCP协议
 *  RTMP_CHANNEL_TYPE_PRIVATE       = 2,    //标准的RTMP协议，网络层采用私有通道传输（在UDP上封装的一套可靠快速的传输通道），能够更好地抵抗网络抖动
 
 */
@property (nonatomic, assign) int                       rtmpChannelType;

@end
