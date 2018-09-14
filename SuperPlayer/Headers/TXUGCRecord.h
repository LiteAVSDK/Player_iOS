#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "TXUGCRecordTypeDef.h"
#import "TXUGCRecordListener.h"
#import "TXUGCPartsManager.h"
#import "TXVideoCustomProcessDelegate.h"

/**********************************************
 **************  短视频录制   **************
 **********************************************/

/// 短视频录制类
@interface TXUGCRecord : NSObject

/// 视频录制的委托对象，可以获取录制进度等
/// @see TXUGCRecordListener
@property (nonatomic, weak)   id<TXUGCRecordListener>   recordDelegate;

/// 视频画面处理的委托对象，可以获取视频画面的OpenGL纹理ID
/// @see TXVideoCustomProcessListener
@property (nonatomic, weak)   id<TXVideoCustomProcessDelegate> videoProcessDelegate;

/// 多段录制的管理
/// @see TXUGCPartsManager
@property (nonatomic, strong, readonly) TXUGCPartsManager *partsManager; 

/// @name 实例化

/// 获取单例
+ (TXUGCRecord*) shareInstance;

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////摄像头,麦克风相关逻辑////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 摄像头,麦克风相关逻辑
/** @name 摄像头,麦克风相关逻辑 */

/*
 * 获取licence信息
 * 请使用 [TXUGCBase getLicenceInfo]
 */
//- (NSString *)getLicenceInfo;

/**
  开始画面预览
  @param config 预览参数
  @param preview 预览画面的父view
  @see   TXUGCSimpleConfig
  @return 0 成功, -1 摄像头尚未关闭 请先调用stopCameraPreview关闭, -2 编码器初始化失败
 */
- (int) startCameraSimple:(TXUGCSimpleConfig*)config preview:(UIView *)preview;

/**
  开始画面预览
  @param config 预览参数
  @param preview 预览画面的父vie
  @see   TXUGCCustomConfig
  @return 0 成功, -1 摄像头尚未关闭 请先调用stopCameraPreview关闭, -2 编码器初始化失败
 */
- (int) startCameraCustom:(TXUGCCustomConfig*)config preview:(UIView *)preview;

/**
  切换视频录制分辨率,startCamera 之后调用有效
  注意：需要在startRecord 之前设置，录制过程中设置无效
  @param resolution 视频分辨率
 */
- (void) setVideoResolution:(TXVideoResolution)resolution;

/**
  设置视频渲染模式,startCamera 之后调用有效
  @param renderMode 渲染模式
 */
- (void) setVideoRenderMode:(TXVideoRenderMode)renderMode;

/**
  切换视频录制码率
  注意：需要在startRecord 之前设置，录制过程中设置无效
  @param bitrate 视频码率
 */
- (void) setVideoBitrate:(int)bitrate;

/**
  调整焦距，startCamera 之后调用有效
  @param distance 取值范围 1~5 ，当为1的时候为最远视角（正常镜头），当为5的时候为最近视角（放大镜头），这里最大值推荐为5，超过5后视频数据会变得模糊不清
 */
- (void) setZoom:(CGFloat)distance;

/**
  切换前后摄像头，startCamera 之后调用有效
  @param isFront  YES 切换到前置摄像头, NO 切换到后置摄像头
  @return  YES 切换成功, NO 切换失败。
 */
- (BOOL) switchCamera:(BOOL)isFront;

/** 打开闪关灯，startCamera 之后调用有效
  @param enable YES, 打开 NO, 关闭.
  @return YES 打开成功, NO 打开失败。
 */
- (BOOL) toggleTorch:(BOOL)enable;

/// 结束画面预览

- (void) stopCameraPreview;

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////录制相关逻辑/////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 录制相关逻辑
/** @name 录制相关逻辑 */

/** 横竖屏录制
 //activity竖屏模式，竖屏录制
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_DOWN];
 [[TXUGCRecord shareInstance] setRenderRotation:0];
 
 //activity竖屏模式，home在右横屏录制
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDOE_HOME_ORIENTATION_RIGHT];
 [[TXUGCRecord shareInstance] setRenderRotation:90];
 
 //activity竖屏模式，home在左横屏录制
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_LEFT];
 [[TXUGCRecord shareInstance] setRenderRotation:270];
 
 //activity横屏模式，home在右横屏录制 注意：渲染view要跟着activity旋转
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDOE_HOME_ORIENTATION_RIGHT];
 [[TXUGCRecord shareInstance] setRenderRotation:0];
 
 //activity横屏模式，home在左横屏录制 注意：渲染view要跟着activity旋转
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_LEFT];
 [[TXUGCRecord shareInstance] setRenderRotation:0];
 */

