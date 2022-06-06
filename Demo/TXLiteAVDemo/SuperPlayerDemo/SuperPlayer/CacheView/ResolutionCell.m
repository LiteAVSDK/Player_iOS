//
//  ResolutionCell.m
//  Pods
//
//  Created by 路鹏 on 2022/2/24.
//  Copyright © 2022年 Tencent. All rights reserved.

#import "ResolutionCell.h"
#import "ResolutionModel.h"
#import <Masonry/Masonry.h>

@interface ResolutionCell()

@property (nonatomic, strong) UILabel *resolutionLabel;

@end

@implementation ResolutionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.resolutionLabel];

        [self.resolutionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(100);
            make.right.equalTo(self).offset(-100);
            make.bottom.equalTo(self).offset(-25);
            make.top.equalTo(self).offset(25);
        }];
    }
    return self;
}

- (void)setResolutionModel:(ResolutionModel *)resolutionModel {
    self.resolutionLabel.text = resolutionModel.resolution;
    if (resolutionModel.isCurrentPlay) {
        self.resolutionLabel.textColor = [UIColor colorWithRed:0/255.0 green:110.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
}

#pragma mark - 懒加载
- (UILabel *)resolutionLabel {
    if (!_resolutionLabel) {
        _resolutionLabel = [[UILabel alloc] init];
        _resolutionLabel.font = [UIFont systemFontOfSize:14];
        _resolutionLabel.textColor = [UIColor whiteColor];
        _resolutionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _resolutionLabel;
}

@end
