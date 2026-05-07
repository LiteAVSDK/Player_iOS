//  Copyright © 2024 Tencent. All rights reserved.

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __has_include(<TXLiteAVSDK_Player/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_Player/TXLiteAVSDK.h>
#elif __has_include(<TXLiteAVSDK_Player_Premium/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_Player_Premium/TXLiteAVSDK.h>
#elif __has_include(<TXLiteAVSDK_Professional/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_Professional/TXLiteAVSDK.h>
#elif __has_include(<TXLiteAVSDK_UGC/TXLiteAVSDK.h>)
#import <TXLiteAVSDK_UGC/TXLiteAVSDK.h>
#else
#import "TXLiteAVSDK.h"
#endif

#if __has_include(<ToolkitBase/Masonry.h>)
#import <ToolkitBase/Masonry.h>
#else
#import <Masonry/Masonry.h>
#endif

@interface TRTCVODViewController : UIViewController {
    TXVodPlayer*       _txVodPlayer;
    UITextView*        _statusView;
    TXVodPlayConfig* _config;
}

@property(nonatomic, retain) UITextField* txtRtmpUrl;

@property (nonatomic, assign) BOOL enablePublish;

- (BOOL)startPlay;
- (void)stopPlay;
- (void)attachTRTCCloud:(NSObject *)trtcCloud;
@end
