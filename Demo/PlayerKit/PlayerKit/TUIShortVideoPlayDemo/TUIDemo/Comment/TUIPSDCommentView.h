//
//  TUIPSDCommentView.h
//  Masonry
//
//  Created by Mars on 2024/4/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TUIPSDCommentViewDelegate <NSObject>

- (void)closeAction;

@end
@interface TUIPSDCommentView : UIView
@property (nonatomic, weak) id <TUIPSDCommentViewDelegate>delegate;
@property (nonatomic, assign) BOOL isShow;
@end

NS_ASSUME_NONNULL_END
