// Copyright (c) 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TUIPlayerVideoModel;
@class TUIPlayerLiveModel;
/**
 VOD    ->  0
 Live   ->  1
 custom ->  2
 */
typedef NS_ENUM(NSInteger, TUI_MODEL_TYPE) {

    ///视频
    ///VOD
    TUI_MODEL_TYPE_VOD = 0,

    ///直播
    ///Live
    TUI_MODEL_TYPE_LIVE = 1,

    ///自定义类型
    ///custom
    TUI_MODEL_TYPE_CUSTOM = 2,

};
NS_ASSUME_NONNULL_BEGIN

@interface TUIPlayerDataModel : NSObject<NSCopying>
///模型类型
@property (nonatomic, assign, readonly)TUI_MODEL_TYPE modelType;
///业务数据
@property (nonatomic, strong) id extInfo;
@property (nonatomic, copy) void (^ onExtInfoChangedBlock) (id extInfo);///extInfo信息改变block回调

/**
 * 通知extInfo数据发生改变
 */
- (void)extInfoChangeNotify;
/**
 * 描述
 */
- (NSString *)description;
/**
 * 强转为TUIPlayerVideoModel类型
 * 注意：数据类型必须是真实的TUIPlayerVideoModel类型
 */
- (TUIPlayerVideoModel *)asVodModel;
/**
 * 强转为TUIPlayerLiveModel类型
 * 注意：数据类型必须是真实的TUIPlayerVideoModel类型
 */
- (TUIPlayerLiveModel *)asLiveModel;
@end

NS_ASSUME_NONNULL_END
