//
//  PlayerKit.h
//  PlayerKit
//
// PlayerKitCommonHeaders
#if __has_include(<SuperPlayerKit/SuperPlayer.h>)
#import <SuperPlayerKit/J2Obj.h>
#import <SuperPlayerKit/SuperPlayerHelpers.h>
#import <SuperPlayerKit/SuperPlayerModelInternal.h>
#import <SuperPlayerKit/SuperPlayerModel.h>
#import <SuperPlayerKit/SuperPlayerUrl.h>
#import <SuperPlayerKit/SuperPlayerView.h>
#import <SuperPlayerKit/SuperPlayer.h>
#import <SuperPlayerKit/UIView+MMLayout.h>
#import <SuperPlayerKit/DynamicWaterModel.h>
#import <SuperPlayerKit/SuperPlayerSmallWindowManager.h>
#import <SuperPlayerKit/SuperPlayerPIPManager.h>
#else
#import <SuperPlayer/J2Obj.h>
#import <SuperPlayer/SuperPlayerHelpers.h>
#import <SuperPlayer/SuperPlayerModelInternal.h>
#import <SuperPlayer/SuperPlayerModel.h>
#import <SuperPlayer/SuperPlayerUrl.h>
#import <SuperPlayer/SuperPlayerView.h>
#import <SuperPlayer/SuperPlayer.h>
#import <SuperPlayer/UIView+MMLayout.h>
#import <SuperPlayer/DynamicWaterModel.h>
#import <SuperPlayer/SuperPlayerSmallWindowManager.h>
#import <SuperPlayer/SuperPlayerPIPManager.h>
#endif

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

#if __has_include(<SDWebImage/SDWebImage.h>)
#import <SDWebImage/SDWebImage.h>
#else
#import "SDWebImage.h"
#endif


