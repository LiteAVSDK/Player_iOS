// Copyright (c) 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUIPlayerCoreLiteAVSDKHeader.h"
#import "TUIPlyerCoreSDKTypeDef.h"
#import "TUIPlayerLiveStrategyManager.h"
NS_ASSUME_NONNULL_BEGIN
@class TUITXLivePlayer;
@protocol TUITXLivePlayerDelegate <NSObject>
/**
 * 缩放模式发生改变，会回调该通知
 *
 * @param player    回调该通知的播放器对象。
 * @param mode      缩放模式
 */
- (void)liveRenderModeChanged:(TUITXLivePlayer *)player
                         mode:(V2TXLiveFillMode)mode;
/**
 * 直播播放器错误通知，播放器出现错误时，会回调该通知
 *
 * @param player    回调该通知的播放器对象。
 * @param code      错误码 {@link V2TXLiveCode}。
 * @param msg       错误信息。
 * @param extraInfo 扩展信息。
 */
- (void)onError:(TUITXLivePlayer *)player
           code:(V2TXLiveCode)code
        message:(NSString *)msg
      extraInfo:(NSDictionary *)extraInfo;

/**
 * 直播播放器警告通知
 *
 * @param player    回调该通知的播放器对象。
 * @param code      警告码 {@link V2TXLiveCode}。
 * @param msg       警告信息。
 * @param extraInfo 扩展信息。
 */
- (void)onWarning:(TUITXLivePlayer *)player
             code:(V2TXLiveCode)code
          message:(NSString *)msg
        extraInfo:(NSDictionary *)extraInfo;

/**
 * 直播播放器分辨率变化通知
 *
 * @param player    回调该通知的播放器对象。
 * @param width     视频宽。
 * @param height    视频高。
 */
- (void)onVideoResolutionChanged:(TUITXLivePlayer *)player
                           width:(NSInteger)width
                          height:(NSInteger)height;

/**
 * 已经成功连接到服务器
 *
 * @param player    回调该通知的播放器对象。
 * @param extraInfo 扩展信息。
 */
- (void)onConnected:(TUITXLivePlayer *)player
          extraInfo:(NSDictionary *)extraInfo;

/**
 * 视频播放事件
 *
 * @param player    回调该通知的播放器对象。
 * @param firstPlay 第一次播放标志。
 * @param extraInfo 扩展信息。
 */
- (void)onVideoPlaying:(TUITXLivePlayer *)player
             firstPlay:(BOOL)firstPlay
             extraInfo:(NSDictionary *)extraInfo;

/**
 * 音频播放事件
 *
 * @param player    回调该通知的播放器对象。
 * @param firstPlay 第一次播放标志。
 * @param extraInfo 扩展信息。
 */
- (void)onAudioPlaying:(TUITXLivePlayer *)player
             firstPlay:(BOOL)firstPlay
             extraInfo:(NSDictionary *)extraInfo;

/**
 * 视频加载事件
 *
 * @param player    回调该通知的播放器对象。
 * @param extraInfo 扩展信息。
 */
- (void)onVideoLoading:(TUITXLivePlayer *)player
             extraInfo:(NSDictionary *)extraInfo;

/**
 * 音频加载事件
 *
 * @param player    回调该通知的播放器对象。
 * @param extraInfo 扩展信息。
 */
- (void)onAudioLoading:(TUITXLivePlayer *)player
             extraInfo:(NSDictionary *)extraInfo;

/**
 * 播放器音量大小回调
 *
 * @param player 回调该通知的播放器对象。
 * @param volume 音量大小。
 * @note  调用 {@link enableVolumeEvaluation} 开启播放音量大小提示之后，会收到这个回调通知。
 */
- (void)onPlayoutVolumeUpdate:(TUITXLivePlayer *)player
                       volume:(NSInteger)volume;

/**
 * 直播播放器统计数据回调
 *
 * @param player     回调该通知的播放器对象。
 * @param statistics 播放器统计数据 {@link V2TXLivePlayerStatistics}。
 */
- (void)onStatisticsUpdate:(TUITXLivePlayer *)player
                statistics:(V2TXLivePlayerStatistics *)statistics;

/**
 * 截图回调
 *
 * @note  调用 {@link snapshot} 截图之后，会收到这个回调通知。
 * @param player 回调该通知的播放器对象。
 * @param image  已截取的视频画面。
 */
- (void)onSnapshotComplete:(TUITXLivePlayer *)player
                     image:(nullable TXImage *)image;

/**
 * 自定义视频渲染回调
 *
 * @param player     回调该通知的播放器对象。
 * @param videoFrame 视频帧数据 {@link V2TXLiveVideoFrame}。
 * @note  需要您调用 {@link enableObserveVideoFrame} 开启回调开关。
 */
