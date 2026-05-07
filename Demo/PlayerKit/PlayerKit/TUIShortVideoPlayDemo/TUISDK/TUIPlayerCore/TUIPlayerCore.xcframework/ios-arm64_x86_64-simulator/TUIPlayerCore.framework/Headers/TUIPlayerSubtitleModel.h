// Copyright (c) 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUIPlyerCoreSDKTypeDef.h"
NS_ASSUME_NONNULL_BEGIN

@interface TUIPlayerSubtitleModel : NSObject <NSCopying>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) TUI_VOD_PLAYER_SUBTITLE_MIME_TYPE mimeType;
@end

NS_ASSUME_NONNULL_END
