//
//  SuperFeedPlayView.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/10/28.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "SuperFeedPlayView.h"
#import "FeedTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import "FeedVideoPlayMem.h"

NSString * const FeedVideoCellIdentifier = @"FeedVideoCellIdentifier";

@interface SuperFeedPlayView()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, FeedTableViewCellDelegate>

@property (nonatomic, strong) UITableView              *tableView;

@property (nonatomic, strong) NSMutableArray           *feedVideoArray;

@property (nonatomic, strong) FeedTableViewCell        *currentTableViewCell;

@property (nonatomic, strong) FeedTableViewCell        *tapTableViewCell;

@property (nonatomic, assign) NSInteger                currentPlayIndex;

@property (nonatomic, assign) BOOL                     isRefresh;

@property (nonatomic, strong) NSIndexPath              *indexPath; ///横屏的cell
@end

@implementation SuperFeedPlayView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.isRefresh = YES;
        [self getNewFeedData];
    }
    return self;
}
#pragma mark - Public Method
- (void)setFeedData:(NSArray *)feedData isCleanData:(BOOL)isNeedCleanData {
    if (isNeedCleanData) {
        [self.feedVideoArray removeAllObjects];
    }
    
    [self.feedVideoArray addObjectsFromArray:feedData];
    
    [self.tableView reloadData];
    self.isRefresh = NO;
    
    if (isNeedCleanData) {
        if (self.currentTableViewCell) {
            [self.currentTableViewCell pause];
             self.currentTableViewCell = nil;
        }
        [self prepareVideo];
        [self playVideoInVisiableCells];
    }
}

- (void)finishRefresh {
    if (self.isRefresh) {
        return;
    }

    [self.tableView.mj_header endRefreshing];
}

- (void)finishLoadMore {
    if (self.isRefresh) {
        return;
    }

    [self.tableView.mj_footer endRefreshing];
}

- (void)addSuperPlayView:(UIView *)view {
    FeedTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.indexPath];
    if ([NSThread isMainThread]) {
        [cell addSuperPlayView:view];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell addSuperPlayView:view];
        });
    }
}

- (void)removeVideo {
    [self.currentTableViewCell removeVideo];
}

- (void)destory {
    [self.feedVideoArray removeAllObjects];
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    for(int row = 0;row < rows;row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        FeedTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell removeVideo];
    }
}

#pragma mark - Action
- (void)getNewFeedData {
    [self finishLoadMore];
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshNewFeedData)]) {
        [self.delegate refreshNewFeedData];
    }
}

- (void)loadMoreData {
    [self finishRefresh];
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadNewFeedDataWithPage:)]) {
        [self.delegate loadNewFeedDataWithPage:0];
    }
}

#pragma mark - Private Method
- (void)playVideoInVisiableCells {
    // 在可见cell中找到第一个cell
    NSArray *visiableCells = [self.tableView visibleCells];
    FeedTableViewCell *firstCell = nil;
    for (UITableViewCell * cell in visiableCells) {
        if ([cell isKindOfClass:[FeedTableViewCell class]]) {
            firstCell = (FeedTableViewCell *)cell;
            break;
        }
    }
    
    [self playVideoFromCell:firstCell];
}

- (void)playVideoFromCell:(FeedTableViewCell *)cell {
    if (self.currentTableViewCell) {
        [self.currentTableViewCell pause];
    }
    self.currentTableViewCell = cell;
    
    self.currentPlayIndex = [self indexOfModel:cell.model];
    [self.currentTableViewCell playVideo];
    
    NSArray *cells = [self.tableView visibleCells];
    for (UITableViewCell *cell in cells) {
        if (cell != self.currentTableViewCell) {
            FeedTableViewCell *cel = (FeedTableViewCell *)cell;
            if (cel.baseView.superPlayView.state == StatePlaying) {
                [cel pause];
            }
        }
    }
}

