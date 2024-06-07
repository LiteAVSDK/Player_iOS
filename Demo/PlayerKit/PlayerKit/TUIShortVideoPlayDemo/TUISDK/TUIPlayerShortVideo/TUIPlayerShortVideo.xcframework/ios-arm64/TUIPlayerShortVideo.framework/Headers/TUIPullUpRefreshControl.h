//  Copyright © 2023 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol TUIPullUpRefreshControlDelegate <NSObject>
- (void)beginRefreshing;
- (void)endRefreshing;
- (void)scrollViewDidScrollContentOffsetY:(CGFloat)y;

@end
@interface TUIPullUpRefreshControl : NSObject

@property (nonatomic, weak) id <TUIPullUpRefreshControlDelegate>delegate;
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, assign) CGSize loadingViewSize;
- (void)beginRefreshing;
- (void)endRefreshing;
- (void)addTarget:(nullable id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
