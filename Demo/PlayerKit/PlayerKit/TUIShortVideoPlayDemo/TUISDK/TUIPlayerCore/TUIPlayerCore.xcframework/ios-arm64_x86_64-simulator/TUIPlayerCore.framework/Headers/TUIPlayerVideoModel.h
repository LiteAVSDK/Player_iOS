// Copyright (c) 2023 Tencent. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TUIPlayerVideoConfig.h"
#import "TUIPlayerVideoPreloadState.h"

typedef NS_ENUM(NSInteger, TUI_ITEM_VIEW_TYPE) {

    /// 视频
    /// VOD
    TUI_ITEM_VIEW_TYPE_VOD = 0,

    /// 直播（暂不支持）
    /// Live
    TUI_ITEM_VIEW_TYPE_LIVE = 1,

    /// 自定义类型
    /// custom
    TUI_ITEM_VIEW_TYPE_CUSTOM = 2,

};
NS_ASSUME_NONNULL_BEGIN

///视频数据模型
@interface TUIPlayerVideoModel : NSObject<NSCopying>

/*** 基础信息 */
@property (nonatomic, copy) NSString *videoUrl;        /// 视频Url地址
@property (nonatomic, copy) NSString *coverPictureUrl; /// 封面图
@property (nonatomic, copy) NSString *duration;         /// 视频时长
@property (nonatomic, assign) int appId;                /// appid
@property (nonatomic, copy) NSString *fileId;           /// 视频的fileId
@property (nonatomic, copy) NSString *pSign;           /// 签名字串
@property (nonatomic, strong) id extInfo;              /// 外部信息
@property (nonatomic, assign) TUI_ITEM_VIEW_TYPE viewType; /// 显示类型,默认视频播放

/*** 预下载状态 */
@property (nonatomic, assign, readonly) TUIPlayerVideoPreloadState preloadState;///预下载状态
@property (nonatomic, strong, readonly) NSMutableDictionary *preloadStateMap;///预加载状态（按分辨率）

/*** 配置信息 */
@property (nonatomic, strong) TUIPlayerVideoConfig *config; ///配置
@property (nonatomic, copy) void (^ onExtInfoChangedBlock) (id extInfo);///extInfo信息改变block回调
/**
 * 视频模型描述
 * @return 返回字符串描述信息
 */
- (NSString *)info ;

/**
 * 通知extInfo数据发生改变
 */
- (void)extInfoChangeNotify;
@end

NS_ASSUME_NONNULL_END
