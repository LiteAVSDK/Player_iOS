//
//  PlayerAppdelegate.m
//  PlayerKit
//
//  Created by hefeima on 2023/12/11.
//

#import "PlayerAppdelegate.h"

@implementation PlayerAppdelegate

- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return  self.interfaceOrientationMask ?: UIInterfaceOrientationMaskPortrait;
}
@end
