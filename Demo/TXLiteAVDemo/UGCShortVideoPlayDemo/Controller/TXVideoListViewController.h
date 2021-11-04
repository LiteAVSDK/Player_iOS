//
//  TXVideoListViewController.h
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/18.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SelectedItemBlock)(NSInteger index);

@interface TXVideoListViewController : UIViewController

@property (nonatomic, copy)   SelectedItemBlock selectedItemBlock;

@property (nonatomic, strong) NSArray *listArray;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
