//  Copyright © 2024 Tencent. All rights reserved.

#import "TRTCVODViewController.h"
#import <mach/mach.h>

@interface TRTCVODViewController () <TXVodPlayListener>

@end

@implementation TRTCVODViewController {
    UIView *     mVideoContainer;
    NSString *   _playUrl;

    NSObject * _trtcCloud;
    UIButton * _startBtn;
    UIButton * _publishVideoBtn;
    UIButton * _publishAudioBtn;
    BOOL _isPlaying;
    BOOL _publishingVideo;
    BOOL _publishingAudio;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.title = @"TRTC-VodPlayer";
    for (UIView *view in [self.view subviews]) {
        [view removeFromSuperview];
    }
    CGSize size = [[UIScreen mainScreen] bounds].size;
    int icon_size = 40;

    self.txtRtmpUrl = [[UITextField alloc] initWithFrame:CGRectMake(10, 110, 500, 50)];
    [self.txtRtmpUrl setBorderStyle:UITextBorderStyleRoundedRect];
    self.txtRtmpUrl.text                   = @"http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/48d0f1f9387702299774251236/adp.10.m3u8";
    self.txtRtmpUrl.alpha                  = 0.5;
    self.txtRtmpUrl.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:self.txtRtmpUrl];

    _txVodPlayer = [[TXVodPlayer alloc] init];
    CGRect videoFrame = self.view.bounds;
    mVideoContainer   = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 CGRectGetMaxY(self.txtRtmpUrl.frame),
                                                                 videoFrame.size.width,
                                                                 videoFrame.size.height/2)];
    [self.view insertSubview:mVideoContainer atIndex:0];
    mVideoContainer.center = self.view.center;

    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startBtn setTitle:@"StatPlay" forState:UIControlStateNormal];
    [_startBtn addTarget:self action:@selector(clcikStart) forControlEvents:UIControlEventTouchUpInside];
        
    _publishVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishVideoBtn setTitle:@"PublishVideo" forState:UIControlStateNormal];
    [_publishVideoBtn addTarget:self action:@selector(clickPublishVideo) forControlEvents:UIControlEventTouchUpInside];

    _publishAudioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishAudioBtn setTitle:@"PublishAudio" forState:UIControlStateNormal];
    [_publishAudioBtn addTarget:self action:@selector(clickPublishAudio) forControlEvents:UIControlEventTouchUpInside];


    CGFloat buttonWidth = 120;
    CGFloat buttonHeight = 50;
    CGFloat spacing = 3;
    CGFloat totalWidth = buttonWidth * 3 + spacing * 2;
    CGFloat startX = (self.view.bounds.size.width - totalWidth) / 2;
    CGFloat startY = CGRectGetMaxY(mVideoContainer.frame) + 5;

    _startBtn.frame = CGRectMake(startX, startY, buttonWidth, buttonHeight);
    _publishVideoBtn.frame = CGRectMake(startX + buttonWidth + spacing, startY, buttonWidth, buttonHeight);
    _publishAudioBtn.frame = CGRectMake(startX + 2 * (buttonWidth + spacing), startY, buttonWidth, buttonHeight);

    [self.view addSubview:_startBtn];
    [self.view addSubview:_publishVideoBtn];
    [self.view addSubview:_publishAudioBtn];
}

- (void)clickPublishVideo {
    if (_publishingVideo) {
        [_txVodPlayer unpublishVideo];
        _publishingVideo = NO;
        [self toastTip:@"unpublishVideo"];
    } else {
        [_txVodPlayer publishVideo];
        _publishingVideo = YES;
        [self toastTip:@"publishVideo"];
    }
}

- (void)clickPublishAudio {
    if (_publishingAudio) {
        [_txVodPlayer unpublishAudio];
        _publishingAudio = NO;
        [self toastTip:@"unpublishAudio"];
    } else {
        [_txVodPlayer publishAudio];
        _publishingAudio = YES;
        [self toastTip:@"publishAudio"];
    }
}

