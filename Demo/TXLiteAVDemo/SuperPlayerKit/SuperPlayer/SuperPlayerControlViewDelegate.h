#ifndef SuperPlayerControlViewDelegate_h
#define SuperPlayerControlViewDelegate_h

@class SuperPlayerUrl;
@class SuperPlayerControlView;
@class TXTrackInfo;

@protocol SuperPlayerControlViewDelegate <NSObject>

/** 返回按钮事件 */
- (void)controlViewBack:(UIView *)controlView;
/** 播放 */
- (void)controlViewPlay:(UIView *)controlView;
/** 暂停 */
- (void)controlViewPause:(UIView *)controlView;
/** 播放下一个 */
- (void)controlViewNextClick:(UIView *)controlView;
/** 播放器全屏 */
- (void)controlViewChangeScreen:(UIView *)controlView
                 withFullScreen:(BOOL)isFullScreen
                   successBlock:(void(^)(void))successBlock
                   failuerBlock:(void(^)(void))failuerBlock;

- (void)controlViewDidChangeScreen:(UIView *)controlView;
/** 锁定屏幕方向 */
- (void)controlViewLockScreen:(UIView *)controlView withLock:(BOOL)islock;
/** 画中画事件 */
- (void)controlViewPip:(UIView *)controlView;
/** 截屏事件 */
- (void)controlViewSnapshot:(UIView *)controlView;
/** 切换分辨率按钮事件 */
- (void)controlViewSwitch:(UIView *)controlView withDefinition:(NSString *)definition;
/** 切换音轨按钮事件 */
- (void)controlViewSwitch:(UIView *)controlView withTrackInfo:(TXTrackInfo *)info preTrackInfo:(TXTrackInfo *)preInfo;
/** 切换字幕按钮事件 */
- (void)controlViewSwitch:(UIView *)controlView withSubtitlesInfo:(TXTrackInfo *)info preSubtitlesInfo:(TXTrackInfo *)preInfo;
/** 设置字幕样式按钮事件 */
- (void)onSettingViewDoneClickWithDic:(NSMutableDictionary *)dic;
/** 修改配置 */
- (void)controlViewConfigUpdate:(SuperPlayerControlView *)controlView withReload:(BOOL)reload;
/** 重新播放 */
- (void)controlViewReload:(UIView *)controlView;
/** seek事件，pos 0~1 */
- (void)controlViewSeek:(UIView *)controlView where:(CGFloat)pos;
/** 滑动预览，pos 0~1 */
- (void)controlViewPreview:(UIView *)controlView where:(CGFloat)pos;
/** 调用关闭按钮，关闭tipView */
- (void)onCloseClick;
/** 调用返回按钮 */
- (void)onBackClick;
/** 调用开通VIP按钮 */
- (void)onOpenVIPClick;
/** 调用重试按钮 */
- (void)onRepeatClick;
/** 显示VipView */
- (void)showVipView;
/** 快进/快退按钮*/
- (void)onLongPressAction:(UILongPressGestureRecognizer *)gesture;

@end

#endif /* SuperPlayerControlViewDelegate_h */
