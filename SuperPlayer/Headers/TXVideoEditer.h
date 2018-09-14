//
//  TXUGCEdit.h
//  TXRTMPSDK
//
//  Created by xiang zhang on 2017/4/10.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import "TXVideoEditerListener.h"
#import "TXVideoEditerTypeDef.h"
#import "TXVideoCustomProcessDelegate.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////  UGC list /////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - 视频信息获取

/// 视频信息获取类
@interface TXVideoInfoReader : NSObject
/**
 * @notice 1,如果当前image图片为nil，sdk会自动返回上一张image图片
 * 2,sampleProcess 回调不在主线程，如果在回调里面有UI操作，请自行切换到主线程，具体可以参考demo代码
 * @param number 当前采样的是第几张图片（number 从1开始）
 * @param image  当前采样图片
 * @return 是否继续获取下一张图片，YES：继续获取  NO：终止获取
 */
typedef BOOL(^sampleProcess)(int number , UIImage * image);

/** 获取视频文件信息
 * @param videoPath 视频文件路径
 */
+ (TXVideoInfo *)getVideoInfo:(NSString *)videoPath;

/** 获取视频文件信息
 * @param videoAsset 视频文件属性
 * @return 视频信息
 */
+ (TXVideoInfo *)getVideoInfoWithAsset:(AVAsset *)videoAsset;

/** 获取视频的采样图列表
 * @param count         获取的采样图数量（均匀采样）
 * @param videoPath     视频文件路径
 * @param sampleProcess 采样进度
 */
+ (void)getSampleImages:(int)count
              videoPath:(NSString *)videoPath
               progress:(sampleProcess)sampleProcess;

/** 获取视频的采样图列表
 * @param count         获取的采样图数量（均匀采样）
 * @param videoAsset   视频文件属性
 * @param sampleProcess 采样进度
 */
+ (void)getSampleImages:(int)count
             videoAsset:(AVAsset *)videoAsset
               progress:(sampleProcess)sampleProcess;

/** 获取视频的采样图列表
 * @param count        获取的采样图数量（均匀采样）
 * @param maxSize      缩略图的最大大小，生成的缩略图大小不会超出这个宽高
 * @param videoAsset   视频文件属性
 * @param sampleProcess 采样进度
 */
+ (void)getSampleImages:(int)count
                maxSize:(CGSize)maxSize
             videoAsset:(AVAsset *)videoAsset
               progress:(sampleProcess)sampleProcess;

/**
 * 根据时间获取单帧图片
 * @param time 获取图片的时间
 * @param videoPath 视频文件路径
 */
+ (UIImage *)getSampleImage:(float)time
                  videoPath:(NSString *)videoPath;

/**
 * 根据时间获取单帧图片
 * @param  time 获取图片的时间
 * @param videoAsset 视频AVAsset对象
 */
+ (UIImage *)getSampleImage:(float)time
                 videoAsset:(AVAsset *)videoAsset;

/**
 * 根据时间列表获取缩略图列表
 * @param asset   视频文件对象
 * @param times   获取的时间列表
 * @param maxSize 缩略图大小
 */
+ (UIImage *)getSampleImagesFromAsset:(AVAsset *)asset
                                times:(NSArray<NSNumber*> *)times
                              maxSize:(CGSize)maxSize
                             progress:(sampleProcess)sampleProcess;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////  Video/Image Edit /////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 视频编辑
/// 视频编辑类
@interface TXVideoEditer : NSObject
/// 生成视频回调的委托对象, 可以获取生成进度与完成时间等
/// @see TXVideoGenerateListener
@property (nonatomic ,weak) id<TXVideoGenerateListener> generateDelegate;
/// 视频预览回调的委托对象，可以获取视频的播放进度等
/// @see TXVideoPreviewListener
@property (nonatomic ,weak) id<TXVideoPreviewListener>  previewDelegate;
/// 视频画面处理的委托对象，可以获取视频画面的OpenGL纹理ID
/// @see TXVideoCustomProcessListener
@property (nonatomic, weak) id<TXVideoCustomProcessListener> videoProcessDelegate;
/// 判断是否支持TwoPass-Encoding
@property (nonatomic, readonly) BOOL supportsTwoPassEncoding;


