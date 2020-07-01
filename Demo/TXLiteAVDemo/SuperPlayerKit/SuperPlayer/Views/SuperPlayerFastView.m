//
//  SuperPlayerFastView.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/8/24.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "SuperPlayerFastView.h"
#import "SuperPlayer.h"
#import "SuperPlayerView+Private.h"
#import "UIView+MMLayout.h"

#define THUMB_VIEW_WIDTH    142
#define THUMB_VIEW_HEIGHT   (142/(16/9.0))

@implementation SuperPlayerFastView

- (instancetype)init {
    self = [super init];
    
    self.backgroundColor = RGBA(0, 0, 0, 0.2);
    
    _videoRatio = 1;
    _style = -1;
    
    return self;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel               = [[UILabel alloc] init];
        _textLabel.textColor     = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font          = [UIFont systemFontOfSize:18.0];
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (UIImageView *)thumbView {
    if (!_thumbView) {
        _thumbView = [[UIImageView alloc] init];
        _thumbView.contentMode = UIViewContentModeScaleAspectFit;
        _thumbView.backgroundColor = [UIColor blackColor];
        [self addSubview:_thumbView];
    }
    return _thumbView;
}

- (UIImageView *)snapshotView {
    if (!_snapshotView) {
        _snapshotView = [[UIImageView alloc] init];
        _snapshotView.contentMode = UIViewContentModeScaleAspectFit;
        _snapshotView.backgroundColor = [UIColor blackColor];
        [self addSubview:_snapshotView];
        
        [_snapshotView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(THUMB_VIEW_WIDTH);
            make.height.mas_equalTo(THUMB_VIEW_HEIGHT);
            make.center.equalTo(self);
        }];
    }
    return _snapshotView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView                   = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor whiteColor];
        _progressView.trackTintColor    = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
        [self addSubview:_progressView];
    }
    return _progressView;
}

- (void)setStyle:(FastViewStyle)style {
    if (_style == style)
        return;
    
    switch (style) {
        case ImgWithProgress: {
            self.imgView.hidden = self.progressView.hidden = NO;
            self.textLabel.hidden = self.thumbView.hidden = self.snapshotView.hidden = YES;
            self.imgView.contentMode = UIViewContentModeScaleAspectFit;
            
            [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
            [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.top.equalTo(self.imgView.mas_bottom).offset(10);
                make.width.mas_equalTo(120);
            }];
        }
            break;
        case ImgWithText: {
            self.thumbView.hidden = self.textLabel.hidden = NO;
            self.progressView.hidden = self.imgView.hidden = self.snapshotView.hidden = YES;
            
            [self.thumbView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.width.mas_equalTo(THUMB_VIEW_WIDTH);
                make.height.mas_equalTo(THUMB_VIEW_HEIGHT);
                make.bottom.equalTo(self.mas_centerY).offset(20);
            }];

            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.top.equalTo(self.thumbView.mas_bottom).offset(10);
            }];
        }
            break;
        case TextWithProgress: {
            self.progressView.hidden = self.textLabel.hidden = NO;
            self.imgView.hidden = self.thumbView.hidden = self.snapshotView.hidden = YES;
            
            [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
            [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.top.equalTo(self.textLabel.mas_bottom).offset(10);
                make.width.mas_equalTo(120);
            }];
        }
            break;
        case SnapshotImg: {
            self.progressView.hidden = self.textLabel.hidden = self.imgView.hidden = self.thumbView.hidden = YES;
            self.snapshotView.hidden = NO;
        }
            break;
        default:
            break;
    }
    _style = style;
}

- (void)showImg:(UIImage *)img withProgress:(GLfloat)progress
{
    self.imgView.image = img;
    self.progressView.progress = progress;
    self.style = ImgWithProgress;
}

- (void)showThumbnail:(UIImage *)img withText:(NSString *)text
{
    self.thumbView.image = [self imageWithImage:img];
    self.textLabel.text = text;
    [self.textLabel sizeToFit];
    self.style = ImgWithText;
}
- (void)showText:(NSString *)text withText:(GLfloat)progress
{
    self.textLabel.text = text;
    [self.textLabel sizeToFit];
    self.progressView.progress = progress;
    self.style = TextWithProgress;
}

- (void)showSnapshot:(UIImage *)img
{
    self.snapshotView.image = img;
    self.style = SnapshotImg;
}

- (UIImage *)imageWithImage:(UIImage *)image {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    CGSize newSize = CGSizeMake(THUMB_VIEW_WIDTH, THUMB_VIEW_HEIGHT);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    
    CGRect rect = AVMakeRectWithAspectRatioInsideRect(CGSizeMake(image.size.width, image.size.width/self.videoRatio), CGRectMake(0, 0, THUMB_VIEW_WIDTH, THUMB_VIEW_HEIGHT));
    
    [image drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
