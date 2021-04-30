//
//  SuperPlayerGuideView.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/8/16.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "SuperPlayerGuideView.h"
#import "SuperPlayer.h"
#import "Masonry.h"
#import "AppLocalized.h"

@interface SuperPlayerGuideView()
@property UIButton *iknow_btn;
@property NSInteger guideIdx;

@property UIImageView *leftImg;
@property UIImageView *middleImg;
@property UIImageView *rightImg;

@property UILabel *leftLabel;
@property UILabel *middleLabel;
@property UILabel *rightLabel;

@property UIImageView *arrowImg;
@property UILabel *arrowLabel;
@property UISlider *videoSlider;

@end

@implementation SuperPlayerGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [btn setImage:SuperPlayerImage(@"iknown") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(miss) forControlEvents:UIControlEventTouchUpInside];
        self.iknow_btn = btn;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_offset(20);
            make.right.equalTo(self).mas_offset(-20);
        }];

        [self showGuide1];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)showGuide1 {
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"left_g")];
    [self addSubview:leftImg];
    UILabel *leftLabel = [UILabel new];
    [self addSubview:leftLabel];
    leftLabel.font = [UIFont systemFontOfSize:10];
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.text = LivePlayerLocalize(@"SuperPlayerDemo.SuperPlayerGuideView.slideupanddowntoadjust");
    self.leftImg = leftImg;
    self.leftLabel = leftLabel;
    
    UIImageView *rightImg = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"right_g")];
    [self addSubview:rightImg];
    UILabel *rightLabel = [UILabel new];
    [self addSubview:rightLabel];
    rightLabel.font = [UIFont systemFontOfSize:10];
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.text = LivePlayerLocalize(@"SuperPlayerDemo.SuperPlayerGuideView.slideupanddowntovolume");
    self.rightImg = rightImg;
    self.rightLabel = rightLabel;
    
    UIImageView *middleImg = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"middle_g")];
    [self addSubview:middleImg];
    UILabel *middleLabel = [UILabel new];
    [self addSubview:middleLabel];
    middleLabel.textColor = [UIColor whiteColor];
    middleLabel.font = [UIFont systemFontOfSize:10];
    middleLabel.text = LivePlayerLocalize(@"SuperPlayerDemo.SuperPlayerGuideView.slideleftandrighttofastforward");
    self.middleImg = middleImg;
    self.middleLabel = middleLabel;

    int leftwidth = 60;
    if (ScreenWidth < 375)
        leftwidth = 45;
    
    [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(leftwidth);
        make.centerY.equalTo(self.mas_top).mas_equalTo(self.frame.size.width*(9.0f/16.0f)/2);
    }];
    
    [middleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(leftImg);
    }];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-leftwidth);
        make.centerY.equalTo(leftImg);
    }];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftImg);
        make.top.equalTo(leftImg.mas_bottom).mas_offset(4);
    }];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightImg);
        make.centerY.equalTo(leftLabel);
    }];
    [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(middleImg);
        make.centerY.equalTo(leftLabel);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // ignore
}


- (void)removeGuide1 {
    [self.leftImg removeFromSuperview];
    [self.middleImg removeFromSuperview];
    [self.rightImg removeFromSuperview];
    [self.leftLabel removeFromSuperview];
    [self.middleLabel removeFromSuperview];
    [self.rightLabel removeFromSuperview];
}

- (void)showGuide2 {

    UIView *bkgView = [UIView new];
    [self addSubview:bkgView];
    bkgView.backgroundColor = RGBA(255, 255, 255, 1);
    bkgView.layer.cornerRadius    = 12;
    bkgView.layer.masksToBounds   = YES;
    
    _videoSlider                       = [[UISlider alloc] init];
    [self addSubview:_videoSlider];
    [_videoSlider setThumbImage:SuperPlayerImage(@"slider_thumb") forState:UIControlStateNormal];
    _videoSlider.maximumValue          = 1;
    _videoSlider.value                 = 1;
    _videoSlider.minimumTrackTintColor = TintColor;
    _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    _videoSlider.userInteractionEnabled = NO;
    
    UIImageView *arrowImg = [[UIImageView alloc] initWithImage:SuperPlayerImage(@"arrow")];
    [self addSubview:arrowImg];
    UILabel *arrowLabel = [UILabel new];
    [self addSubview:arrowLabel];
    arrowLabel.font = [UIFont systemFontOfSize:10];
    arrowLabel.textColor = [UIColor whiteColor];
    arrowLabel.text = LivePlayerLocalize(@"SuperPlayerDemo.SuperPlayerGuideView.leftwatchlivecontent");
    self.arrowImg = arrowImg;
    self.arrowLabel = arrowLabel;
    
    [_videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(86);
        make.right.mas_equalTo(-48);
        make.centerY.equalTo(self.mas_top).mas_offset(ScreenWidth*(9.0f/16.0f)-18);
    }];
    
    [bkgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_videoSlider).mas_offset(UIEdgeInsetsMake(-5, -5, -5, -5));
    }];
    
    [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_videoSlider);
        make.bottom.equalTo(bkgView.mas_top);
    }];
    
    [arrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImg.mas_left);
        make.bottom.equalTo(arrowImg.mas_top);
    }];
}

- (void)miss {
    self.guideIdx++;
    if (self.guideIdx == 1) {
        [self removeGuide1];
        [self showGuide2];
    } else if (self.guideIdx == 2) {
        [self removeFromSuperview];
        if (self.missHandler)
            self.missHandler();
    }
}

@end
