//
//  TXVideoModel.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/19.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXVideoModel : NSObject

@property (nonatomic, strong)   NSString  *name;
@property (nonatomic, strong)   NSString  *videourl;
@property (nonatomic, strong)   NSString  *width;
@property (nonatomic, strong)   NSString  *height;
@property (nonatomic, strong)   NSString  *duration;
@property (nonatomic, strong)   NSString  *requestId;
@property (nonatomic, strong)   NSString  *coverUrl;
@property (nonatomic, assign)   NSInteger bitrateIndex;

@end

NS_ASSUME_NONNULL_END
