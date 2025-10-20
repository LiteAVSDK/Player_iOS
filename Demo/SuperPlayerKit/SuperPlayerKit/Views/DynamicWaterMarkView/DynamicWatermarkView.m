//
//  DynamicWatermarkView.m
//  Pods
//
//  Created by 路鹏 on 2021/12/9.
//

#import "DynamicWatermarkView.h"
#import "UILabel+Size.h"
#import "SuperPlayerHelpers.h"

@interface DynamicWatermarkView()
// the height of this view
// 此view的高度
@property (nonatomic, assign) NSInteger watermarkViewHeight;
// the width of this view
// 此view的宽度
@property (nonatomic, assign) NSInteger watermarkViewWidth;
// watermark center point X value
// 水印中心点 X值
@property (nonatomic, assign) double watermarkCenterX;
// watermark center point y value
// 水印中心点 y值
@property (nonatomic, assign) double watermarkCenterY;
// watermark width
// 水印宽度
@property (nonatomic, assign) NSInteger watermarkWidth;
// watermark height
// 水印高度
@property (nonatomic, assign) NSInteger watermarkHeight;
// Velocity on the X axis
// X轴上的速度
@property (nonatomic, assign) double deltaX;
// Velocity on the X axis
// X轴上的速度
@property (nonatomic, assign) double deltaY;
// speed
// 速度
@property (nonatomic, assign) NSInteger watermarkSpeed;
// One-half the width of the background rectangle
// 背景矩形框宽的二分之一
@property (nonatomic, assign) NSInteger bgRectWidthHalf;
// Half of the height of the background rectangle
// 背景矩形框高的二分之一
@property (nonatomic, assign) NSInteger bgRectHeightHalf;
// angle of movement
// 运动的角度
@property (nonatomic, assign) NSInteger watermarkDegree;
// frame
@property (nonatomic, assign) CGRect    bgRect;

@property (nonatomic, strong) UILabel   *waterMarkLabel;

@property (nonatomic, strong) NSTimer   *waterMarkTimer;
// ghost timer
// 幽灵水印定时器
@property (nonatomic, strong) NSTimer *ghostTimer;
// ghost timer cycle count
// 幽灵水印定时器周期数
@property (nonatomic, assign) NSInteger ghostTimerCount;

@end

@implementation DynamicWatermarkView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // The speed at which the watermark moves, randomly select one from 1 to 3
        // 水印移动的速度，从1到3随机取一个
        self.watermarkSpeed = 1 + rand()%(3 - 1 + 1);
        [self addSubview:self.waterMarkLabel];
        self.userInteractionEnabled = NO;
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.bounds;
    [self onSizeChange:rect];
}
#pragma mark - Public Method
- (void)setDynamicWaterModel:(DynamicWaterModel *)dynamicWaterModel {
    if (dynamicWaterModel != nil && dynamicWaterModel.dynamicWatermarkTip.length > 0) {
        if (self.dynamicWaterModel == nil) {
            // The angle at which the watermark starts to move, randomly select an angle from 25 to 65
            // 水印开始移动的角度，从25到65随机取个角度
            self.watermarkDegree = 25 + rand()%(65 - 25 + 1);
            [self calculateSpeedXY:self.watermarkDegree];
        }
        _dynamicWaterModel = dynamicWaterModel;
        [self.waterMarkLabel setTextColor:dynamicWaterModel.textColor];
        self.waterMarkLabel.text = dynamicWaterModel.dynamicWatermarkTip;
        [self calculateBgRectWH];
        [self showDynamicWateView];
        if (!self.waterMarkTimer) {
            self.waterMarkTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(changeFrame) userInfo:nil repeats:YES];
        }
        if (dynamicWaterModel.showType == ghost) {
            int cycle = [self calculateCycle:dynamicWaterModel.duration];
            if (cycle > 0) {
                self.ghostTimer = [NSTimer scheduledTimerWithTimeInterval:cycle/4
                                                                   target:self
                                                                 selector:@selector(ghostAction)
                                                                 userInfo:nil
                                                                  repeats:YES];
            }
        }
    } else {
        [self hideDynamicWateView];
    }
}