/** 默认初始化方法
 * @param param 编辑器画面预览参数
 * @see TXPreviewParam
 */
- (instancetype)initWithPreview:(TXPreviewParam *)param;

#pragma mark 视频/图片设置相关方法
/// @name 视频/图片设置相关方法

/** Tips:
 * 4.7版本以后，SDK支持图片编辑，这里需要注意的是，只能单独对图片或则视频进行编辑，暂不支持图片和视频的混合编辑。
 * 视频编辑暂不支持的功能：转场动画
 * 图片编辑暂不支持的功能：重复，倒放，快速/慢速，片尾水印, 旋转
 */

/**
 * 设置视频文件路径
 * @param videoPath 视频文件路径
 * @return  0 成功；
 *          -1 视频文件不存在；
 *          -2 视频不支持：暂不支持2个声道以上的视频编辑
 */
- (int)setVideoPath:(NSString *)videoPath;

/**
 * 设置视频 AVAsset
 * @param videoAsset 视频AVAsset对象,从本地相册loading出来的视频，可以直接传入对应的视频属性，会极大的降低视频从相册loading的时间，具体请参考demo用法
 * @return  0 成功；
 *         -1 视频属性asset 为nil；
 *         -2 视频不支持：暂不支持2个声道以上的视频编辑
 */
- (int)setVideoAsset:(AVAsset *)videoAsset;

/**
 * @param pitureList 转场图片列表,至少设置三张图片 （tips ：图片最好压缩到720P以下（参考demo用法），否则内存占用可能过大，导致编辑过程异常）
 * @param fps       转场图片生成视频后的fps （15 ~ 30）
 * @return  0 设置成功；
 *         -1 设置失败，请检查图片列表是否存在，图片数量是否大于等于3张，fps是否正常；
 */
- (int)setPictureList:(NSArray<UIImage *> *)pitureList fps:(int)fps;

/**
 * 设置图片转场类型
 * @param transitionType 转场类型，详情见 TXTransitionType
 * @param duration 转场视频时长（tips：同一个图片列表，每种转场动画的持续时间可能不一样，这里可以获取转场图片的持续时长）；
 */
- (void)setPictureTransition:(TXTransitionType)transitionType duration:(void(^)(CGFloat))duration;

#pragma mark 预览逻辑相关
/// @name 预览逻辑相关方法

/** 渲染某一时刻的视频画面
 *  @param time      预览帧时间(s)
 */
- (void)previewAtTime:(CGFloat)time;

/** 播放某一时间段的视频
 * @param startTime     播放起始时间(s)
 * @param endTime       播放结束时间(s)
 */
- (void)startPlayFromTime:(CGFloat)startTime
                   toTime:(CGFloat)endTime;

/**
 * 暂停播放
 */
- (void)pausePlay;


/// 继续播放
- (void)resumePlay;

/// 停止播放
- (void)stopPlay;


#pragma mark 特效相关
// @name 特效相关方法
/**
 * 设置美颜，美白级别 0~9
 * @param beautyLevel 磨皮级别 0~9
 * @param whiteningLevel 美白级别 0~9
 */
- (void) setBeautyFilter:(float)beautyLevel setWhiteningLevel:(float)whiteningLevel;

/**
 * 设置特效滤镜
 * @param image 滤镜图片
 */
- (void) setFilter:(UIImage *)image;


/**
 * 设置两个滤镜效果
 * @param   leftFilter          左滤镜图片(nil代表无左滤镜)
 * @param   leftIntensity    左滤镜浓度
 * @param   rightFilter          右滤镜图片(nil代表无右滤镜)
 * @param   rightIntensity   右滤镜浓度
 * @param   leftRatio           左滤镜所占比例
 */
- (void)setFilter:(UIImage*)leftFilter leftIntensity:(CGFloat)leftIntensity rightFilter:(UIImage*)rightFilter rightIntensity:(CGFloat)rightIntensity leftRatio:(CGFloat)leftRatio;

/**
 * 设置滤镜效果程度
 * @param specialRatio     从0到1，越大滤镜效果越明显，默认取值0.5
 */
-(void) setSpecialRatio:(float)specialRatio;

/**
 * 设置倒放
 * @param isReverse 是否倒放
 */
