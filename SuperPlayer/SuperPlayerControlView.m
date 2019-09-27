#import "SuperPlayerControlView.h"

@implementation SuperPlayerVideoPoint

@end

@implementation SuperPlayerControlView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _compact =YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (self.compact) {
        [self setOrientationPortraitConstraint];
    } else {
        [self setOrientationLandscapeConstraint];
    }
    [self.delegate controlViewDidChangeScreen:self];
}

- (void)setOrientationPortraitConstraint
{
    
}

- (void)setOrientationLandscapeConstraint
{
    
}

- (void)playerBegin:(SuperPlayerModel *)model
        isLive:(BOOL)isLive
isTimeShifting:(BOOL)isTimeShifting
    isAutoPlay:(BOOL)isAutoPlay
{

}

- (void)setPlayState:(BOOL)isPlay {

}

- (void)setProgressTime:(NSInteger)currentTime
              totalTime:(NSInteger)totalTime
          progressValue:(CGFloat)progress
          playableValue:(CGFloat)playable
{

}

@end
