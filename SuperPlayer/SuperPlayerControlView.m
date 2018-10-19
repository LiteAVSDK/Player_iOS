#import "SuperPlayerControlView.h"

@implementation SuperPlayerControlView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIDeviceOrientationPortrait) {
        [self setOrientationPortraitConstraint];
    } else {
        [self setOrientationLandscapeConstraint];
    }
}

- (void)setOrientationPortraitConstraint
{
    
}

- (void)setOrientationLandscapeConstraint
{
    
}

- (void)addVideoPoint:(CGFloat)where text:(NSString *)text time:(NSInteger)time
{
    
}
- (void)removeAllVideoPoints
{
    
}
@end
