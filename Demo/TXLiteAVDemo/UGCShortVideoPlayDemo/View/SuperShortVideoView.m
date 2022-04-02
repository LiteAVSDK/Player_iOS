//
//  SuperShortVideoView.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/18.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "SuperShortVideoView.h"
#import "TXVideoPlayMem.h"
#import "TXVideoPlayer.h"
#import "TXLoadingView.h"
#import "TXPlayerCacheManager.h"
#import "TXUpSlideGuideView.h"
#import "TXPauseGuideView.h"
#import "TXLeftSlideGuideView.h"
#import "TXProgressSlideGuideView.h"
#import <Masonry/Masonry.h>
#import "TXTableViewCell.h"
#import "UITableView+indexPath.h"
#import "TXVideoModel.h"

NSString * const TXShortVideoCellIdentifier = @"TXShortVideoCellIdentifier";

@interface SuperShortVideoView()<TXVideoPlayerDelegate, UITableViewDelegate, UITableViewDataSource, TXTableViewCellDelegate>

@property (nonatomic, strong) UITableView                *tableView;

@property (nonatomic, assign) NSUInteger                 viewCount;

@property (nonatomic, strong) UIButton                   *backBtn;

@property (nonatomic, strong) UILabel                    *titleLabel;
// 遮罩层
@property (nonatomic, strong) TXUpSlideGuideView         *upSlideGuideView;
@property (nonatomic, strong) TXPauseGuideView           *pauseGuideView;
@property (nonatomic, strong) TXLeftSlideGuideView       *leftSlideGuideView;
@property (nonatomic, strong) TXProgressSlideGuideView   *progressSlideGuideView;

@property (nonatomic, strong) TXLoadingView              *loadingView;

@property (nonatomic, strong) UIImageView                *bgImageView;

@property (nonatomic, strong) UIViewController           *vc;

@property (nonatomic, assign) BOOL                       isPlayEnd;

@property (nonatomic, assign) BOOL                       isPause;

@property (nonatomic, strong) NSMutableArray             *videos;

@property (nonatomic, strong) TXVideoPlayer              *currentPlayer;

@property (nonatomic, strong) TXTableViewCell            *currentPlayingCell;

@property (nonatomic, assign) BOOL                       isDragging;

@property (nonatomic, assign) CGFloat                    lastContentOffsetY;

@property (nonatomic, assign) NSInteger                  currentPlayIndex;

@property (nonatomic, strong) NSIndexPath                *willPlayIndexPath;

@end

@implementation SuperShortVideoView

- (instancetype)initWithViewController:(UIViewController *)vc {
    if (self = [super init]) {
        
        // 监听APP进入前台或者退到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        _vc = vc;
        [self addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.bgImageView addSubview:self.loadingView];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bgImageView);
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(17);
            make.top.mas_equalTo(kStatusBarHeight + 11);
            make.size.mas_equalTo(CGSizeMake(23, 23));
        }];
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kStatusBarHeight + 8);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(120, 30));
        }];
        
    }
    return self;
}

#pragma mark - Public Methods
- (void)showLoading {
    [self.loadingView startLoading];
}

