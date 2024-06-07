//
//  VodPlayerRouter.m
//  PlayerKit
//
//  Created by hefeima on 2023/12/8.
//

#import "VodPlayerRouter.h"
#import "MoviePlayerViewController.h" //  超级播放器
#import "PlayVodViewController.h"     // 点播播放器
#import "TUIShortVideoPlayViewController.h"  //短视频（高级版）
#import "ShortVideoPlayViewController.h"   //短视频
#import "FeedPlayViewController.h"         //Feed流
@interface VodPlayerRouter ()
@property(nonatomic, strong) NSArray<TKMainEntrance *> *entranceArr;
@end

@implementation VodPlayerRouter
- (instancetype)initWithNavigation:(UINavigationController *)nav {
    self = [super initWithNavigation:nav];
    if (self) {
        [self createEntranceArr];
    }
    return self;
}

- (void)createEntranceArr {
    __weak typeof(self) weakSelf = self;

    TKMainEntrance *superPlayerEntrance = [[TKMainEntrance alloc] init];
    superPlayerEntrance.title = baseLocalized(@"超级播放器");
    superPlayerEntrance.action = ^{
        MoviePlayerViewController *vc = [[MoviePlayerViewController alloc] init];
        [weakSelf.navigation pushViewController:vc animated:YES];
    };

    TKMainEntrance *vodEntrance = [[TKMainEntrance alloc] init];
    vodEntrance.title = baseLocalized(@"点播播放器");
    vodEntrance.action = ^{
        PlayVodViewController *vc = [[PlayVodViewController alloc] init];
        [weakSelf.navigation pushViewController:vc animated:YES];
    };

    TKMainEntrance *tuiShortVideoEntrance = [[TKMainEntrance alloc] init];
    tuiShortVideoEntrance.title = baseLocalized(@"短视频（高级版）");
    tuiShortVideoEntrance.action = ^{
        TUIShortVideoPlayViewController *vc = [[TUIShortVideoPlayViewController alloc] init];
        [weakSelf.navigation pushViewController:vc animated:YES];
    };
    
    TKMainEntrance *shortVideoEntrance = [[TKMainEntrance alloc] init];
    shortVideoEntrance.title = baseLocalized(@"短视频");
    shortVideoEntrance.action = ^{
        ShortVideoPlayViewController *vc = [[ShortVideoPlayViewController alloc] init];
        [weakSelf.navigation pushViewController:vc animated:YES];
    };
    
    TKMainEntrance *feedPlayEntrance = [[TKMainEntrance alloc] init];
    feedPlayEntrance.title = baseLocalized(@"Feed流播放器");
    feedPlayEntrance.action = ^{
        FeedPlayViewController *vc = [[FeedPlayViewController alloc] init];
        [weakSelf.navigation pushViewController:vc animated:YES];
    };

    self.entranceArr = @[superPlayerEntrance ,vodEntrance,tuiShortVideoEntrance, shortVideoEntrance, feedPlayEntrance ];
}

- (NSArray<TKMainEntrance *> *)entrances {
    return self.entranceArr;
}
@end