- (void)showDynamicWateView {
    if (self.dynamicWaterModel != nil) {
        self.waterMarkLabel.hidden = NO;
    } else {
        [self hideDynamicWateView];
    }
}

- (void)hideDynamicWateView {
    self.waterMarkLabel.hidden = YES;
}

- (void)releaseDynamicWater {
    [self.waterMarkTimer invalidate];
    self.waterMarkTimer = nil;
    [self hideDynamicWateView];
}

- (void)onSizeChange:(CGRect)rect {
    if (rect.size.width != self.watermarkViewWidth || rect.size.height != self.watermarkViewHeight) {
        self.watermarkViewWidth = rect.size.width;
        self.watermarkViewHeight = rect.size.height;
        if (_dynamicWaterModel != nil) {
            self.watermarkCenterX = self.bgRectWidthHalf;
            self.watermarkCenterY = self.bgRectHeightHalf;
        }
    }
}

#pragma mark - Private Method
- (int)calculateCycle:(int)duration {
    int cycle = 0;
    if (duration <= 0 ) { ///小于0，关闭水印
        [self hideDynamicWateView];
    } else if (duration > 0 && duration <= 60 ) {
        cycle = duration/2;
    } else if (duration > 60 && duration <= 30*60 ) {
        cycle = duration/4;
    } else { ///duration > 30*60
        cycle = 30*60/4;
    }
    return cycle;
}
- (void)changeFrame {
    [self processData];
    self.waterMarkLabel.frame = _bgRect;
}
- (void)ghostAction {
    if (self.dynamicWaterModel.showType == ghost) {
        self.ghostTimerCount ++;
        if (self.ghostTimerCount == 1) {
            self.waterMarkLabel.hidden = YES;
        }
        if (self.ghostTimerCount == 4) {
            self.waterMarkLabel.hidden = NO;
            self.ghostTimerCount = 0;///复位
        }
    }
}
/**
  * Calculate the width and height of the background according to the text
  */
/**
 * 根据文本计算背景的宽高
 */
- (void)calculateBgRectWH {
    UIFont *textFont = [UIFont systemFontOfSize:self.dynamicWaterModel.textFont];
    CGFloat width = [UILabel getWidthWithTitle:self.dynamicWaterModel.dynamicWatermarkTip font:textFont];
    CGFloat height = [UILabel getHeightByWidth:width title:self.dynamicWaterModel.dynamicWatermarkTip font:textFont];
    self.watermarkWidth = width;
    self.watermarkHeight = height;
    self.watermarkCenterX = width / 2;
    self.watermarkCenterY = height / 2;
    self.bgRectWidthHalf = width / 2;
    self.bgRectHeightHalf = height / 2;
}
/**
  * Process the location data of the watermark
  */
/**
 * 处理水印的位置数据
 */
- (void)processData {
    if (self.dynamicWaterModel == nil) {
        return;
    }
    self.watermarkCenterY += self.deltaY;
    self.watermarkCenterX += self.deltaX;
    [self checkBorderCollision];
    _bgRect.origin.x = _watermarkCenterX - _bgRectWidthHalf;
    _bgRect.origin.y = _watermarkCenterY - _bgRectHeightHalf;
    _bgRect.size.width = self.watermarkWidth;
    _bgRect.size.height = self.watermarkHeight;
}
/**
  * Impact checking
  */
/**
 * 碰撞检测
 */
- (void)checkBorderCollision {
    if (self.watermarkCenterY <= self.bgRectHeightHalf) {  // 表示碰撞到了上边距
        [self onCollisionBorderResultDegree:DYNAMIC_WATERMARK_BORDER_TOP];
        self.watermarkCenterY = _bgRectHeightHalf;
    } else if (self.watermarkCenterY >= self.watermarkViewHeight - self.bgRectHeightHalf) {  //表示碰撞到了下边距
        [self onCollisionBorderResultDegree:DYNAMIC_WATERMARK_BORDER_BOTTOM];
        self.watermarkCenterY = self.watermarkViewHeight - self.bgRectHeightHalf;
    }
    
    if (self.watermarkCenterX <= self.bgRectWidthHalf) {    //表示碰撞到了左边距
        [self onCollisionBorderResultDegree:DYNAMIC_WATERMARK_BORDER_LEFT];
        self.watermarkCenterX = self.bgRectWidthHalf;
    } else if (self.watermarkCenterX >= self.watermarkViewWidth - self.bgRectWidthHalf) {   //表示碰撞到了右边距
        [self onCollisionBorderResultDegree:DYNAMIC_WATERMARK_BORDER_RIGHT];
        self.watermarkCenterX = self.watermarkViewWidth - self.bgRectWidthHalf;
    }
}
/**
  * Angle transformation after collision
  */
