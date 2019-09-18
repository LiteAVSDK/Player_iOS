//
//  TXBitrateItem.h
//  TXLiteAVSDK
//
//  Created by annidyfeng on 2017/11/15.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#ifndef TXBitrateItem_h
#define TXBitrateItem_h

/// HLS多码率信息
@interface TXBitrateItem : NSObject
@property (nonatomic, assign) NSInteger index;   ///< m3u8 文件中的序号
@property (nonatomic, assign) NSInteger width;   ///< 此流的视频宽度
@property (nonatomic, assign) NSInteger height;  ///< 此流的视频高度
@property (nonatomic, assign) NSInteger bitrate; ///< 此流的视频码率
@end
#endif /* TXBitrateItem_h */