- (void)showGuideView {
    [self.loadingView stopLoading];
    [self.loadingView removeFromSuperview];
    
    [self addSubview:self.upSlideGuideView];
    [self addSubview:self.pauseGuideView];
    [self addSubview:self.leftSlideGuideView];
    [self addSubview:self.progressSlideGuideView];
    
    [self.upSlideGuideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.pauseGuideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.leftSlideGuideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.progressSlideGuideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setModels:(NSArray *)models viewCount:(NSInteger)viewCount {
    
    self.viewCount = viewCount;
    [self.videos removeAllObjects];
    [self.videos addObjectsFromArray:models];
    
    self.titleLabel.hidden = NO;
    self.backBtn.hidden = NO;
    self.tableView.hidden = NO;
    [self.loadingView stopLoading];
    [self.loadingView removeFromSuperview];
        
    if (viewCount == 0) {
        return;
    }
    
    if (models.count == 0) return;
    
    if (viewCount == 1) {
        _tableView.pagingEnabled = YES;
    }
    
    [self.tableView reloadData];
    [self playVideoInVisiableCells];
}

- (void)pause {
    if (self.currentPlayer.isPlaying) {
        [self.currentPlayer pausePlay];
        self.isPause = YES;
    }
}

- (void)resume {
    if (self.currentPlayer) {
        [self.currentPlayer resumePlay];
        self.isPause = NO;
    }
}

- (void)destoryPlayer {
    [self.currentPlayer removeVideo];
    self.currentPlayer = nil;
}

- (void)setPlaymode:(TXVideoPlayMode)playmode {
    _playmode = playmode;
}

- (void)jumpToCellWithIndex:(NSInteger)index {
    if (index != self.currentPlayIndex) {
        self.currentPlayingCell = nil;
    }
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark - Private Methods
-(void)playVideoInVisiableCells {
    // 找到下一个要播放的cell(最在屏幕中心的cell)
    TXTableViewCell *firstCell = nil;
    NSArray *visiableCells = [self.tableView visibleCells];
    for (UITableViewCell * cell in visiableCells) {
        if ([cell isKindOfClass:[TXTableViewCell class]]) {
            firstCell = (TXTableViewCell *)cell;
            break;
        }
    }
    // 播放第一个视频
    [self playVideoFrom:firstCell];
    self.lastContentOffsetY = 0;
}

- (void)handleScrollPlaying:(UIScrollView *)scrollView {
    
    // 找到下一个要播放的cell(最在屏幕中心的)
    TXTableViewCell *finnalCell = nil;
    NSArray *visiableCells = [self.tableView visibleCells];
    
    NSMutableArray *tempVideoCells = [NSMutableArray array];
    for (int i = 0; i < visiableCells.count; i++) {
        UITableViewCell *cell = visiableCells[i];
        
        if ([cell isKindOfClass:[TXTableViewCell class]]) {
            [tempVideoCells addObject:cell];
        }
    }
    
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    CGFloat gap = MAXFLOAT;
    for (TXTableViewCell *cell in tempVideoCells) {
        
        [indexPaths addObject:[self.tableView indexPathForCell:cell]];
        
        //计算距离屏幕中心最近的cell
        CGPoint coorCentre = [cell.superview convertPoint:cell.center toView:nil];
        CGFloat delta = fabs(coorCentre.y-[UIScreen mainScreen].bounds.size.height*0.5);
        if (delta < gap) {
            gap = delta;
            finnalCell = cell;
        }
    }
    
    if (self.currentPlayingCell == finnalCell) {
        if (self.currentPlayingCell.indexPath.row != self.currentPlayIndex && finnalCell.indexPath.row != self.currentPlayIndex) {
            self.currentPlayingCell = nil;
        }
    }
    
    // 注意, 如果正在播放的cell和finnalCell是同一个cell, 不应该在播放
    if (finnalCell != nil && self.currentPlayingCell != finnalCell)  {
        if (self.currentPlayer) {
            [self.currentPlayer removeVideo];
        }
        [self playVideoFrom:finnalCell];
    }
}

- (void)getVideoPlayer:(TXVideoModel *)currentModel preloadOtherPlayer:(NSArray *)modelArray {
    [[TXPlayerCacheManager shareInstance] updatePlayerCache:modelArray];
    if (currentModel != nil) {
        self.currentPlayer = [[TXPlayerCacheManager shareInstance] getVideoPlayer:currentModel];
        self.currentPlayer.delegate = self;
        if (self.playmode == TXVideoPlayModeOneLoop) {
            self.currentPlayer.loop = YES;
        }
    }
}

- (void)playVideoFrom:(TXTableViewCell *)cell {
     // 移除原来的播放
    [self.currentPlayer removeVideo];
    
    [self.currentPlayingCell setProgress:0];
    
    NSString *timeLabelStr = [self detailCurrentTime:0 totalTime:[self.currentPlayingCell.model.duration intValue]];
    [self.currentPlayingCell setTXtimeLabel:timeLabelStr];
    
    self.isPlayEnd = NO;
    self.currentPlayingCell = nil;
    self.currentPlayingCell.delegate = nil;
    self.currentPlayer.delegate = nil;
    
    self.currentPlayIndex = [self indexOfModel:cell.model];
    
    NSArray *cacheUrlArr = [self getUpdateUrlArrayWithstartIndex:self.currentPlayIndex maxCount:3];
    [self getVideoPlayer:cell.model preloadOtherPlayer:cacheUrlArr];
    
    self.currentPlayingCell = cell;
    self.currentPlayingCell.delegate = self;
        
    // 更新时间view
    NSString *curTimeLabelStr = [self detailCurrentTime:0 totalTime:[self.currentPlayingCell.model.duration intValue]];
    [self.currentPlayingCell setTXtimeLabel:curTimeLabelStr];
    // 重新播放
    NSString *url = cell.model.videourl;
    if (url.length > 0) {
        [self.currentPlayer playVideoWithView:cell.baseView.videoFatherView url:url];
    }
}

// 获取当前播放内容的索引
- (NSInteger)indexOfModel:(TXVideoModel *)model {
    __block NSInteger index = 0;
    [self.videos enumerateObjectsUsingBlock:^(TXVideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.requestId isEqualToString:obj.requestId]) {
            index = idx;
        }
    }];
    return index;
}

- (NSArray *)getUpdateUrlArrayWithstartIndex:(NSInteger)startIndex maxCount:(NSInteger)maxCount {
    NSInteger i = startIndex - 1;
    if (i + maxCount > self.videos.count) {
        i = self.videos.count - maxCount;
    }
    
    if (i < 0) {
        i = 0;
    }
    
    NSInteger updatedCount = 0;
    NSMutableArray *cacheUrlArray = [NSMutableArray array];
    while (i < self.videos.count && updatedCount < maxCount) {
        [cacheUrlArray addObject:(TXVideoModel *)self.videos[i]];
        updatedCount++;
        i++;
    }
    return cacheUrlArray;
}

- (NSString *)detailCurrentTime:(int)currentTime totalTime:(int)totalTime {
    if (currentTime <= 0) {
        return [NSString stringWithFormat:@"00:00/%02d:%02d",(int)(totalTime / 60), (int)(totalTime % 60)];
    }
    return  [NSString stringWithFormat:@"%02d:%02d/%02d:%02d", (int)(currentTime / 60), (int)(currentTime % 60), (int)(totalTime / 60), (int)(totalTime % 60)];
}

#pragma mark - TXVideoPlayerDelegate
- (void)player:(TXVideoPlayer *)player statusChanged:(TXVideoPlayerStatus)status {
    switch (status) {
        case TXVideoPlayerStatusUnload:
            break;
        case TXVideoPlayerStatusLoading:
            [self.currentPlayingCell hidePlayBtn];
            break;
        case TXVideoPlayerStatusPlaying: {
            [self.currentPlayingCell stopLoading];
            [self.currentPlayingCell hidePlayBtn];
        }
            
            break;
        case TXVideoPlayerStatusPaused:
            [self.currentPlayingCell stopLoading];
            [self.currentPlayingCell showPlayBtn];
            break;
        case TXVideoPlayerStatusEnded: {
            self.isPause = NO;
            // 重新开始播放
            WEAKIFY(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                STRONGIFY(self);
                if (self.playmode == TXVideoPlayModeListLoop) {
                    if (self.currentPlayIndex == self.videos.count - 1) {
                        return;
                    }
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPlayIndex + 1 inSection:0];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                }
            });
        }
            break;
        case TXVideoPlayerStatusError:
            break;
        default:
            break;
    }
}

