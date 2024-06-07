// Copyright (c) 2023 Tencent. All rights reserved.

#import <UIKit/UIKit.h>
#import "TUIShortVideoView.h"
#import <TUIPlayerCore/TUITXVodPlayerWrapper.h>
#import "TUIPlayerShortVideoUIManager.h"
#import "TUIPullUpRefreshControl.h"
#import "TUIShortVideoDataManager.h"
@class TUIPlayerStrategyModel;
@class TUIPlayerVideoModel;

/// 播放模式
typedef NS_ENUM(NSUInteger, TUIPlayMode) {
    TUIPlayModeOneLoop,       /// 单个循环，当前视频重复播放
    TUIPlayModeListLoop,      /// 列表循环，自动播放下一个视频，列表播放完毕后从第一个继续播放
    TUIPlayModeCustomLoop     /// 自定义循环，当前视频播放完毕后停止
};
NS_ASSUME_NONNULL_BEGIN

///Delegate
@protocol TUIShortVideoViewDelegate <NSObject>

/**
 * 视频滑动回调
 * @param videoIndex 当前视频索引
 * @param videoModel 当前视频数据模型
 */
- (void)scrollToVideoIndex:(NSInteger )videoIndex
                videoModel:(TUIPlayerVideoModel *)videoModel;

/**
 * 需要加载下一页
 * 回调时机跟TUIPlayerStrategyModel/mPreloadConcurrentCount相关
 * 例如：mPreloadConcurrentCount=3时, 此方法会在视频组的倒数第三个回调
 * 提醒加载新的一页数据
 */
- (void)onReachLast;

/**
 播放器状态
 @param videoModel 当前播放的视频数据模型
 @param status 播放状态
 */
- (void)currentVideo:(TUIPlayerVideoModel *)videoModel
       statusChanged:(TUITXVodPlayerStatus)status;

/**
 播放器progress回调
 @param videoModel 当前播放的视频数据模型
 @param currentTime 当前时间
 @param totalTime 总时长
 @param progress 进度
 */
- (void)currentVideo:(TUIPlayerVideoModel *)videoModel
         currentTime:(float)currentTime
           totalTime:(float)totalTime
            progress:(float)progress;
/**
 * 播放器网络状态
 * @param videoModel 当前播放的视频数据模型
 * @param param 网络状态参数
 */
- (void)onNetStatus:(TUIPlayerVideoModel *)videoModel
          withParam:(NSDictionary *)param;

/**
 * 视频预加载回调
 * @param videoModel 视频模型
 */
- (void)videoPreLoadStateWithModel:(TUIPlayerVideoModel *)videoModel;

@end

///自定义回调事件协议
@protocol TUIShortVideoViewCustomCallbackDelegate <NSObject>
/**
 * 调用TUIPlayerShortVideoControl&TUIPlayerShortVideoCustomControl协议的customCallbackEvent
 * 会在此代理收到回调，处理业务事件
 * @param info 业务数据
 */
- (void)customCallbackEvent:(id)info;

@end
///播放器窗口
@interface TUIShortVideoView : UIView
/// 首次加载是否自动播放第一个视频，默认YES
@property (nonatomic, assign) BOOL isAutoPlay;
///视频数据模型
@property (nonatomic, strong, readonly) NSMutableArray<TUIPlayerVideoModel *> *videos;
///当前正在播放的视频模型
@property (nonatomic, strong, readonly) TUIPlayerVideoModel *currentVideoModel;
///当前正在播放的视频索引
@property (nonatomic, assign, readonly) NSInteger currentVideoIndex;
///当前播放器的播放状态
@property (nonatomic, assign, readonly) TUITXVodPlayerStatus currentPlayerStatus;
///当前播放器是否正在播放
@property (nonatomic, assign, readonly) BOOL isPlaying;
///代理
@property (nonatomic, weak) id<TUIShortVideoViewDelegate>delegate;
///自定义回调代理
@property (nonatomic, weak) id<TUIShortVideoViewCustomCallbackDelegate>customCallbackDelegate;
///下拉刷新控件
@property (nonatomic, strong) UIRefreshControl *refreshControl API_AVAILABLE(ios(10.0)) API_UNAVAILABLE(tvos);
///上拉刷新控件
@property (nonatomic, strong) TUIPullUpRefreshControl *pullUpRefreshControl;
///默认是YES ,NO禁止滑动
@property (nonatomic, assign) BOOL scrollEnabled;
/**
 * 初始化（带自定义UI）
 */
- (instancetype)initWithUIManager:(TUIPlayerShortVideoUIManager *)uimanager;
/**
 * 视频播放设置
 * @param model 策略数据模型
 */
- (void)setShortVideoStrategyModel:(TUIPlayerStrategyModel *)model;

/**
 * 首次设置数据源
 * @param models   视频数据源
*/
- (void)setShortVideoModels:(NSArray<TUIPlayerVideoModel *> *)models;

/**
 * 增加数据源
 * @param models   视频数据源
 */
- (void)appendShortVideoModels:(NSArray<TUIPlayerVideoModel *> *)models;

/**
 *  删除所有视频数据
 */
- (void)removeAllVideoModels;
/**
 * 设置播放模式
 * @param playmode   播放模式
*/
- (void)setPlaymode:(TUIPlayMode)playmode;

/**
 * 暂停
 */
- (void)pause;

/**
 * 继续播放
 */
- (void)resume;

/**
 * 销毁播放器
 */
- (void)destoryPlayer;

/**
 * 跳到特定的Cell上
 * @param index   特定Cell的Index
 * @param animated 是否开启动画效果
 */
- (void)didScrollToCellWithIndex:(NSInteger)index animated:(BOOL)animated;

/**
 * 开始加载Loading
 */
- (void)startLoading;

/**
 * 停止加载Loading
 */
- (void)stopLoading;

/**
 * 当前正在播放的视频支持的码率
 * @return 码率数组
 */
- (NSArray<TUIPlayerBitrateItem *> *)currentPlayerSupportedBitrates;

/**
 * 获取当前正在播放的码率索引
 */
- (NSInteger)bitrateIndex;

/**
 * 切换分辨率
 * @param resolution 分辨率, 例：1080*1920
 * @param index 视频索引
 * 【0-n】：切换index位置的单个视频的分辨率
 * 【-1】：切换列表内所有视频的分辨率
 * 【-2】：切换当前播放的单个视频的分辨率
 * @return  返回切换结果 BOOL值 YES&NO
 * 
 * 说明：
 * index = [0-n]
 * - 只会触发当前索引下的视频的分辨率切换
 * index = -2
 * - 只会触发当前所播放的视频的分辨率切换
 * index = -1
 * -会无缝切换当前新的分辨率，时间上略有延迟，如果视频源本身不支持此分辨率设置将无效
 * -同时会触发当先索引后的视频以新的分辨率重新预加载（如果开启了预下载）
 * -同时会触发对一下个视频以新的分辨率重新预播放
 */
- (BOOL)switchResolution:(long)resolution
                   index:(NSInteger)index;

/**
 * 暂停预加载
 */
- (void)pausePreload;

/**
 * 恢复预加载
 */
- (void)resumePreload;

/**
 * 获取数据管理器
 */
- (TUIShortVideoDataManager *)getDataManager;
@end

NS_ASSUME_NONNULL_END
