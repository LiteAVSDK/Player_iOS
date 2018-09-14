//
//  TXUGCRecordClipManager.h
//  TXLiteAVSDK
//
//  Created by xiang zhang on 2017/8/25.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
/**********************************************
 **************  视频片段管理   **************
 **********************************************/

/**
 * 视频在每一次stopRecord 和 pauseRecord 的时候都会生成一个视频片段,视频片段保存在 /Documents/TXUGC/TXUGCParts
   文件夹下，您可以在当前文件夹下获取所有本地存储的视频片段
 * 以下SDK接口仅针对当前录制视频的所有片段生效
 * 这里需要特别注意的是，如果您确认不再使用当前录制的视频片段，请调用 deleteAllParts 接口删除所有当前录制的视频片段
   ,如果您想删除本地所有的视频片段，请直接删除 /Documents/TXUGC/TXUGCParts 文件夹下面的视频即可
 */

@interface TXUGCPartsManager : NSObject
/**
 *  获取当前录制视频片段的总时长  单位：s
 */
-(float)getDuration;

/**
 *  获取当前录制所有视频片段路径
 */
-(NSArray *)getVideoPathList;

/**
 *  删除当前录制视频最后一片段,默认删除本地视频文件
 */
-(void)deleteLastPart;

/**
 *  删除当前录制视频指定片段，默认删除本地视频文件
 */
-(void)deletePart:(int)index;

/**
 *  删除当前录制视频所有片段，默认删除本地视频文件
 */
-(void)deleteAllParts;

/**
 *  您可以添加当前录制视频之外的视频，调用合joinAllParts的时候，SDK会把所有的视频合成（这里添加的视频需要和录制视频的分辨率保持一致，否则会合成失败）
 *  videoPath 添加视频的文件路径
 *  index 添加视频的所在整个视频list的位置
 */
-(void)insertPart:(NSString *)videoPath atIndex:(int)index;

/**
 *  合成当前录制视频所有片段（这里需要保证视频片段的分辨率一致，否则会合成失败）
 *  videoPath 合成后视频文件存放地址
 *  result  0:成功  -1：失败
 */
-(void)joinAllParts:(NSString *)videoOutputPath complete:(void(^)(int))result;

@end
