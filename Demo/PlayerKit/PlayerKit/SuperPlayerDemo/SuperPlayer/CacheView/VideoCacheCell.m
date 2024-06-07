//
//  VideoCacheCell.m
//  Pods
//
//  Created by 路鹏 on 2022/2/17.
//  Copyright © 2022年 Tencent. All rights reserved.

#import "VideoCacheCell.h"
#import "PlayerKitCommonHeaders.h"
#import "VideoCacheModel.h"

@interface VideoCacheCell()

@property (nonatomic, strong) UILabel *videoNameLabel;

@property (nonatomic, strong) UIImageView *chooseImageView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation VideoCacheCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self addSubview:self.videoNameLabel];
        [self addSubview:self.chooseImageView];
        [self addSubview:self.lineView];

        [self.videoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-45);
            make.bottom.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(10);
        }];

        [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.bottom.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(10);
            make.width.mas_equalTo(20);
        }];

        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(20);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setCacheModel:(VideoCacheModel *)cacheModel {
    self.videoNameLabel.text = cacheModel.videoTitle;
    self.chooseImageView.hidden = !cacheModel.isCache;
    if (cacheModel.isCurrentPlay) {
        self.videoNameLabel.textColor = [UIColor colorWithRed:0/255.0 green:110.0/255.0 blue:255.0/255.0 alpha:1.0];
        self.lineView.hidden = NO;
    } else {
        _videoNameLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
        self.lineView.hidden = YES;
    }
}

#pragma mark - 懒加载
- (UILabel *)videoNameLabel {
    if (!_videoNameLabel) {
        _videoNameLabel = [[UILabel alloc] init];
        _videoNameLabel.font = [UIFont systemFontOfSize:14];
        _videoNameLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    return _videoNameLabel;
}

- (UIImageView *)chooseImageView {
    if (!_chooseImageView) {
        _chooseImageView = [[UIImageView alloc] init];
        _chooseImageView.image = SuperPlayerImage(@"videoCache_choose");
        _chooseImageView.hidden = YES;
    }
    return _chooseImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:0/255.0 green:110.0/255.0 blue:255.0/255.0 alpha:1.0];
        _lineView.hidden = YES;
    }
    return _lineView;
}

@end
