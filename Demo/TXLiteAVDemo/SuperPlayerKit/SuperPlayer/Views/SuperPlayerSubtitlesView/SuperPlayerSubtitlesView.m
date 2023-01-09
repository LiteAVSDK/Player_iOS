//
//  SuperPlayerSubtitlesView.m
//  SuperPlayer-Player
//
//  Created by 路鹏 on 2022/10/11.
//  Copyright © 2022 Tencent. All rights reserved.

#import "SuperPlayerSubtitlesView.h"
#import "SuperPlayerHelpers.h"
#import "SuperPlayerSubSettingView.h"
#import "SuperPlayerHelpers.h"
#import "SuperPlayerLocalized.h"
#import <Masonry/Masonry.h>

#define SUBTITLES_MODEL_TAG_BEGIN 70

@interface SuperPlayerSubtitlesView()<SuperPlayerSubSettingViewDelegate>

// 头部标题
@property (nonatomic, strong) UILabel *titleLabel;

// 设置按钮
@property (nonatomic, strong) UIButton *subtitlesSettingBtn;

// 当前选中的按钮
@property (nonatomic, strong) UIButton *subtitlesCurrentBtn;

// 内容View
@property (nonatomic, strong) UIView   *contentView;

// 设置View
@property (nonatomic, strong) SuperPlayerSubSettingView *settingView;

@property (nonatomic, strong) NSMutableArray<TXTrackInfo *>* infos;

@end

@implementation SuperPlayerSubtitlesView

#pragma mark - Public Method
- (void)initSubtitlesViewWithTrackArray:(NSMutableArray<TXTrackInfo *> *)subtitlesArray
                  currentSubtitlesIndex:(NSInteger)currentSubtitlesIndex {
    self.infos = [NSMutableArray array];
    for (TXTrackInfo *info in subtitlesArray) {
        if (!info.isInternal) {
            [self.infos addObject:info];
        }
    }
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(25);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview:self.subtitlesSettingBtn];
    [self.subtitlesSettingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-20);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    // 音轨view上的btn
    for (NSInteger i = 0; i< self.infos.count; i++) {
        TXTrackInfo *info = self.infos[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:info.name.length > 0 ? info.name : [NSString stringWithFormat:@"%@%ld",superPlayerLocalized(@"SuperPlayer.subtitles"),i - 1] forState:UIControlStateNormal];
        [btn setTitleColor:RGBA(252, 89, 81, 1) forState:UIControlStateSelected];
        [self.contentView addSubview:btn];
        [btn addTarget:self action:@selector(changeSubtitles:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.mas_width);
            make.height.mas_equalTo(45);
            make.left.equalTo(self.mas_left);
            make.centerY.equalTo(self.mas_centerY).offset((i - self.infos.count / 2.0 + 0.5) * 45);
        }];
        btn.tag = SUBTITLES_MODEL_TAG_BEGIN + i;
        
        if (i == currentSubtitlesIndex) {
            btn.selected = YES;
            btn.backgroundColor = RGBA(34, 30, 24, 1);
            self.subtitlesCurrentBtn = btn;
        }
    }
}

#pragma mark - Private Method
/**
 * 点击切换字幕
 */
- (void)changeSubtitles:(UIButton *)sender {
    if (self.subtitlesCurrentBtn.tag == sender.tag) {
        return;
    }
    NSInteger preSubtitlesIndex = self.subtitlesCurrentBtn.tag - SUBTITLES_MODEL_TAG_BEGIN;
    self.subtitlesCurrentBtn.selected = NO;
    self.subtitlesCurrentBtn.backgroundColor = [UIColor clearColor];
    self.subtitlesCurrentBtn = sender;
    self.subtitlesCurrentBtn.selected = YES;
    self.subtitlesCurrentBtn.backgroundColor = RGBA(34, 30, 24, 1);
    
    // delegate回调给外部
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseSubtitlesInfo:preSubtitlesInfo:)]) {
        [self.delegate chooseSubtitlesInfo:self.infos[sender.tag - SUBTITLES_MODEL_TAG_BEGIN] preSubtitlesInfo:self.infos[preSubtitlesIndex]];
    }
}

- (void)subtitlesSettingClick {
    self.contentView.hidden = YES;
    self.settingView.hidden = NO;
}

#pragma mark - SuperPlayerSubSettingViewDelegate

- (void)onSettingViewBackClick {
    self.settingView.hidden = YES;
    self.contentView.hidden = NO;
}

- (void)onSettingViewDoneClickWithDic:(NSMutableDictionary *)dic {
    // todo:回调给SuperPlayerView调用SDK设置字幕样式
}

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = superPlayerLocalized(@"SuperPlayer.subtitles");
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UIButton *)subtitlesSettingBtn {
    if (!_subtitlesSettingBtn) {
        _subtitlesSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_subtitlesSettingBtn setImage:SuperPlayerImage(@"play_setting") forState:UIControlStateNormal];
        [_subtitlesSettingBtn addTarget:self action:@selector(subtitlesSettingClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subtitlesSettingBtn;
}

- (SuperPlayerSubSettingView *)settingView {
    if (!_settingView) {
        _settingView = [[SuperPlayerSubSettingView alloc] initWithFrame:CGRectMake(0, 0, 330, self.frame.size.height)];
        [_settingView initSubtitlesSettingView];
        _settingView.hidden = YES;
        _settingView.delegate = self;
        [self addSubview:_settingView];
    }
    return _settingView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

@end