- (void)player:(TXVideoPlayer *)player currentTime:(float)currentTime totalTime:(float)totalTime progress:(float)progress {
    if (player != self.currentPlayer) {
        return;
    }
    WEAKIFY(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        STRONGIFY(self);
        [self.currentPlayingCell setProgress:progress];
        int intCurrentTime = currentTime;
        int intTotalTime = totalTime;
        if (intCurrentTime <= intTotalTime) {
            if (!self.isPlayEnd) {
                [self.currentPlayingCell setTXtimeLabel:[self detailCurrentTime:intCurrentTime totalTime:intTotalTime]];
                if (intCurrentTime == intTotalTime) {
                    self.isPlayEnd = YES;
                }
            } else {
                [self.currentPlayingCell setTXtimeLabel:[self detailCurrentTime:intCurrentTime totalTime:intTotalTime]];
            }
        }
    });
}

#pragma mark - TXTableViewCellDelegate
- (void)controlViewDidClickSelf:(TXTableViewCell *)controlView {
    if (self.currentPlayer.isPlaying) {
        [self pause];
        self.isPause = YES;
    } else {
        [self resume];
        self.isPause = NO;
    }
}

- (void)seekToTime:(float)time {
    [self.currentPlayer seekToTime:time];
    if (self.isPause) {
        [self resume];
    }
}

#pragma mark - action
- (void)backHomeVC {
    [[TXPlayerCacheManager shareInstance] removeAllCache];
    self.currentPlayer = nil;
    self.tableView = nil;
    self.currentPlayingCell = nil;
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    [self.upSlideGuideView removeFromSuperview];
    self.upSlideGuideView = nil;
    [self.pauseGuideView removeFromSuperview];
    self.pauseGuideView = nil;
    [self.leftSlideGuideView removeFromSuperview];
    self.leftSlideGuideView = nil;
    [self.progressSlideGuideView removeFromSuperview];
    self.progressSlideGuideView = nil;
    [self.vc.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - Notification Click
// APP进入前台
- (void)appWillEnterForeground:(NSNotification *)notify {
    [self.currentPlayer detailAppWillEnterForeground];
}

// APP退到后台
- (void)appDidEnterBackground:(NSNotification *)notify {
    [self.currentPlayer detailAppDidEnterBackground];
}

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"短视频播放";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC" size:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backHomeVC) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.hidden = YES;
    }
    return _backBtn;
}

