//
//  ListVideoCell.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/1/25.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PlayerKitCommonHeaders.h>
#import "TXMoviePlayInfoResponse.h"

@interface ListVideoUrl : NSObject
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *url;
@end


@interface PlayerSubtitles : NSObject
/// Subtitle address
/// 字幕地址
@property (nonatomic, strong) NSString *subtitlesUrl;
/// subtitle name
/// 字幕名称
@property (nonatomic, strong) NSString *subtitlesName;
/// subtitle type
/// 字幕类型
@property (nonatomic, assign) NSInteger subtitlesType;
@end

@interface ListVideoModel : NSObject
@property(nonatomic, strong) NSString *coverUrl;
@property(nonatomic, strong) NSString *customCoverUrl;
@property(nonatomic, assign) int       duration;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, assign) NSInteger appId;
@property(nonatomic, strong) NSString *fileId;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSArray<ListVideoUrl *> *hdUrl;
@property(nonatomic, assign) int type;  /// 0 - 点播；1 - 直播 & 0 - vod; 1 - live
@property(nonatomic, strong) NSString *psign;
@property(nonatomic, strong) TXPlayerDrmBuilder *drmBuilder;
@property(nonatomic, strong) DynamicWaterModel *dynamicWaterModel;
/// 0 - autoplay; 1 - manual playback 2 - preload
/// 0 - 自动播放；1 - 手动播放  2 - 预加载
@property(nonatomic, assign) int playAction;
/// Whether to enable the caching module
/// 是否启用缓存模块
@property(nonatomic, assign) BOOL isEnableCache;
/// Array of subtitles to be loaded
/// 需要加载的字幕数组
@property(nonatomic, strong) NSMutableArray<PlayerSubtitles *> *subtitlesArray;
- (void)addHdUrl:(NSString *)url withTitle:(NSString *)title;
- (void)setModel:(SuperPlayerModel *)model;
- (SuperPlayerModel *)getPlayerModel;
@end

@interface ListVideoCell : UITableViewCell

- (void)setDataSource:(ListVideoModel *)source;
- (SuperPlayerModel *)getPlayerModel;
- (ListVideoModel *)getSource;
@end