- (void)clcikStart {
    if (_isPlaying) {
        [_txVodPlayer pause];
        _isPlaying = NO;
        [self toastTip:@"Pause"];
    } else {
        [_txVodPlayer resume];
        _isPlaying = YES;
        [self toastTip:@"Start"];
    }
}

- (void)attachTRTCCloud:(NSObject *)trtcCloud {
    _trtcCloud = trtcCloud;
    if (_txVodPlayer) {
        if (trtcCloud) {
            [_txVodPlayer attachTRTC:trtcCloud];
            [self startPlay];
        } else {
            [_txVodPlayer detachTRTC];
        }
    }
}

- (void)setEnablePublish:(BOOL)enablePublish {
    _enablePublish = enablePublish;
    if (enablePublish && _txVodPlayer) {
        [_txVodPlayer publishVideo];
        [_txVodPlayer publishAudio];
        _publishingAudio = YES;
        _publishingVideo = YES;
    } else {
        [_txVodPlayer unpublishVideo];
        [_txVodPlayer unpublishAudio];
        _publishingAudio = NO;
        _publishingVideo = NO;
    }
}


- (void)dealloc {
}

- (BOOL)startPlay {
    NSString *playUrl = self.txtRtmpUrl.text;
    if (_txVodPlayer != nil) {
        _txVodPlayer.vodDelegate = self;
        [_txVodPlayer setupVideoWidget:self->mVideoContainer insertIndex:0];
        [self setVodConfig];
        [_txVodPlayer setRenderMode:RENDER_MODE_FILL_EDGE];
        int result  = [_txVodPlayer startVodPlay:playUrl];
        if (result != 0) {
            return NO;
        }
    }
    _playUrl = playUrl;
    _isPlaying = YES;
    return YES;
}

- (void)setVodConfig {
    if (_config == nil) {
        _config = [[TXVodPlayConfig alloc] init];
    }
    [_txVodPlayer setLoop:YES];
    [_txVodPlayer setConfig:_config];
}

- (void)stopPlay {
    _playUrl = @"";
    if (_txVodPlayer != nil) {
        [self setEnablePublish:NO];
        [_txVodPlayer stopPlay];
    }
}

- (float)heightForString:(UITextView *)textView andWidth:(float)width {
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void)toastTip:(NSString *)toastInfo {
    CGRect frameRC   = [[UIScreen mainScreen] bounds];
    frameRC.origin.y = frameRC.size.height - 110;
    frameRC.size.height -= 110;
    __block UITextView *toastView = [[UITextView alloc] init];

    toastView.editable   = NO;
    toastView.selectable = NO;
    frameRC.size.height = [self heightForString:toastView andWidth:frameRC.size.width];
    toastView.frame = frameRC;

    toastView.text            = toastInfo;
    toastView.textColor = [UIColor blackColor];
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.alpha           = 0.5;
    [self.view addSubview:toastView];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^() {
        [toastView removeFromSuperview];
        toastView = nil;
    });
}



- (void)onPlayEvent:(TXVodPlayer *)player event:(int)eventId withParam:(NSDictionary *)param {
    NSDictionary *dict = param;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (eventId == PLAY_EVT_VOD_LOADING_END || eventId == PLAY_EVT_VOD_PLAY_PREPARED) {
        }
        if (eventId == PLAY_EVT_PLAY_BEGIN) {
        } else if (eventId == PLAY_EVT_PLAY_PROGRESS) {
        } else if (eventId == PLAY_ERR_NET_DISCONNECT || eventId == PLAY_EVT_PLAY_END || eventId == PLAY_ERR_FILE_NOT_FOUND) {
        } else if (eventId == PLAY_EVT_PLAY_LOADING) {
        } else if (eventId == PLAY_EVT_CONNECT_SUCC) {
        } else if (eventId == PLAY_EVT_CHANGE_ROTATION) {
            return;
        }
    });
}
@end
