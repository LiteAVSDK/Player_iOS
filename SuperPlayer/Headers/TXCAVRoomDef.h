//
//  TXCAVRoomDef.h
//  TXLiteAVSDK
//
//  Created by lijie on 2017/7/26.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 音视频通话的通话能力权限位。
typedef NS_ENUM(NSInteger, TXEAVRoomAuthBits) {
    AVROOM_AUTH_BITS_DEFAULT             = -1,         ///< 所有权限
    AVROOM_AUTH_BITS_CREATE_ROOM         = 0x00000001, ///< 创建房间权限。
    AVROOM_AUTH_BITS_JOIN_ROOM           = 0x00000002, ///< 加入房间的权限。
    AVROOM_AUTH_BITS_SEND_AUDIO          = 0x00000004, ///< 发送音频的权限。
    AVROOM_AUTH_BITS_RECV_AUDIO          = 0x00000008, ///< 接收音频的权限。
    AVROOM_AUTH_BITS_SEND_CAMERA_VIDEO   = 0x00000010, ///< 发送摄像头视频(也就是来至摄像头设备AVCameraDevice或外部视频捕获设备AVExternalCapture的视频)的权限。
    AVROOM_AUTH_BITS_RECV_CAMERA_VIDEO   = 0x00000020, ///< 接收摄像头视频(也就是来至摄像头设备AVCameraDevice或外部视频捕获设备AVExternalCapture的视频)的权限。
    AVROOM_AUTH_BITS_SEND_SCREEN_VIDEO   = 0x00000040, ///< 发送屏幕视频(也就是捕获计算机屏幕画面所得到的视频)的权限。
    AVROOM_AUTH_BITS_RECV_SCREEN_VIDEO   = 0x00000080, ///< 接收屏幕视频(也就是捕获计算机屏幕画面所得到的视频)的权限。
};


// 进房参数
@interface TXCAVRoomParam : NSObject

@property (nonatomic, assign) UInt32            roomID;
@property (nonatomic, assign) TXEAVRoomAuthBits authBits;
@property (nonatomic, strong) NSData*           authBuffer;

@end


typedef NS_ENUM(NSInteger, TXEAVRoomEventID) {
    /*
     * 房间事件
     */
    AVROOM_EVT_REQUEST_IP_SUCC                     = 1001,    // 拉取接口机服务器地址成功
    AVROOM_EVT_CONNECT_SUCC                        = 1002,    // 连接接口机服务器成功
    AVROOM_EVT_ENTER_ROOM_SUCC                     = 1003,    // 进入房间成功
    AVROOM_EVT_EXIT_ROOM_SUCC                      = 1004,    // 退出房间成功
    AVROOM_EVT_REQUEST_AVSEAT_SUCC                 = 1005,    // 请求视频位成功
    
    
    AVROOM_ERR_REQUEST_IP_FAIL                     = -1001,   // 拉取接口机服务器地址失败
    AVROOM_ERR_CONNECT_FAILE                       = -1002,   // 连接接口机服务器失败
    AVROOM_ERR_ENTER_ROOM_FAIL                     = -1003,   // 进入房间失败
    AVROOM_ERR_EXIT_ROOM_FAIL                      = -1004,   // 退出房间失败
    AVROOM_ERR_REQUEST_AVSEAT_FAIL                 = -1005,   // 请求视频位失败
    
    
    
    /*
     * 网络事件
     */
    AVROOM_WARNING_DISCONNECT                      = 2001,    // 网络断开连接
    AVROOM_WARNING_RECONNECT                       = 2002,    // 网络断连, 已启动自动重连
    AVROOM_WARNING_NET_BUSY                        = 2003,    // 网络状况不佳：上行带宽太小，上传数据受阻

    
    
    /*
     * 上行音视频事件
     */
    AVROOM_EVT_OPEN_CAMERA_SUCC                    = 3001,    // 打开摄像头成功
    AVROOM_EVT_START_VIDEO_ENCODER                 = 3002,    // 编码器启动
    AVROOM_EVT_UP_CHANGE_RESOLUTION		           = 3003,	  // 视频上行分辨率改变
    AVROOM_EVT_UP_CHANGE_BITRATE                   = 3004,    // 视频上行动态调整码率
    AVROOM_EVT_FIRST_FRAME_AVAILABLE               = 3005,    // 首帧画面采集完成
    
    AVROOM_WARNING_HW_ACCELERATION_ENCODE_FAIL     = 3101,    // 硬编码启动失败，采用软编码
    
    
    AVROOM_ERR_OPEN_CAMERA_FAIL                    = -3001,   // 打开摄像头失败
    AVROOM_ERR_OPEN_MIC_FAIL                       = -3002,   // 打开麦克风失败
    AVROOM_ERR_VIDEO_ENCODE_FAIL                   = -3003,   // 视频编码失败
    AVROOM_ERR_AUDIO_ENCODE_FAIL                   = -3004,   // 音频编码失败
    AVROOM_ERR_UNSUPPORTED_RESOLUTION              = -3005,   // 不支持的视频分辨率
    AVROOM_ERR_UNSUPPORTED_SAMPLERATE              = -3006,   // 不支持的音频采样率
    
    
    
    /*
     * 下行音视频事件
     */
    AVROOM_EVT_RCV_FIRST_I_FRAME                   = 4001,    // 渲染首个视频数据包(IDR)
    AVROOM_EVT_PLAY_BEGIN                          = 4002,    // 视频播放开始
    AVROOM_EVT_PLAY_LOADING			               = 4003,    // 视频播放loading
    AVROOM_EVT_START_VIDEO_DECODER                 = 4004,    // 解码器启动
    AVROOM_EVT_DOWN_CHANGE_RESOLUTION		       = 4005,	  // 视频下行分辨率改变

    
    AVROOM_WARNING_VIDEO_DECODE_FAIL               = 4101,    // 当前视频帧解码失败
    AVROOM_WARNING_AUDIO_DECODE_FAIL               = 4102,    // 当前音频帧解码失败
    AVROOM_WARNING_HW_ACCELERATION_DECODE_FAIL     = 4103,    // 硬解启动失败，采用软解
    AVROOM_WARNING_VIDEO_PLAY_LAG                  = 4104,    // 当前视频播放出现卡顿（用户直观感受）

};

