//
//  TXBitrateView.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2017/11/15.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlayerKitCommonHeaders.h"

@protocol TXBitrateViewDelegate <NSObject>
- (void)onSelectBitrateIndex;
@end

@interface TXBitrateView : UIView
@property (nonatomic, copy)   NSArray<TXBitrateItem *>  *dataSource;
@property (nonatomic, weak)   id<TXBitrateViewDelegate> delegate;
@property (nonatomic, assign) NSInteger                 selectedIndex;
@property (nonatomic, strong) NSString                  *videoUrl;
@end
