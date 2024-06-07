//
//  SuperPlayerTableMenu.h
//  Pods
//
//  Created by 路鹏 on 2022/10/13.
//  Copyright © 2022 Tencent. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"
@interface SuperPlayerTableMenu : UIView
/**
  * This is a menu view whose height is based on the array length <= 1/2 screen height
  * After initializing the object, the view will be displayed in the window immediately, click on the mask to * remove the view and release itself
  * @param title title
  * @param array string input
  * @return menu view
  */
/**
  * 这是一个高度根据数组长度 <=1/2 屏幕高度 的 菜单view
  * 初始化对象之后 会立即在窗口显示该视图，点击蒙版 视图消除释放自身
  * @param title   标题
  * @param array   字符串输入
  * @return      菜单视图
 */
+ (instancetype)title:(NSString *)title array:(NSArray *)array;


typedef void (^SuperPlayerTableMenuBlock)(NSInteger index);

/**
  * The block here will be triggered when the cell in the menu is clicked
  * @param block returns the index of the data source
  */
/**
 * 当点击菜单中的cell时会触发这里的block
 * @param block 返回数据源的索引
 */
- (void)clickCellWithResultblock:(SuperPlayerTableMenuBlock)block;

@end
#pragma clang diagnostic pop
NS_ASSUME_NONNULL_END
