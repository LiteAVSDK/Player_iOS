//
//  FeedDetailView.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "FeedDetailView.h"
#import "FeedVideoPlayMem.h"
#import "FeedHeadModel.h"
#import "FeedDetailViewCell.h"
#import <Masonry/Masonry.h>

NSString * const FeedDetailVideoCellIdentifier = @"FeedDetailVideoCellIdentifier";

@interface FeedDetailView()<UITableViewDelegate, UITableViewDataSource, SuperPlayerDelegate>

@property (nonatomic, strong) UIView             *videoView;

@property (nonatomic, strong) UITableView        *tableView;

@property (nonatomic, strong) NSMutableArray     *videos;

@property (nonatomic, strong) SuperPlayerView    *temPlayView;

@end

@implementation FeedDetailView

- (instancetype)init {
    if (self = [super init]) {
        // 背景色
        self.backgroundColor = [UIColor whiteColor];
        NSArray *colors = @[(__bridge id)[UIColor colorWithRed:19.0 / 255.0 green:41.0 / 255.0 blue:75.0 / 255.0 alpha:1].CGColor,
                            (__bridge id)[UIColor colorWithRed:5.0 / 255.0 green:12.0 / 255.0 blue:23.0 / 255.0 alpha:1].CGColor];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = colors;
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.frame = self.bounds;
        [self.layer insertSublayer:gradientLayer atIndex:0];
        
        [self addSubview:self.videoView];
        [self addSubview:self.headView];
        [self addSubview:self.tableView];
        
        [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.height.mas_equalTo(cellHeight);
        }];
    }
    return self;
}

#pragma mark - Public Method
- (void)setModel:(FeedHeadModel *)model {
    CGSize size = CGSizeMake(ScreenWidth, 2000);
    UIFont *font = [UIFont systemFontOfSize:14];
    NSDictionary *attrDic = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect subtitlelabelRect = [model.videoSubTitleStr boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attrDic context:nil];
    CGRect deslabelRect = [model.videoDesStr boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attrDic context:nil];
    CGFloat subHeight = subtitlelabelRect.size.height > 14 ? subtitlelabelRect.size.height : 14;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(cellHeight);
        make.right.equalTo(self);
        make.height.mas_equalTo(44 + subHeight + deslabelRect.size.height);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(cellHeight + 44 + subHeight + deslabelRect.size.height);
        make.bottom.equalTo(self);
    }];
    
    _model = model;
    [self.headView setHeadModel:model subLableHeight:subHeight];
}

- (void)setVideoModel:(FeedVideoModel *)videoModel {
    _videoModel = videoModel;
}

- (void)setSuperPlayView:(SuperPlayerView *)superPlayView {
    _superPlayView = superPlayView;
    [self.videoView addSubview:superPlayView];
    superPlayView.fatherView = self.videoView;
    [superPlayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.videoView);
    }];
    
    if (superPlayView.state == StatePause || superPlayView.state == StatePrepare) {
        [self.superPlayView resume];
    }
}

- (void)setListData:(NSArray *)videos {
    
    [self.videos removeAllObjects];
    [self.videos addObjectsFromArray:videos];
    
    [self.tableView reloadData];
}

- (void)destory {
    if (self.temPlayView) {
        [self.temPlayView removeVideo];
        self.temPlayView = nil;
    }
}

#pragma mark - Private Method
- (SuperPlayerModel *)setSuperPlayerModel:(FeedDetailModel *)model {
    SuperPlayerModel *playerModel   = [SuperPlayerModel new];
    SuperPlayerVideoId *videoId     = [SuperPlayerVideoId new];

    playerModel.appId = model.appId;
    videoId.fileId    = model.fileId;
    videoId.psign = nil;
    playerModel.videoId = videoId;
    playerModel.videoURL = nil;
    playerModel.action = PLAY_ACTION_AUTO_PLAY;
    playerModel.defaultCoverImageUrl = model.coverUrl;

    return playerModel;
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

#pragma mark - UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedDetailVideoCellIdentifier];
    if (!cell) {
        cell = [[FeedDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeedDetailVideoCellIdentifier];
    }
    if (cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.videos[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedDetailViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell) {
        // 先暂停掉正在播放的
        [self.superPlayView pause];
        
        [self.temPlayView playWithModelNeedLicence:[self setSuperPlayerModel:cell.model]];
        [self.temPlayView.controlView setTitle:cell.model.title];
        [self.temPlayView showOrHideBackBtn:NO];
        
        SPDefaultControlView *defaultControlView = (SPDefaultControlView *)self.temPlayView.controlView;
        defaultControlView.disableDanmakuBtn = YES;
        defaultControlView.disablePipBtn = YES;
        
        // 修改介绍
        FeedHeadModel *model = [[FeedHeadModel alloc] init];
        model.headImageUrl = cell.model.coverUrl;
        model.videoNameStr = cell.model.title;
        model.videoSubTitleStr = cell.model.videoIntroduce;
        model.videoDesStr = cell.model.videoDesStr;
        [self setModel:model];
    }
}

#pragma mark - 懒加载
- (UIView *)videoView {
    if (!_videoView) {
        _videoView = [UIView new];
        _videoView.backgroundColor = [UIColor blackColor];
    }
    return _videoView;
}

- (FeedDetailHeadView *)headView {
    if (!_headView) {
        _headView = [FeedDetailHeadView new];
    }
    return _headView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:24.0/255.0 blue:47.0/255.0 alpha:1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FeedDetailViewCell class] forCellReuseIdentifier:FeedDetailVideoCellIdentifier];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (NSMutableArray *)videos {
    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

- (SuperPlayerView *)temPlayView {
    if (!_temPlayView) {
        _temPlayView = [SuperPlayerView new];
        _temPlayView.fatherView = self.videoView;
        _temPlayView.backgroundColor = [UIColor blackColor];
        _temPlayView.disableGesture = NO;
        _temPlayView.delegate = self;
    }
    return _temPlayView;
}

@end
