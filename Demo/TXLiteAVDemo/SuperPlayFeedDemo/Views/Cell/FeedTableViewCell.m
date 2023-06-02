//
//  FeedTableViewCell.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/10/29.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "FeedTableViewCell.h"
#import <Masonry/Masonry.h>

@interface FeedTableViewCell()<FeedBaseViewDelegate>

@end

@implementation FeedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:24.0/255.0 blue:47.0/255.0 alpha:1.0];
        [self.contentView addSubview:self.baseView];
        [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

//- (void)prepareForReuse {
//    [super prepareForReuse];
    //Mars [self.baseView.superPlayView removeFromSuperview];
    //Mars self.baseView.superPlayView = nil;
//}

#pragma mark - Public Method
- (void)setModel:(FeedVideoModel *)model {
    _model = model;
    [self.baseView setModel:model];
}

- (void)prepare {
    [self.baseView prepare];
}

- (void)pause {
    [self.baseView pause];
}

- (void)playVideo {
    [self.baseView resume];
}

- (void)removeVideo {
    [self.baseView removeVideo];
}

- (void)resetPlayer {
    [self.baseView resetPlayer];
}

- (void)addSuperPlayView:(UIView *)view {
    [self.baseView addSuperPlayView:view];
}

#pragma mark - FeedBaseViewDelegate
- (void)headViewClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headViewClickWithCell:)]) {
        [self.delegate headViewClickWithCell:self];
    }
}

- (void)superPlayerDidStart {
    if (self.delegate && [self.delegate respondsToSelector:@selector(superPlayerDidStartWithCell:)]) {
        [self.delegate superPlayerDidStartWithCell:self];
    }
}
-(void)showFullScreenViewWithPlayView:(SuperPlayerView *)superPlayerView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showFullScreenViewWithPlayView:cell:)]){
        [self.delegate showFullScreenViewWithPlayView:superPlayerView cell:self];
    }
}
- (void)screenRotation:(BOOL)fullScreen {
    if (self.delegate && [self.delegate respondsToSelector:@selector(screenRotation:)]) {
        [self.delegate screenRotation:fullScreen];
    }
}
#pragma mark - 懒加载
- (FeedBaseView *)baseView {
    if (!_baseView) {
        _baseView = [FeedBaseView new];
        _baseView.delegate = self;
    }
    return _baseView;
}

@end
