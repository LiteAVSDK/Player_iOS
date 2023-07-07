//
//  TXCollectionLayout.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/29.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXCollectionLayout.h"

@implementation TXCollectionLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置单元格的大小
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat itemW = (width-30)/2;
        CGFloat itemH = 300;
        self.itemSize = CGSizeMake(itemW, itemH);
        
        // 设置单元格之间的间距
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        
        // 设置集合视图的内边距
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}
@end
