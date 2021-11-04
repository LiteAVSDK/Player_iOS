//
//  TXTableViewCell.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/9/10.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXTableViewCell.h"
#import <Masonry/Masonry.h>

@interface TXTableViewCell()<TXVideoBaseViewDelegate>


@end

@implementation TXTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.baseView];
        [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(TXVideoModel *)model {
    _model = model;
    [self.baseView setModel:model];
}

- (void)setProgress:(float)progress {
    [self.baseView setProgress:progress];
}

- (void)setTXtimeLabel:(NSString *)time {
    [self.baseView setTXtimeLabel:time];
}

- (void)startLoading {
    [self.baseView startLoading];
}

- (void)stopLoading {
    [self.baseView stopLoading];
}

- (void)showPlayBtn {
    [self.baseView showPlayBtn];
}

- (void)hidePlayBtn {
    [self.baseView hidePlayBtn];
}

#pragma mark - TXVideoBaseViewDelegate
- (void)controlViewDidClickSelf:(TXVideoBaseView *)baseView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlViewDidClickSelf:)]) {
        [self.delegate controlViewDidClickSelf:self];
    }
}

- (void)seekToTime:(float)time {
    if (self.delegate && [self.delegate respondsToSelector:@selector(seekToTime:)]) {
        [self.delegate seekToTime:time];
    }
}

#pragma mark - 懒加载
- (TXVideoBaseView *)baseView {
    if (!_baseView) {
        _baseView = [TXVideoBaseView new];
        _baseView.delegate = self;
    }
    return _baseView;
}

@end
