//
//  FeedHeadView.m
//  TXLiteAVDemo
//
//  Created by 路鹏 on 2021/11/1.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "FeedHeadView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface FeedHeadView()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel     *videoNameLabel;

@property (nonatomic, strong) UILabel     *videoDesLabel;

@end

@implementation FeedHeadView

- (instancetype)init {
    if (self = [super init]) {
        
        [self addSubview:self.headImageView];
        [self addSubview:self.videoNameLabel];
        [self addSubview:self.videoDesLabel];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(8);
            make.top.equalTo(self).offset(8);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        [self.videoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(8 + 40 + 8);
            make.top.equalTo(self).offset(8);
            make.right.equalTo(self);
            make.height.mas_equalTo(20);
        }];
        
        [self.videoDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(8 + 40 + 8);
            make.bottom.equalTo(self).offset(-8);
            make.right.equalTo(self);
            make.height.mas_equalTo(17);
        }];
        
    }
    return self;
}

#pragma mark - Public Method
- (void)setHeadModel:(FeedHeadModel *)model {
    NSURL *url = [NSURL URLWithString:model.headImageUrl];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_video_loading"]];
    
    self.videoNameLabel.text = model.videoNameStr;
    
    self.videoDesLabel.text = model.videoSubTitleStr;
}

#pragma mark - 懒加载
- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.layer.cornerRadius = 20;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)videoNameLabel {
    if (!_videoNameLabel) {
        _videoNameLabel = [UILabel new];
        _videoNameLabel.font = [UIFont systemFontOfSize:16];
        _videoNameLabel.textAlignment = NSTextAlignmentLeft;
        _videoNameLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        _videoNameLabel.text = @"";
    }
    return _videoNameLabel;
}

- (UILabel *)videoDesLabel {
    if (!_videoDesLabel) {
        _videoDesLabel = [UILabel new];
        _videoDesLabel.font = [UIFont systemFontOfSize:12];
        _videoDesLabel.textAlignment = NSTextAlignmentLeft;
        _videoDesLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        _videoDesLabel.numberOfLines = 1;
        _videoDesLabel.text = @"";
    }
    return _videoDesLabel;
}

@end
