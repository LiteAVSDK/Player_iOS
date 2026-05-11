//  Copyright © 2023 Tencent. All rights reserved.
//

#import "ViewController.h"
#import "PlayerLocalized.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *appName = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
    self.title = [PlayerLocalized(@"Player.MianTitle") stringByAppendingFormat:@" - %@", appName];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


@end
