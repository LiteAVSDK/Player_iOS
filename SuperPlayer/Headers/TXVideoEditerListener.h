#ifndef TXVideoEditerListener_H
#define TXVideoEditerListener_H

#import "TXVideoEditerTypeDef.h"

///  视频预览回调
@protocol TXVideoPreviewListener <NSObject>

/**
 * 短视频预览进度
 * time 视频预览的当前时间 (s)
 */
@optional
-(void) onPreviewProgress:(CGFloat)time;

/**
 * 短视频预览结束回调
 */
@optional
-(void) onPreviewFinished;

@end

/// 视频预览生成纹理回调
@protocol TXVideoCustomProcessListener<NSObject>
@optional

/** 
 在OpenGL线程中回调，在这里可以进行采集图像的二次处理
 @param texture    纹理ID
 @param width      纹理的宽度
 @param height     纹理的高度
 @param timestamp        纹理timestamp 单位ms
 @return           返回给SDK的纹理
 说明：SDK回调出来的纹理类型是GL_TEXTURE_2D，接口返回给SDK的纹理类型也必须是GL_TEXTURE_2D; 该回调在SDK美颜之后. 纹理格式为GL_RGBA
 timestamp 为当前视频帧的 pts ，单位是ms ，客户可以根据自己的需求自定义滤镜特效
 */
- (GLuint)onPreProcessTexture:(GLuint)texture width:(CGFloat)width height:(CGFloat)height timestamp:(UInt64)timestamp;

/**
 * 在OpenGL线程中回调，可以在这里释放创建的OpenGL资源
 */
- (void)onTextureDestoryed;
@end


/// 视频生成回调
@protocol TXVideoGenerateListener<NSObject>
@optional

/**
 * 短视频生成完成
 * @param progress 生成视频进度百分比
 */
-(void) onGenerateProgress:(float)progress;

/**
 * 短视频生成完成
 * @param result 生成结果
 * @see TXGenerateResult
 */
-(void) onGenerateComplete:(TXGenerateResult *)result;

@end


/// 视频合成回调
@protocol TXVideoJoinerListener<NSObject>
@optional

/**
 * 短视频合成完成
 * @param progress  合成视频进度百分比
 */
-(void) onJoinProgress:(float)progress;

/**
 * 短视频合成完成
 * @param result 合成结果
 * @see TXJoinerResult
 */
-(void) onJoinComplete:(TXJoinerResult *)result;

@end
#endif
