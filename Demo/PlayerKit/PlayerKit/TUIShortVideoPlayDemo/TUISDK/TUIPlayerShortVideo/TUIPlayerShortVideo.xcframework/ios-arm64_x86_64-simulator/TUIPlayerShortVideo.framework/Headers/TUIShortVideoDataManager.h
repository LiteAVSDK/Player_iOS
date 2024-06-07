// Copyright (c) 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TUIPlayerVideoModel;
NS_ASSUME_NONNULL_BEGIN

@interface TUIShortVideoDataManager : NSObject
/**
 * 移除数据
 * @param index 索引
 */
- (void)removeData:(NSInteger )index;

/**
 * 移除数据
 * @param range 范围
 */
- (void)removeRangeData:(NSRange )range;

/**
 * 移除数据
 * @param indexArray 索引数组
 */
- (void)removeDataByIndex:(NSArray <NSNumber*> *)indexArray;

/**
 * 添加数据
 * @param model 数据模型
 * @param index 索引
 */
- (void)addData:(TUIPlayerVideoModel *)model
          index:(NSInteger )index;

/**
 * 添加数据
 * @param array 数据模型数组
 * @param index 开始位置索引
 */
- (void)addRangeData:(NSArray<TUIPlayerVideoModel *>*)array
          startIndex:(NSInteger )index;

/**
 * 替换数据
 * @param model 替换数据
 * @param index 索引
 */
- (void)replaceData:(TUIPlayerVideoModel *)model
              index:(NSInteger )index;

/**
 * 替换数据
 * @param array 数据数组
 * @param index 索引
 */
- (void)replaceRangeData:(NSArray<TUIPlayerVideoModel *>*)array
              startIndex:(NSInteger )index;

/**
 * 读取数据
 * @param index 索引
 * @return 数据模型
 */
- (TUIPlayerVideoModel *)getDataByPageIndex:(NSInteger )index;

/**
 * 读取数据总数
 * @return 数据总数
 */
- (NSInteger)getCurrentDataCount;

/**
 * 读取当前页面数据索引
 * @return 数据索引
 */
- (NSInteger)getCurrentIndex;

/**
 * 读取当前页面数据模型
 * @return 数据模型
 */
- (TUIPlayerVideoModel *)getCurrentModel;

@end

NS_ASSUME_NONNULL_END
