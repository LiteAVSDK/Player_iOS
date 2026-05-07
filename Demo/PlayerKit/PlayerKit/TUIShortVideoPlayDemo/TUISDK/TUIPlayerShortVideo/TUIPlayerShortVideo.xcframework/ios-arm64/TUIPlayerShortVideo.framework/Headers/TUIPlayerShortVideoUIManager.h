// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TUIPlayerShortVideoControl.h"
#import "TUIPlayerShortVideoLoadingViewProtocol.h"
#import "TUIPlayerShortVideoCustomControl.h"
#import "TUIPlayerShortVideoLiveControl.h"

typedef NS_ENUM(NSInteger, TUI_ITEM_VIEW_TYPE) {

    /// 视频
    /// VOD
    TUI_ITEM_VIEW_TYPE_VOD = 0,

    /// 直播
    /// Live
    TUI_ITEM_VIEW_TYPE_LIVE = 1,

    /// 自定义类型
    /// custom
    TUI_ITEM_VIEW_TYPE_CUSTOM = 2,

};
NS_ASSUME_NONNULL_BEGIN
///UI管理
@interface TUIPlayerShortVideoUIManager : NSObject

/**
 * 加载图
 * @param loadingView  view实例
 */
- (void)setLoadingView:(UIView <TUIPlayerShortVideoLoadingViewProtocol>*)loadingView;
/**
 * 背景图
 * @param backgroundView  view实例
 */
- (void)setBackgroundView:(UIView *)backgroundView;
/**
 * 视频背景占位图
 * @param image  image实例
 */
- (void)setVideoPlaceholderImage:(UIImage *)image;
/**
 * 错误界面
 * @param errorView  view实例
 */
- (void)setErrorView:(UIView *)errorView;
/**
 * 视频控制层
 * @param viewClass  控制层类 ,viewClass是你封装好的视频控制view，包含如进度条，时间lable等控件
 * 它将被整体覆盖在视频窗口上，大小与视频窗口一致。
 */
- (void)setControlViewClass:(Class<TUIPlayerShortVideoControl>)viewClass;

/**
 * 视频控制层
 * @param viewClass  控制层类 ,viewClass是你封装好的视频控制view，包含如进度条，时间lable等控件
 * @param viewType 视图类型
 * 它将被整体覆盖在视频窗口上，大小与视频窗口一致。
 * TUI_ITEM_VIEW_TYPE_VOD类型需要遵循TUIPlayerShortVideoControl协议
 * TUI_ITEM_VIEW_TYPE_LIVE类型需要遵循TUIPlayerShortVideoLiveControl协议
 * TUI_ITEM_VIEW_TYPE_CUSTOM类型需要遵循TUIPlayerShortVideoCustomControl协议
 */
- (void)setControlViewClass:(Class)viewClass viewType:(TUI_ITEM_VIEW_TYPE)viewType;

/**
 * 获取加载图实例
 */
- (UIView<TUIPlayerShortVideoLoadingViewProtocol> *)getLoadingView;
/**
 * 获取背景图实例
 */
- (UIView *)getBackgroundView;
/**
 * 获取视频占位背景图
 */
- (UIImage *)getVideoPlaceholderImage;
/**
 * 获取错误界面实例
 */
- (UIView *)getErrorView;
/**
 * 获取视频控制界面类
 */
- (Class<TUIPlayerShortVideoControl> )getControlViewClass;
/**
 * 获取视频控制界面类
 * @param viewType 视图类型
 */
- (Class)getControlViewClassWithViewType:(TUI_ITEM_VIEW_TYPE)viewType;
@end

NS_ASSUME_NONNULL_END