- (void)handleScroll {
    // 找到下一个要播放的cell
    FeedTableViewCell *finnalCell = nil;
    NSArray *visiableCells = [self.tableView visibleCells];
    
    NSMutableArray *tempVideoCells = [NSMutableArray array];
    for (int i = 0; i < visiableCells.count; i++) {
        UITableViewCell *cell = visiableCells[i];
        
        if ([cell isKindOfClass:[FeedTableViewCell class]]) {
            [tempVideoCells addObject:cell];
        }
    }
    
    finnalCell = [self findBestCellForPlayingVideo:tempVideoCells];
    
    if (finnalCell == self.currentTableViewCell) {
        if (self.currentTableViewCell.indexPath.row != self.currentPlayIndex && finnalCell.indexPath.row != self.currentPlayIndex) {
            self.currentTableViewCell = nil;
        }
    } else {
        CGPoint cellLeftUpPoint = self.currentTableViewCell.frame.origin;
        cellLeftUpPoint.y += self.currentTableViewCell.bounds.size.height;
        BOOL isContainCell = [self isContainCell:self.currentTableViewCell cellPoint:cellLeftUpPoint];
        SuperPlayerState curState = self.currentTableViewCell.baseView.superPlayView.state;
        if (finnalCell.cellStyle != FeedUnreachCellStyleNone && curState == StatePlaying && isContainCell) {
            return;
        }
    }
    
    if (finnalCell && finnalCell != self.currentTableViewCell) {
        [self playVideoFromCell:finnalCell];
    }
}

- (FeedTableViewCell *)findBestCellForPlayingVideo:(NSMutableArray *)tempVideoCells {
    FeedTableViewCell *findCell = nil;
    for (FeedTableViewCell *cell in tempVideoCells) {
        // 优先查找滑动不可及cell
        if (cell.cellStyle != FeedUnreachCellStyleNone) {
            // 并且不可及的cell要全部显示在屏幕上
            
            if (cell.cellStyle == FeedUnreachCellStyleUp) {
                CGPoint cellLeftUpPoint = cell.frame.origin;
                // 不要在边界上
                cellLeftUpPoint.y += 1;
                if ([self isContainCell:cell cellPoint:cellLeftUpPoint]) {
                    findCell = cell;
                    break;
                }
            } else if (cell.cellStyle == FeedUnreachCellStyleDown) {
                CGPoint cellLeftUpPoint = cell.frame.origin;
                cellLeftUpPoint.y += cell.bounds.size.height;
                // 不要在边界上
                cellLeftUpPoint.y -= 1;
                if ([self isContainCell:cell cellPoint:cellLeftUpPoint]) {
                    findCell = cell;
                    break;
                }
            }
        } else {
            NSMutableArray *indexPaths = [NSMutableArray array];
            CGFloat gap = MAXFLOAT;
            for (FeedTableViewCell *cell in tempVideoCells) {
        
                [indexPaths addObject:[self.tableView indexPathForCell:cell]];
        
                //计算距离屏幕中心最近的cell
                CGPoint coorCentre = [cell.superview convertPoint:cell.center toView:nil];
                CGFloat delta = fabs(coorCentre.y-self.frame.size.height*0.5);
                if (delta < gap) {
                    gap = delta;
                    findCell = cell;
                }
            }
        }
    }
    return findCell;
}

- (BOOL)isContainCell:(FeedTableViewCell *)cell cellPoint:(CGPoint)cellLeftUpPoint {
    CGPoint coorPoint = [cell.superview convertPoint:cellLeftUpPoint toView:nil];
    CGRect viewRect = self.bounds;
    BOOL isContain = CGRectContainsPoint(viewRect, coorPoint);
    return isContain;
}

// 获取当前播放内容的索引
- (NSInteger)indexOfModel:(FeedVideoModel *)model {
    __block NSInteger index = 0;
    [self.feedVideoArray enumerateObjectsUsingBlock:^(FeedVideoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.fileId isEqualToString:obj.fileId]) {
            index = idx;
        }
    }];
    return index;
}

- (void)prepareVideo {
    NSArray *visiableCells = [self.tableView visibleCells];
    for (FeedTableViewCell *cell in visiableCells) {
        [cell prepare];
    }
}

