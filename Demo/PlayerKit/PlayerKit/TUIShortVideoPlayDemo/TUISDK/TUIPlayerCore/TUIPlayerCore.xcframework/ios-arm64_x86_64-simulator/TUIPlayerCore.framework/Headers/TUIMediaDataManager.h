// Copyright (c) 2024 Tencent. All rights reserved.


#import <Foundation/Foundation.h>

@class TUIPlayerDataModel;

///type 1 insert 2 delete 3 reload
typedef NS_ENUM(NSInteger, TUIMeidaDataActionType) {
    ///1
    TUIDataActionTypeInsert = 1,
    ///2
    TUIDataActionTypeDelete = 2,
    ///3
    TUIDataActionTypeReload = 3,
};

NS_ASSUME_NONNULL_BEGIN

// 当videoModels_n数组列表改变时 触发的messageName
FOUNDATION_EXPORT NSString *const MEDIA_MODELS_DATA_CHANGE;


@interface TUIMediaDataManager : NSObject
/**
 * 移除数据
 * @param index 索引
 */
- (BOOL)removeData:(NSInteger )index;

/**
 * 移除数据
 * @param range 范围
 */
- (BOOL)removeRangeData:(NSRange )range;

/**
 * 移除数据
 * @param indexArray 索引数组
 */
- (BOOL)removeDataByIndex:(NSArray <NSNumber*> *)indexArray;

/**
 * 添加数据
 * @param model 数据模型
 * @param index 索引
 */
- (BOOL)addData:(TUIPlayerDataModel *)model
          index:(NSInteger )index;

/**
 * 添加数据
 * @param array 数据模型数组
 * @param index 开始位置索引
 */
- (BOOL)addRangeData:(NSArray<TUIPlayerDataModel *>*)array
          startIndex:(NSInteger )index;

/**
 * 替换数据
 * @param model 替换数据
 * @param index 索引
 */
- (BOOL)replaceData:(TUIPlayerDataModel *)model
              index:(NSInteger )index;

/**
 * 替换数据
 * @param array 数据数组
 * @param index 索引
 */
- (BOOL)replaceRangeData:(NSArray<TUIPlayerDataModel *>*)array
              startIndex:(NSInteger )index;

/**
 * 读取数据
 * @param index 索引
 * @return 数据模型
 */
- (TUIPlayerDataModel *)getDataByPageIndex:(NSInteger )index;

/**
 * 读取数据总数
 * @return 数据总数
 */
- (NSInteger)currentDataCount;

/**
 * 读取当前页面数据索引
 * @return 数据索引
 */
- (NSInteger)currentIndex;

/**
 * 读取当前页面数据模型
 * @return 数据模型
 */
- (TUIPlayerDataModel *)currentModel;

/**
 * 读取上一个页面数据模型
 * @return 数据模型
 */
- (TUIPlayerDataModel *)lastModel;

/**
 * 读取下一个页面数据模型
 * @return 数据模型
 */
- (TUIPlayerDataModel *)nextModel;

@end

NS_ASSUME_NONNULL_END
