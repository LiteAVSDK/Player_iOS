// Copyright (c) 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUIPlayerDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TUIPlayerLiveModel : TUIPlayerDataModel <NSCopying>
///直播Url
@property (nonatomic, copy) NSString *liveUrl;
///封面图
@property (nonatomic, copy) NSString *coverPictureUrl;

@end

NS_ASSUME_NONNULL_END