- (void) setReverse:(BOOL)isReverse;

/**
 * 设置重复播放
 * @param repeatList 重复播放的范围列表
 * @see TXRepeat
 */
- (void) setRepeatPlay:(NSArray<TXRepeat *> *)repeatList;

/**
 * 设置画面渲染角度
 * @param rotation 画面渲染角度, 必须是90的倍数
 * @warning 只支持视频旋转
 */
- (void)setRenderRotation:(int)rotation;

/**
 * 设置视频加速播级别
 * @param speedList 加速范围列表
 */
- (void) setSpeedList:(NSArray<TXSpeed *> *)speedList;

/**
 * 开始特效
 * @param type 特效类型
 * @param startTime 特效开始时间
 */
- (void) startEffect:(TXEffectType)type  startTime:(float)startTime;

/**
 * 结束特效
 * @param type 特效类型
 * @param endTime 特效结束时间
 */
- (void) stopEffect:(TXEffectType)type  endTime:(float)endTime;

/**
 * 删除最后一个添加的特效
 */
- (void) deleteLastEffect;

/**
 * 删除所有特效
 */
- (void) deleteAllEffect;

#pragma mark 贴纸相关
/// @name 贴纸相关方法

/**
 * 设置字幕（气泡）列表
 * @param subtitleList 字幕列表
 */
- (void) setSubtitleList:(NSArray<TXSubtitle *> *)subtitleList;

/**
 * 设置静态贴纸
 * @param pasterList 静态贴纸列表
 */
- (void) setPasterList:(NSArray<TXPaster *> *)pasterList;

/**
 * 设置动图列表
 * @param animatedPasterList 动态贴纸列表
 */
- (void) setAnimatedPasterList:(NSArray<TXAnimatedPaster *> *)animatedPasterList;

#pragma mark BGM相关
/// @name BGM相关方法

/**
 * 设置背景音乐
 * @param path      音乐文件路径
 * @param result 0:成功, -1:音乐文件格式不支持
 */
- (void) setBGM:(NSString *)path result:(void(^)(int))result;

/**
 * 设置背景音乐
 * @param asset      音乐AVAsset对象, 从系统媒体库loading出来的音乐，可以直接传入对应的音乐属性，会极大的降低音乐从系统媒体库loading的时间，具体请参考demo用法
 * @param result     0:成功, -1:音乐文件格式不支持
 */
- (void) setBGMAsset:(AVAsset *)asset result:(void(^)(int))result;

/**
 * 设置背景音乐的起始时间和结束时间
 * @param startTime 音乐起始时间
 * @param endTime   音乐结束时间
 */
- (void) setBGMStartTime:(float)startTime endTime:(float)endTime;

/**
 * 设置背景音乐是否循环播放
 * @param isLoop 是否循环播放
 */
- (void) setBGMLoop:(BOOL)isLoop;

/**
 * 设置背景音乐在视频的添加的起始位置
 * @param time 背景音乐在视频的添加的起始时间
 */
- (void) setBGMAtVideoTime:(float)time;

/**
 * 设置视频声音大小
 * @param volume 音量, 取值范围 0.0 ~ 1.0
 */
- (void) setVideoVolume:(float)volume;

/**
 * 设置背景音乐声音大小
 * @param volume 背景音量, 取值范围 0.0 ~ 1.0
 */
- (void) setBGMVolume:(float)volume;

#pragma mark 水印相关
/// @name 水印相关方法

/**
 * 设置全局水印
 * @param waterMark            全局水印图片
 * @param normalizationFrame   水印相对于视频图像的归一化frame，x,y,width,height 取值范围 0~1；
 *                             height不用设置，sdk内部会根据水印宽高比自动计算height；
 *                             比如视频图像大小为（540，960） frame设置为（0.1，0.1，0.1,0）,
 *                             水印的实际像素坐标为（540 * 0.1，960 * 0.1，540 * 0.1 ，540 * 0.1 * waterMark.size.height / waterMark.size.width）
 */
- (void) setWaterMark:(UIImage *)waterMark  normalizationFrame:(CGRect)normalizationFrame;

