//
//  TXCAVRoom.h
//  TXLiteAVSDK
//
//  Created by alderzhang on 2017/7/26.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIkit/UIKit.h>
#import "TXCAVRoomDef.h"
#import "TXCAVRoomListener.h"
#import "TXCAVRoomConfig.h"

typedef void (^TXIAVRoomCompletionHandler)(int result);


@interface TXCAVRoom : NSObject

@property(nonatomic, weak) id<TXCAVRoomListener> delegate;

- (instancetype)initWithConfig:(TXCAVRoomConfig *)config andAppId:(UInt32)appID andUserID:(UInt64)userID;
- (instancetype)init __attribute__((unavailable("init not available, call initAppId instead")));

/**
 * getRoomMemberList 返回房间成员列表(userID)
 * 注意：该列表不包括自己
 */
- (NSArray *)getRoomMemberList;

/**
 * getRoomVideoList 返回房间里面正在进行视频推流的用户列表(userID)
 * 注意：该列表不包括自己
 */
- (NSArray *)getRoomVideoList;

/**
 * isInRoom 返回是否已经在房间
 */
- (BOOL)isInRoom;

/**
 * isPushing 返回是否正在推流
 */
- (BOOL)isPushing;

/**
 * enterRoom 进入房间
 */
- (void)enterRoom:(TXCAVRoomParam *)param withCompletion:(TXIAVRoomCompletionHandler)completion;

/**
 * exitRoom 退出房间
 */
- (void)exitRoom:(TXIAVRoomCompletionHandler)completion;

/**
 * startLocalPreview 开启本地视频采集及预览
 */
- (void)startLocalPreview:(UIView *)view;

/**
 * stopLocalPreview 停止本地视频采集及预览
 */
- (void)stopLocalPreview;

/**
 * startRemoteView 播放指定userID的视频
 */
- (void)startRemoteView:(UIView *)view withUserID:(UInt64)userID;

/**
 * stopRemoteView 停止播放指定userID的视频
 */
- (void)stopRemoteView:(UInt64)userID;

/**
 * setRemoteMute 关闭指定userID的声音(将其设置为静音)
 * 注意：当userID为0时，setRemoteMute的设置对所有远端生效
 */
- (void)setRemoteMute:(BOOL)bEnable withUserID:(UInt64)userID;

/**
 * setRenderMode 设置画面的裁剪模式
 * 参数
 *       renderMode : 详见 TXEAVRoomRenderMode 的定义。
 */
- (void)setRenderMode:(TXEAVRoomRenderMode)renderMode;

/**
 * switchCamera 切换前后摄像头
 */
- (void)switchCamera;

/**
 * isMirror YES：播放端看到的是镜像画面   NO：播放端看到的是非镜像画面
 * (tips：推流端前置摄像头默认看到的是镜像画面，后置摄像头默认看到的是非镜像画面)
 */
- (void)setMirror:(BOOL)isMirror;

/**
 * setAudioMode 设置声音播放模式(扬声器、听筒)
 */
- (void)setAudioMode:(TXEAVRoomAudioMode)audioMode;

/**
 * setLocalMute 设置静音推流(纯视频推流)
 */
- (void)setLocalMute:(BOOL)bEnable;

/**
 * 当从前台切到后台的时候，调用pause会推配置里设置的图片(TXCAVRoomConfig.pauseImg)
 */
- (void)pause;

/**
 * 当从后台回到前台的时候，调用resume恢复推送camera采集的数据
 */
- (void)resume;

/**
 * setVideoBitrate 设置视频上行码率
 * 参数:
 *          videoBitrate : 视频上行码率
 *          videoAspect  : 视频分辨率比例
 */
- (void)setVideoBitrate:(NSInteger)videoBitrate videoAspect:(TXEAVRoomVideoAspect)videoAspect;


/**
 * setBeautyLevel 设置美颜 和 美白 效果级别
 * 参数：
 *          beautyLevel     : 美颜级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 *          whitenessLevel  : 美白级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 *          ruddinessLevel  : 红润级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 */
- (void)setBeautyLevel:(int)beautyLevel whitenessLevel:(int)whitenessLevel ruddinessLevel:(int)ruddinessLevel;

/**
 * setEyeScaleLevel  设置大眼级别（涉及人脸识别,增值版本有效，普通版本设置此参数无效）
 * 参数：
 *          eyeScaleLevel     : 大眼级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 */
- (void)setEyeScaleLevel:(float)eyeScaleLevel;

/**
 * setFaceScaleLevel  设置瘦脸级别（特权版本有效，普通版本设置此参数无效）
 * 参数：
 *          faceScaleLevel    : 瘦脸级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 */
- (void)setFaceScaleLevel:(float)faceScaleLevel;

/**
 * setFilter 设置指定素材滤镜特效
 * 参数：
 *          image     : 指定素材，即颜色查找表图片。注意：一定要用png格式！！！
 *          demo用到的滤镜查找表图片位于RTMPiOSDemo/RTMPiOSDemo/resource／FilterResource.bundle中
 */
- (void)setFilter:(UIImage *)filterImage;

/**
 * 设置绿幕文件
 * 参数:
 *          file: 绿幕文件路径。支持mp4; nil 关闭绿幕
 */
- (void)setGreenScreenFile:(NSURL *)file;

/**
 * 选择动效。仅增值版有效
 * 参数:
 *          tmplName: 动效名称
 *          tmplDir: 动效所在目录
 */
- (void)selectMotionTmpl:(NSString *)tmplName inDir:(NSString *)tmplDir;

/**
 * setFaceVLevel  设置V脸（特权版本有效，普通版本设置此参数无效）
 * 参数：
 *          faceVLevel      : 瘦脸级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 */
- (void)setFaceVLevel:(float)vLeve;

/**
 * setFaceShortLevel  设置短脸（特权版本有效，普通版本设置此参数无效）
 * 参数：
 *          faceShortlevel  : 瘦脸级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 */
- (void)setFaceShortLevel:(float)shortLevel;

/**
 * setNoseSlimLevel  设置瘦鼻（特权版本有效，普通版本设置此参数无效）
 * 参数：
 *          noseSlimLevel   : 瘦脸级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 */
- (void)setNoseSlimLevel:(float)slimLevel;

/** 
 * setChinLevel  设置下巴拉伸或收缩（特权版本有效，普通版本设置此参数无效）
 * 参数：
 *          chinLevel      : 瘦脸级别取值范围 -9 ~ 9； 0 表示关闭 -9收缩 ~ 9拉伸。
 */
- (void)setChinLevel:(float)chinLevel;

/**
 * setBeautyStyle 设置美颜类型
 * 参数：
 *          style  0:光滑美颜，1:自然美颜
 */
- (void)setBeautyStyle:(int)style;

/**
 * setFilterMixLevel 设置滤镜融合度（0-10）
 * 参数:
 *          mixLevel    滤镜融合度
 */
- (void)setFilterMixLevel:(float)mixLevel;

@end
