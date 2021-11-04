//
//  TXCollectionLayout.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/29.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TXCollectionLayout;

@protocol TXCollectionLayoutDelegate <NSObject>

@required
/**
决定cell的高度,必须实现方法
@param layout 布局类
@param index 第index个Cell
@param width cell 宽度
@return cell 高度
*/
- (CGFloat)collectionLayout: (TXCollectionLayout *)layout heightForRowAtIndex:(NSInteger)index itemWidth:(CGFloat)width;

@optional
/**
确定有多少列
@param collectionLayout 布局类
@return 列数（默认2列）
*/
- (NSInteger)cloumnCountInCollectionLayout:(TXCollectionLayout *)collectionLayout;

/**
决定cell 的列的距离
@param collectionLayout 布局类
@return 列的距离(默认10)
*/
- (CGFloat)columMarginInCollectionLayout:(TXCollectionLayout *)collectionLayout;

/**
决定cell 的行的距离
@param collectionLayout 布局类
@return 行的距离（默认10）
*/
- (CGFloat)rowMarginInCollectionLayout:(TXCollectionLayout *)collectionLayout;

/**
决定cell 的边缘距
@param collectionLayout 布局类
@return 边距
*/
- (UIEdgeInsets)edgeInsetInCollectionLayout:(TXCollectionLayout *)collectionLayout;

@end

@interface TXCollectionLayout : UICollectionViewFlowLayout

- (CGFloat)rowMargin;
- (CGFloat)columMargin;
- (NSInteger)columCount;
- (UIEdgeInsets)defaultEdgeInsets;

@property (nonatomic,assign) id <TXCollectionLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
