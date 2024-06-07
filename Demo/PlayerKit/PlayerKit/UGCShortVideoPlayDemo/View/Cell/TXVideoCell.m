//
//  TXVideoCell.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/29.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXVideoCell.h"
#import "TXVideoModel.h"
#import "PlayerKitCommonHeaders.h"
#import "UIImageView+WebCache.h"

@interface TXVideoCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *durationLabel;

@end

@implementation TXVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self=[super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.durationLabel];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(8);
            make.right.equalTo(self).offset(-11);
            make.bottom.equalTo(self).offset(-8);
            make.height.mas_equalTo(17);
        }];
        
        [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.right.equalTo(self.nameLabel);
            make.bottom.equalTo(self.nameLabel).offset(- 21);
            make.height.mas_equalTo(14);
        }];
    }
    return self;
}

- (void)setVideoModel:(TXVideoModel *)videoModel {
    
    if ([videoModel.width floatValue] > [videoModel.height floatValue]) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }else {
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }

    if (videoModel.coverUrl) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:videoModel.coverUrl] placeholderImage:[UIImage imageNamed:@"img_video_loading"]];
    } else {
        [self.imageView setImage:[UIImage imageNamed:@"img_video_loading"]];
    }
    
    self.nameLabel.text = videoModel.name;
    
    NSInteger duration = (NSInteger)(videoModel.duration.intValue);
    self.durationLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", duration /60, duration % 60];
}

#pragma mark - 懒加载
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC" size:12];
    }
    return _nameLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [UILabel new];
        _durationLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        _durationLabel.textAlignment = NSTextAlignmentLeft;
        _durationLabel.font = [UIFont fontWithName:@"PingFangSC" size:10];
    }
    return _durationLabel;
}

@end
