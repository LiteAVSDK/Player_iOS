//
//  SuperPlayerSubSettingView.h
//  Pods
//
//  Created by 路鹏 on 2022/10/13.
//  Copyright © 2022 Tencent. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SuperPlayerSubSettingViewDelegate <NSObject>

- (void)onSettingViewBackClick;

- (void)onSettingViewDoneClickWithDic:(NSMutableDictionary *)dic;

@end

@interface SuperPlayerSubSettingView : UIView

@property (nonatomic, weak) id<SuperPlayerSubSettingViewDelegate> delegate;
@property (nonatomic, strong, readonly) NSDictionary *subtitlesConfig; ///  字幕配置
- (void)initSubtitlesSettingView;

@end

NS_ASSUME_NONNULL_END
