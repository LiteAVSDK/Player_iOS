//
//  DynamicWaterModel.h
//  Pods
//
//  Created by 路鹏 on 2021/12/9.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// watermark type
/// 水印类型
typedef NS_ENUM(NSInteger, WaterShowType) {
    dynamic,
    ghost,
};
@interface DynamicWaterModel : NSObject
/// font size
/// 字体大小
@property (nonatomic, assign) CGFloat  textFont;
/// dynamic watermark content
/// 动态水印内容
@property (nonatomic, strong) NSString *dynamicWatermarkTip;
/// dynamic watermark content
/// 动态水印内容
@property (nonatomic, strong) UIColor  *textColor;
///video duration
/// 视频时长
@property (nonatomic, assign) int duration;
/// showType
/// 0： dynamic 1: ghost
@property (nonatomic, assign) WaterShowType showType;
@end

NS_ASSUME_NONNULL_END
