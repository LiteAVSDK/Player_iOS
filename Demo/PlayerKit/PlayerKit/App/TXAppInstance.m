//
//  AppInstance.m
//  PlayerKit
//

#import <Foundation/Foundation.h>
#import "TXAppInstance.h"

@implementation TXAppInstance

NSString *helpUrlDb[] = {
    [Help_超级播放器]   = @"https://cloud.tencent.com/document/product/454/18871",
};

+ (void)clickHelp:(UIButton *)sender {
    NSURL *        helpUrl = [NSURL URLWithString:helpUrlDb[sender.tag]];
    UIApplication *myApp   = [UIApplication sharedApplication];
    if ([myApp canOpenURL:helpUrl]) {
        [myApp openURL:helpUrl];
    }
}

+ (UIImage *)imageFromPlayerBundleNamed:(NSString *)imageName {
    NSBundle *playerBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"]];
    UIImage *image = [UIImage imageNamed:imageName inBundle:playerBundle compatibleWithTraitCollection:nil];
    return image;
}

@end
