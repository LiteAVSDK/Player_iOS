//
//  DrmPlayViewController.m
//  Example
//
//  Created by annidyfeng on 2019/3/1.
//  Copyright © 2019年 annidy. All rights reserved.
//

#import "DrmPlayViewController.h"
#import <SuperPlayer/SuperPlayer.h>
#import <SuperPlayer/UIView+MMLayout.h>
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
    self.playerContainer.m_width(self.view.mm_w).m_height(self.view.mm_w*9.0f/16.0f);
    
    _playerView = [[SuperPlayerView alloc] init];
    // 设置父View
    _playerView.disableGesture = YES;
    

    [self.view addSubview:self.playerContainer];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectZero];
    text.text = @"getplayinfo v3加密视频";
    text.m_sizeToFit().m_top(_playerContainer.mm_maxY+20);
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
    [manager POST:@"https://demo.vod2.myqcloud.com/drm/gettoken" parameters:@{@"fileId":@"15517827183850370616"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSData *responseObject) {
        
        NSString *token  = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
        SuperPlayerVideoId *video = [[SuperPlayerVideoId alloc] init];
        video.appId = 1253039488;
        video.fileId = @"15517827183850370616";
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

