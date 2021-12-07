//
//  TXCollectionLayout.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/29.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXCollectionLayout.h"

/**  列数*/
static const CGFloat columCount = 2;
/**  每一列间距*/
static const CGFloat columMargin = 10;
/**  每一行间距*/
static const CGFloat rowMargin = 10;
/**  边缘间距*/
static const UIEdgeInsets defaultEdgeInsets = {10,10,10,10};

@interface TXCollectionLayout()

/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeight;

/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation TXCollectionLayout

- (NSInteger)columCount{
    
    if ([self.delegate respondsToSelector:@selector(cloumnCountInCollectionLayout:)]) {
        return  [self.delegate cloumnCountInCollectionLayout:self];
    }
    else{
        return columCount;
    }
}

- (CGFloat)columMargin
{
    if ([self.delegate respondsToSelector:@selector(columMarginInCollectionLayout:)]) {
        return [self.delegate columMarginInCollectionLayout:self];
    } else {
        return columMargin;
    }
}

- (CGFloat)rowMargin{
    
    if ([self.delegate respondsToSelector:@selector(rowMarginInCollectionLayout:)]) {
        return  [self.delegate rowMarginInCollectionLayout:self];
    }
    else{
        return rowMargin;
    }
}

- (UIEdgeInsets)defaultEdgeInsets{
    
    if ([self.delegate respondsToSelector:@selector(edgeInsetInCollectionLayout:)]) {
        return  [self.delegate edgeInsetInCollectionLayout:self];
    }
    else{
        return defaultEdgeInsets;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)attrsArray {
    if (!_attrsArray) {
        
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeight {
    if (!_columnHeight) {
        
        _columnHeight = [NSMutableArray array];
    }
    return _columnHeight;
}

#pragma mark - 重写prepareLayout, layoutAttributesForItemAtIndexPath, layoutAttributesForElementsInRect, collectionViewContentSize 方法
/**
 * 初始化
 */
- (void)prepareLayout {
    [super prepareLayout];
    //内容的高度
    self.contentHeight = 0;
    
    // 清除之前计算的所有高度
    [self.columnHeight removeAllObjects];
    
    // 设置每一列默认的高度
    for (NSInteger i = 0; i < columCount ; i ++) {
        [self.columnHeight addObject:@(defaultEdgeInsets.top)];
    }
    // 清楚之前所有的布局属性
    [self.attrsArray removeAllObjects];
    
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0] ;
    
    for (int i = 0; i < count; i++) {
        // 创建位置
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0] ;
        
        // 获取indexPath位置上cell对应的布局属性
        UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:indexPath] ;
        
        [self.attrsArray addObject:attrs] ;
    }
}

/**
 * 返回indexPath 位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建布局属性
    UICollectionViewLayoutAttributes * attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    // 设置布局属性的frame
    CGFloat totalWidth = collectionViewW - self.defaultEdgeInsets.left - self.defaultEdgeInsets.right - (self.columCount - 1) * self.columMargin;
    CGFloat cellW = totalWidth / self.columCount ;
    
    CGFloat cellH = [self.delegate collectionLayout:self heightForRowAtIndex:indexPath.item itemWidth:cellW];
    // 找出最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeight[0] doubleValue];
    
    for (int i = 1; i < columCount; i++) {
        
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeight[i] doubleValue];
        //判断是否替换最小的列宽
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    CGFloat cellX = self.defaultEdgeInsets.left + destColumn * (cellW + self.columMargin);
    CGFloat cellY = minColumnHeight;
    if (cellY != self.defaultEdgeInsets.top) {
        cellY += self.rowMargin;
    }
    attrs.frame = CGRectMake(cellX, cellY, cellW, cellH);
    
    // 更新最短那一列的高度
    self.columnHeight[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的高度 - 即最长那一列的高度
    CGFloat maxColumnHeight = [self.columnHeight[destColumn] doubleValue];
    if (self.contentHeight < maxColumnHeight) {
        self.contentHeight = maxColumnHeight;
    }
    
    return attrs;
}

/**
 * 决定cell的排布
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

- (CGSize)collectionViewContentSize
{
    CGFloat maxColumnHeight = [self.columnHeight[0] doubleValue];
    for (int i = 0; i < columCount; i++) {

        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeight[i] doubleValue];

        if (maxColumnHeight < columnHeight) {
            maxColumnHeight = columnHeight;
        }
    }

    return CGSizeMake(0, self.contentHeight + self.defaultEdgeInsets.bottom);
}

@end
