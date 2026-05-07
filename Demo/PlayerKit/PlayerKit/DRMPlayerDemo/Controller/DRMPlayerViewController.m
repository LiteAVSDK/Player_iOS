//  Copyright © 2025 Tencent. All rights reserved.

#import "AppLocalized.h"
#import "AppLogMgr.h"
#import "DRMPlayerControlCollectionCell.h"
#import "DRMPlayerControlModel.h"
#import "DRMPlayerLandscapeController.h"
#import "DRMPlayerSlider.h"
#import "DRMPlayerViewController.h"
#import "PlayerKitCommonHeaders.h"
#import "TXAppInstance.h"
#import "TXBitrateView.h"
#import "UIView+Layout.h"

#define BUNDLE_IMAGE(name) [[TXAppInstance class] imageFromPlayerBundleNamed:name]

static NSString * const gDRMControlCellIdentifier = @"gDRMControlCellIdentifier";
const static CGFloat gDRMHorizontalMargin = 12.0;
const static CGFloat gDRMVerticalMargin = 12.0;
const static CGFloat gDRMConfigButtonSize = 40.0;
const static CGFloat gDRMControlItemSize = 40.0;
const static CGFloat gDRMControlItemLineSpacing = 6.0;
const static CGFloat gDRMSliderHeight = 30.0;
const static CGFloat gDRMMinimumRate = 0.5;
const static CGFloat gDRMMaximumRate = 3.0;
const static CGFloat gDRMStatusViewHeight = 65;
const static CGFloat gDRMLoadingSize = 34;

typedef NS_ENUM(NSUInteger, DRMPlayerControlType) {
    DRMPlayerControlTypePlay = 0,   // resume/pause
    DRMPlayerControlTypeStop,       // stop
    DRMPlayerControlTypeLog,        // log switch
    DRMPlayerControlTypeMute,       // player mute
    DRMPlayerControlTypeHardware,   // Hard decoding
    DRMPlayerControlTypeOrientation,// Orientation
    DRMPlayerControlTypeRenderMode, // Render Mode
    DRMPlayerControlTypeCache,      // cache video
};


@interface DRMPlayerViewController () <UICollectionViewDelegate, UICollectionViewDataSource, TXVodPlayListener, TXBitrateViewDelegate>
// background color
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
// video source textview
@property (nonatomic, strong) UITextView *videoSourceView;
// switch video button
@property (nonatomic, strong) UIButton *configButton;
// Progress Bar
@property (nonatomic, strong) DRMPlayerSlider *progressSlider;
// rate Bar
@property (nonatomic, strong) DRMPlayerSlider *rateSlider;
// bottom control bar
@property (nonatomic, strong) UICollectionView *controlBar;
// player status textview
@property (nonatomic, strong) UITextView *statusView;
// player log textview
@property (nonatomic, strong) UITextView *logView;
// clarity View
@property (nonatomic, strong) TXBitrateView *bitrateView;
// player container
@property (nonatomic, strong) UIView *videoContainer;
// viewModel list
@property (nonatomic, copy) NSArray<DRMPlayerControlViewModel *> *viewModelList;
// player
@property (nonatomic, strong) TXVodPlayer *player;
// player info model
@property (nonatomic, strong) DRMPlayerControlModel *controlModel;

@property (nonatomic, strong) UIImageView *loadingView;

@end

