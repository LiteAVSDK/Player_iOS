#import <UIKit/UIKit.h>

#import "TXLaunchMoviePlayProtocol.h"

@interface MoviePlayerViewController : UIViewController <TXLaunchMoviePlayProtocol>
/// Video URL
/// 视频URL
@property(nonatomic, strong) NSString *videoURL;

- (void)startPlayVideoFromLaunchInfo:(NSDictionary *)launchInfo complete:(void (^)(BOOL succ))complete;

@end
