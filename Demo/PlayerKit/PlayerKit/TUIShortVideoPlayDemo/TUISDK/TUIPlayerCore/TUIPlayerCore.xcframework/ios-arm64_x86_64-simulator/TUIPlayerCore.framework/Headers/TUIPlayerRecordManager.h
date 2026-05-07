//  Copyright © 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUIPlayerVodStrategyManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface TUIPlayerRecordManager : NSObject

///视频播放设置策略管理
@property (nonatomic, strong) TUIPlayerVodStrategyManager *strategyManager;

/**
 * 记录视频的播放时长记录
 * @param time 时间
 * @param videoId 视频ID
 * @return BOOL值：YES成功 NO失败
 */
- (BOOL)recordPlayBackTime:(float)time videoId:(NSString *)videoId;

/**
 * 获取视频的播放时长记录
 * @param videoId 视频ID
 * @return 时间
 */
- (float)readPlayBackTimeWithVideoId:(NSString *)videoId;

/**
 * 清空记录
 * @return BOOL值：YES成功 NO失败
 */
- (BOOL)reset;
@end

NS_ASSUME_NONNULL_END