/** 设置横竖屏录制，设置后可能会改变视频预览的方向,请调用setRenderRotation 来修本地视预览频流方向，请参考上面注释或则demo示例
 * @param homeOrientation 横竖屏录制方向
 * @warning 需要在startRecord 之前设置，录制过程中设置无效
 * @see     TXVideoHomeOrientation
 */
- (void) setHomeOrientation:(TXVideoHomeOrientation)homeOrientation;

/**
 * 设置预览视频方向
 * @param rotation 取值为 0 , 90, 180, 270（其他值无效） 表示视频预览向右旋转的角度
 设置横竖屏录制,activty旋转可能会改变视频预览的方向，可以设置此参数让视频预览回到正方向，请参考上面注释或则demo示例
 * @warning 需要在 startRecord 之前设置，录制过程中设置无效
 */
- (void) setRenderRotation:(int)rotation;

/**
 * 设置视频录制比例
 * @warning 需要在 startRecord 之前设置，录制过程中设置无效
 * @param videoRatio : 3：4  9：16  1：1
 */
- (void) setAspectRatio:(TXVideoAspectRatio)videoRatio;

/// 设置录制速率
- (void) setRecordSpeed:(TXVideoRecordSpeed) recordSpeed;

/// 设置是否静音录制
- (void) setMute:(BOOL) isMute;

/**
  开始录制短视频，SDK内部会自动生成视频路经，在TXVideoRecordListener里面返回
  @warning 这个接口SDK会自动管理生成的视频和封面，在下次调用startRecord的时候，SDK会自动删除上一次生成的视频和封面
  @return 
  返回值 | 涵义
  ------|------
   -1   | 正在录制短视频 
   -2   | videoRecorder初始化失败
   -3   | 摄像头没有打开
   -4   | 麦克风没有打开
   -5   | licence 验证失败，您可以通过 getLicenceInfo 接口查询licence信息，
   -6   | videoPath 为nil
   -7   | coverPath 为nil
 */
- (int) startRecord;

/**
  开始录制短视频
  @param videoPath 视频文件输出路径
  @param coverPath 封面文件输出路径
  @warning 这个接口SDK会自动管理生成的视频和封面，在下次调用startRecord的时候，SDK会自动删除上一次生成的视频和封面
  @return
  返回值 | 涵义
  ------|------
  -1   | 正在录制短视频 
  -2   | videoRecorder初始化失败
  -3   | 摄像头没有打开
  -4   | 麦克风没有打开
  -5   | licence 验证失败，您可以通过 getLicenceInfo 接口查询licence信息，
  -6   | videoPath 为nil
  -7   | coverPath 为nil
 */
- (int) startRecord:(NSString *)videoPath coverPath:(NSString *)coverPath;


/**
  开始录制短视频
  @param videoPath 视频文件输出路径
  @param videoPartsFolder 分片视频存储目录
  @param coverPath 封面文件输出路径
  @warning 这个接口客户需要自己管理生成的视频和封面，在不需要视频和封面的时候自行删除
  @return
  返回值 | 涵义
  ------|------
  -1    | 正在录制短视频 
  -2     | videoRecorder初始化失败
  -3    | 摄像头没有打开
  -4    | licence 验证失败，您可以通过 getLicenceInfo 接口查询licence信息，
  -6    | videoPath 为nil
  -7    | coverPath 为nil
 */
- (int)startRecord:(NSString *)videoPath videoPartsFolder:(NSString *)videoPartsFolder coverPath:(NSString *)coverPath;


/**
  暂停录制短视频(注:切后台时需保持后台运行状态)
  每一次暂停录制都会生成一个视频片段(>100ms有效，<= 100ms 会被认为是无效视频，不会被存放在视频分片里面)，您可以在partsManager里面管理这些视频片段
  @return  0 成功, -1 不存在录制任务, -2 videoRecorder未初始化
 */
- (int) pauseRecord;

/**
  4.9 版本后pauseRecord 修改为了异步调用，请在收到 complete 回调后再去 partsManager 获取当前的视频片段信息
  注意：resumeRecord 不需要等到 pauseRecord 的 complete 之后再调用，正常顺序调用即可
  @return 0 成功, -1 不存在录制任务, -2 videoRecorder未初始化
 */
