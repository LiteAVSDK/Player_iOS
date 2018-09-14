//
//  PlayerSlider.m
//  Slider
//
//  Created by annidyfeng on 2018/8/27.
//  Copyright © 2018年 annidy. All rights reserved.
//

#import "PlayerSlider.h"

@implementation PlayerPoint
- (instancetype)init {
    self = [super init];
    
    self.holder = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //    view.backgroundColor = [UIColor yellowColor];
    UIView *inter = [[UIView alloc] initWithFrame:CGRectMake(14, 14, 2, 2)];
    inter.backgroundColor = [UIColor whiteColor];
    [self.holder addSubview:inter];
    self.holder.userInteractionEnabled = YES;
    
    return self;
}
@end

@interface PlayerSlider()
@property UIImageView    *tracker;
@end

@implementation PlayerSlider

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initUI];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self initUI];
    return self;
}

- (void)initUI {
    _progressView                   = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.progressTintColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    _progressView.trackTintColor    = [UIColor clearColor];
    
    [self addSubview:_progressView];
    
    self.pointArray = [NSMutableArray new];
    self.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tracker = self.subviews.lastObject;
    for (PlayerPoint *point in self.pointArray) {
        point.holder.center = [self holderCenter:point.where];
        [self insertSubview:point.holder belowSubview:self.tracker];
    }
    _progressView.frame = CGRectMake(2, 0, self.frame.size.width-4, _progressView.frame.size.height);
    _progressView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2+0.5);
}

- (PlayerPoint *)addPoint:(GLfloat)where
{
    PlayerPoint *point = [PlayerPoint new];
    point.where = where;
    point.holder.center = [self holderCenter:where];
    point.holder.hidden = _hiddenPoints;
    [self.pointArray addObject:point];
    [point.holder addTarget:self action:@selector(onClickHolder:) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsLayout];
    return point;
}

- (CGPoint)holderCenter:(GLfloat)where {
    return CGPointMake(self.frame.size.width * where, self.frame.size.height/2+0.5);
}

- (void)onClickHolder:(UIControl *)sender {
    NSLog(@"clokc");
    for (PlayerPoint *point in self.pointArray) {
        if (point.holder == sender) {
            if ([self.delegate respondsToSelector:@selector(onPlayerPointSelected:)])
                [self.delegate onPlayerPointSelected:point];
        }
    }
}

- (void)setHiddenPoints:(BOOL)hiddenPoints
{
    for (PlayerPoint *point in self.pointArray) {
        point.holder.hidden = hiddenPoints;
    }
    _hiddenPoints = hiddenPoints;
}
@end
