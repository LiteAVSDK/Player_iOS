#ifndef SuperPlayerControlViewDelegate_h
#define SuperPlayerControlViewDelegate_h


@class SuperPlayerUrl;

@protocol SuperPlayerControlViewDelegate <NSObject>

@optional
/** 返回按钮事件 */
- (void)onControlView:(UIView *)controlView backAction:(UIButton *)sender;
/** 关闭按钮事件 */
- (void)onControlView:(UIView *)controlView closeAction:(UIButton *)sender;
/** 播放按钮事件 */
- (void)onControlView:(UIView *)controlView playAction:(UIButton *)sender;
/** 全屏按钮事件 */
- (void)onControlView:(UIView *)controlView fullScreenAction:(UIButton *)sender;
/** 锁定屏幕方向按钮时间 */
- (void)onControlView:(UIView *)controlView lockScreenAction:(UIButton *)sender;
/** 重播按钮事件 */
- (void)onControlView:(UIView *)controlView repeatPlayAction:(UIButton *)sender;
/** 中间播放按钮事件 */
- (void)onControlView:(UIView *)controlView cneterPlayAction:(UIButton *)sender;
/** 加载失败按钮事件 */
- (void)onControlView:(UIView *)controlView failAction:(UIButton *)sender;
/** 网络不好按钮事件 */
- (void)onControlView:(UIView *)controlView badNetAction:(UIButton *)sender;
/** 截屏按钮事件 */
- (void)onControlView:(UIView *)controlView captureAction:(UIButton *)sender;
/** 弹幕按钮事件 */
- (void)onControlView:(UIView *)controlView danmakuAction:(UIButton *)sender;
/** 切换分辨率按钮事件 */
- (void)onControlView:(UIView *)controlView resolutionAction:(SuperPlayerUrl *)model;
/** 修改速度 */
- (void)onControlView:(UIView *)controlView changeSpeed:(CGFloat)value;
/** 修改镜像 */
- (void)onControlView:(UIView *)controlView changeMirror:(BOOL)value;
/** 修改加速 */
- (void)onControlView:(UIView *)controlView changeHWAccelerate:(BOOL)value;
/** slider的点击事件（点击slider控制进度） */
- (void)onControlView:(UIView *)controlView progressSliderTap:(CGFloat)value;
/** slider触摸中 */
- (void)onControlView:(UIView *)controlView progressSliderValueChanged:(UISlider *)slider;
/** slider触摸结束 */
- (void)onControlView:(UIView *)controlView progressSliderTouchEnded:(UISlider *)slider;
/** 返回直播事件 */
- (void)onControlView:(UIView *)controlView backLiveAction:(UIButton *)sender;

@end

#endif /* SuperPlayerControlViewDelegate_h */
