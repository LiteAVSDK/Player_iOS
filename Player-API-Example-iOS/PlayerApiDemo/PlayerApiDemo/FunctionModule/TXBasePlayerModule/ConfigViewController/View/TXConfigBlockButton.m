//
//  TXConfigBlockButton.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXConfigBlockButton.h"

@interface TXConfigBlockButton()

// block回调
@property (nonatomic, copy) VoidBlock clickButtonCallback;

@end

@implementation TXConfigBlockButton

+ (instancetype)btnWithTitle:(NSString*)title{
    if (title == nil) {
        title = @"";
    }
    
    TXConfigBlockButton *btn = [TXConfigBlockButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:btn action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    return btn;
}


+ (instancetype)tagWithTitle:(NSString*)title{
    if (title == nil) {
        title = @"";
    }
    
    TXConfigBlockButton *btn = [TXConfigBlockButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:btn action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    return btn;
}


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
    
}

- (void)clickAction{
    if (self.clickButtonCallback){
        self.clickButtonCallback();
    }
}

- (void)clickButtonWithResultBlock:(VoidBlock)block{
    self.clickButtonCallback = block;
}


@end
