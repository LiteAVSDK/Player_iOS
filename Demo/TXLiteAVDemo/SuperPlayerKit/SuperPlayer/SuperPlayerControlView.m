#import "SuperPlayerControlView.h"

@implementation SuperPlayerControlView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _compact = YES;
        _enableFadeAction = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (self.compact) {
        [self setOrientationPortraitConstraint];
    } else {
        [self setOrientationLandscapeConstraint];
    }
    [self.delegate controlViewDidChangeScreen:self];
}

- (void)setOrientationPortraitConstraint {
}

- (void)setOrientationLandscapeConstraint {
}

- (void)resetWithResolutionNames:(NSArray<NSString *> *)resolutionNames
          currentResolutionIndex:(NSUInteger)resolutionIndex
                          isLive:(BOOL)isLive
                  isTimeShifting:(BOOL)isTimeShifting
                       isPlaying:(BOOL)isAutoPlay {
}

- (void)resetWithTracks:(NSMutableArray *)tracks
      currentTrackIndex:(NSInteger)trackIndex
              subtitles:(NSMutableArray *)subtitles
  currentSubtitlesIndex:(NSInteger)subtitleIndex {
}

- (void)setPlayState:(BOOL)isPlay {
}

- (void)showOrHideBackBtn:(BOOL)isShow {
}

- (void)setSliderState:(BOOL)isEnable {
}

- (void)setTopViewState:(BOOL)isShow {
}

- (void)setResolutionViewState:(BOOL)isShow {
}

- (void)setNextBtnState:(BOOL)isShow {
}

- (void)setTrackBtnState:(BOOL)isShow {
}

- (void)setSubtitlesBtnState:(BOOL)isShow {
}

- (void)setDisableOfflineBtn:(BOOL)disableOfflineBtn {
}

- (void)setProgressTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime progressValue:(CGFloat)progress playableValue:(CGFloat)playable {
}

@end
