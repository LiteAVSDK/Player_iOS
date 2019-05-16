//
//  DrmPlayViewController.m
//  Example
//
//  Created by annidyfeng on 2019/3/1.
//  Copyright © 2019年 annidy. All rights reserved.
//

#import "DrmPlayViewController.h"
#import <SuperPlayer/SuperPlayer.h>
#import <MMLayout/UIView+MMLayout.h>
#import "Masonry.h"
#import <AFNetworking.h>

@interface DrmPlayViewController ()<SuperPlayerDelegate>
@property UIView *playerContainer;
@property SuperPlayerView *playerView;
@end

@implementation DrmPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.playerContainer = [[UIView alloc] init];
    self.playerContainer.backgroundColor = [UIColor blackColor];
    self.playerContainer.mm_width(self.view.mm_w).mm_height(self.view.mm_w*9.0f/16.0f);
    
    _playerView = [[SuperPlayerView alloc] init];
    // 设置父View
    _playerView.disableGesture = YES;
    

    [self.view addSubview:self.playerContainer];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectZero];
    text.text = @"加密视频可阻止截屏、录屏、下载等，保护视频不被非法使用";
    text.mm_sizeToFit().mm_top(_playerContainer.mm_maxY+20);
    [self.view addSubview:text];
    
    [self getToken];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)superPlayerBackAction:(SuperPlayerView *)player {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didMoveToParentViewController:(nullable UIViewController *)parent
{
    if (parent == nil) {
        [self.playerView resetPlayer];
    }
}

- (void)getToken
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //    SuperEncrypt *enc = [SuperEncrypt new];
    //    NSString *pubKey = [NSString stringWithFormat:@"-----BEGIN+RSA+PUBLIC+KEY-----\n%@\n-----END+RSA+PUBLIC+KEY-----", [[enc getPublicKey] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]];
    
    // @"http://129.204.177.142/gettoken"
    [manager GET:@"https://demo.vod2.myqcloud.com/drm/gettoken" parameters:@{@"fileId":@"5285890787511552106",@"appId":@"1256468886"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSData *responseObject) {
        
        NSString *token  = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
        SuperPlayerVideoId *video = [[SuperPlayerVideoId alloc] init];
        video.appId = 1256468886;
        video.fileId = @"5285890787511552106";
        video.playDefinition = @"20";
        video.version = FileIdV3;
        playerModel.videoId = video;
        playerModel.token = token;
        playerModel.certificate = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://5000.drm.myqcloud.com/huaxida_test/fairplay.cer"]];
        
        self.playerView.delegate = self;
        self.playerView.fatherView = self.playerContainer;
        
        // 开始播放
        [self.playerView playWithModel:playerModel];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end

