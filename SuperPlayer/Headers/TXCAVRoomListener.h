//
//  TXCAVRoomListener.h
//  TXLiteAVSDK
//
//  Created by lijie on 2017/7/26.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIkit/UIKit.h>

@protocol TXCAVRoomListener <NSObject>

/**
 * 房间成员变化
 * flag为YES: 表示该userID进入房间
 * flag为NO: 表示该userID退出房间
 */
@optional
- (void)onMemberChange:(UInt64)userID withFlag:(BOOL)flag;

/**
 * 指定userID的视频状态变化通知
 * flag为YES: 表示该userID正在进行视频推流
 * flag为NO: 表示该userID已经停止视频推流
 */
@optional
- (void)onVideoStateChange:(UInt64)userID withFlag:(BOOL)flag;

/**
 * 事件通知
 * 参数：
 *       userID:   用户的唯一标记
 *       eventID:  事件ID，取值为 TXEAVRoomEventID
 *       param:    保存有两个值，param[EVT_TIME]为事件发生时间，param[EVT_MSG]为事件描述
 */
@optional
- (void)onAVRoomEvent:(UInt64)userID withEventID:(int)eventID andParam:(NSDictionary *)param;

/**
 * 状态通知
 * 参数:
 *      array: 保存上行和所有下行的状态值
 *      假设item是数组array中的一个元素, item[NET_STATUS_USER_ID]表示这个item对应的userID
 *      例如：如果item是自己的，则item[NET_STATUS_NET_SPEED]表示上行速率
 *           如果item是对方的，则item[NET_STATUS_NET_SPEED]表示下行速率
 */
@optional
- (void)onAVRoomStatus:(NSArray *)array;

@end
