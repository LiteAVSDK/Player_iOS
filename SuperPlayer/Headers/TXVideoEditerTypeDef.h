#ifndef TXVideoEditerTypeDef_H
#define TXVideoEditerTypeDef_H

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/// 视频信息
@interface TXVideoInfo : NSObject
/// 视频首帧图片
@property (nonatomic, strong) UIImage*              coverImage;
/// 视频时长(s)
@property (nonatomic, assign) CGFloat               duration;
/// 视频大小(byte)
@property (nonatomic, assign) unsigned long long    fileSize;
/// 视频fps
@property (nonatomic, assign) float                 fps;      
/// 视频码率 (kbps)
@property (nonatomic, assign) int                   bitrate;
/// 音频采样率
@property (nonatomic, assign) int                   audioSampleRate;
/// 视频宽度
@property (nonatomic, assign) int                   width;
/// 视频高度
@property (nonatomic, assign) int                   height;
/// 视频旋转角度
@property (nonatomic, assign) int                   angle;
@end


/// 短视频预览参数
typedef NS_ENUM(NSInteger, TXPreviewRenderMode)
{
    /// 填充模式，尽可能充满屏幕不留黑边，所以可能会裁剪掉一部分画面
    PREVIEW_RENDER_MODE_FILL_SCREEN                 = 0,     
    /// 黑边模式，尽可能保持画面完整，但当宽高比不合适时会有黑边出现
    PREVIEW_RENDER_MODE_FILL_EDGE                   = 1,            
};

/// 短视频预览参数
@interface TXPreviewParam : NSObject
/// 视频预览View
@property (nonatomic, strong) UIView*               videoView;
/// 填充模式
/// @see TXPreviewRenderMode
@property (nonatomic, assign) TXPreviewRenderMode   renderMode;     

@end

/// 字幕
@interface TXSubtitle: NSObject
/// 字幕图片   （这里需要客户把承载文字的控件转成image图片）
@property (nonatomic, strong) UIImage*              titleImage; 
/// 字幕的frame（注意这里的frame坐标是相对于渲染view的坐标）
@property (nonatomic, assign) CGRect                frame;     
/// 字幕起始时间(s)
@property (nonatomic, assign) CGFloat               startTime;      
/// 字幕结束时间(s)
@property (nonatomic, assign) CGFloat               endTime;        
@end

/// 贴纸
@interface TXPaster: NSObject
/// 贴纸图片
@property (nonatomic, strong) UIImage*              pasterImage; 
/// 贴纸frame（注意这里的frame坐标是相对于渲染view的坐标）
@property (nonatomic, assign) CGRect                frame;   
/// 贴纸起始时间(s)
@property (nonatomic, assign) CGFloat               startTime;  
/// 贴纸结束时间(s)
@property (nonatomic, assign) CGFloat               endTime;       
@end


/// 动图
@interface TXAnimatedPaster: NSObject
/// 动图文件路径
@property (nonatomic, strong) NSString*             animatedPasterpath;  
/// 动图的frame（注意这里的frame坐标是相对于渲染view的坐标）
@property (nonatomic, assign) CGRect                frame;       
/// 动图旋转角度 (0 ~ 360)
@property (nonatomic, assign) CGFloat               rotateAngle;  
/// 动图起始时间(s)
@property (nonatomic, assign) CGFloat               startTime;  
/// 动图结束时间(s)
@property (nonatomic, assign) CGFloat               endTime;        
@end


/// 重复播放
@interface TXRepeat: NSObject
/// 重复播放起始时间(s)
@property (nonatomic, assign) CGFloat               startTime;  
/// 重复播放结束时间(s)
@property (nonatomic, assign) CGFloat               endTime;    
/// 重复播放次数
@property (nonatomic, assign) int                   repeatTimes;    
@end


/// 快慢速播放类型
typedef NS_ENUM(NSInteger, TXSpeedLevel) {
    /// 极慢速
    SPEED_LEVEL_SLOWEST, 
    /// 慢速
    SPEED_LEVEL_SLOW, 
    /// 正常速
    SPEED_LEVEL_NOMAL, 
    /// 快速
    SPEED_LEVEL_FAST,     
    /// 极快速
    SPEED_LEVEL_FASTEST,       
};