@implementation DRMPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBackgroundTheme];
    self.title = V2Localize(@"MLVB.MainMenu.DRMPlayer");
    self.controlModel = [[DRMPlayerControlModel alloc] init];
    self.videoContainer = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.videoContainer];
    [self.view addSubview:self.statusView];
    [self.view addSubview:self.logView];
    [self.view addSubview:self.videoSourceView];
    [self.view addSubview:self.configButton];
    [self.view addSubview:self.progressSlider];
    [self.view addSubview:self.rateSlider];
    [self.view addSubview:self.controlBar];
    [self.view addSubview:self.bitrateView];
    [self.view addSubview:self.loadingView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.gradientLayer.frame = self.view.bounds;
    self.videoContainer.frame = self.view.bounds;
    // Top kit
    self.configButton.size = CGSizeMake(gDRMConfigButtonSize, gDRMConfigButtonSize);
    self.configButton.top = self.view.safeAreaInsets.top;
    self.configButton.right = self.view.width - gDRMHorizontalMargin;
    
    self.videoSourceView.top = self.view.safeAreaInsets.top;
    self.videoSourceView.left = gDRMHorizontalMargin;
    self.videoSourceView.width = self.view.width - gDRMHorizontalMargin * 3 - gDRMConfigButtonSize;
    self.videoSourceView.height = gDRMConfigButtonSize;
    // Bottom kit
    self.controlBar.left = gDRMHorizontalMargin;
    self.controlBar.width = self.view.width - 2 * gDRMHorizontalMargin;
    self.controlBar.height = gDRMControlItemSize;
    self.controlBar.bottom = self.view.height - self.view.safeAreaInsets.bottom;
    
    self.progressSlider.size = CGSizeMake(self.view.width - 2 * gDRMHorizontalMargin, gDRMSliderHeight);
    self.progressSlider.left = gDRMHorizontalMargin;
    self.progressSlider.bottom = self.controlBar.top - gDRMVerticalMargin;
    
    self.rateSlider.size = CGSizeMake(self.view.width - 2 * gDRMHorizontalMargin, gDRMSliderHeight);
    self.rateSlider.left = gDRMHorizontalMargin;
    self.rateSlider.bottom = self.progressSlider.top - gDRMVerticalMargin;
    
    self.statusView.origin = CGPointMake(gDRMHorizontalMargin, self.videoSourceView.bottom + gDRMVerticalMargin);
    self.statusView.size = CGSizeMake(self.view.width - 2 * gDRMHorizontalMargin, gDRMStatusViewHeight);
    
    self.logView.origin = CGPointMake(gDRMHorizontalMargin, self.statusView.bottom);
    self.logView.size = CGSizeMake(self.view.width - 2 * gDRMHorizontalMargin , self.view.height - self.logView.top);
    
    self.bitrateView.right = self.view.width;
    self.bitrateView.centerY = self.view.height / 2;
    
    self.loadingView.size = CGSizeMake(gDRMLoadingSize, gDRMLoadingSize);
    self.loadingView.center = CGPointMake(self.view.width / 2.0, self.view.height / 2.0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)dealloc {
    [_player stopPlay];
}

#pragma mark - Action

- (void)didConfigButtonClick {
    [self displayVideoSourceAlert];
}

- (void)didSelectPlayItem {
    [SuperPlayerPIPShared close];
    DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypePlay];
    if (self.controlModel.status == DRMPlayerStatusIdle) {
        [self startAnimating];
        [self loadPlayer];
        return;
    }
    switch (self.controlModel.status) {
        case DRMPlayerStatusPrepared:
        case DRMPlayerStatusPause:
            [self.player resume];
            viewModel.imageName = @"suspend";
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            break;
        case DRMPlayerStatusPlaying:
            [self.player pause];
            self.controlModel.status = DRMPlayerStatusPause;
            viewModel.imageName = @"start";
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            break;
        case DRMPlayerStatusIdle:
        case DRMPlayerStatusError:
        case DRMPlayerStatusPlayEnd:
            viewModel.imageName = @"suspend";
            [self loadPlayer];
            break;
        default:
            break;
    }
}

- (void)didSelectStopItem {
    [self.player stopPlay];
    [self reset];
}

- (void)didSelectLogItem {
    self.controlModel.logSwitch = !self.controlModel.logSwitch;
    if (self.controlModel.logSwitch) {
        self.statusView.hidden = NO;
        self.logView.hidden = NO;
    } else {
        self.statusView.hidden = YES;
        self.logView.hidden = YES;
    }
    DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypeLog];
    viewModel.imageName = self.controlModel.logSwitch ? @"log2" : @"log";
//    [self.player snapshot:^(UIImage *image) {
//        image = nil;
//    }];
}

