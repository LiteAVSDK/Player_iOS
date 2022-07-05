//
//  FeedBaseView.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "FeedBaseView.h"
#import "FeedHeadModel.h"
#import "FeedVideoPlayMem.h"
#import <Masonry/Masonry.h>

@interface FeedBaseView()<SuperPlayerDelegate>

@property (nonatomic, strong) SuperPlayerView *tempPlayView;

@property (nonatomic, strong) UIView          *fatherView;

@property (nonatomic, strong) UIView          *marginView;

@end

@implementation FeedBaseView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:24.0/255.0 blue:47.0/255.0 alpha:1.0];
        [self addSubview:self.fatherView];
        [self addSubview:self.headView];
        [self addSubview:self.marginView];
        [self.fatherView addSubview:self.superPlayView];
        
        [self.fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.left.equalTo(self).offset(8);
            make.right.equalTo(self).offset(-8);
            make.height.mas_equalTo(cellHeight);
        }];
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self).offset(8 + cellHeight + 8);
            make.height.mas_equalTo(56);
        }];
        
        [self.marginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(8);
        }];
        
        [self.superPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.fatherView);
        }];
        
        [self.headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTap)]];
    }
    return self;
}

#pragma mark - Public Method
- (void)setModel:(FeedVideoModel *)model {
    _model = model;
    FeedHeadModel *headModel = [FeedHeadModel new];
    headModel.headImageUrl = model.coverUrl;
    headModel.videoNameStr = model.title;
    headModel.videoSubTitleStr  = model.videoIntroduce;
    
    [self.headView setHeadModel:headModel];
    [self.superPlayView.controlView setTitle:model.title];
    [self.superPlayView showOrHideBackBtn:NO];
    
    [self playVideoWithModel:model];
}

- (void)playVideoWithModel:(FeedVideoModel *)model {
    SuperPlayerModel *playerModel   = [SuperPlayerModel new];
    SuperPlayerVideoId *videoId     = [SuperPlayerVideoId new];

    playerModel.appId = model.appId;
    videoId.fileId    = model.fileId;
    videoId.psign = nil;
    playerModel.videoId = videoId;
    playerModel.videoURL = nil;
    playerModel.action = PLAY_ACTION_PRELOAD;
    playerModel.defaultCoverImageUrl = model.coverUrl;
    playerModel.duration = model.duration;

    [self.superPlayView playWithModel:playerModel];
    
    SPDefaultControlView *defaultControlView = (SPDefaultControlView *)self.superPlayView.controlView;
    defaultControlView.disableDanmakuBtn = YES;
    defaultControlView.disablePipBtn = YES;
}

- (void)pause {
    [self.superPlayView pause];
}

- (void)resume {
    [self.superPlayView resume];
}

- (void)removeVideo {
    [self.superPlayView removeVideo];
}

- (void)resetPlayer {
    [self.superPlayView resetPlayer];
}

- (void)addSuperPlayView:(UIView *)view {
    self.superPlayView = (SuperPlayerView *)view;
    [self addSubview:self.superPlayView];
    self.superPlayView.fatherView = self.fatherView;
    [self.superPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.mas_equalTo(cellHeight);
    }];
    
    if (self.superPlayView.state == StatePause) {
        [self.superPlayView resume];
    }
    
}

#pragma mark - Click
- (void)handlerTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headViewClick)]) {
        [self.delegate headViewClick];
    }
}

#pragma mark - SuperPlayerDelegate
- (void)superPlayerFullScreenChanged:(SuperPlayerView *)player {
    [[UIApplication sharedApplication] setStatusBarHidden:player.isFullScreen];
    if (player.isFullScreen) {
        player.disableGesture = YES;
        [player showOrHideBackBtn:YES];
    } else {
        player.disableGesture = NO;
        [player showOrHideBackBtn:NO];
    }
}

- (void)superPlayerDidStart:(SuperPlayerView *)player {
    if (self.delegate && [self.delegate respondsToSelector:@selector(superPlayerDidStart)]) {
        [self.delegate superPlayerDidStart];
    }
}

#pragma mark - 懒加载
- (UIView *)fatherView {
    if (!_fatherView) {
        _fatherView = [UIView new];
    }
    return _fatherView;
}

- (UIView *)marginView {
    if (!_marginView) {
        _marginView = [UIView new];
        _marginView.backgroundColor = [UIColor blackColor];
    }
    return _marginView;
}

- (SuperPlayerView *)superPlayView {
    if (!_superPlayView) {
        _superPlayView = [SuperPlayerView new];
        _superPlayView.fatherView = self.fatherView;
        _superPlayView.backgroundColor = [UIColor clearColor];
        _superPlayView.disableGesture = NO;
        _superPlayView.delegate = self;
        _superPlayView.disableVolumControl = YES;
    }
    return _superPlayView;
}

- (FeedHeadView *)headView {
    if (!_headView) {
        _headView = [FeedHeadView new];
    }
    return _headView;
}

@end
