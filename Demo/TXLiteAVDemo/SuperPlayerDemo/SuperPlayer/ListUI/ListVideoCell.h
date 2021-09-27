//
//  ListVideoCell.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2018/1/25.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SuperPlayer.h"
#import "TXMoviePlayInfoResponse.h"

@interface ListVideoUrl : NSObject
@property NSString *title;
@property NSString *url;
@end

@interface ListVideoModel : NSObject
@property NSString *coverUrl;
@property int       duration;
@property NSString *title;
@property NSInteger appId;
@property NSString *fileId;
@property NSString *url;
@property NSArray<ListVideoUrl *> *hdUrl;
@property int                      type;  // 0 - 点播；1 - 直播
@property NSString *psign;
- (void)addHdUrl:(NSString *)url withTitle:(NSString *)title;
- (void)setModel:(SuperPlayerModel *)model;
- (SuperPlayerModel *)getPlayerModel;
@end

@interface ListVideoCell : UITableViewCell

- (void)setDataSource:(ListVideoModel *)source;
- (SuperPlayerModel *)getPlayerModel;
- (ListVideoModel *)getSource;
@end
