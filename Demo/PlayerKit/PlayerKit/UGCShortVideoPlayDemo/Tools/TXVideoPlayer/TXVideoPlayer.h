//
//  TXVideoPlayer.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/18.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PlayerKitCommonHeaders.h"
#import "TXVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TXVideoPlayerStatus) {
    TXVideoPlayerStatusUnload,      // 未加载
    TXVideoPlayerStatusPrepared,    // 准备播放
    TXVideoPlayerStatusLoading,     // 加载中
    TXVideoPlayerStatusPlaying,     // 播放中
    TXVideoPlayerStatusPaused,      // 暂停
    TXVideoPlayerStatusEnded,       // 播放完成
    TXVideoPlayerStatusError        // 错误
};

@class TXVideoPlayer;

@protocol TXVideoPlayerDelegate <NSObject>

- (void)player:(TXVideoPlayer *)player statusChanged:(TXVideoPlayerStatus)status;

- (void)player:(TXVideoPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress;

@end

@interface TXVideoPlayer : NSObject

@property (nonatomic, weak) id<TXVideoPlayerDelegate>       delegate;

@property (nonatomic, assign) TXVideoPlayerStatus           status;

@property (nonatomic, assign) BOOL                          isPlaying;

@property (nonatomic, assign) BOOL                          loop;

@property (nonatomic, assign) BOOL                          isAutoPlay;

/**
 预加载
 */
- (void)preparePlayWithVideoModel:(TXVideoModel *)model;
/**
 根据指定url在指定视图上播放视频
 
 @param playView 播放视图
 @param url 播放地址
 */
- (void)playVideoWithView:(UIView *)playView url:(NSString *)url;

/**
 停止播放并移除播放视图
 */
- (void)removeVideo;

/**
 暂停播放
 */
- (void)pausePlay;

/**
 恢复播放
 */
- (void)resumePlay;

/**
 * 开始播放
 * @param url 视频url
 */
- (void)startPlayWithUrl:(NSString *)url;

/**
 * 播放跳转到某个时间
 * @param time 流时间，单位为秒
 */
- (void)seekToTime:(float)time;

/**
 * 当播放地址为master playlist，返回支持的码率（清晰度）
 *
 * @warning 在收到EVT_VIDEO_PLAY_BEGIN事件后才能正确返回结果
 * @return 无多码率返回空数组
 */
- (NSArray<TXBitrateItem *> *)supportedBitrates;

/**
 * 设置当前正在播放的码率索引，无缝切换清晰度
 *  清晰度切换可能需要等待一小段时间。腾讯云支持多码率HLS分片对齐，保证最佳体验。
 *
 * @param index 码率索引，index == -1，表示开启HLS码流自适应；index > 0 （可从supportedBitrates获取），表示手动切换到对应清晰度码率
 */
- (void)setBitrateIndex:(NSInteger)index;

/**
 应用进入前台处理
 */
- (void)detailAppWillEnterForeground;

/**
 应用退到后台处理
 */
- (void)detailAppDidEnterBackground;

@end

NS_ASSUME_NONNULL_END
