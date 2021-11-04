//
//  SuperShortVideoView.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/18.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXVideoViewModel.h"
#import "TXVideoUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuperShortVideoView : UIView

// ViewModel
@property (nonatomic, strong) TXVideoViewModel        *viewModel;

@property (nonatomic, assign) TXVideoPlayMode         playmode;

/**
 * 初始化
 * @param vc               所属控制器
*/
- (instancetype)initWithViewController:(UIViewController *)vc;

/**
 * 设置数据源
 * @param models       视频数据源
*/
- (void)setModels:(NSArray *)models viewCount:(NSInteger)viewCount;

/**
 * 开始加载菊花
*/
- (void)showLoading;

/**
 * 显示遮罩控件
*/
- (void)showGuideView;

/**
 * 暂停
*/
- (void)pause;

/**
 * 继续播放
*/
- (void)resume;

/**
 * 销毁播放器
*/
- (void)destoryPlayer;


- (void)jumpToCellWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
