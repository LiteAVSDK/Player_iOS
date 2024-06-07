//
//  FeedDetailViewCell.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/11/3.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "FeedDetailViewCell.h"
#import "PlayerKitCommonHeaders.h"
#import "UIImageView+WebCache.h"

@interface FeedDetailViewCell()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UILabel     *durationLabel;

@property (nonatomic, strong) UILabel     *videoNameLabel;

@property (nonatomic, strong) UILabel     *videoDesLabel;

@end

@implementation FeedDetailViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:24.0/255.0 blue:47.0/255.0 alpha:1.0];
        [self addSubview:self.coverImageView];
        [self addSubview:self.videoNameLabel];
        [self addSubview:self.videoDesLabel];
        
        [self.coverImageView addSubview:self.durationLabel];
        
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.top.equalTo(self).offset(8);
            make.width.mas_equalTo(104);
            make.height.mas_equalTo(72);
        }];
        
        [self.videoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12 + 104 + 8);
            make.top.equalTo(self).offset(8);
            make.right.equalTo(self);
            make.height.mas_equalTo(20);
        }];
        
        [self.videoDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12 + 104 + 8);
            make.bottom.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(40);
        }];
        
        [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coverImageView);
            make.right.equalTo(self.coverImageView).offset(-8);
            make.bottom.equalTo(self.coverImageView).offset(-8);
            make.height.mas_equalTo(14);
        }];
    }
    return self;
}

#pragma mark - Public Method
- (void)setModel:(FeedDetailModel *)model {
    _model = model;
    
    NSURL *url = [NSURL URLWithString:model.coverUrl];
    [self.coverImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_video_loading"]];
    
    self.videoNameLabel.text = model.title;
    
    self.videoDesLabel.text = model.videoIntroduce;
    
    self.durationLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)(model.duration / 60), (int)(model.duration % 60)];
}

#pragma mark - 懒加载
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.layer.cornerRadius = 4;
        _coverImageView.layer.masksToBounds = YES;
    }
    return _coverImageView;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel new];
        _durationLabel.font = [UIFont systemFontOfSize:10];
        _durationLabel.textAlignment = NSTextAlignmentRight;
        _durationLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    }
    return _durationLabel;
}

- (UILabel *)videoNameLabel {
    if (!_videoNameLabel) {
        _videoNameLabel = [UILabel new];
        _videoNameLabel.font = [UIFont systemFontOfSize:16];
        _videoNameLabel.textAlignment = NSTextAlignmentLeft;
        _videoNameLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    }
    return _videoNameLabel;
}

- (UILabel *)videoDesLabel {
    if (!_videoDesLabel) {
        _videoDesLabel = [UILabel new];
        _videoDesLabel.font = [UIFont systemFontOfSize:12];
        _videoDesLabel.textAlignment = NSTextAlignmentLeft;
        _videoDesLabel.numberOfLines = 0;
        _videoDesLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    }
    return _videoDesLabel;
}

@end
