//
//  TXBottomToolView.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXBottomToolViewDelegate <NSObject>

/**
 *   开始播放或者暂停的事件
 *   @param isSelected 是否选中，选中则是开始播放 未选中为暂停
 */
- (void)onStartPlaySwitch:(BOOL)isSelected;

/**
 *   停止播放的事件
 */
- (void)onStopPlayClick;

/**
 *   开日志开启与否的事件
 *   @param isOpenLog 是否开启，YES为开启，NO为关闭
 */
- (void)onLogSwitch:(BOOL)isOpenLog;

/**
 *   是否静音的事件
 *   @param isMute 是否静音，YES为静音，NO为不静音
 */
- (void)onMuteSwitch:(BOOL)isMute;

/**
 *   软硬解切换的事件
 *   @param bHWDec  软硬解，YES为硬解，NO为软解 切换后会重启播放流程
 */
- (void)onHardWareSwitch:(BOOL)bHWDec;

/**
 *   填充模式切换的事件
 *   @param isFillScreen  是否填充整个屏幕，YES为填充整个屏幕，NO为适应屏幕
 */
- (void)onRenderModeSwitch:(BOOL)isFillScreen;

/**
 *   是否开启缓存的事件
 *   @param isCache  是否开启缓存，YES为开启缓存，NO为不开启缓存
 */
- (void)onCacheSwitch:(BOOL)isCache;

@end

@interface TXBottomToolView : UIView

@property(nonatomic,weak) id<TXBottomToolViewDelegate> delegate;

/**
 *   更新开始播放按钮
 *   @param isSelected  是否为选中状态
 */
- (void)updateStartPlayBtnStateSelected:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