/**
 * 设置片尾水印
 * @param tailWaterMark        片尾水印图片
 * @param normalizationFrame   水印相对于视频图像的归一化frame，x,y,width,height 取值范围 0~1；
 *                             height不用设置，sdk内部会根据水印宽高比自动计算height；
 *                             比如视频图像大小为（540，960） frame设置为（0.1，0.1，0.1,0）,
 *                             水印的实际像素坐标为（540 * 0.1，960 * 0.1，540 * 0.1 ，540 * 0.1 * waterMark.size.height / waterMark.size.width）
 * @param duration             水印的持续时长
 */
- (void) setTailWaterMark:(UIImage *)tailWaterMark normalizationFrame:(CGRect)normalizationFrame duration:(CGFloat)duration;


#pragma mark 视频生成相关
/// @name 视频生成相关方法

/**
 * 设置视频剪裁
 * @param startTime 视频起始时间
 * @param endTime   视频结束时间
 */
- (void) setCutFromTime:(float)startTime toTime:(float)endTime;

/**
 * 设置视频码率
 * @param bitrate  视频码率 单位:kbps
 *                 如果设置了码率，SDK生成视频会优先使用这个码率，注意码率不要太大或则太小，码率太小视频会模糊不清，码率太大，生成视频体积会很大
 *                 这里建议设置范围为：600~12000，如果没有调用这个接口，SDK内部会根据压缩质量自动计算码率
 */
- (void) setVideoBitrate:(int)bitrate;

/**
 * 生成视频
 * 优点：兼容性好，支持各种操作类型的视频生成，生成的视频文件在各个平台播放的兼容性好
 * 缺点：生成视频速度稍慢
 * 调用之后在TXVideoGenerateListener里面监听结果回调
 * @param videoCompressed 视频压缩质量
 * @param videoOutputPath 视频操作之后存储路径
 * 
 */
- (void) generateVideo:(TXVideoCompressed)videoCompressed videoOutputPath:(NSString *)videoOutputPath;

/**
 * 使用系统函数快速生成视频
 * 优点：生成视频速度快
 * 缺点：1，剪切出来的视频在各个平台播放的兼容性稍差
 *      2，只有剪切和压缩操作才会使用系统函数，其他情况系统不支持，SDK内部会自动走正常视频生成的逻辑
 * 调用之后在 TXVideoGenerateListener 里面监听结果回调
 * @param videoCompressed 视频压缩质量
 * @param videoOutputPath 视频操作之后存储路径
 */
- (void) quickGenerateVideo:(TXVideoCompressed)videoCompressed videoOutputPath:(NSString *)videoOutputPath;

/**
 * 两次扫描生成视频(Two-Pass Encoding)
 * 优点：兼容性好，在同等码率下视频更加清晰，可以在较低码率下保持视频质量，支持各种操作类型的视频生成，生成的视频文件在各个平台播放的兼容性好
 * 缺点：生成视频慢
 * 调用之后在TXVideoGenerateListener里面监听结果回调
 * @param videoCompressed 视频压缩质量
 * @param videoOutputPath 视频操作之后存储路径
 */
- (void) generateVideoWithTwoPass:(TXVideoCompressed)videoCompressed videoOutputPath:(NSString *)videoOutputPath;

/*SDK生成视频默认采用的是硬编码（编码效率高，编码出来的图像效果好），硬编码器在程序进后台后会停止工作，从而导致视频生成失败，
  这里新增了两个接口pauseGenerate，resumeGenerate，程序进后台后您可以调用pauseGenerate暂停视频生成，程序重新进前台后，
  您可以调用resumeGenerate 继续视频生成，这里需要注意的是，调用resumeGenerate，sdk会重启硬编码器，会有一定的概率重启失败，
  或则重启后前几帧数据编码失败，这个时候SDK内部会在 TXVideoGenerateListener 抛出编码错误事件，收到错误事件后您需要重新生成视频。
  */

/**
  暂停视频生成，仅适用于generateVideo，quickGenerateVideo调用无效
  @discussion 
  SDK生成视频默认采用的是硬编码（编码效率高，编码出来的图像效果好），硬编码器在程序进后台后会停止工作，从而导致视频生成失败，
  这里新增了两个接口pauseGenerate，resumeGenerate，程序进后台后您可以调用pauseGenerate暂停视频生成，程序重新进前台后，
  您可以调用resumeGenerate 继续视频生成，这里需要注意的是，调用resumeGenerate，sdk会重启硬编码器，会有一定的概率重启失败，
  或则重启后前几帧数据编码失败，这个时候SDK内部会在 TXVideoGenerateListener 抛出编码错误事件，收到错误事件后您需要重新生成视频。
  
  @see resumeGenerate
 */