/// 加速播放参数
@interface TXSpeed: NSObject
/// 加速播放起始时间(s)
@property (nonatomic, assign) CGFloat               startTime;    
/// 加速播放结束时间(s)
@property (nonatomic, assign) CGFloat               endTime;      
/// 加速级别
@property (nonatomic, assign) TXSpeedLevel          speedLevel;    
@end

///  视频特效类型
typedef  NS_ENUM(NSInteger,TXEffectType)
{
    /// 动感光波
    TXEffectType_ROCK_LIGHT,
    /// 暗黑幻境
    TXEffectType_DARK_DRAEM,
    /// 灵魂出窍
    TXEffectType_SOUL_OUT,
    /// 视频分裂
    TXEffectType_SCREEN_SPLIT,
    /// 百叶窗
    TXEffectType_WIN_SHADOW,
    /// 鬼影
    TXEffectType_GHOST_SHADOW,
    /// 幻影
    TXEffectType_PHANTOM,
    /// 幽灵
    TXEffectType_GHOST,
    /// 闪电
    TXEffectType_LIGHTNING,
    /// 镜像
    TXEffectType_MIRROR,
    /// 幻觉
    TXEffectType_ILLUSION,

    TXEffectType_Count
};

/**
 * 转场特效
 */
typedef  NS_ENUM(NSInteger,TXTransitionType)
{
    /// 左右滑动
    TXTransitionType_LefRightSlipping,     
    /// 上下滑动
    TXTransitionType_UpDownSlipping,      
    /// 放大
    TXTransitionType_Enlarge,              
    /// 缩小
    TXTransitionType_Narrow,             
    /// 旋转缩放
    TXTransitionType_RotationalScaling,   
    /// 淡入淡出
    TXTransitionType_FadeinFadeout,        
};

/// 生成视频结果错误码定义
typedef NS_ENUM(NSInteger, TXGenerateResultCode)
{
    /// 生成视频成功
    GENERATE_RESULT_OK                                   = 0,  
    /// 生成视频失败
    GENERATE_RESULT_FAILED                               = -1,   
    /// 生成视频取消
    GENERATE_RESULT_CANCEL                               = -2, 
    /// licence 验证失败
    GENERATE_RESULT_LICENCE_VERIFICATION_FAILED          = -5,     
};

/// 生成视频结果
@interface TXGenerateResult : NSObject
/// 错误码
/// @see TXGenerateResultCode
@property (nonatomic, assign) TXGenerateResultCode  retCode;   
/// 错误描述信息
@property (nonatomic, strong) NSString*             descMsg;        
@end

/// 视频合成结果错误码定义
typedef NS_ENUM(NSInteger, TXJoinerResultCode)
{
    /// 合成成功
    JOINER_RESULT_OK                                = 0,         
    /// 合成失败
    JOINER_RESULT_FAILED                            = -1,  
    /// licence 验证失败
    JOINER_RESULT_LICENCE_VERIFICATION_FAILED       = -5,           
};

/// 短视频合成结果
@interface TXJoinerResult : NSObject
/// 错误码
/// @see TXJoinerResultCode 
@property (nonatomic, assign) TXJoinerResultCode    retCode;      
/// 错误描述信息
@property (nonatomic, strong) NSString*             descMsg;         

/**
 * 短视频压缩质量
 * 注意如果视频的分辨率小于压缩到的目标分辨率，视频不会被压缩，会保留原画
 */
typedef NS_ENUM(NSInteger, TXVideoCompressed)
{
    /// 压缩至360P分辨率
    VIDEO_COMPRESSED_360P                              = 0,  
    /// 压缩至480P分辨率
    VIDEO_COMPRESSED_480P                              = 1,  
    /// 压缩至540P分辨率
    VIDEO_COMPRESSED_540P                              = 2,  
    /// 压缩至720P分辨率
    VIDEO_COMPRESSED_720P                              = 3,  
};

@end

#endif
