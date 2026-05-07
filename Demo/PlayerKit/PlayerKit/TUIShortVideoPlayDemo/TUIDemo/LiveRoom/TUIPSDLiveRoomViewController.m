//  Copyright (c) 2024 Tencent. All rights reserved.
//

#import "TUIPSDFullScreenViewController.h"
#import "TUIPSDLiveRoomControlView.h"
#import "TUIPSDLiveRoomViewController.h"
#import "TUIPSVDCommentViewController.h"

@interface TUIPSDLiveRoomViewController ()<TUIPSDLiveRoomControlViewDelegate,
TUIPSDFullScreenViewControllerDelegate,
TUIPSVDCommentViewControllerDelegate>

@property (nonatomic, strong) TUIPSDLiveRoomControlView *controlView;

@end

@implementation TUIPSDLiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.controlView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:self.playerView belowSubview:self.controlView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.controlView.frame = self.view.bounds;
    self.playerView.frame = self.view.bounds;
}

- (void)setPlayerView:(UIView *)playerView {
    _playerView = playerView;
}

- (void)resetPlayerView {
    [self.view insertSubview:self.playerView belowSubview:self.controlView];
    [self.view setNeedsLayout];
}

#pragma mark - TUIPSDLiveRoomControlViewDelegate

- (void)closeAction {
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewControllerDismissed)]) {
            [self.delegate viewControllerDismissed];
        }
    }];
}
- (void)fullScreenButtonAction {
    TUIPSDFullScreenViewController *vc = [[TUIPSDFullScreenViewController alloc] init];
    vc.playerView = self.playerView;
    vc.delegate = self;
    vc.type = 2;
    vc.livePlayer = self.livePlayer;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.controlView.hidden = YES;
    [self presentViewController:vc animated:NO completion:^{
        
    }];
}
-(void)commentAction {
    TUIPSVDCommentViewController *vc = [[TUIPSVDCommentViewController alloc] init];
    vc.videoLayoutRect = self.videoLayoutRect;
    vc.playerView = self.playerView;
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.controlView.hidden = YES;
    [self presentViewController:vc animated:NO completion:^{
        
    }];
}
#pragma mark - TUIPSDFullScreenViewControllerDelegate
- (void)viewControllerDismissed {
    [self resetPlayerView];
    self.controlView.hidden = NO;
}

- (void)resume {
    if ([self.delegate respondsToSelector:@selector(resume)]) {
        [self.delegate resume];
    }
}

- (void)pause {
    if ([self.delegate respondsToSelector:@selector(pause)]) {
        [self.delegate pause];
    }
}

#pragma mark - TUIPSVDCommentViewControllerDelegate
- (void)CommentViewControllerDismissed {
    [self resetPlayerView];
    self.controlView.hidden = NO;
}
#pragma mark - lazyload
- (TUIPSDLiveRoomControlView *)controlView {
    if (!_controlView) {
        _controlView = [[TUIPSDLiveRoomControlView alloc] init];
        _controlView.delegate = self;
    }
    return _controlView;
}

@end
