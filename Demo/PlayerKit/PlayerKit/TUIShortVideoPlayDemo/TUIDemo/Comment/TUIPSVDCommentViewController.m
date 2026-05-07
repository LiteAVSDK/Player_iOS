//
//  TUIPSVDCommentViewController.m
//  TUIPlayerShortVideoDemo
//
//  Created by Mars on 2024/4/15.
//

#import "TUIPSVDCommentViewController.h"
#import "PlayerKitCommonHeaders.h"
#import "UIView+TUIPSVD.h"
#import "TUIPSDCommentView.h"

@interface TUIPSVDCommentViewController ()<TUIPSDCommentViewDelegate>
@property (nonatomic, strong) TUIPSDCommentView *commentView;
@property (nonatomic, strong) UIView *commentCoverView;
@end

@implementation TUIPSVDCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.commentView];
    [self.view addSubview:self.commentCoverView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).offset(0);
    }];
    [self.commentCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.commentView.mas_top);
    }];
    
    [self.view layoutIfNeeded];
    [self.commentView tuipsvd_setCornerRadius:35 forCorner:UIRectCornerTopRight|UIRectCornerTopRight];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view.mas_bottom).offset(-500);
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.commentCoverView.frame;
    if (self.videoLayoutRect.size.width < self.videoLayoutRect.size.height) {
        CGSize playerViewSize = self.playerView.bounds.size;
        CGFloat s = playerViewSize.width / playerViewSize.height;
        frame.size.width = frame.size.height * s;
        frame.origin.x = (self.view.bounds.size.width - frame.size.width) / 2.0;
    }
    self.playerView.frame = frame;
}

- (void)setPlayerView:(UIView *)playerView {
    _playerView = playerView;
    [self.view insertSubview:playerView belowSubview:self.commentCoverView];
    [self.view setNeedsLayout];
}
#pragma mark - layload
- (TUIPSDCommentView *)commentView {
    if (!_commentView) {
        _commentView = [[TUIPSDCommentView alloc] init];
        _commentView.delegate = self;
        
    }
    return _commentView;
}
- (UIView *)commentCoverView {
    if (!_commentCoverView) {
        _commentCoverView = [[UIView alloc] init];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentCoverViewTapped:)];
        _commentCoverView.userInteractionEnabled = YES;
        [_commentCoverView addGestureRecognizer:tapGesture];
    }
    return _commentCoverView;
}

// TUIPSDCommentViewDelegate
- (void)closeAction {
    [UIView animateWithDuration:0.3 animations:^{
        [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view.mas_bottom).offset(0);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(CommentViewControllerDismissed)]) {
                [self.delegate CommentViewControllerDismissed];
            }
        }];
    }];
}
- (void)commentCoverViewTapped:(UITapGestureRecognizer *)gesture {
    [self closeAction];
    
}
@end
