//
//  DynamicWaterModel.h
//  Pods
//
//  Created by 路鹏 on 2021/12/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynamicWaterModel : NSObject

// 字体大小
@property (nonatomic, assign) CGFloat  textFont;

// 动态水印内容
@property (nonatomic, strong) NSString *dynamicWatermarkTip;

// 动态水印内容
@property (nonatomic, strong) UIColor  *textColor;

@end

NS_ASSUME_NONNULL_END