- (void)onRenderVideoFrame:(TUITXLivePlayer *)player
                     frame:(V2TXLiveVideoFrame *)videoFrame;

/**
 * 音频数据回调
 *
 * @param player     回调该通知的播放器对象。
 * @param audioFrame 音频帧数据 {@link V2TXLiveAudioFrame}。
 * @note  需要您调用 {@link enableObserveAudioFrame} 开启回调开关。请在当前回调中使用 audioFrame 的 data。
 */
- (void)onPlayoutAudioFrame:(TUITXLivePlayer *)player
                      frame:(V2TXLiveAudioFrame *)audioFrame;

/**
 * 收到 SEI 消息的回调，发送端通过 {@link V2TXLivePusher} 中的 `sendSeiMessage` 来发送 SEI 消息
 *
 * @note  调用 {@link V2TXLivePlayer} 中的 `enableReceiveSeiMessage` 开启接收 SEI 消息之后，会收到这个回调通知。
 * @param player         回调该通知的播放器对象。
 * @param payloadType    回调数据的SEI payloadType。
 * @param data           数据。
 */
- (void)onReceiveSeiMessage:(TUITXLivePlayer *)player
                payloadType:(int)payloadType
                       data:(NSData *)data;

/**
 * 分辨率无缝切换回调
 *
 * @note  调用 {@link V2TXLivePlayer} 中的 `switchStream` 切换分辨率，会收到这个回调通知。
 * @param player 回调该通知的播放器对象。
 * @param url    切换的播放地址。
 * @param code   状态码，0：成功，-1：切换超时，-2：切换失败，服务端错误，-3：切换失败，客户端错误。
 */
- (void)onStreamSwitched:(TUITXLivePlayer *)player
                     url:(NSString *)url
                    code:(NSInteger)code;

/**
 * 画中画状态变更回调
 *
 * @note  调用 {@link V2TXLivePlayer} 中的 `enablePictureInPicture` 开启画中画之后，会收到这个回调通知。
 * @param player    回调该通知的播放器对象。
 * @param state     画中画的状态。
 * @param extraInfo 扩展信息。
 */
- (void)onPictureInPictureStateUpdate:(TUITXLivePlayer *)player
                                state:(V2TXLivePictureInPictureState)state
                              message:(NSString *)msg
                            extraInfo:(NSDictionary *)extraInfo;

/**
 * 录制任务开始的事件回调
 * 开始录制任务时，SDK 会抛出该事件回调，用于通知您录制任务是否已经顺利启动。对应于 {@link startLocalRecording} 接口。
 *
 * @param player 回调该通知的播放器对象。
 * @param code 状态码。
 *               - 0：录制任务启动成功。
 *               - -1：内部错误导致录制任务启动失败。
 *               - -2：文件后缀名有误（比如不支持的录制格式）。
 *               - -6：录制已经启动，需要先停止录制。
 *               - -7：录制文件已存在，需要先删除文件。
 *               - -8：录制目录无写入权限，请检查目录权限问题。
 * @param storagePath 录制的文件地址。
 */
- (void)onLocalRecordBegin:(TUITXLivePlayer *)player
                   errCode:(NSInteger)errCode
               storagePath:(NSString *)storagePath;

/**
 * 录制任务正在进行中的进展事件回调
 * 当您调用 {@link startLocalRecording} 成功启动本地媒体录制任务后，SDK 变会按一定间隔抛出本事件回调，【默认】：不抛出本事件回调。
 * 您可以在 {@link startLocalRecording} 时，设定本事件回调的抛出间隔参数。
 *
 * @param player       回调该通知的播放器对象。
 * @param durationMs   录制时长。
 * @param storagePath  录制的文件地址。
 */
- (void)onLocalRecording:(TUITXLivePlayer *)player
              durationMs:(NSInteger)durationMs
             storagePath:(NSString *)storagePath;

/**
 * 录制任务已经结束的事件回调
 * 停止录制任务时，SDK 会抛出该事件回调，用于通知您录制任务的最终结果。对应于 {@link stopLocalRecording} 接口。
 *
 * @param player 回调该通知的播放器对象。
 * @param code 状态码。
 *               -  0：结束录制任务成功。
 *               - -1：录制失败。
 *               - -2：切换分辨率或横竖屏导致录制结束。
 *               - -3：录制时间太短，或未采集到任何视频或音频数据，请检查录制时长，或是否已开启音、视频采集。
 * @param storagePath 录制的文件地址。
 */
- (void)onLocalRecordComplete:(TUITXLivePlayer *)player
                      errCode:(NSInteger)errCode
                  storagePath:(NSString *)storagePath;