/**
 * 碰撞后角度变换
 */
- (void)onCollisionBorderResultDegree:(NSInteger)border {
    if (self.watermarkDegree > DYNAMIC_WATERMARK_DEGREE_0 && self.watermarkDegree <= DYNAMIC_WATERMARK_DEGREE_90) {
        if (border == DYNAMIC_WATERMARK_BORDER_BOTTOM) {
            self.watermarkDegree = DYNAMIC_WATERMARK_DEGREE_180 - self.watermarkDegree;
        }
        if (border == DYNAMIC_WATERMARK_BORDER_RIGHT) {
            self.watermarkDegree = DYNAMIC_WATERMARK_DEGREE_360 - self.watermarkDegree;
        }
    } else if (self.watermarkDegree > DYNAMIC_WATERMARK_DEGREE_90 && self.watermarkDegree <= DYNAMIC_WATERMARK_DEGREE_180) {
        if (border == DYNAMIC_WATERMARK_BORDER_RIGHT) {
            self.watermarkDegree = DYNAMIC_WATERMARK_DEGREE_360 - self.watermarkDegree;
        }
        if (border == DYNAMIC_WATERMARK_BORDER_TOP) {
            self.watermarkDegree = DYNAMIC_WATERMARK_DEGREE_180 - self.watermarkDegree;
        }
    } else if (self.watermarkDegree > DYNAMIC_WATERMARK_DEGREE_180 && self.watermarkDegree <= DYNAMIC_WATERMARK_DEGREE_270) {
        if (border == DYNAMIC_WATERMARK_BORDER_LEFT) {
            self.watermarkDegree = DYNAMIC_WATERMARK_DEGREE_360 - self.watermarkDegree;
        }
        if (border == DYNAMIC_WATERMARK_BORDER_TOP) {
            self.watermarkDegree = DYNAMIC_WATERMARK_DEGREE_270 + DYNAMIC_WATERMARK_DEGREE_270 - self.watermarkDegree;
        }
    } else if (self.watermarkDegree > DYNAMIC_WATERMARK_DEGREE_270 && self.watermarkDegree <= DYNAMIC_WATERMARK_DEGREE_360) {
        if (border == DYNAMIC_WATERMARK_BORDER_BOTTOM) {
            self.watermarkDegree = DYNAMIC_WATERMARK_DEGREE_360 - self.watermarkDegree + DYNAMIC_WATERMARK_DEGREE_180;
        }
        if (border == DYNAMIC_WATERMARK_BORDER_LEFT) {
            self.watermarkDegree = DYNAMIC_WATERMARK_DEGREE_360 - self.watermarkDegree;
        }
    }
    
    [self calculateSpeedXY:self.watermarkDegree];
}
/**
  * Calculate the speed in x direction and y direction
  */
/**
 * 计算x方向和y方向的速度
 */
- (void)calculateSpeedXY:(NSInteger)degree {
    double tempPI = degree / 180.0 * M_PI;
    self.deltaX = sin(tempPI) * self.watermarkSpeed;
    self.deltaY = cos(tempPI) * self.watermarkSpeed;
}

#pragma mark - 懒加载
- (UILabel *)waterMarkLabel {
    if (!_waterMarkLabel) {
        _waterMarkLabel = [[UILabel alloc] init];
        _waterMarkLabel.backgroundColor = [UIColor clearColor];
        _waterMarkLabel.textAlignment = NSTextAlignmentCenter;
        _waterMarkLabel.numberOfLines = 2;
        _waterMarkLabel.hidden = YES;
    }
    return _waterMarkLabel;
}
@end
