//
//  AppInstance.h
//  PlayerKit
//

#import <UIKit/UIKit.h>

@interface TXAppInstance : NSObject

+ (void)clickHelp:(UIButton *)sender;

+ (UIImage *)imageFromPlayerBundleNamed:(NSString *)imageName;

typedef enum : NSUInteger {
    Help_超级播放器,
} HelpTitle;

@end
