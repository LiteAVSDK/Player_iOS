//
//  TXWeiboListTableViewCell.h
//  Example
//
//  Created by annidyfeng on 2018/9/25.
//  Copyright © 2018年 annidy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXWeiboListTableViewCell;
@protocol TXWeiboListTableViewCellDelegate

- (void)cellStartPlay:(TXWeiboListTableViewCell*)cell;

@end

@interface TXWeiboListTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, weak)id<TXWeiboListTableViewCellDelegate> cellDelegate;
@property UIImageView *backgroundImageView;
@end