- (void)didSelectMuteItem {
    self.controlModel.mute = !self.controlModel.isMute;
    DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypeMute];
    viewModel.imageName = self.controlModel.isMute ? @"play_mute" : @"play_sound";
    [self.player setMute:self.controlModel.isMute];
}

- (void)didSelectHardwareItem {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        [self displayToastWithTitle:playerLocalize(@"SuperPlayerDemo.OndemandPlayer.supporthardware") messgae:nil];
        return;
    }
    self.player.enableHWAcceleration = !self.player.enableHWAcceleration;
    self.controlModel.hardware = !self.controlModel.hardware;
    DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypeHardware];;
    viewModel.imageName = self.controlModel.hardware ? @"quick" : @"quick2";
    BOOL isRunning = (self.controlModel.status != DRMPlayerStatusIdle) &&
                     (self.controlModel.status != DRMPlayerStatusError) &&
                     (self.controlModel.status != DRMPlayerStatusPlayEnd);
    [self.player stopPlay];
    if (isRunning) {
        if (self.controlModel.hardware) {
            [self displayToastWithTitle:playerLocalize(@"SuperPlayerDemo.OndemandPlayer.switchharddecode") messgae:@""];
        } else {
            [self displayToastWithTitle:playerLocalize(@"SuperPlayerDemo.OndemandPlayer.switchsoftdecode") messgae:@""];
        }
        [self loadPlayer];
    }
}

- (void)didSelectRotateScreenItem {
    DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypeOrientation];
    if (self.controlModel.screenMode == DRMPlayerScreenModePortrait) {
        self.controlModel.screenMode = DRMPlayerScreenModeLandscape;
        viewModel.imageName = @"portrait";
        [self rotateToLandscape];
    }
}

- (void)didSelectRenderModeItem {
    DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypeRenderMode];
    if (self.controlModel.renderMode == RENDER_MODE_FILL_SCREEN) {
        self.controlModel.renderMode = RENDER_MODE_FILL_EDGE;
        viewModel.imageName = @"fill";
    } else {
        self.controlModel.renderMode = RENDER_MODE_FILL_SCREEN;
        viewModel.imageName = @"adjust";
    }
    [self.player setRenderMode:self.controlModel.renderMode];
}

- (void)didSelectCacheEnableItem {
    self.controlModel.cacheEnable = !self.controlModel.cacheEnable;
    DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypeCache];
    if (self.controlModel.cacheEnable) {
        viewModel.imageName = @"cache";
    } else {
        viewModel.imageName = @"cache2";
    }
}

#pragma mark - Seek

- (void)didReceiveProgressSeekBegin:(UISlider *)slider {
    self.controlModel.seeking = YES;
}

- (void)didReceiveProgressSeekEvent:(UISlider *)slider {
    [self.player resume];
    [self.player seek:slider.value];
    self.controlModel.seeking = NO;
}

- (void)didReceiveProgressDragEvent:(UISlider *)slider {
    NSInteger progress = lroundf(slider.value);
    self.progressSlider.leftLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", progress / 60, progress % 60];
}

#pragma mark - Rate

- (void)didReceiveRateSeekEvent:(UISlider *)slider {
    NSString *title = [NSString stringWithFormat:@"%.2f", [self.class verifyRate:slider.value]];
    [self.rateSlider.rightLabel setText:title];
}

- (void)didReceiveRateSeekEndEvent:(UISlider *)slider {
    [self.player setRate:[self.class verifyRate:slider.value]];
}

- (void)didReceiveRateSeekOutSideEvent:(UISlider *)slider {
    [self.player setRate:[self.class verifyRate:slider.value]];
}

