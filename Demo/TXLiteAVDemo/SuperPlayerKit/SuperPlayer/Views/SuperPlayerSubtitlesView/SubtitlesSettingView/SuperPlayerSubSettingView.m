//
//  SuperPlayerSubSettingView.m
//  Pods
//
//  Created by 路鹏 on 2022/10/13.
//  Copyright © 2022 Tencent. All rights reserved.

#import "SuperPlayerSubSettingView.h"
#import "SuperPlayerHelpers.h"
#import "SuperPlayerTableMenu.h"
#import "SuperPlayerSubParamView.h"
#import "SuperPlayerLocalized.h"
#import <Masonry/Masonry.h>

@interface SuperPlayerSubSettingView()

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel  *titleLabel;

@property (nonatomic, strong) UIView   *bottomLineView;

@property (nonatomic, strong) UIView   *topLineView;

@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) UIButton *resetBtn;

@property (nonatomic, strong) SuperPlayerSubParamView *fontColorBtn;

@property (nonatomic, strong) SuperPlayerSubParamView *bondFontBtn;

@property (nonatomic, strong) SuperPlayerSubParamView *outlineWidthBtn;

@property (nonatomic, strong) SuperPlayerSubParamView *outlineColorBtn;

@property (nonatomic, assign) NSInteger fontColorType;

@property (nonatomic, assign) NSInteger bondFontType;

@property (nonatomic, assign) NSInteger outlineWidthType;

@property (nonatomic, assign) NSInteger outlineColorType;

@end

@implementation SuperPlayerSubSettingView

- (void)initSubtitlesSettingView {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(20);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(60);
        make.top.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.topLineView];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(70);
        make.height.mas_equalTo(1);
    }];
    
    [self addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-70);
        make.height.mas_equalTo(1);
    }];
    
    [self addSubview:self.doneBtn];
    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self).offset(-20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(130);
    }];
    
    [self addSubview:self.resetBtn];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(130);
    }];
    
    CGFloat blockBtnHeight = (self.frame.size.height - (71 * 2)) / 4;
    
    self.fontColorBtn = [[SuperPlayerSubParamView alloc] initWithFrame:
                         CGRectMake(0, 71, self.frame.size.width, blockBtnHeight)];
    [self addSubview:self.fontColorBtn];
    
    self.bondFontBtn = [[SuperPlayerSubParamView alloc] initWithFrame:
                        CGRectMake(0, 71 + blockBtnHeight, self.frame.size.width, blockBtnHeight)];
    [self addSubview:self.bondFontBtn];
    
    self.outlineWidthBtn = [[SuperPlayerSubParamView alloc] initWithFrame:
                            CGRectMake(0, 71 + (2 * blockBtnHeight), self.frame.size.width, blockBtnHeight)];
    [self addSubview:self.outlineWidthBtn];
    
    self.outlineColorBtn = [[SuperPlayerSubParamView alloc] initWithFrame:
                            CGRectMake(0, 71 + (3 * blockBtnHeight), self.frame.size.width, blockBtnHeight)];
    [self addSubview:self.outlineColorBtn];
    
    __weak __typeof(self) weakSelf = self;
    
    [self.fontColorBtn clickButtonWithResultBlock:^{  //字体颜色
        NSArray *fontColorArr = [weakSelf fontColorArray];
        SuperPlayerTableMenu *menu = [SuperPlayerTableMenu title:superPlayerLocalized(@"SuperPlayer.choosefontcolor") array:fontColorArr];
        [menu clickCellWithResultblock:^(NSInteger index) {
            weakSelf.fontColorType = index;
            [weakSelf.fontColorBtn setChooseTitle:fontColorArr[index] name:[weakSelf stringFontColor]];
        }];
    }];
    
    [self.bondFontBtn clickButtonWithResultBlock:^{   // 字体类型，是否粗体
        NSArray *bondFontArr = [weakSelf bondFontArray];
        SuperPlayerTableMenu *menu = [SuperPlayerTableMenu title:superPlayerLocalized(@"SuperPlayer.choosebontfont") array:bondFontArr];
        [menu clickCellWithResultblock:^(NSInteger index) {
            weakSelf.bondFontType = index;
            [weakSelf.bondFontBtn setChooseTitle:bondFontArr[index] name:[weakSelf stringBondFont]];
        }];
    }];
    
    [self.outlineWidthBtn clickButtonWithResultBlock:^{   // 描边宽度
        NSArray *outlineWidthArr = [weakSelf outlineWidthArray];
        SuperPlayerTableMenu *menu = [SuperPlayerTableMenu title:superPlayerLocalized(@"SuperPlayer.chooseoutlinewidth") array:outlineWidthArr];
        [menu clickCellWithResultblock:^(NSInteger index) {
            weakSelf.outlineWidthType = index;
            [weakSelf.outlineWidthBtn setChooseTitle:outlineWidthArr[index] name:[weakSelf stringOutLineWidth]];
        }];
    }];
    
    [self.outlineColorBtn clickButtonWithResultBlock:^{   // 描边颜色
        NSArray *outlineColorArr = [weakSelf outlineColorArray];
        SuperPlayerTableMenu *menu = [SuperPlayerTableMenu title:superPlayerLocalized(@"SuperPlayer.chooseoutlinecolor") array:outlineColorArr];
        [menu clickCellWithResultblock:^(NSInteger index) {
            weakSelf.outlineColorType = index;
            [weakSelf.outlineColorBtn setChooseTitle:outlineColorArr[index] name:[weakSelf stringOutlineColor]];
        }];
    }];
    
    [self defaultPlayerConfig];
    
    [self setDefaultBtnStatus];
}

#pragma mark - Private Method

