//
//  SuperPlayerTrackView.m
//  SuperPlayer-Player
//
//  Created by 路鹏 on 2022/10/11.
//  Copyright © 2022 Tencent. All rights reserved.

#import "SuperPlayerTrackView.h"
#import "SuperPlayerHelpers.h"
#import "SuperPlayerLocalized.h"
#import "Masonry.h"
#import "TXTrackInfo.h"

#define TRACK_MODEL_TAG_BEGIN 50

// NOTE：用于内部记录选择的轨道
static NSInteger trackSelectedIndex = 0;

@interface SuperPlayerTrackView()

// 头部标题
@property (nonatomic, strong) UILabel *titleLabel;

// 当前选中的按钮
@property (nonatomic, strong) UIButton *trackCurrentBtn;

@property (nonatomic, strong) NSMutableArray<TXTrackInfo *>* infos;

@end

@implementation SuperPlayerTrackView

#pragma mark - Public Method
- (void)initTrackViewWithTrackArray:(NSMutableArray<TXTrackInfo *> *)trackArray currentTrackIndex:(NSInteger)currentTrackIndex {
    self.infos = trackArray;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(25);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
    
    // 音轨view上的btn
    for (NSInteger i = 0; i< trackArray.count; i++) {
        TXTrackInfo *info = trackArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:info.name.length > 0 ? info.name : [NSString stringWithFormat:@"%@%ld",superPlayerLocalized(@"SuperPlayer.track"),i - 1] forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(252, 89, 81, 1) forState:UIControlStateSelected];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(changeTrack:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(45);
            make.left.equalTo(self.mas_left);
            make.centerY.equalTo(self.mas_centerY).offset((i - trackArray.count / 2.0 + 0.5) * 45);
        }];
        btn.tag = TRACK_MODEL_TAG_BEGIN + i;
        
        if (info.trackIndex == currentTrackIndex) {
            btn.selected = YES;
            btn.backgroundColor = RGBA(34, 30, 24, 1);
            self.trackCurrentBtn = btn;
        }
    }
}

#pragma mark - Private Method
/**
 * 点击切换音轨
 */
- (void)changeTrack:(UIButton *)sender {
    if (self.trackCurrentBtn.tag == sender.tag) {
        return;
    }
    
    NSInteger preTrackIndex = self.trackCurrentBtn.tag - TRACK_MODEL_TAG_BEGIN;
    self.trackCurrentBtn.selected = NO;
    self.trackCurrentBtn.backgroundColor = [UIColor clearColor];
    self.trackCurrentBtn = sender;
    self.trackCurrentBtn.selected = YES;
    self.trackCurrentBtn.backgroundColor = RGBA(34, 30, 24, 1);
    
    NSInteger currentTrackIndex = sender.tag - TRACK_MODEL_TAG_BEGIN;
    trackSelectedIndex = currentTrackIndex;
    
    // NOTE:数组进行范围限制，防止出现Crash
    if (0 <= preTrackIndex && preTrackIndex < [self.infos count]
        && 0 <= currentTrackIndex && currentTrackIndex < [self.infos count]) {
        // delegate回调给外部
        if (self.delegate && [self.delegate respondsToSelector:@selector(chooseTrackInfo:preTrackInfo:)]) {
            [self.delegate chooseTrackInfo:self.infos[currentTrackIndex] preTrackInfo:self.infos[preTrackIndex]];
        }
    }
}

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = superPlayerLocalized(@"SuperPlayer.track");
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

@end