#pragma mark - UICollectionViewDelegate || UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DRMPlayerControlType controlType = indexPath.row;
    switch (controlType) {
        case DRMPlayerControlTypePlay: {
            [self didSelectPlayItem];
        }
            break;
        case DRMPlayerControlTypeStop: {
            [self didSelectStopItem];
        }
            break;
        case DRMPlayerControlTypeLog: {
            [self didSelectLogItem];
        }
            break;
        case DRMPlayerControlTypeMute:
            [self didSelectMuteItem];
            break;
        case DRMPlayerControlTypeHardware:
            [self didSelectHardwareItem];
            break;
        case DRMPlayerControlTypeOrientation:
            [self didSelectRotateScreenItem];
            break;
        case DRMPlayerControlTypeRenderMode:
            [self didSelectRenderModeItem];
            break;
        case DRMPlayerControlTypeCache:
            [self didSelectCacheEnableItem];
            break;
        default:
            break;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModelList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DRMPlayerControlCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gDRMControlCellIdentifier forIndexPath:indexPath];
    //index.row and DRMPlayerControlType correspond
    DRMPlayerControlViewModel *viewModel = self.viewModelList[indexPath.row];
    [cell bindViewModel:viewModel];
    return cell;
}

#pragma mark - Play Control

- (void)play {
    [self.player resume];
}

- (void)pause {
    [self.player pause];
    self.controlModel.status = DRMPlayerStatusPause;
    DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypePlay];
    viewModel.imageName = @"start";
}

- (void)stop {
    [self.player stopPlay];
}

#pragma mark - TXVodPlayListener

- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (EvtID) {
            case PLAY_EVT_VOD_PLAY_PREPARED:
                self.controlModel.status = DRMPlayerStatusPrepared;
                [self stopAnimating];
                break;
            case PLAY_EVT_PLAY_BEGIN: {
                [self didReceivePlayerPlaying];
                NSArray *supportedBitrates = [self.player supportedBitrates];
                self.bitrateView.dataSource = supportedBitrates;
            }
                break;
            case PLAY_EVT_PLAY_PROGRESS:
                [self didReceivePlayerProgressUpdate:param];
                break;
            case PLAY_ERR_NET_DISCONNECT:
            case PLAY_ERR_FILE_NOT_FOUND:
            case PLAY_ERR_HLS_KEY:
            case PLAY_ERR_GET_PLAYINFO_FAIL: {
                self.controlModel.status = DRMPlayerStatusError;
                DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypePlay];
                viewModel.imageName = @"start";
                [self stopAnimating];
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            }
                break;
            case PLAY_EVT_PLAY_END: {
                self.controlModel.status = DRMPlayerStatusPlayEnd;
                DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypePlay];
                viewModel.imageName = @"start";
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            }
                break;
            case VOD_PLAY_EVT_PLAY_LOADING:
                [self startAnimating];
                break;
            case VOD_PLAY_EVT_VOD_LOADING_END:
                [self stopAnimating];
                break;
            default:
                break;
        }
        if (EvtID != PLAY_EVT_PLAY_PROGRESS) {
            [self.controlModel appendLogWithParams:param];
            [self.logView setText:self.controlModel.playerLog];
        }
    });
}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {
    NSDictionary *dict = param;
    dispatch_async(dispatch_get_main_queue(), ^{
        int       netspeed       = [(NSNumber *)[dict valueForKey:NET_STATUS_NET_SPEED] intValue];
        int       vbitrate       = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_BITRATE] intValue];
        int       abitrate       = [(NSNumber *)[dict valueForKey:NET_STATUS_AUDIO_BITRATE] intValue];
        int       cachesize      = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_CACHE] intValue];
        int       dropsize       = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_DROP] intValue];
        int       jitter         = [(NSNumber *)[dict valueForKey:NET_STATUS_NET_JITTER] intValue];
        int       fps            = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_FPS] intValue];
        int       width          = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_WIDTH] intValue];
        int       height         = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_HEIGHT] intValue];
        float     cpu_app_usage  = [(NSNumber *)[dict valueForKey:NET_STATUS_CPU_USAGE] floatValue];
        float     cpu_sys_usage  = [(NSNumber *)[dict valueForKey:NET_STATUS_CPU_USAGE_D] floatValue];
        NSString *serverIP       = [dict valueForKey:NET_STATUS_SERVER_IP];
        int       codecCacheSize = [(NSNumber *)[dict valueForKey:NET_STATUS_AUDIO_CACHE] intValue];
        int       nCodecDropCnt  = [(NSNumber *)[dict valueForKey:NET_STATUS_AUDIO_DROP] intValue];
        int       nCahcedSize    = [(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_CACHE] intValue] / 1000;

        NSString *log =
            [NSString stringWithFormat:@"CPU:%.1f%%|%.1f%%\tRES:%d*%d\tSPD:%dkb/s\nJITT:%d\tFPS:%d\tARA:%dkb/s\nQUE:%d|%d\tDRP:%d|%d\tVRA:%dkb/s\nSVR:%@\t\tCAH:%d kb", cpu_app_usage * 100,
                                       cpu_sys_usage * 100, width, height, netspeed, jitter, fps, abitrate, codecCacheSize, cachesize, nCodecDropCnt, dropsize, vbitrate, serverIP, nCahcedSize];
        [self.statusView setText:log];
        AppDemoLogOnlyFile(@"Current status, VideoBitrate:%d, AudioBitrate:%d, FPS:%d, RES:%d*%d, netspeed:%d", vbitrate, abitrate, fps, width, height, netspeed);
    });
}

