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
#import "PlayerKitCommonHeaders.h"
@interface FeedBaseView()<SuperPlayerDelegate>

@property (nonatomic, strong) UIView           *fatherView;

@property (nonatomic, strong) UIView           *marginView;

@property (nonatomic, assign) BOOL             isPrepare;

@property (nonatomic, strong) SuperPlayerModel *playerModel;

@end

@implementation FeedBaseView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:24.0/255.0 blue:47.0/255.0 alpha:1.0];
        [self addSubview:self.fatherView];
        self.superPlayView = [self createSuperPlayView];
        self.superPlayView.fatherView = self.fatherView;
        [self addSubview:self.headView];
        [self addSubview:self.marginView];
        
        [self.fatherView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.left.equalTo(self).offset(8);
            make.right.equalTo(self).offset(-8);
            make.height.mas_equalTo(cellHeight);
        }];
        [self.superPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.fatherView);
        }];
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self.fatherView.mas_bottom).offset(8);
            make.height.mas_equalTo(56);
        }];
        
        [self.marginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.top.equalTo(self.headView.mas_bottom);
            make.height.mas_equalTo(8);
        }];
        
        
        
        [self.headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTap)]];
    }
    return self;
}

#pragma mark - Public Method
- (void)setModel:(FeedVideoModel *)model {
    _model = model;
    
    self.isPrepare = NO;
    FeedHeadModel *headModel = [FeedHeadModel new];
    headModel.headImageUrl = model.coverUrl;
    headModel.videoNameStr = model.title;
    headModel.videoSubTitleStr  = model.videoIntroduce;
    
    [self.headView setHeadModel:headModel];
    
    if (self.superPlayView == nil ) { ///如果为nil 说明这个视频窗口被移动到了横屏VC或者详情VC
        ///tableview发生了reload导致不再是原来的cell
        self.superPlayView = [self createSuperPlayView]; ///
        self.superPlayView.fatherView = self.fatherView;
    }
    
    
    [self.superPlayView.controlView setTitle:model.title];
    [self playVideoWithModel:model];
}

- (void)playVideoWithModel:(FeedVideoModel *)model {
    SuperPlayerModel *playerModel   = [SuperPlayerModel new];
    SuperPlayerVideoId *videoId     = [SuperPlayerVideoId new];

    playerModel.appId = model.appId;
    videoId.fileId    = model.fileId;
    videoId.psign = model.pSign;
    playerModel.videoId = videoId;
    playerModel.videoURL = model.videoURL;
    playerModel.action = PLAY_ACTION_PRELOAD;
    playerModel.defaultCoverImageUrl = model.coverUrl;
    playerModel.duration = model.duration;

    playerModel.multiVideoURLs = model.multiVideoURLs;
    self.playerModel = playerModel;
    [self.superPlayView.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:SuperPlayerImage(@"defaultCoverImage")];
    if (self.superPlayView.state == StatePlaying) {
        self.superPlayView.centerPlayBtn.hidden = YES;
    } else {
        self.superPlayView.centerPlayBtn.hidden = NO;
    }
    self.superPlayView.controlView.hidden = YES;
    [self.superPlayView showOrHideBackBtn:NO];
    SPDefaultControlView *defaultControlView = (SPDefaultControlView *)self.superPlayView.controlView;
    defaultControlView.disableDanmakuBtn = YES;
    defaultControlView.disablePipBtn = YES;
}

- (void)prepare {
    if (self.isPrepare) {
        return;
    }
    self.isPrepare = YES;
    [self.superPlayView playWithModelNeedLicence:self.playerModel];
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
    [self.superPlayView pause];
    [self.superPlayView removeFromSuperview];
    self.superPlayView = (SuperPlayerView *)view;
    self.superPlayView.delegate = self;
    self.superPlayView.fatherView = self.fatherView;
    [self.superPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-8);
        make.height.mas_equalTo(cellHeight);
    }];
    
    if (self.superPlayView.state == StatePlaying) {
        self.superPlayView.centerPlayBtn.hidden = YES;
    } else {
        self.superPlayView.centerPlayBtn.hidden = NO;
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

- (void)screenRotation:(BOOL)fullScreen {
    if(self.delegate && [self.delegate respondsToSelector:@selector(screenRotation:)]){
        [self.delegate screenRotation:fullScreen];
    }
}

-(void)fullScreenHookAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showFullScreenViewWithPlayView:)]){
        [self.delegate showFullScreenViewWithPlayView:self.superPlayView];
        self.superPlayView = nil;
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


- (SuperPlayerView *)createSuperPlayView {
    SuperPlayerView *superPlayView = [SuperPlayerView new];
    superPlayView.fatherView = self.fatherView;
    superPlayView.backgroundColor = [UIColor clearColor];
    superPlayView.disableGesture = NO;
    superPlayView.delegate = self;
    superPlayView.disableVolumControl = YES;
    return superPlayView;
}

- (FeedHeadView *)headView {
    if (!_headView) {
        _headView = [FeedHeadView new];
    }
    return _headView;
}

@end


