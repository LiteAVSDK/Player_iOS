#ifndef SuperPlayerControlViewDelegate_h
#define SuperPlayerControlViewDelegate_h

@class SuperPlayerUrl;
@class SuperPlayerControlView;
@class TXTrackInfo;

@protocol SuperPlayerControlViewDelegate <NSObject>
/** Back button event */
/** 返回按钮事件 */
- (void)controlViewBack:(UIView *)controlView;
/** play */
/** 播放 */
- (void)controlViewPlay:(UIView *)controlView;
/** pause */
/** 暂停 */
- (void)controlViewPause:(UIView *)controlView;
/** Play the next one */
/** 播放下一个 */
- (void)controlViewNextClick:(UIView *)controlView;
/** Player full screen */
/** 播放器全屏 */
- (void)controlViewChangeScreen:(UIView *)controlView
                 withFullScreen:(BOOL)isFullScreen
                   successBlock:(void(^)(void))successBlock
                   failuerBlock:(void(^)(void))failuerBlock;

- (void)controlViewDidChangeScreen:(UIView *)controlView;
/** Lock screen orientation */
/** 锁定屏幕方向 */
- (void)controlViewLockScreen:(UIView *)controlView withLock:(BOOL)islock;
/** Picture-in-picture event */
/** 画中画事件 */
- (void)controlViewPip:(UIView *)controlView;
/** Screen capture event */
/** 截屏事件 */
- (void)controlViewSnapshot:(UIView *)controlView;
/** Switch resolution button event */
/** 切换分辨率按钮事件 */
- (void)controlViewSwitch:(UIView *)controlView withDefinition:(NSString *)definition;
/** Switch track button event */
/** 切换音轨按钮事件 */
- (void)controlViewSwitch:(UIView *)controlView withTrackInfo:(TXTrackInfo *)info preTrackInfo:(TXTrackInfo *)preInfo;
/** Toggle subtitle button event */
/** 切换字幕按钮事件 */
- (void)controlViewSwitch:(UIView *)controlView withSubtitlesInfo:(TXTrackInfo *)info preSubtitlesInfo:(TXTrackInfo *)preInfo;
/** Set subtitle style button event */
/** 设置字幕样式按钮事件 */
- (void)onSettingViewDoneClickWithDic:(NSMutableDictionary *)dic;
/** Change setting */
/** 修改配置 */
- (void)controlViewConfigUpdate:(SuperPlayerControlView *)controlView withReload:(BOOL)reload;
/** Replay */
/** 重新播放 */
- (void)controlViewReload:(UIView *)controlView;
/** seek event, pos 0~1 */
/** seek事件，pos 0~1 */
- (void)controlViewSeek:(UIView *)controlView where:(CGFloat)pos;
/** Slide preview, pos 0~1 */
/** 滑动预览，pos 0~1 */
- (void)controlViewPreview:(UIView *)controlView where:(CGFloat)pos;
/** Call the close button to close tipView */
/** 调用关闭按钮，关闭tipView */
- (void)onCloseClick;
/** Call back button */
/** 调用返回按钮 */
- (void)onBackClick;
/** Call the VIP button */
/** 调用开通VIP按钮 */
- (void)onOpenVIPClick;
/** Call the retry button */
/** 调用重试按钮 */
- (void)onRepeatClick;
/** Display VipView */
/** 显示VipView */
- (void)showVipView;
/** Fast forward/rewind button */
/** 快进/快退按钮*/
- (void)onLongPressAction:(UILongPressGestureRecognizer *)gesture;

@end

#endif /* SuperPlayerControlViewDelegate_h */