- (void)setDefaultBtnStatus {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"subtitlesConfig"];
    // 显示默认值
    self.fontColorType = [[dic objectForKey:@"fontColor"] integerValue];
    NSArray *fontColorArray = [self fontColorArray];
    [self.fontColorBtn setChooseTitle:fontColorArray[self.fontColorType] name:[self stringFontColor]];
    
    self.bondFontType = [[dic objectForKey:@"bondFont"] integerValue];
    NSArray *bontFontArray = [self bondFontArray];
    [self.bondFontBtn setChooseTitle:bontFontArray[self.bondFontType] name:[self stringBondFont]];
    
    self.outlineWidthType = [[dic objectForKey:@"outlineWidth"] integerValue];
    NSArray *outlineWidthArray = [self outlineWidthArray];
    [self.outlineWidthBtn setChooseTitle:outlineWidthArray[self.outlineWidthType] name:[self stringOutLineWidth]];
    
    self.outlineColorType = [[dic objectForKey:@"outlineColor"] integerValue];
    NSArray *outlineColorArray = [self outlineColorArray];
    [self.outlineColorBtn setChooseTitle:outlineColorArray[self.outlineColorType] name:[self stringOutlineColor]];
}

- (NSArray *)fontColorArray {
    return @[@"White(默认)", @"Black", @"Red" ,@"Blue",
             @"Green", @"Yellow" ,@"Magenta", @"Cyan"];
}

- (uint32_t)getFontColor:(NSInteger)index {
    NSArray<NSNumber *> *array = @[@(0xFFFFFFFF), @(0xFF000000), @(0xFFFF0000), @(0xFF0000FF),
                       @(0xFF00FF00), @(0xFFFFFF00), @(0xFFFF00FF), @(0xFF00FFFF)];
    return [array[index] unsignedIntValue];
}

- (NSArray *)bondFontArray {
    return @[@"Normal(默认)",@"BoldFace"];
}

- (BOOL)getBondFont:(NSInteger)index{
    NSArray<NSNumber *> *array = @[@(0),@(1)];
    return [array[index] boolValue];
}

- (NSArray *)outlineWidthArray {
    return @[@"50%", @"75%", @"100%(默认)" ,@"125%",
             @"150%", @"175%" ,@"200%", @"300%", @"400%"];
}

- (CGFloat)getOutlineWidth:(NSInteger)index{
    NSArray<NSNumber *> *array = @[@(0.5), @(0.75), @(1) ,@(1.25),
                       @(1.5), @(1.75) ,@(2), @(3), @(4)];
    return [array[index] floatValue];
}

- (NSArray *)outlineColorArray {
    return @[@"Black(默认)", @"White", @"Red" ,@"Blue",
             @"Green", @"Yellow" ,@"Magenta", @"Cyan"];
}

- (uint32_t)getOutlineColor:(NSInteger)index {
    NSArray<NSNumber *> *array = @[@(0xFF000000), @(0xFFFFFFFF), @(0xFFFF0000), @(0xFF0000FF),
                       @(0xFF00FF00), @(0xFFFFFF00), @(0xFFFF00FF), @(0xFF00FFFF)];
    return [array[index] unsignedIntValue];
}

- (NSString *)stringFontColor {
    return @"Font Color:";
}

- (NSString *)stringBondFont {
    return @"Bond Font:";
}

- (NSString *)stringOutLineWidth {
    return @"Outline Width:";
}

- (NSString *)stringOutlineColor {
    return @"Outline Color:";
}

- (void)defaultPlayerConfig {
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    [mDic setObject:@(0) forKey:@"fontColor"];
    [mDic setObject:@(0) forKey:@"bondFont"];
    [mDic setObject:@(2) forKey:@"outlineWidth"];
    [mDic setObject:@(0) forKey:@"outlineColor"];
    
    [[NSUserDefaults standardUserDefaults] setObject:mDic forKey:@"subtitlesConfig"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Click

- (void)backBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSettingViewBackClick)]) {
        [self.delegate onSettingViewBackClick];
    }
}

- (void)doneBtnClick {
    
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    [mDic setObject:@([self getFontColor:self.fontColorType]) forKey:@"fontColor"];
    [mDic setObject:@([self getBondFont:self.bondFontType]) forKey:@"bondFont"];
    [mDic setObject:@([self getOutlineWidth:self.outlineWidthType]) forKey:@"outlineWidth"];
    [mDic setObject:@([self getOutlineColor:self.outlineColorType]) forKey:@"outlineColor"];
    
    [[NSUserDefaults standardUserDefaults] setObject:mDic forKey:@"subtitlesConfig"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSettingViewDoneClickWithDic:)]) {
        [self.delegate onSettingViewDoneClickWithDic:mDic];
    }
}

- (void)resetBtnClick {
    [self defaultPlayerConfig];
    
    [self setDefaultBtnStatus];
}

#pragma mark - 懒加载

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:SuperPlayerImage(@"back_full") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel           = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font      = [UIFont systemFontOfSize:15.0];
        _titleLabel.text      = superPlayerLocalized(@"SuperPlayer.subtitlessetting");
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.25];
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.25];
    }
    return _bottomLineView;
}

- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _doneBtn.layer.cornerRadius = 2;
        _doneBtn.layer.borderWidth = 1;
        _doneBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _doneBtn.layer.masksToBounds = YES;
    }
    return _doneBtn;
}

- (UIButton *)resetBtn {
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetBtn setTitle:@"Reset" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _resetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_resetBtn addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _resetBtn.layer.cornerRadius = 2;
        _resetBtn.layer.borderWidth = 1;
        _resetBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _resetBtn.layer.masksToBounds = YES;
    }
    return _resetBtn;
}

@end