@end
@interface TUITXLivePlayer : NSObject
///直播播放策略
@property (nonatomic, strong) TUIPlayerLiveStrategyManager *liveStrategyManager;
///是否已经预播放
@property (nonatomic, assign) BOOL isPrePlay;
///视频宽度
@property (nonatomic, assign) NSInteger width;
///视频高度
@property (nonatomic, assign) NSInteger height;

/**
 * 设置播放器回调
 *
 * 通过设置回调，可以监听 TUITXLivePlayer 播放器的一些回调事件，
 * 包括播放器状态、播放音量回调、音视频首帧回调、统计数据、警告和错误信息等。
 * @param observer 播放器的回调目标对象，更多信息请查看 {@link TUITXLivePlayerDelegate}
 */
- (void)addObserver:(id<TUITXLivePlayerDelegate>)observer;
/**
 * 移除播放器回调
 *
 * 通过设置回调，可以监听 TUITXLivePlayer 播放器的一些回调事件，
 * 包括播放器状态、播放音量回调、音视频首帧回调、统计数据、警告和错误信息等。
 * @param observer 播放器的回调目标对象，更多信息请查看 {@link TUITXLivePlayerDelegate}
 */
- (void)removeObserver:(id<TUITXLivePlayerDelegate>)observer;
/**
 * 设置播放器的视频渲染 View，该控件负责显示视频内容
 *
 * @param view 播放器渲染 View。
 */
- (V2TXLiveCode)setRenderView:(UIView *)view;

/**
 * 移除 Video 渲染 Widget
 */
- (void)removeVideoWidget;
/**
 * 设置画面的填充模式
 *
 * @param mode 画面填充模式 {@link V2TXLiveFillMode}。
 *         - V2TXLiveFillModeFill 【默认值】: 图像铺满屏幕，不留黑边，如果图像宽高比不同于屏幕宽高比，部分画面内容会被裁剪掉。
 *         - V2TXLiveFillModeFit: 图像适应屏幕，保持画面完整，但如果图像宽高比不同于屏幕宽高比，会有黑边的存在。
 *         - V2TXLiveFillModeScaleFill: 图像拉伸铺满，因此长度和宽度可能不会按比例变化。
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 成功。
 */
- (V2TXLiveCode)setRenderFillMode:(V2TXLiveFillMode)mode;
/**
 * 开始播放音视频流
 * @param url 音视频流的播放地址，支持 RTMP，HTTP-FLV，TRTC。
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 操作成功，开始连接并播放。
 *         - V2TXLIVE_ERROR_INVALID_PARAMETER：操作失败，url 不合法。
 *         - V2TXLIVE_ERROR_REFUSED：RTC 不支持同一设备上同时推拉同一个 StreamId。
 *         - V2TXLIVE_ERROR_INVALID_LICENSE：licence 不合法，播放失败。
 */
- (V2TXLiveCode)startLivePlay:(NSString *)url;

/**
 * 停止播放音视频流
 *
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 成功。
 */
- (V2TXLiveCode)stopPlay;

/**
 * 是否正在播放
 *
 * @return YES 拉流中，NO 没有拉流。
 */
- (BOOL)isPlaying;

/**
 * 暂停播放器的音频流
 */
- (void)pauseAudio;

/**
 * 恢复播放器的音频流
 *
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 成功。
 */
- (V2TXLiveCode)resumeAudio;

/**
 * 从UI上移除当前播放器
 */

- (void)removeVideo;


/**
 * 暂停播放器的视频流
 */
- (void)pauseVideo;

/**
 * 恢复播放器的视频流
 *
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 成功。
 */
- (V2TXLiveCode)resumeVideo;
/**
 * 设置播放器音量
 *
 * @param volume 音量大小，取值范围0 - 100。【默认值】: 100。
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 成功。
 */
- (V2TXLiveCode)setPlayoutVolume:(NSUInteger)volume;
/**
 * 设置播放器缓存自动调整的最小和最大时间 ( 单位：秒 )
 *
 * @param minTime 缓存自动调整的最小时间，取值需要大于0。【默认值】：1。
 * @param maxTime 缓存自动调整的最大时间，取值需要大于0。【默认值】：5。
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 成功。
 *         - V2TXLIVE_ERROR_INVALID_PARAMETER: 操作失败，minTime 和 maxTime 需要大于0。
 *         - V2TXLIVE_ERROR_REFUSED: 播放器处于播放状态，不支持修改缓存策略。
 */
- (V2TXLiveCode)setCacheParams:(CGFloat)minTime maxTime:(CGFloat)maxTime;
/**
 * 直播流无缝切换，支持 FLV 和 LEB
 *
 * @param newUrl 新的拉流地址。
 */
- (V2TXLiveCode)switchStream:(NSString *)newUrl;

/**
 * 获取码流信息
 */
- (NSArray<V2TXLiveStreamInfo *> *)getStreamList;

