//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import "PlayerKitCommonHeaders.h"
#import "TUIPSDFullScreenViewController.h"
#import "TUIPSVDCommonDefine.h"
#import "TUIPSVDResourceManager.h"
#import "TUIPSDFullScreenControlView.h"
@interface TUIPSDFullScreenViewController ()<TUIPSDFullScreenControlViewDelegate,TUITXVodPlayerDelegate>

@property (nonatomic, strong) TUIPSDFullScreenControlView *controlView;
@property (nonatomic, assign) BOOL isPlayEnd; /// 是否播放结束
@property (nonatomic, assign) float totalTime;
@end

@implementation TUIPSDFullScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    id delegate = [UIApplication sharedApplication].delegate;
    [delegate setValue:@(UIInterfaceOrientationMaskLandscape) forKey:@"interfaceOrientationMask"];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.controlView];
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.controlView.hidden = YES;
}

- (void)setPlayerView:(UIView *)playerView {
    _playerView = playerView;
    [self.view insertSubview:playerView belowSubview:self.controlView];
    
    CGSize playerViewSize = playerView.bounds.size;
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(@(playerViewSize.width));
        make.height.equalTo(@(playerViewSize.height));
    }];
    playerView.transform = CGAffineTransformMakeRotation(-M_PI_2);

}
- (void)setVodPlayer:(TUITXVodPlayer *)vodPlayer {
    _vodPlayer = vodPlayer;
    [vodPlayer addDelegate:self];
    [self.controlView setPlayerStatus:vodPlayer.isPlaying];
}
- (void)setLivePlayer:(TUITXLivePlayer *)livePlayer {
    _livePlayer = livePlayer;
    [self.controlView setPlayerStatus:livePlayer.isPlaying];
}
- (void)setType:(NSInteger)type {
    _type = type;
    if (type == 1) { /// 点播
        [self.controlView progressViewHidden:NO];
    } else if (type == 2) { ///直播
        [self.controlView progressViewHidden:YES];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        [UIView animateWithDuration:0.3 animations:^{
            self.playerView.transform = CGAffineTransformMakeRotation(0);
            [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
        }];
        } completion:^(BOOL finished) {
            self.controlView.hidden = NO;
        }];
}
#pragma mark - lazyload
- (TUIPSDFullScreenControlView *)controlView {
    if (!_controlView) {
        _controlView = [[TUIPSDFullScreenControlView alloc] init];
        _controlView.delegate = self;
    }
    return _controlView;
}

#pragma mark - TUIPSDFullScreenControlViewDelegate
- (void)backAction {
    self.controlView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
            self.playerView.transform = CGAffineTransformMakeRotation(M_PI_2);
        } else { //right
            self.playerView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
        
        CGSize playerViewSize = self.playerView.bounds.size;
        [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(@(playerViewSize.height));
            make.height.equalTo(@(playerViewSize.width));
        }];
    } completion:^(BOOL finished) {
        if (finished) {
            self.playerView.transform = CGAffineTransformMakeRotation(0);
            id delegate = [UIApplication sharedApplication].delegate;
            [delegate setValue:@(UIInterfaceOrientationMaskPortrait) forKey:@"interfaceOrientationMask"];
            [self dismissViewControllerAnimated:NO completion:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(viewControllerDismissed)]) {
                    [self.delegate viewControllerDismissed];
                }
            }];
        }
    }];
    
   
    if (self.type == 2) {
        [self.livePlayer resumeAudio];
        [self.livePlayer resumeVideo];
    }
}

- (void)pause {
    if ([self.delegate respondsToSelector:@selector(pause)]) {
        [self.delegate pause];
    }
}
- (void)resume {
    if ([self.delegate respondsToSelector:@selector(resume)]) {
        [self.delegate resume];
    }
}
- (void)seekToTime:(float)time {
    [self.vodPlayer seekToTime:time*self.totalTime];
}

#pragma mark - TUITXVodPlayerDelegate
- (void)player:(TUITXVodPlayer *)player
   currentTime:(float)currentTime
     totalTime:(float)totalTime
      progress:(float)progress {
    
    TUIPSVD_WEAK_SELF(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        TUIPSVD_STRONG_SELF(self);
        [self.controlView setProgress:progress];
        if (self.totalTime == 0) {
            self.totalTime = totalTime;
            [self.controlView setDurationTime:totalTime];
        }
        int intCurrentTime = currentTime;
        int intTotalTime = totalTime;
        if (intCurrentTime <= intTotalTime) {
            if (!self.isPlayEnd) {
                [self.controlView setCurrentTime:currentTime];
                if (intCurrentTime == intTotalTime) {
                    self.isPlayEnd = YES;
                }
            } else {
                [self.controlView setCurrentTime:currentTime];
            }
        }
    });
    
}
@end
