#ifndef TXUGCRecordListener_H
#define TXUGCRecordListener_H

#import "TXUGCRecordTypeDef.h"

/// 短视频录制回调定义
@protocol TXUGCRecordListener <NSObject>

/**
 * 短视频录制进度
 * @param milliSecond 以毫秒为单位的播放的时间
 */
@optional
-(void) onRecordProgress:(NSInteger)milliSecond;

/**
 * 短视频录制完成
 * @param result 返回码及错误原因
 * @see TXUGCRecordResult
 */
@optional
-(void) onRecordComplete:(TXUGCRecordResult*)result;

/**
 * 短视频录制事件通知(暂未使用)
 * @param evt 时间字典
 */
@optional
-(void) onRecordEvent:(NSDictionary*)evt;

@end

#endif