- (int) pauseRecord:(void(^)(void))complete;

/**
  恢复录制短视频
  @return 0 成功, -1 不存在录制任务, -2 videoRecorder未初始化
 */
- (int) resumeRecord;

/**
 * 结束录制短视频
 * @return 0 成功, -1 不存在录制任务, -2 videoRecorder未初始化
 */
-(int) stopRecord;

/**
 * 在录制的过程中，如果您使用了其他播放器预览视频，AudioSession可能会冲突，会导致录制/播放异常，因此，
 * 当使用其他播放器预览视频的时候，请先调用 pauseAudioSession
 * 当停止视频预览，重新录制的时候，请调用 resumeAudioSession
 */
-(void) pauseAudioSession;

/// 重启SDK内部的 AudioSession
-(void) resumeAudioSession;

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////录制效果设置相关逻辑///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 录制效果设置相关逻辑
/** @name 录制效果设置相关逻辑 */

/**
  设置全局水印
  @param waterMark            全局水印图片
  @prarm normalizationFrame   水印相对于视频图像的归一化frame，x,y,width,height 取值范围 0~1；
                      height不用设置，sdk内部会根据水印宽高比自动计算height；
                      比如视频图像大小为（540，960） frame设置为（0.1，0.1，0.1,0）,水印的实际像素坐标为（540 * 0.1，960 * 0.1，540 * 0.1 ，540 * 0.1 * waterMark.size.height / waterMark.size.width）
 */
- (void) setWaterMark:(UIImage *)waterMark  normalizationFrame:(CGRect)normalizationFrame;

/** 设置美颜 和 美白 效果级别
  @param beautyStyle     : 美颜风格，TXVideoBeautyStyle类型。
  @param beautyLevel     : 美颜级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
  @param whitenessLevel  : 美白级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
  @param ruddinessLevel  : 红润级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 */
- (void) setBeautyStyle:(TXVideoBeautyStyle)beautyStyle beautyLevel:(float)beautyLevel whitenessLevel:(float)whitenessLevel ruddinessLevel:(float)ruddinessLevel;

/** 
 设置指定素材滤镜特效
 demo 用到的滤镜查找表图片位于RTMPiOSDemo/RTMPiOSDemo/resource／FilterResource.bundle中
 @param filterImage 指定素材，即颜色查找表图片。注意：一定要用png格式！！！
 */
-(void) setFilter:(UIImage*)filterImage;

/**
  设置两个滤镜效果
  @param   leftFilter       左滤镜图片(nil代表无左滤镜效果)
  @param   leftIntensity    左滤镜浓度
  @param   rightFilter      右滤镜图片(nil代表无右滤镜效果)
  @param   rightIntensity   右滤镜浓度
  @param   leftRatio        左滤镜所占比例
 */
- (void)setFilter:(UIImage*)leftFilter leftIntensity:(CGFloat)leftIntensity rightFilter:(UIImage*)rightFilter rightIntensity:(CGFloat)rightIntensity leftRatio:(CGFloat)leftRatio;

/**  
  设置滤镜效果程度
  @param specialRatio     从0到1，越大滤镜效果越明显，默认取值0.5
 */

-(void) setSpecialRatio:(float)specialRatio;

/** 
  设置大眼级别（增值版本有效，普通版本设置此参数无效）
  @param eyeScaleLevel 大眼级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 */
-(void) setEyeScaleLevel:(float)eyeScaleLevel;

/**
  设置瘦脸级别（增值版本有效，普通版本设置此参数无效）
  @param faceScaleLevel 瘦脸级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 */
-(void) setFaceScaleLevel:(float)faceScaleLevel;

/**
  设置V脸（增值版本有效，普通版本设置此参数无效）
  @param faceVLevel V脸级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 */
- (void) setFaceVLevel:(float)faceVLevel;

/** 设置下巴拉伸或收缩（增值版本有效，普通版本设置此参数无效）
 * @param chinLevel 下巴拉伸或收缩取值范围 -9 ~ 9； 0 表示关闭 -9收缩 ~ 9拉伸。
 */
- (void) setChinLevel:(float)chinLevel;

/** 设置短脸（增值版本有效，普通版本设置此参数无效）
 * @param faceShortlevel 短脸级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 */
- (void) setFaceShortLevel:(float)faceShortlevel;

