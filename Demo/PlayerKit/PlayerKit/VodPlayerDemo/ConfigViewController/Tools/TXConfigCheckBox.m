//
//  TXConfigCheckBox.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXConfigCheckBox.h"
#import "PlayerKitCommonHeaders.h"
#import "TXAppInstance.h"
@interface TXConfigCheckBox()

// 选择框
@property (nonatomic, strong) UIImageView    *ctrlStatusImgView;

// 文字
@property (nonatomic, strong) UILabel        *titleLab;

// block回调
@property (nonatomic, copy) VoidBlockTPCheck clickButtonCallback;

@end

@implementation TXConfigCheckBox

+ (instancetype)boxWithTitle:(NSString *)title{
    
    TXConfigCheckBox *box = [[TXConfigCheckBox alloc] init];
    
    //左边的图片
    box.ctrlStatusImgView = [[UIImageView alloc] init];
    [box addSubview:box.ctrlStatusImgView];
    box.ctrlStatusImgView.image = [TXAppInstance imageFromPlayerBundleNamed:@"btn_unselected"];
    [box.ctrlStatusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    //右边的标题
    box.titleLab = [[UILabel alloc] init];
    box.titleLab.text = title;
    box.titleLab.font = [UIFont systemFontOfSize:12];
    [box addSubview:box.titleLab];
    [box.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(box.ctrlStatusImgView.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
    }];
    
    [box addTarget:box  action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    return box;
    
}

- (void)clickAction{
    self.selected = !self.selected;
    if (self.selected) {
        self.ctrlStatusImgView.image = [TXAppInstance imageFromPlayerBundleNamed:@"btn_selected"];
    } else {
        self.ctrlStatusImgView.image = [TXAppInstance imageFromPlayerBundleNamed:@"btn_unselected"];
    }
    if (self.clickButtonCallback) {
        self.clickButtonCallback();
    }
}

- (void)clickButtonWithResultBlock:(VoidBlockTPCheck)block{
    self.clickButtonCallback = block;
}

//重写
- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (self.selected) {
        self.ctrlStatusImgView.image = [TXAppInstance imageFromPlayerBundleNamed:@"btn_selected"];
    }else{
        self.ctrlStatusImgView.image = [TXAppInstance imageFromPlayerBundleNamed:@"btn_unselected"];
    }
}

@end