- (void)onPlayer:(TXVodPlayer *)player pictureInPictureStateDidChange:(TX_VOD_PLAYER_PIP_STATE)pipState withParam:(NSDictionary *)param {
    DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypePlay];
    switch (pipState) {
        case TX_VOD_PLAYER_PIP_STATE_DID_STOP:
            if (player.isPlaying) {
                viewModel.imageName = @"suspend";
                [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            } else {
                self.controlModel.status = DRMPlayerStatusPause;
                viewModel.imageName = @"start";
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - TXBitrateViewDelegate

- (void)onSelectBitrateIndex {
    [self.player setBitrateIndex:self.bitrateView.selectedIndex];
}

#pragma mark - Rotate Screen

- (void)rotateToLandscape {
    if (self.controlModel.status == DRMPlayerStatusIdle) {
        return;
    }
    DRMPlayerLandscapeController *controller = [[DRMPlayerLandscapeController alloc] initWithNibName:nil bundle:nil];
    controller.widget = self.videoContainer;
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    controller.dismissBlock = ^{
        self.controlModel.screenMode = DRMPlayerScreenModePortrait;
        DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypeOrientation];
        viewModel.imageName = @"landscape";
        [self.view insertSubview:self.videoContainer belowSubview:self.statusView];
    };
    self.view.hidden = YES;
    [self presentViewController:controller animated:NO completion:^{
        self.view.hidden = NO;
    }];
}

#pragma mark - Private

- (BOOL)loadPlayer {
    if (!self.controlModel.videoInfo.videoURL.length) {
        return NO;
    }
    if (!self.controlModel.videoInfo.license.length) {
        return NO;
    }
    if (!self.controlModel.videoInfo.certificate.length) {
        return NO;
    }
    [self.controlModel initPlayerLog];
    [self.logView setText:self.controlModel.playerLog];
    self.bitrateView.videoUrl = self.controlModel.videoInfo.videoURL;
    [self resetPlayer];
    TXPlayerDrmBuilder *builder = [[TXPlayerDrmBuilder alloc] initWithDeviceCertificateUrl:self.controlModel.videoInfo.certificate
                                                                                licenseUrl:self.controlModel.videoInfo.license
                                                                                  videoUrl:self.controlModel.videoInfo.videoURL];
    int result = [self.player startPlayDrm:builder];
    if (result) {
        return NO;
    }
    self.controlModel.status = DRMPlayerStatusLoading;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    return YES;
}

- (void)resetPlayer {
    [self.player setupVideoWidget:self.videoContainer insertIndex:0];
    [self.player setConfig:[self defaultPlayerConfig]];
    [self.player setMute:self.controlModel.isMute];
    [self.player setRate:[self.class verifyRate:self.rateSlider.slider.value]];
    self.player.enableHWAcceleration = self.controlModel.hardware;
    [self.player setRenderMode:self.controlModel.renderMode];
    if (self.controlModel.screenMode == DRMPlayerScreenModePortrait) {
        [self.player setRenderRotation:HOME_ORIENTATION_DOWN];
    } else {
        [self.player setRenderRotation:HOME_ORIENTATION_RIGHT];
    }
    [self.player setRenderMode:self.controlModel.renderMode];
}

- (void)reset {
    [self.progressSlider.slider setValue:1.0];
    self.progressSlider.leftLabel.text = @"00:00";
    self.progressSlider.rightLabel.text = @"00:00";
    [self.rateSlider.slider setValue:1.0];
    self.rateSlider.rightLabel.text = @"1.00";
    self.bitrateView.selectedIndex = 0;
    self.statusView.text = @"";
    self.logView.text = @"";
    self.controlModel.status = DRMPlayerStatusIdle;
    DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypePlay];
    viewModel.imageName =  @"start";
}

- (void)didReceivePlayerProgressUpdate:(NSDictionary *)param {
    if (self.controlModel.isSeeking) {
        return;
    }
    CGFloat duration = [param[EVT_PLAY_DURATION] floatValue];
    NSUInteger progress = lroundf([param[EVT_PLAY_PROGRESS] floatValue]);
    if (self.progressSlider.slider.maximumValue != duration) {
        self.progressSlider.slider.maximumValue = duration;
    }
    self.progressSlider.rightLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (lroundf(duration) / 60), (lroundf(duration) % 60)];
    self.progressSlider.leftLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(progress / 60), (int)(progress % 60)];
    self.progressSlider.slider.value = progress;
}

