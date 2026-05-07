// Copyright (c) 2024 Tencent. All rights reserved.
//

#import "TUIMediaDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TUIMediaDataManagerDelegate <NSObject>

///type 1 insert 2 delete 3 reload
- (void)reloadDataWithType:(TUIMeidaDataActionType)type
                indexPaths:(NSArray<NSIndexPath *>*)indexPaths
               targetIndex:(NSInteger )targetIndex
            isCurrentModel:(BOOL)isCurrentModel
                 animation:(BOOL) animation;

@end
@interface TUIMediaDataManager (Private)

@property (nonatomic, weak) id <TUIMediaDataManagerDelegate>dateDelegate;



///
- (void)setShortVideoModels:(NSArray<TUIPlayerDataModel *> *)models;
- (void)appendShortVideoModels:(NSArray<TUIPlayerDataModel *> *)models;
- (void)removeAllObjects;
- (NSInteger)count;
- (TUIPlayerDataModel *)index:(NSInteger)index;
- (NSInteger)indexOfModel:(TUIPlayerDataModel *)model;
- (NSMutableArray *)videoModels;

- (void)setCurrentPlayingModel:(TUIPlayerDataModel *)currentPlayingModel;
- (TUIPlayerDataModel *)currentPlayingModel;
- (NSInteger)currentPlayingIndex;

@end

NS_ASSUME_NONNULL_END
