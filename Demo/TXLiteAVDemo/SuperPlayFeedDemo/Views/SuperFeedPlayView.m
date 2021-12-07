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

@end

@implementation SuperFeedPlayView


#pragma mark - Public Method
- (void)initChildView {
    [self addSubview:self.tableView];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewFeedData)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)setFeedData:(NSArray *)feedData isCleanData:(BOOL)isNeedCleanData {
    if (isNeedCleanData) {
        [self.feedVideoArray removeAllObjects];
    }
    
    [self.feedVideoArray addObjectsFromArray:feedData];
    
    [self.tableView reloadData];
    
    if (isNeedCleanData) {
        [self playVideoInVisiableCells];
    }
}

- (void)finishRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (void)finishLoadMore {
    [self.tableView.mj_footer endRefreshing];
}

- (void)addSuperPlayView:(UIView *)view {
    if ([NSThread isMainThread]) {
        [self.tapTableViewCell addSuperPlayView:view];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tapTableViewCell addSuperPlayView:view];
        });
    }
}

- (void)removeVideo {
    [self.currentTableViewCell removeVideo];
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
    [self.currentTableViewCell pause];
    self.currentTableViewCell = cell;
    
    self.currentPlayIndex = [self indexOfModel:cell.model];
    [self.currentTableViewCell playVideo];
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
        [cell.baseView.superPlayView removeFromSuperview];
        
        [self.delegate showFeedDetailViewWithHeadModel:headModel videoModel:cell.model playView:cell.baseView.superPlayView];
    }
}

- (void)superPlayerDidStartWithCell:(FeedTableViewCell *)cell {
    if (cell != self.currentTableViewCell) {
        [self.currentTableViewCell pause];
        self.currentTableViewCell = cell;
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
    }

    if (cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell removeVideo];
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

// 松手时已经静止，只会调用scrollViewDidEndDragging
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self handleScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self handleScroll];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        _tableView.frame = self.bounds;
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
    }
    return _tableView;
}

- (NSMutableArray *)feedVideoArray {
    if (!_feedVideoArray) {
        _feedVideoArray = [NSMutableArray array];
    }
    return _feedVideoArray;
}

@end
