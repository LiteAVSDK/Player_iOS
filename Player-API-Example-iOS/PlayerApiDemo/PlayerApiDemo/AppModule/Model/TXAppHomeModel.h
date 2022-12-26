//
//  TXAppHomeModel.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TXHomeCellModel;

@interface TXAppHomeModel : NSObject

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSMutableArray<TXHomeCellModel *> *homeModels;

@end

NS_ASSUME_NONNULL_END