- (void) pauseGenerate;

/**
 * 继续视频生成，仅适用于generateVideo，quickGenerateVideo调用无效
 * @see pauseGenerate
 */
- (void) resumeGenerate;

/**
 * 停止视频文件生成
 */
- (void) cancelGenerate;
@end

#pragma mark - 视频合成、拼接

/// 视频合成与拼接, 可以进行画中画合成或者前后拼接
@interface TXVideoJoiner : NSObject

/// 合成的回调委托对象
/// @see TXVideoJoinerListener
@property (nonatomic ,weak) id<TXVideoJoinerListener>  joinerDelegate;
/// 预览的回调委托对象
/// @see TXVideoPreviewListener
@property (nonatomic ,weak) id<TXVideoPreviewListener> previewDelegate;

/**
 * @param param 参考 TXPreviewParam
 */
- (instancetype)initWithPreview:(TXPreviewParam *)param;

/** 设置视频文件列表 app本地的视频文件建议使用这个接口
 * @param videoPathList  视频路径列表
 * @return  0 成功；
 *         -1 视频列表文件不存在
 *         -2 视频列表里面有一个或则几个视频不存在
 *         -3 视频列表里面有不支持合成的视频 (声道数>2 , 视频无声音数据暂不支持合成)
*/
- (int)setVideoPathList:(NSArray *)videoPathList;

/** 设置视频文件列表 相册的视频文件建议使用这个接口
 * @param videoAssetList 视频AVAsset对象列表,从本地相册loading出视频列表后，可以直接传入对应的视频属性列表，会极大的降低视频从相册loading的时间，具体请参考demo用法
 * @return  0 成功；
 *         -1 视频属性asset列表不存在
 *         -2 视频列表里面有一个或则几个视频不存在
 *         -3 视频列表里面有不支持合成的视频 (声道数大于2, 或者没有声音数据的视频暂不支持合成)
 */
- (int)setVideoAssetList:(NSArray<AVAsset *> *)videoAssetList;

/// 开启视频播放，会从视频的起始位置开始播放 （需要在setVideoPathList之后调用）
- (void)startPlay;

/// 暂停播放
- (void)pausePlay;

/// 继续播放
- (void)resumePlay;

/// 停止播放
- (void)stopPlay;

/** 合成视频
 * SDK内部会自动判断视频是否可以快速合成，如果可以，会优先走快速合成逻辑
 * 调用后在TXVideoComposeListener里面监听结果回调
 * 注意：需要合成的视频列表中，每个视频必须要有video data 和 audio data 数据
 * @param videoCompressed 视频压缩质量
 * @param videoOutputPath 生成新的视频存储路径
 */
- (void)joinVideo:(TXVideoCompressed)videoCompressed  videoOutputPath:(NSString *)videoOutputPath;

/*
 *注意：当前接口已经被废弃，请使用 joinVideo 接口，SDK内部会自动判断视频是否具有快速合成的条件
 */
//- (void)quickJoinVideo:(TXVideoCompressed)videoCompressed  videoOutputPath:(NSString *)videoOutputPath;


/** 设置分屏合成坐标
 * 使用方法详见demo示例
 * @param rects  需要合成视频的坐标
 * @param canvasWidth 画布宽度，也是分屏合成之后视频的宽度
 * @param canvasHeight 画布高度，也是分屏合成之后视频的高度
 */
- (void)setSplitScreenList:(NSArray <NSValue *> *)rects  canvasWidth:(int)canvasWidth canvasHeight:(int)canvasHeight;

/** 分屏合成
 * @param videoCompressed 视频压缩质量
 * @param videoOutputPath 生成新的视频存储路径
 */
- (void)splitJoinVideo:(TXVideoCompressed)videoCompressed  videoOutputPath:(NSString *)videoOutputPath;

/// 停止视频文件合成
- (void)cancelJoin;

@end