/**
 * 启用播放音量大小提示
 *
 * 开启后可以在 {@link onPlayoutVolumeUpdate} 回调中获取到 SDK 对音量大小值的评估。
 * @param intervalMs 决定了 onPlayoutVolumeUpdate 回调的触发间隔，单位为ms，最小间隔为100ms，如果小于等于0则会关闭回调，建议设置为300ms；【默认值】：0，不开启。
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 成功。
 */
- (V2TXLiveCode)enableVolumeEvaluation:(NSUInteger)intervalMs;
/**
 * 截取播放过程中的视频画面
 *
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 成功。
 *         - V2TXLIVE_ERROR_REFUSED: 播放器处于停止状态，不允许调用截图操作。
 */
- (V2TXLiveCode)snapshot;

/**
 * 开启/关闭对视频帧的监听回调
 *
 * SDK 在您开启此开关后将不再渲染视频画面，您可以通过 V2TXLivePlayerObserver 获得视频帧，并执行自定义的渲染逻辑。
 * @param enable      是否开启自定义渲染。【默认值】：NO。
 * @param pixelFormat 自定义渲染回调的视频像素格式 {@link V2TXLivePixelFormat}。
 * @param bufferType  自定义渲染回调的视频数据格式 {@link V2TXLiveBufferType}。
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 成功。
 *         - V2TXLIVE_ERROR_NOT_SUPPORTED: 像素格式或者数据格式不支持。
 */
- (V2TXLiveCode)enableObserveVideoFrame:(BOOL)enable pixelFormat:(V2TXLivePixelFormat)pixelFormat bufferType:(V2TXLiveBufferType)bufferType;

/**
 * 开启/关闭对音频数据的监听回调
 *
 * 如果您开启此开关，您可以通过 V2TXLivePlayerObserver 获得音频数据，并执行自定义的逻辑。
 * @param enable 是否开启音频数据回调。【默认值】：NO。
 * @return 返回值 {@link V2TXLiveCode}
 *         - V2TXLIVE_OK: 成功
 */
- (V2TXLiveCode)enableObserveAudioFrame:(BOOL)enable;

/**
 * 开启接收 SEI 消息
 *
 * @param enable      YES: 开启接收 SEI 消息; NO: 关闭接收 SEI 消息。【默认值】: NO。
 * @param payloadType 指定接收 SEI 消息的 payloadType，支持 5、242，请与发送端的 payloadType 保持一致。
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 成功。
 */
- (V2TXLiveCode)enableReceiveSeiMessage:(BOOL)enable payloadType:(int)payloadType;

/**
 * 开启画中画功能，仅支持直播和快直播播放
 *
 * @param enable      YES: 开启画中画功能; NO: 关闭画中画功能。【默认值】: NO。
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 成功。
 */
- (V2TXLiveCode)enablePictureInPicture:(BOOL)enable;

/**
 * 是否显示播放器状态信息的调试浮层
 *
 * @param isShow 是否显示。【默认值】：NO。
 */
- (void)showDebugView:(BOOL)isShow;

/**
 * 调用 V2TXLivePlayer 的高级 API 接口
 *
 * @note  该接口用于调用一些高级功能。
 * @param key   高级 API 对应的 key, 详情请参考 {@link V2TXLiveProperty} 定义。
 * @param value 调用 key 所对应的高级 API 时，需要的参数。
 * @return 返回值 {@link V2TXLiveCode}。
 *         - V2TXLIVE_OK: 成功。
 *         - V2TXLIVE_ERROR_INVALID_PARAMETER: 操作失败，key 不允许为 nil。
 */
- (V2TXLiveCode)setProperty:(NSString *)key value:(NSObject *)value;

/**
 * 开始录制音视频流
 *
 * @param  params 请参考 V2TXLiveDef.java 中关于 {@link V2TXLiveLocalRecordingParams}的介绍。
 * @return 返回值 {@link V2TXLiveCode}。
 *          - `V2TXLIVE_OK`: 成功。
 *          - `V2TXLIVE_ERROR_INVALID_PARAMETER` : 参数不合法，比如filePath 为空。
 *          - `V2TXLIVE_ERROR_REFUSED`: API被拒绝，拉流尚未开始。
 * @note   拉流开启后才能开始录制，非拉流状态下开启录制无效。
 *        - 录制过程中不要动态切换软/硬解，生成的视频极有可能出现异常。
 */
- (V2TXLiveCode)startLocalRecording:(V2TXLiveLocalRecordingParams *)params;

/**
 * 停止录制音视频流
 *
 * @note  当停止拉流后，如果视频还在录制中，SDK 内部会自动结束录制。
 */
- (void)stopLocalRecording;

@end

NS_ASSUME_NONNULL_END