- (void)didReceivePlayerPlaying {
    self.controlModel.status = DRMPlayerStatusPlaying;
    DRMPlayerControlViewModel *viewModel = self.viewModelList[DRMPlayerControlTypePlay];
    viewModel.imageName = @"suspend";
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)configBackgroundTheme {
    self.view.backgroundColor = [UIColor blackColor];
    NSArray *colors = @[
        (__bridge id)[UIColor colorWithRed:19.0 / 255.0 green:41.0 / 255.0 blue:75.0 / 255.0 alpha:1].CGColor,
        (__bridge id)[UIColor colorWithRed:5.0 / 255.0 green:12.0 / 255.0 blue:23.0 / 255.0 alpha:1].CGColor
    ];
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.colors = colors;
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 1);
    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)displayVideoSourceAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter video info"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"VideoURL";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"LicenseKey";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"CertificateURL";
    }];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
        NSArray<UITextField *> *textFields = alertController.textFields;
        weakSelf.controlModel.videoInfo.videoURL = textFields.firstObject.text;
        weakSelf.controlModel.videoInfo.license = textFields[1].text;
        weakSelf.controlModel.videoInfo.certificate = textFields[2].text;
        weakSelf.videoSourceView.text = weakSelf.controlModel.videoInfo.videoURL;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Helper

+ (CGFloat)verifyRate:(CGFloat)rate {
    if (rate < gDRMMinimumRate) {
        return gDRMMinimumRate;
    }
    if (rate > gDRMMaximumRate) {
        return gDRMMaximumRate;
    }
    return rate;
}

- (void)displayToastWithTitle:(NSString *)title messgae:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (TXVodPlayConfig *)defaultPlayerConfig {
    TXVodPlayConfig *config = [[TXVodPlayConfig alloc] init];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"vodConfig"];
    if (dic == nil) {
        if (self.controlModel.cacheEnable) {
            NSString *cacheFolderPath = [[NSSearchPathForDirectoriesInDomains
                                          (NSDocumentDirectory, NSUserDomainMask, YES)
                                          objectAtIndex:0]
                                         stringByAppendingString:@"/txcache"];
            [TXPlayerGlobalSetting setCacheFolderPath:cacheFolderPath];
        }
        
    } else {
        config.smoothSwitchBitrate = [(NSNumber*)[dic objectForKey:@"accurateSeek"] boolValue];
        config.autoRotate = [(NSNumber*)[dic objectForKey:@"smoothSwitch"] boolValue];
        config.connectRetryCount = [[dic objectForKey:@"connectRetryCount"] intValue];
        config.connectRetryInterval = [[dic objectForKey:@"connectRetryInterval"] intValue];
        config.timeout = [[dic objectForKey:@"timeout"] integerValue];
        config.progressInterval = [[dic objectForKey:@"progressInterval"] integerValue] / 1000;
        if (self.controlModel.cacheEnable) {
            NSString *cacheFolderPath = [[NSSearchPathForDirectoriesInDomains
                                          (NSDocumentDirectory, NSUserDomainMask, YES)
                                          objectAtIndex:0]
                                         stringByAppendingString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"cacheFloderPath"]]];
            [TXPlayerGlobalSetting setCacheFolderPath:cacheFolderPath];
        }
        [TXPlayerGlobalSetting setMaxCacheSize:[[dic objectForKey:@"maxCacheSize"] integerValue]];
        config.maxPreloadSize = [[dic objectForKey:@"maxPreloadSize"] intValue];
        config.maxBufferSize = [[dic objectForKey:@"maxBufferSize"] intValue];
        config.preferredResolution = [[dic objectForKey:@"preferredResolution"] longValue];
    }
    return config;
}