#pragma mark - FeedTableViewCellDelegate
- (void)headViewClickWithCell:(FeedTableViewCell *)cell {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showFeedDetailViewWithHeadModel:videoModel:playView:)]) {
        FeedHeadModel *headModel = [FeedHeadModel new];
        headModel.headImageUrl = cell.model.coverUrl;
        headModel.videoNameStr = cell.model.title;
        headModel.videoSubTitleStr = cell.model.videoIntroduce;
        headModel.videoDesStr  = cell.model.videoDesStr;
        if (cell != self.currentTableViewCell) {
            [self.currentTableViewCell pause];
        }
        self.tapTableViewCell = cell;
        self.indexPath = cell.indexPath;
        [self.delegate showFeedDetailViewWithHeadModel:headModel
                                            videoModel:cell.model
                                              playView:cell.baseView.superPlayView];
        cell.baseView.superPlayView = nil;
    }
}

- (void)superPlayerDidStartWithCell:(FeedTableViewCell *)cell {
    if (cell != self.currentTableViewCell) {
        // 禁止音量按钮事件触发
        self.currentTableViewCell.baseView.superPlayView.disableVolumControl = NO;
        [self.currentTableViewCell pause];
        self.currentTableViewCell = cell;
        cell.baseView.superPlayView.disableVolumControl = YES;
    }
    NSArray *cells = [self.tableView visibleCells];
    for (UITableViewCell *cell in cells) {
        if (cell != self.currentTableViewCell) {
            FeedTableViewCell *cel = (FeedTableViewCell *)cell;
            if (cel.baseView.superPlayView.state == StatePlaying) {
                [cel pause];
            }
        }
    }
}

-(void)showFullScreenViewWithPlayView:(SuperPlayerView *)superPlayerView
                            indexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    FeedTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(showFullScreenViewWithPlayView:)]){
        if (cell != self.currentTableViewCell) {
            [self.currentTableViewCell pause];
        }
        [self.delegate showFullScreenViewWithPlayView:superPlayerView];
    }
}
#pragma mark - UITableViewDelegate UITableViewDataSource UIScrollViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedVideoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (cellHeight + 80);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedVideoCellIdentifier];
    if (!cell) {
        cell = [[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeedVideoCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (cell) {
        cell.indexPath = indexPath;
        cell.model = self.feedVideoArray[indexPath.row];
        cell.delegate = self;
        if (indexPath.row <= 0) {
            cell.cellStyle = FeedUnreachCellStyleUp;
        } else if (indexPath.row >= self.feedVideoArray.count - 1) {
            cell.cellStyle = FeedUnreachCellStyleDown;
        } else {
            cell.cellStyle = FeedUnreachCellStyleNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentTableViewCell == cell) {
        self.currentTableViewCell = nil;
    }
    [(FeedTableViewCell *)cell pause];
}

// 松手时已经静止，只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ((self.tableView.mj_header.isRefreshing || self.tableView.mj_footer.isRefreshing) && self.isRefresh) {
        return;
    }
    
    if (!decelerate) {
        [self prepareVideo];
        [self handleScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ((self.tableView.mj_header.isRefreshing || self.tableView.mj_footer.isRefreshing) && self.isRefresh) {
        return;
    }
    
    [self prepareVideo];
    [self handleScroll];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.scrollsToTop = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[FeedTableViewCell class] forCellReuseIdentifier:FeedVideoCellIdentifier];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewFeedData)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _tableView.mj_header = header;
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    return _tableView;
}

- (NSMutableArray *)feedVideoArray {
    if (!_feedVideoArray) {
        _feedVideoArray = [NSMutableArray array];
    }
    return _feedVideoArray;
}

#pragma mark - FeedTableViewCellDelegate
-(void)screenRotation:(BOOL)fullScreen {
    if(self.delegate && [self.delegate respondsToSelector:@selector(screenRotation:)]) {
        [self.delegate screenRotation:fullScreen];
    }
}
@end