/** 设置瘦鼻（增值版本有效，普通版本设置此参数无效）
 * @param noseSlimLevel 瘦鼻级别取值范围 0 ~ 9； 0 表示关闭 1 ~ 9值越大 效果越明显。
 */
- (void) setNoseSlimLevel:(float)noseSlimLevel;

/** 设置绿幕文件（增值版本有效，普通版本设置此参数无效）
 * @param file 绿幕文件路径
 */
-(void) setGreenScreenFile:(NSURL *)file;

/**
 * 设置动效 （增值版本有效，普通版本设置此参数无效）
 * @param tmplName 动效名称 
 * @param tmplDir  动效上层文件路径
 */
- (void) selectMotionTmpl:(NSString *)tmplName inDir:(NSString *)tmplDir;

/**
 * 设置动效静音 （增值版本有效，普通版本设置此参数无效）
 * @param motionMute YES 静音, NO 不静音
 */
- (void)setMotionMute:(BOOL)motionMute;

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////背景音相关逻辑////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 背景音相关逻辑 
/** @name 背景音相关逻辑 */

/**
 * 设置背景音乐文件
 * 注意：录制过程不能切换背景音乐，可能会导致异常，如果需要切换音乐，请先停止视频录制
 * @param path 音乐文件路径，一定要是app对应的document目录下面的路径，否则文件会读取失败
 * return: 音乐时长 s (返回值为0，表示BGM格式不支持或则音频解析失败)
 */
- (CGFloat) setBGM:(NSString *)path;

/**
 * 设置背景音乐文件
 * 注意：录制过程不能切换背景音乐，可能会导致异常，如果需要切换音乐，请先停止视频录制
 * @param asset 音乐属性asset,从系统媒体库loading出来的音乐，可以直接传入对应的音乐属性，会极大的降低音乐从系统媒体库loading的时间，具体请参考demo用法
 * return: 音乐时长 s (返回值为0，表示BGM格式不支持或则音频解析失败)
 */
- (CGFloat) setBGMAsset:(AVAsset *)asset;

/**
 * 播放背景音乐
 * 必须在startCamera之后调用
 * @param startTime 音乐播放起始时间
 * @param endTime   音乐播放结束时间
 * @param beginNotify 音乐播放开始的回调
 * @param progressNotify 音乐播放的进度回调，单位毫秒
 * @param completeNotify 音乐播放结束的回调
 * @return 是否成功
 */
- (BOOL)playBGMFromTime:(float)startTime
                 toTime:(float)endTime
        withBeginNotify:(void (^)(NSInteger errCode))beginNotify
     withProgressNotify:(void (^)(NSInteger progressMS, NSInteger durationMS))progressNotify
      andCompleteNotify:(void (^)(NSInteger errCode))completeNotify;

/**
 * 停止播放背景音乐
 */
- (BOOL)stopBGM;

/**
 * 暂停播放背景音乐
 */
- (BOOL)pauseBGM;

/**
 * 继续播放背景音乐
 */
- (BOOL)resumeBGM;


/** 设置麦克风的音量大小，播放背景音乐混音时使用，用来控制麦克风音量大小
 * @param volume 音量大小，1为正常音量，建议值为0~2，如果需要调大音量可以设置更大的值
 * 注意：这个接口目前在playBGM之后才生效
 */
- (BOOL)setMicVolume:(float)volume;

/** 设置背景音乐的音量大小，播放背景音乐混音时使用，用来控制背景音音量大小
 * @param volume 音量大小，1为正常音量，建议值为0~2，如果需要调大背景音量可以设置更大的值
 * 注意：这个接口目前在playBGM之后才生效
 */
- (BOOL)setBGMVolume:(float)volume;

/**
 * 设置混响效果
 * @param reverbType 混响类型 ，详见 TXReverbType
 */
- (BOOL)setReverbType:(TXVideoReverbType)reverbType;

/**
 *  设置变声类型
 *  @param voiceChangerType 变声类型, 详见 TXVoiceChangerType
 *  注意：变声目前仅支持 AUDIO_SAMPLERATE_8000 , AUDIO_SAMPLERATE_16000 ,AUDIO_SAMPLERATE_48000 三种采样率
 */
- (BOOL)setVoiceChangerType:(TXVideoVoiceChangerType)voiceChangerType;

/**
 * 截图/拍照,startCamera 之后调用有效
 @param snapshotCompletionBlock 完成回调
 */
- (void)snapshot:(void (^)(UIImage *))snapshotCompletionBlock;
@end
