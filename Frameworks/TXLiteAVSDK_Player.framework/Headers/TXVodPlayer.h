//
//  TXVodPlayer.h
//  TXLiteAVSDK
//
//  Created by annidyfeng on 2017/9/12.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TXLivePlayListener.h"
#import "TXVodPlayListener.h"
#import "TXVodPlayConfig.h"
#import "TXVideoCustomProcessDelegate.h"
#import "TXBitrateItem.h"
#import "TXPlayerAuthParams.h"

/// 点播播放器
@interface TXVodPlayer : NSObject

/**
 * 事件回调
 * @warning 建议使用vodDelegate
 */
@property(nonatomic, weak) id <TXLivePlayListener> delegate __attribute__((deprecated("use vodDelegate instead")));

/// 事件回调
@property(nonatomic, weak) id <TXVodPlayListener> vodDelegate;

/**
 * 视频渲染回调。（仅硬解支持）
 */
@property(nonatomic, weak) id <TXVideoCustomProcessDelegate> videoProcessDelegate;

/**
 * 是否开启硬件加速
 * 播放前设置有效
 */
@property(nonatomic, assign) BOOL enableHWAcceleration;

/**
 * 点播配置
 */
@property(nonatomic, copy) TXVodPlayConfig *config;

/// startPlay后是否立即播放，默认YES
@property BOOL isAutoPlay;

/**
 * 加密HLS的token。设置此值后，播放器自动在URL中的文件名之前增加 voddrm.token.TOKEN
 */
@property (nonatomic, strong) NSString *token;

/* setupContainView 创建Video渲染View,该控件承载着视频内容的展示。
 * @param view 父view
 * @param idx Widget在父view上的层级位置
 */
- (void)setupVideoWidget:(UIView *)view insertIndex:(unsigned int)idx;

/**
 * 移除Video渲染View
 */
- (void)removeVideoWidget;

/**
 * 设置播放开始时间
 * 在startPlay前设置，修改开始播放的起始位置
 */
- (void)setStartTime:(CGFloat)startTime;

/**
 * startPlay 启动从指定URL播放
 *
 * @param url 完整的URL(如果播放的是本地视频文件，这里传本地视频文件的完整路径)
 * @return 0 = OK
 */
- (int)startPlay:(NSString *)url;

/**
 * 通过fileid方式播放。
 *
 * fileid的获取方式可参考 [启动播放](https://cloud.tencent.com/document/product/454/12148#step-3.3A-.E5.90.AF.E5.8A.A8.E6.92.AD.E6.94.BE)
 *
 * @param params 认证参数
 * @return 0 = OK
 */
- (int)startPlayWithParams:(TXPlayerAuthParams *)params;

/**
 * 停止播放音视频流
 * @return 0 = OK
 */
- (int)stopPlay;

/**
 * 是否正在播放
 */
- (bool)isPlaying;

/**
 * 暂停播放
 */
- (void)pause;

/**
 * 继续播放
 */
- (void)resume;

/**
 * 播放跳转到音视频流某个时间
 * @param time 流时间，单位为秒
 * @return 0 = OK
 */
- (int)seek:(float)time;

/**
 * 获取当前播放时间
 */
- (float)currentPlaybackTime;

/**
 * 获取视频总时长
 */
- (float)duration;

/**
 * 可播放时长
 */
- (float)playableDuration;

/**
 * 视频宽度
 */
- (int)width;

/**
 * 视频高度
 */
- (int)height;

/**
 * 设置画面的方向
 * @param rotation 方向
 * @see TX_Enum_Type_HomeOrientation
 */
- (void)setRenderRotation:(TX_Enum_Type_HomeOrientation)rotation;

/**
 * 设置画面的裁剪模式
 * @param renderMode 裁剪
 * @see TX_Enum_Type_RenderMode
 */
- (void)setRenderMode:(TX_Enum_Type_RenderMode)renderMode;


/**
 * 设置静音
 */
- (void)setMute:(BOOL)bEnable;

/*
 * 截屏
 * @param snapshotCompletionBlock 通过回调返回当前图像
 */
- (void)snapshot:(void (^)(UIImage *))snapshotCompletionBlock;

/**
 * 设置播放速率
 * @param rate 正常速度为1.0；小于为慢速；大于为快速。最大建议不超过2.0
 */
- (void)setRate:(float)rate;

/**
 * 当播放地址为master playlist，返回支持的码率（清晰度）
 *
 * @warning 在收到EVT_VIDEO_PLAY_BEGIN事件后才能正确返回结果
 * @return 无多码率返回空数组
 */
- (NSArray<TXBitrateItem *> *)supportedBitrates;

/**
 * 获取当前正在播放的码率索引
 */
- (NSInteger)bitrateIndex;

/**
 * 设置当前正在播放的码率索引，无缝切换清晰度
 *  清晰度切换可能需要等待一小段时间。腾讯云支持多码率HLS分片对齐，保证最佳体验。
 *
 * @param index 码率索引
 */
- (void)setBitrateIndex:(NSInteger)index;

/**
 * 设置画面镜像
 */
- (void)setMirror:(BOOL)isMirror;

/**
 * 是否循环播放
 */
@property (nonatomic, assign) BOOL loop;

@end
