//
//  TUIPSControlLiveView.m
//  TUIPlayerShortVideoDemo
//
//  Created by hefeima on 2024/1/18.
//

#import "TUIPSControlLiveView.h"
#import "PlayerKitCommonHeaders.h"
#import "UIView+TUIPSVD.h"
#import "TUIPSDLiveRoomViewController.h"
@interface TUIPSControlLiveView () <TUIPSDLiveRoomViewControllerDelegate,TUITXLivePlayerDelegate>
@property (nonatomic, weak) TUITXLivePlayer *livePlayer;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIButton *liveTipLabel;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, weak) UIView *videoWidget;
@property (nonatomic, assign) CGRect videoLayoutRect;
@end
@implementation TUIPSControlLiveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.enterButton];
        [self addSubview:self.nameLabel];
        [self addSubview:self.desLabel];
        [self addSubview:self.liveTipLabel];
        [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).offset(-200);
        }];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-5);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.bottom.equalTo(self.desLabel.mas_top).offset(-5);
        }];
        [self.liveTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel.mas_left);
            make.bottom.equalTo(self.nameLabel.mas_top).offset(-2);
            make.height.equalTo(@(22));
            make.width.equalTo(@(50));
        }];
    }
    return self;
}

@synthesize delegate = _delegate;


- (void)reloadControlData {
    NSLog(@"");
}

-(void)setModel:(TUIPlayerLiveModel *)model {
    _model = model;
    
    NSDictionary *dic = model.extInfo;
    NSString *adTitile = [dic objectForKey:@"liveTitile"];
    NSString *adDes = [dic objectForKey:@"liveDes"];
    NSString *name = [dic objectForKey:@"name"];
    
    self.nameLabel.text = name;
    self.desLabel.text = adTitile;
}

#pragma mark - lazyload
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.font = [UIFont systemFontOfSize:14];
    }
    return _desLabel;
}
- (UIButton *)liveTipLabel {
    if (!_liveTipLabel) {
        _liveTipLabel = [[UIButton alloc] init];
        _liveTipLabel.titleLabel.font = [UIFont systemFontOfSize:12];
        _liveTipLabel.backgroundColor = [UIColor redColor];
        [_liveTipLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_liveTipLabel setTitle:@"直播中" forState:UIControlStateNormal];
        _liveTipLabel.layer.cornerRadius = 5;
        _liveTipLabel.layer.borderWidth = 0.5;
    }
    return _liveTipLabel;
}
- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [[UIButton alloc] init];
        _enterButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_enterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_enterButton setTitle:@"Click to enter the live room" forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _enterButton.layer.cornerRadius = 14;
        _enterButton.layer.borderWidth = 0.5;
        _enterButton.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return _enterButton;
}

- (void)enterButtonClick:(UIButton *)button {
    
    TUIPSDLiveRoomViewController *vc = [[TUIPSDLiveRoomViewController alloc] init];
    vc.playerView = self.videoWidget;
    vc.videoLayoutRect = self.videoLayoutRect;
    vc.livePlayer = self.livePlayer;
    vc.delegate = self;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UIViewController *currentVC = [self tuipsvd_viewController];
    currentVC.definesPresentationContext = YES;
    [currentVC presentViewController:vc animated:NO completion:^{}];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(customCallbackEvent:)]) {
        [self.delegate customCallbackEvent:@"EnteredLivePage:YES"];
    }
}

#pragma mark - TUIPSDLiveRoomViewControllerDelegate
- (void)viewControllerDismissed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(resetVideoWeigetContainer)]) {
        [self.delegate resetVideoWeigetContainer];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(customCallbackEvent:)]) {
        [self.delegate customCallbackEvent:@"EnteredLivePage:NO"];
    }
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

#pragma mark - V2TXLivePlayerObserver
- (void)onVideoResolutionChanged:(TUITXLivePlayer *)player width:(NSInteger)width height:(NSInteger)height {
    NSLog(@"");
}
#pragma mark - TUIPlayerShortVideoLiveControl
- (void)getPlayer:(TUITXLivePlayer *)player {
    self.livePlayer = player;
    [player addObserver:self];
}
- (void)getVideoWidget:(UIView *)view {
    self.videoWidget = view;
}

- (void)getVideoLayerRect:(CGRect)rect { 
    self.videoLayoutRect = rect;
}



@end
