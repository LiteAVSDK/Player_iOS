#ifndef SuperPlayerControlViewDelegate_h
#define SuperPlayerControlViewDelegate_h


@class SuperPlayerUrl;
@class SuperPlayerControlView;

@protocol SuperPlayerControlViewDelegate <NSObject>

@optional
/** 返回按钮事件 */
- (void)controlViewBack:(UIView *)controlView;
/** 播放 */
- (void)controlViewPlay:(UIView *)controlView;
/** 暂停 */
- (void)controlViewPause:(UIView *)controlView;
/** 播放器全屏 */
- (void)controlViewChangeScreen:(UIView *)controlView withFullScreen:(BOOL)isFullScreen;
- (void)controlViewDidChangeScreen:(UIView *)controlView;
/** 锁定屏幕方向 */
- (void)controlViewLockScreen:(UIView *)controlView withLock:(BOOL)islock;
/** 截屏事件 */
- (void)controlViewSnapshot:(UIView *)controlView;
/** 切换分辨率按钮事件 */
- (void)controlViewSwitch:(UIView *)controlView withDefinition:(NSString *)definition;
/** 修改配置 */
- (void)controlViewConfigUpdate:(SuperPlayerControlView *)controlView withReload:(BOOL)reload;
/** 重新播放 */
- (void)controlViewReload:(UIView *)controlView;
/** seek事件，pos 0~1 */
- (void)controlViewSeek:(UIView *)controlView where:(CGFloat)pos;
/** 滑动预览，pos 0~1 */
- (void)controlViewPreview:(UIView *)controlView where:(CGFloat)pos;

/** 清屏 */
- (void)controlViewPreview:(UIView *)controlView clearScreen:(BOOL)isClear;
/** 调节水印层透明度 */
- (void)controlViewPreview:(UIView *)controlView waterMarkAlpha:(CGFloat)alpha;

@end


#endif /* SuperPlayerControlViewDelegate_h */
