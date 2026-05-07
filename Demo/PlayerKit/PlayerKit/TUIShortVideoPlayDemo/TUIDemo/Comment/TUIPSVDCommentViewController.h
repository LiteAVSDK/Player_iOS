//
//  TUIPSVDCommentViewController.h
//  TUIPlayerShortVideoDemo
//
//  Created by Mars on 2024/4/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TUIPSVDCommentViewControllerDelegate <NSObject>

- (void)CommentViewControllerDismissed;

@end
@interface TUIPSVDCommentViewController : UIViewController
@property (nonatomic, weak) id<TUIPSVDCommentViewControllerDelegate> delegate;
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, assign) CGRect videoLayoutRect;
@end

NS_ASSUME_NONNULL_END