#pragma mark - Loading

- (void)startAnimating {
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
}

- (void)stopAnimating {
    self.loadingView.hidden = YES;
    [self.loadingView stopAnimating];
}

#pragma mark - Initialize

- (UITextView *)videoSourceView {
    if (!_videoSourceView) {
        _videoSourceView = [[UITextView alloc] initWithFrame:CGRectZero];
        _videoSourceView.clipsToBounds = YES;
        _videoSourceView.layer.cornerRadius = 2.0;
        _videoSourceView.font = [UIFont systemFontOfSize:16.0];
        _videoSourceView.textColor = UIColor.whiteColor;
        _videoSourceView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        _videoSourceView.editable = NO;
        _videoSourceView.text = self.controlModel.videoInfo.videoURL;
    }
    return _videoSourceView;
}

- (UIButton *)configButton {
    if (!_configButton) {
        _configButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _configButton.backgroundColor = UIColor.whiteColor;
        [_configButton setImage:[[TXAppInstance class] imageFromPlayerBundleNamed:@"add"] forState:UIControlStateNormal];
        [_configButton addTarget:self action:@selector(didConfigButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _configButton;
}

- (DRMPlayerSlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[DRMPlayerSlider alloc] initWithFrame:CGRectZero];
        _progressSlider.leftLabel.text = @"00:00";
        _progressSlider.rightLabel.text = @"00:00";
        [_progressSlider.slider addTarget:self action:@selector(didReceiveProgressSeekBegin:) forControlEvents:UIControlEventTouchDown];
        [_progressSlider.slider addTarget:self action:@selector(didReceiveProgressSeekEvent:) forControlEvents:UIControlEventValueChanged];
        [_progressSlider.slider addTarget:self action:@selector(didReceiveProgressDragEvent:) forControlEvents:UIControlEventTouchDragInside];
    }
    return _progressSlider;
}

- (DRMPlayerSlider *)rateSlider {
    if (!_rateSlider) {
        _rateSlider = [[DRMPlayerSlider alloc] initWithFrame:CGRectZero];
        _rateSlider.slider.minimumValue = gDRMMinimumRate;
        _rateSlider.slider.maximumValue = gDRMMaximumRate;
        _rateSlider.slider.value = 1.0;
        _rateSlider.leftLabel.text = @"速率";
        _rateSlider.rightLabel.text = @"1.00";
        [_rateSlider.slider addTarget:self action:@selector(didReceiveRateSeekOutSideEvent:) forControlEvents:UIControlEventTouchUpOutside];
        [_rateSlider.slider addTarget:self action:@selector(didReceiveRateSeekEvent:) forControlEvents:UIControlEventValueChanged];
        [_rateSlider.slider addTarget:self action:@selector(didReceiveRateSeekEndEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rateSlider;
}

- (UICollectionView *)controlBar {
    if (!_controlBar) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumLineSpacing = gDRMControlItemLineSpacing;
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.itemSize = CGSizeMake(gDRMControlItemSize, gDRMControlItemSize);
        _controlBar = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _controlBar.backgroundColor = UIColor.clearColor;
        [_controlBar registerClass:DRMPlayerControlCollectionCell.class forCellWithReuseIdentifier:gDRMControlCellIdentifier];
        _controlBar.delegate = self;
        _controlBar.dataSource = self;
    }
    return _controlBar;
}

- (TXVodPlayer *)player {
    if (!_player) {
        _player = [[TXVodPlayer alloc] init];
        _player.vodDelegate = self;
    }
    return _player;
}

- (UITextView *)statusView {
    if (!_statusView) {
        _statusView = [[UITextView alloc] initWithFrame:CGRectZero];
        _statusView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _statusView.textColor = [UIColor greenColor];
        _statusView.editable = NO;
        _statusView.hidden = YES;
        _statusView.textContainerInset = UIEdgeInsetsMake(gDRMVerticalMargin, gDRMHorizontalMargin, 0, gDRMHorizontalMargin);
    }
    return _statusView;
}

- (UITextView *)logView {
    if (!_logView) {
        _logView = [[UITextView alloc] initWithFrame:CGRectZero];
        _logView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _logView.textColor = [UIColor greenColor];
        _logView.editable = NO;
        _logView.hidden = YES;
        _logView.textContainerInset = UIEdgeInsetsMake(0, gDRMHorizontalMargin, gDRMHorizontalMargin, gDRMHorizontalMargin);
    }
    return _logView;
}

- (TXBitrateView *)bitrateView {
    if (!_bitrateView) {
        _bitrateView = [[TXBitrateView alloc] initWithFrame:CGRectZero];
        _bitrateView.delegate = self;
        _bitrateView.hidden = YES;
    }
    return _bitrateView;
}

- (UIImageView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _loadingView.contentMode = UIViewContentModeScaleAspectFit;
        _loadingView.backgroundColor = UIColor.clearColor;
        NSMutableArray *images = [NSMutableArray array];
        NSArray *imageName = @[@"loading_image0.png", @"loading_image1.png", @"loading_image2.png",
                               @"loading_image3.png", @"loading_image4.png", @"loading_image5.png",
                               @"loading_image6.png", @"loading_image7.png"];
        for (NSString *image in imageName) {
            if ([[TXAppInstance class] imageFromPlayerBundleNamed:image]) {
                [images addObject:[[TXAppInstance class] imageFromPlayerBundleNamed:image]];
            }
        }
        _loadingView.animationImages = images;
        _loadingView.animationDuration = 1;
        _loadingView.hidden = YES;
    }
    return _loadingView;
}

- (NSArray<DRMPlayerControlViewModel *> *)viewModelList {
    if (!_viewModelList.count) {
        NSMutableArray *array = [NSMutableArray array];
        for (DRMPlayerControlType type = DRMPlayerControlTypePlay; type <= DRMPlayerControlTypeCache; type++) {
            DRMPlayerControlViewModel *viewModel = [[DRMPlayerControlViewModel alloc] init];
            [array addObject:viewModel];
            switch (type) {
                case DRMPlayerControlTypePlay:
                    viewModel.imageName = @"start";
                    break;
                case DRMPlayerControlTypeStop:
                    viewModel.imageName = @"stop";
                    break;
                case DRMPlayerControlTypeLog:
                    viewModel.imageName = self.controlModel.logSwitch ? @"log2" : @"log";
                    break;
                case DRMPlayerControlTypeMute:
                    viewModel.imageName = self.controlModel.isMute ? @"play_mute" : @"play_sound";
                    break;
                case DRMPlayerControlTypeHardware:
                    viewModel.imageName = self.controlModel.hardware ?  @"quick" : @"quick2";
                    break;
                case DRMPlayerControlTypeOrientation:
                    viewModel.imageName = @"landscape";
                    break;
                case DRMPlayerControlTypeRenderMode:
                    viewModel.imageName = self.controlModel.renderMode == RENDER_MODE_FILL_SCREEN ?  @"adjust" : @"fill";
                    break;
                case DRMPlayerControlTypeCache:
                    viewModel.imageName = self.controlModel.cacheEnable ?  @"cache" : @"cache2";
                    break;
                default:
                    break;
            }
        }
        _viewModelList = array.copy;
    }
    return _viewModelList;
}

@end
