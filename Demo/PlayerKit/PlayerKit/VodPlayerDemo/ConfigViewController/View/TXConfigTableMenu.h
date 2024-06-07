//
//  TXConfigTableMenu.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TXConfigTableMenu : UIView

/**
 这是一个高度根据数组长度 <=1/2 屏幕高度 的 菜单view
 初始化对象之后 会立即在窗口显示该视图，点击蒙版 视图消除释放自身

 @param title   标题
 @param array   字符串输入
 @return      菜单视图
 */
+ (instancetype)title:(NSString *)title array:(NSArray *)array;


typedef void (^TableMenuBlock)(NSInteger index);


/**
 当点击菜单中的cell时会触发这里的block

 @param block 返回数据源的索引
 */
- (void)clickCellWithResultblock:(TableMenuBlock)block;

@end

NS_ASSUME_NONNULL_END
