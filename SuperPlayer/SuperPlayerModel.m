#import "SuperPlayerModel.h"
#import "SuperPlayer.h"

@implementation SuperPlayerUrl
@end

@implementation SuperPlayerModel

- (UIImage *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = SuperPlayerImage(@"loading_bgView");
    }
    return _placeholderImage;
}
@end
