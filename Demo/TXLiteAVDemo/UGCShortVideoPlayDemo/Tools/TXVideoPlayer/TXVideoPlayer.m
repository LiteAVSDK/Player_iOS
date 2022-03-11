//
//  TXVideoPlayer.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/18.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXVideoPlayer.h"
#import "TXVideoPlayMem.h"
#import "TXLiveBase.h"
#import "TXVodPlayer.h"
#import "TXVodPlayListener.h"

@interface TXVideoPlayer()<TXVodPlayListener>

@property (nonatomic, strong) TXVodPlayer     *player;

@property (nonatomic, assign) float           duration;

@property (nonatomic, assign) BOOL            isNeedResume;

@property (nonatomic, assign) BOOL            isPrepared;

@end

@implementation TXVideoPlayer

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - Public Method
- (void)preparePlayWithVideoModel:(TXVideoModel *)model {
    self.isPrepared = NO;
    [self removeVideo];
    self.player.isAutoPlay = NO;
    [self startPlayWithUrl:model.videourl];
    [self.player setBitrateIndex:model.bitrateIndex];
}

- (void)playVideoWithView:(UIView *)playView url:(NSString *)url {
    // 设置播放视图
    [self.player setupVideoWidget:playView insertIndex:0];
    
    // 开始播放
    if (self.player.isAutoPlay) {
        [self.player startPlay:url];
    } else {
        [self resumePlay];
    }
}

- (void)removeVideo {
    // 停止播放
    [self.player stopPlay];
    
    // 移除player视图
    [self.player removeVideoWidget];
    
    // 改变状态
    [self playerStatusChange:TXVideoPlayerStatusUnload];
    
}

- (void)pausePlay {
    // 暂停播放
    [self.player pause];
    
    // 改变状态
    [self playerStatusChange:TXVideoPlayerStatusPaused];
}

- (void)resumePlay {
    if (self.status == TXVideoPlayerStatusPaused || self.status == TXVideoPlayerStatusPrepared || self.status == TXVideoPlayerStatusLoading) {
        [self.player resume];

        // 状态改变
        [self playerStatusChange:TXVideoPlayerStatusPlaying];
    } else {
        _isPrepared = YES;
    }
}

- (void)startPlayWithUrl:(NSString *)url {
    [self.player startPlay:url];
}

- (BOOL)isPlaying {
    return self.player.isPlaying;
}

- (void)setLoop:(BOOL)loop {
    _loop = loop;
    self.player.loop = loop;
}

- (void)setIsAutoPlay:(BOOL)isAutoPlay {
    _isAutoPlay = isAutoPlay;
    self.player.isAutoPlay = isAutoPlay;
}

- (void)seekToTime:(float)time {
    [self.player seek:time];
}

- (NSArray<TXBitrateItem *> *)supportedBitrates {
    return self.player.supportedBitrates;
}

- (void)setBitrateIndex:(NSInteger)index {
    [self.player setBitrateIndex:index];
}

- (void)detailAppWillEnterForeground {
    
    if (self.isNeedResume && self.status == TXVideoPlayerStatusPaused) {
        self.isNeedResume = NO;
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        WEAKIFY(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            STRONGIFY(self);
            [self resumePlay];
        });
    }
}

- (void)detailAppDidEnterBackground {
    if (self.status == TXVideoPlayerStatusLoading || self.status == TXVideoPlayerStatusPlaying || self.status == TXVideoPlayerStatusPrepared) {
        [self pausePlay];
        self.isNeedResume = YES;
    }
}

#pragma mark - Private Methods
- (void)playerStatusChange:(TXVideoPlayerStatus)status {
    self.status = status;
    if (self.delegate && [self.delegate respondsToSelector:@selector(player:statusChanged:)]) {
        [self.delegate player:self statusChanged:status];
    }
}

#pragma mark - 懒加载
- (TXVodPlayer *)player {
    if (!_player) {
        _player = [TXVodPlayer new];
        _player.enableHWAcceleration = YES;
        _player.vodDelegate = self;
        TXVodPlayConfig *config = [TXVodPlayConfig new];
        config.maxBufferSize = 1;
        config.smoothSwitchBitrate = NO;
        _player.config = config;
        [_player setRenderMode:RENDER_MODE_FILL_SCREEN];
    }
    return _player;
}

#pragma mark - TXVodPlayListener
- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
    switch (EvtID) {
        case EVT_VOD_PLAY_PREPARED: {           //  视频加载完毕
            [self playerStatusChange:TXVideoPlayerStatusPrepared];
            if (_isPrepared) {
                [self.player resume];
                self.isPrepared = NO;
                [self playerStatusChange:TXVideoPlayerStatusPlaying];
            }
        }
            break;
        case PLAY_EVT_PLAY_LOADING: {            //  加载中
            if (self.status == TXVideoPlayerStatusPaused) {
                [self playerStatusChange:TXVideoPlayerStatusPaused];
            } else {
                [self playerStatusChange:TXVideoPlayerStatusLoading];
            }
        }
            break;
        case PLAY_EVT_PLAY_PROGRESS: {          //  播放进度
            self.duration = [param[EVT_PLAY_DURATION] floatValue];
            
            float currentTime = [param[EVT_PLAY_PROGRESS] floatValue];
            
            float progress = self.duration == 0 ? 0 : currentTime / self.duration;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(player:currentTime:totalTime:progress:)]) {
                [self.delegate player:self currentTime:currentTime totalTime:self.duration progress:progress];
            }
        }
            break;
        case PLAY_EVT_PLAY_END: {               //  播放结束
            if (self.delegate && [self.delegate respondsToSelector:@selector(player:currentTime:totalTime:progress:)]) {
                [self.delegate player:self currentTime:self.duration totalTime:self.duration progress:1.0f];
            }
            [self playerStatusChange:TXVideoPlayerStatusEnded];
        }
            break;
        case PLAY_ERR_NET_DISCONNECT: {         //  失败，多次重链无效
            [self playerStatusChange:TXVideoPlayerStatusError];
        }
            break;
            
        default:
            break;
    }
}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {
    
}

@end
