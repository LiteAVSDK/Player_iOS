//
//  UGCUploadList.h
//  TXLiteAVDemo
//
//  Created by cui on 2019/12/27.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ListVideoCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCUploadList : NSObject
- (void)fetchList:(void (^)(ListVideoModel *model))whenGotOneModel completion:(void (^)(int result, NSString *message))completion;
@end

NS_ASSUME_NONNULL_END