- (NSMutableArray *)videos {
    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

- (TXVideoViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [TXVideoViewModel new];
    }
    return _viewModel;
}

- (TXUpSlideGuideView *)upSlideGuideView {
    if (!_upSlideGuideView) {
        _upSlideGuideView = [TXUpSlideGuideView new];
        __weak typeof(self) weakSelf = self;
        _upSlideGuideView.upSlideViewHidden = ^(BOOL isHidden) {
            weakSelf.upSlideGuideView.hidden = isHidden;
            weakSelf.pauseGuideView.hidden = !isHidden;
            weakSelf.leftSlideGuideView.hidden = isHidden;
            weakSelf.progressSlideGuideView.hidden = isHidden;
        };
    }
    return _upSlideGuideView;
}

- (TXPauseGuideView *)pauseGuideView {
    if (!_pauseGuideView) {
        _pauseGuideView = [TXPauseGuideView new];
        _pauseGuideView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _pauseGuideView.pauseViewHidden = ^(BOOL isHidden) {
            weakSelf.upSlideGuideView.hidden = isHidden;
            weakSelf.pauseGuideView.hidden = isHidden;
            weakSelf.leftSlideGuideView.hidden = !isHidden;
            weakSelf.progressSlideGuideView.hidden = isHidden;
        };
    }
    return _pauseGuideView;
}

- (TXLeftSlideGuideView *)leftSlideGuideView {
    if (!_leftSlideGuideView) {
        _leftSlideGuideView = [TXLeftSlideGuideView new];
        _leftSlideGuideView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _leftSlideGuideView.leftSlideViewHidden = ^(BOOL isHidden) {
            weakSelf.upSlideGuideView.hidden = isHidden;
            weakSelf.pauseGuideView.hidden = isHidden;
            weakSelf.leftSlideGuideView.hidden = isHidden;
            weakSelf.progressSlideGuideView.hidden = !isHidden;
        };
    }
    return _leftSlideGuideView;
}

- (TXProgressSlideGuideView *)progressSlideGuideView {
    if (!_progressSlideGuideView) {
        _progressSlideGuideView = [TXProgressSlideGuideView new];
        _progressSlideGuideView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _progressSlideGuideView.progressSlideViewHidden = ^(BOOL isHidden) {
            weakSelf.upSlideGuideView.hidden = isHidden;
            weakSelf.pauseGuideView.hidden = isHidden;
            weakSelf.leftSlideGuideView.hidden = isHidden;
            weakSelf.progressSlideGuideView.hidden = isHidden;
        };
    }
    return _progressSlideGuideView;
}

- (TXLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [TXLoadingView new];
    }
    return _loadingView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.image = [UIImage imageNamed:@"img_video_loading"];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.hidden = YES;
        _tableView.scrollsToTop = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TXTableViewCell class] forCellReuseIdentifier:TXShortVideoCellIdentifier];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            _vc.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSources UIScrollView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT / self.viewCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TXShortVideoCellIdentifier];
    if (!cell) {
        cell = [[TXTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TXShortVideoCellIdentifier];
    }
    if (cell) {
        cell.model = self.videos[indexPath.row];
        cell.indexPath = indexPath;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.willPlayIndexPath = indexPath;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat oldContentOffsetY = self.lastContentOffsetY;
    self.lastContentOffsetY = scrollView.contentOffset.y;
    if ((self.lastContentOffsetY > oldContentOffsetY) && self.lastContentOffsetY >= self.willPlayIndexPath.row * SCREEN_HEIGHT) {
        // scroll up
        if (self.currentPlayIndex < self.willPlayIndexPath.row) {
            NSIndexPath *currentIndexPath = [self.tableView currentIndexPathForFullScreenCell];
            if (currentIndexPath.row == self.willPlayIndexPath.row) {
                if (self.currentPlayIndex != [self.tableView currentIndexPathForFullScreenCell].row) {
                    [self.currentPlayer removeVideo];
                }
            }
        }
    } else if ((self.lastContentOffsetY < oldContentOffsetY) && self.lastContentOffsetY <= self.willPlayIndexPath.row * SCREEN_HEIGHT) {
        // scroll down
        if (self.currentPlayIndex > self.willPlayIndexPath.row) {
            NSIndexPath *currentIndexPath = [self.tableView currentIndexPathForFullScreenCell];
            if (currentIndexPath.row == self.willPlayIndexPath.row) {
                if (self.currentPlayIndex != [self.tableView currentIndexPathForFullScreenCell].row) {
                    [self.currentPlayer removeVideo];
                }
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //滑动播放
    [self handleScrollPlaying:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        //滑动播放
        [self handleScrollPlaying:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //滑动播放
    [self handleScrollPlaying:scrollView];
}

@end
