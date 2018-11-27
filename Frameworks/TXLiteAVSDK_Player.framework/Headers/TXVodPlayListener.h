//
//  TXLiveVodListener.h
//  TXLiteAVSDK
//
//  Created by annidyfeng on 2017/11/14.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#ifndef TXLiveVodListener_h
#define TXLiveVodListener_h
#import <Foundation/Foundation.h>
#import "TXLiveSDKTypeDef.h"
@class TXVodPlayer;

/// 点播通知
@protocol TXVodPlayListener <NSObject>

/**
 * 点播事件通知
 *
 * @param player 点播对象
 * @param EvtID 参见TXLiveSDKTypeDef.h
 * @param param 参见TXLiveSDKTypeDef.h
 * @see TXVodPlayer
 */
-(void) onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary*)param;

/**
 * 网络状态通知
 *
 * @param player 点播对象
 * @param param 参见TXLiveSDKTypeDef.h
 * @see TXVodPlayer
 */
-(void) onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary*)param;

@end
#endif /* TXLiveVodListener_h */