// 声音播放模式
typedef NS_ENUM(NSInteger, TXEAVRoomAudioMode) {
    AVROOM_AUDIO_MODE_SPEAKER  =   0,      //扬声器
    AVROOM_AUDIO_MODE_RECEIVER =   1,      //听筒
};

// 视频分辨率比例
typedef NS_ENUM(NSInteger, TXEAVRoomVideoAspect) {
    AVROOM_VIDEO_ASPECT_9_16   =  1,   // 视频分辨率为9:16或者16:9
    AVROOM_VIDEO_ASPECT_3_4    =  2,   // 视频分辨率为3:4 或者4:3
    AVROOM_VIDEO_ASPECT_1_1    =  3,   // 视频分辨率为1:1
};

// Home键的方向
typedef NS_ENUM(NSInteger, TXEAVRoomHomeOrientation) {
    AVROOM_HOME_ORIENTATION_RIGHT  = 0,        // home在右边
    AVROOM_HOME_ORIENTATION_DOWN,              // home在下面
    AVROOM_HOME_ORIENTATION_LEFT,              // home在左边
    AVROOM_HOME_ORIENTATION_UP,                // home在上面
};

// 渲染模式
typedef NS_ENUM(NSInteger, TXEAVRoomRenderMode) {
    AVROOM_RENDER_MODE_FILL_SCREEN  = 0,      // 图像铺满屏幕
    AVROOM_RENDER_MODE_FILL_EDGE              // 图像长边填满屏幕
};


// 状态键名定义
#define NET_STATUS_USER_ID                          @"USER_ID"
#define NET_STATUS_CPU_USAGE                        @"CPU_USAGE"        // cpu使用率
#define NET_STATUS_CPU_USAGE_D                      @"CPU_USAGE_DEVICE" // 设备总CPU占用
#define NET_STATUS_VIDEO_BITRATE                    @"VIDEO_BITRATE"    // 当前视频编码器输出的比特率，也就是编码器每秒生产了多少视频数据，单位 kbps
#define NET_STATUS_AUDIO_BITRATE                    @"AUDIO_BITRATE"    // 当前音频编码器输出的比特率，也就是编码器每秒生产了多少音频数据，单位 kbps
#define NET_STATUS_VIDEO_FPS                        @"VIDEO_FPS"        // 当前视频帧率，也就是视频编码器每条生产了多少帧画面
#define NET_STATUS_VIDEO_GOP                        @"VIDEO_GOP"        // 当前视频GOP,也就是每两个关键帧(I帧)间隔时长，单位s
#define NET_STATUS_NET_SPEED                        @"NET_SPEED"        // 当前的发送速度
#define NET_STATUS_NET_JITTER                       @"NET_JITTER"       // 网络抖动情况，抖动越大，网络越不稳定
#define NET_STATUS_CACHE_SIZE                       @"CACHE_SIZE"       // 缓冲区大小，缓冲区越大，说明当前上行带宽不足以消费掉已经生产的视频数据
#define NET_STATUS_DROP_SIZE                        @"DROP_SIZE"
#define NET_STATUS_VIDEO_WIDTH                      @"VIDEO_WIDTH"
#define NET_STATUS_VIDEO_HEIGHT                     @"VIDEO_HEIGHT"
#define NET_STATUS_SERVER_IP                        @"SERVER_IP"
#define NET_STATUS_CODEC_CACHE                      @"CODEC_CACHE"      //编解码缓冲大小
#define NET_STATUS_CODEC_DROP_CNT                   @"CODEC_DROP_CNT"   //编解码队列DROPCNT
#define NET_STATUS_VIDEO_CACHE_SIZE                 @"VIDEO_CACHE_SIZE" // 视频缓冲帧数 （包括jitterbuffer和解码器两部分缓冲）
#define NET_STATUS_V_DEC_CACHE_SIZE                 @"V_DEC_CACHE_SIZE" // 视频解码器缓冲帧数
#define NET_STATUS_AV_PLAY_INTERVAL                 @"AV_PLAY_INTERVAL"  //视频当前渲染帧的timestamp和音频当前播放帧的timestamp的差值，标示当时音画同步的状态
#define NET_STATUS_AV_RECV_INTERVAL                 @"AV_RECV_INTERVAL"  //jitterbuffer最新收到的视频帧和音频帧的timestamp的差值，标示当时jitterbuffer收包同步的状态
#define NET_STATUS_AUDIO_PLAY_SPEED                 @"AUDIO_PLAY_SPEED"  //jitterbuffer当前的播放速度
#define NET_STATUS_AUDIO_INFO                       @"AUDIO_INFO"
#define NET_STATUS_SET_VIDEO_BITRATE                @"SET_VIDEO_BITRATE"


#define EVT_MSG                                     @"EVT_MSG"
#define EVT_TIME                                    @"EVT_TIME"
