//
//  TXConfigViewController.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXConfigViewController.h"
#import "TXConfigCheckBox.h"
#import "TXConfigBlockButton.h"
#import "TXConfigCellText.h"
#import "TXConfigTableMenu.h"
#import "PlayerKitCommonHeaders.h"
#import "AppLocalized.h"
@interface TXConfigViewController ()

@property (nonatomic, strong)UIScrollView   *scrollView;

// 开关类
@property (nonatomic, strong)TXConfigCheckBox *accurateSeekTxtBox;//是否使用精准seek
@property (nonatomic, strong)TXConfigCheckBox *smoothSwitchingBox;//平滑切换多码率
@property (nonatomic, strong)TXConfigCheckBox *rotatesAutomaticallyBox;//视频角度自动旋转
@property (nonatomic, strong)TXConfigCheckBox *autoIndexBox;//开启自适应码率
@property (nonatomic, strong)TXConfigCheckBox *renderProcessBox;//开启超分后处理

// 填写类
@property (nonatomic, strong)TXConfigCellText *connectRetryCountTxt;//播放器重连次数
@property (nonatomic, strong)TXConfigCellText *connectRetryIntervalTxt;//播放器重连间隔
@property (nonatomic, strong)TXConfigCellText *timeoutTxt;//播放器链接超时时间
@property (nonatomic, strong)TXConfigCellText *progressIntervalTxt;//播放器进度回调间隔
@property (nonatomic, strong)TXConfigCellText *cacheFloderPathTxt;//设置播放引擎的cache目录
@property (nonatomic, strong)TXConfigCellText *maxCacheSizeTxt;//播放引擎cache目录的最大缓存(MB)
@property (nonatomic, strong)TXConfigCellText *maxPreloadSizeTxt;//预加载最大缓存(MB)
@property (nonatomic, strong)TXConfigCellText *maxBufferSizeTxt;//最大播放缓冲大小(MB)
@property (nonatomic, strong)TXConfigCellText *preferredResolutionTxt;//启播偏好分辨率(width*height)

// 下拉多选类
@property (nonatomic, strong)TXConfigBlockButton *mediaTypeBtn;//播放媒资类型->弹出Menu
@property (nonatomic, assign)NSInteger mediaType;//记录播放器类型

@property (nonatomic, strong)TXConfigBlockButton *decodeStrategyBtn;//编码策略->弹出Menu
@property (nonatomic, assign)NSInteger decodeStrategy;//记录编码策略

@property (nonatomic, strong)TXConfigBlockButton *resourcesBtn;//播放资源->弹出Menu
@property (nonatomic, assign)NSInteger resources;//记录播放资源

@property (nonatomic, strong)TXConfigBlockButton  *saveBtn;
@property (nonatomic, strong)TXConfigBlockButton  *resetBtn;

@end

@implementation TXConfigViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // 背景色
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *colors = @[(__bridge id)[UIColor colorWithRed:19.0 / 255.0 green:41.0 / 255.0 blue:75.0 / 255.0 alpha:1].CGColor,
                        (__bridge id)[UIColor colorWithRed:5.0 / 255.0 green:12.0 / 255.0 blue:23.0 / 255.0 alpha:1].CGColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigUI];
    [self setConfigAndFreshUI];
}

#pragma mark - Private Method

- (float)getStatusHeight {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

- (void)initConfigUI {
    self.title = playerLocalize(@"SuperPlayerDemo.Vod.Config.PlayerConfig");
    
    // 添加scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:
                       CGRectMake(0, [self getStatusHeight] + 44,
                                  self.view.bounds.size.width,
                                  self.view.bounds.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*1.5)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    UILabel *labConfig = [self labWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.PlayerConfig")];
    [self.scrollView addSubview:labConfig];
    [labConfig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(35);
    }];
    
    self.accurateSeekTxtBox = [TXConfigCheckBox boxWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.WhetherToUsePreciseSeek")];
    [self.scrollView addSubview:self.accurateSeekTxtBox];
    [self.accurateSeekTxtBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labConfig.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(140);
    }];
    
    self.smoothSwitchingBox = [TXConfigCheckBox
                               boxWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.SmoothSwitchingBetweenMultipleBitrates")];
    [self.scrollView addSubview:self.smoothSwitchingBox];
    [self.smoothSwitchingBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accurateSeekTxtBox.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(140);
    }];
    
    self.rotatesAutomaticallyBox = [TXConfigCheckBox
                                    boxWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.VideoAngleAuto-rotate")];
    [self.scrollView addSubview:self.rotatesAutomaticallyBox];
    [self.rotatesAutomaticallyBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.smoothSwitchingBox.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(140);
    }];
    
    self.autoIndexBox = [TXConfigCheckBox
                         boxWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.EnableAdaptiveBitrate")];
    [self.scrollView addSubview:self.autoIndexBox];
    [self.autoIndexBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rotatesAutomaticallyBox.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(140);
    }];
    
    self.renderProcessBox = [TXConfigCheckBox
                             boxWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.EnableSuperResolutionPostProcessing")];
    [self.scrollView addSubview:self.renderProcessBox];
    [self.renderProcessBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.autoIndexBox.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(140);
    }];
    
    NSString *holder = playerLocalize(@"SuperPlayerDemo.Vod.Config.PleaseEnterAnInteger");
    self.connectRetryCountTxt = [TXConfigCellText cellWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.PlayerReconnectTimes")
                                                    placeholder:holder
                                                       isNumber:YES];
    [self addCellToScroll:self.connectRetryCountTxt preTPText:self.renderProcessBox];
    
    self.connectRetryIntervalTxt = [TXConfigCellText
                                    cellWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.PlayerReconnectionInterval")
                                                       placeholder:holder
                                                          isNumber:YES];
    [self addCellToScroll:self.connectRetryIntervalTxt preTPText:self.connectRetryCountTxt];
    
    self.timeoutTxt = [TXConfigCellText
                       cellWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.PlayerLinkTimeout")
                                          placeholder:holder
                                             isNumber:YES];
    [self addCellToScroll:self.timeoutTxt preTPText:self.connectRetryIntervalTxt];
    
    self.progressIntervalTxt = [TXConfigCellText
                                cellWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.PlayerProgressCallbackInterval")
                                                   placeholder:holder
                                                      isNumber:YES];
    [self addCellToScroll:self.progressIntervalTxt preTPText:self.timeoutTxt];
    
    self.cacheFloderPathTxt = [TXConfigCellText
                               cellWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.SetTheCacheDirectoryOfThePlaybackEngine")
                                                  placeholder:playerLocalize(@"SuperPlayerDemo.Vod.Config.PleaseEnterTheCacheDirectory")
                                                     isNumber:NO];
    [self addCellToScroll:self.cacheFloderPathTxt preTPText:self.progressIntervalTxt];
    
    self.maxCacheSizeTxt = [TXConfigCellText
                            cellWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.MaximumCacheSizeOfThePlaybackEngineCacheDirectory")
                                               placeholder:holder
                                                  isNumber:YES];
    [self addCellToScroll:self.maxCacheSizeTxt preTPText:self.cacheFloderPathTxt];
    
    self.maxPreloadSizeTxt = [TXConfigCellText
                              cellWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.PreloadMaxCache")
                                                 placeholder:holder
                                                    isNumber:YES];
    [self addCellToScroll:self.maxPreloadSizeTxt preTPText:self.maxCacheSizeTxt];
    
    self.maxBufferSizeTxt = [TXConfigCellText
                             cellWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.MaximumPlaybackBufferSize")
                                                placeholder:holder
                                                   isNumber:YES];
    [self addCellToScroll:self.maxBufferSizeTxt preTPText:self.maxPreloadSizeTxt];
    
    self.preferredResolutionTxt = [TXConfigCellText
                                   cellWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.StartBroadcastPreferenceResolution")
                                                      placeholder:playerLocalize(@"SuperPlayerDemo.Vod.Config.PleaseEnterTheProductOfWidthAndHeight")
                                                         isNumber:YES];
    [self addCellToScroll:self.preferredResolutionTxt preTPText:self.maxBufferSizeTxt];
    
    self.mediaTypeBtn = [TXConfigBlockButton tagWithTitle:@"   播放媒资类型：           (默认)"];
    self.mediaTypeBtn.backgroundColor = [UIColor lightGrayColor];
    [self addCellToScroll:self.mediaTypeBtn preTPText:self.preferredResolutionTxt];
    
    self.decodeStrategyBtn = [TXConfigBlockButton tagWithTitle:@"   视频解码策略               (默认)"];
    self.decodeStrategyBtn.backgroundColor = [UIColor lightGrayColor];
    [self addCellToScroll:self.decodeStrategyBtn preTPText:self.mediaTypeBtn];
    
    self.resourcesBtn = [TXConfigBlockButton tagWithTitle:@"   播放资源类型               (默认)"];
    self.resourcesBtn.backgroundColor = [UIColor lightGrayColor];
    [self addCellToScroll:self.resourcesBtn preTPText:self.decodeStrategyBtn];
    
    self.saveBtn = [TXConfigBlockButton btnWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.Save")];
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveBtn.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:144.0/255.0 blue:177.0/255.0 alpha:1];
    [self.scrollView addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resourcesBtn.mas_bottom).offset(40);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    
    self.resetBtn = [TXConfigBlockButton btnWithTitle:playerLocalize(@"SuperPlayerDemo.Vod.Config.Reset")];
    [self.resetBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    self.resetBtn.backgroundColor = [UIColor colorWithRed:59.0/255.0 green:144.0/255.0 blue:177.0/255.0 alpha:1];
    [self.scrollView addSubview:self.resetBtn];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.resourcesBtn.mas_bottom).offset(40);
        make.left.mas_equalTo(self.saveBtn.mas_right).offset(30);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    
    __weak __typeof(self) weakSelf = self;
    
    [self.mediaTypeBtn clickButtonWithResultBlock:^{//播放器类型
        [weakSelf.view endEditing:YES];
        NSArray *arr = [weakSelf mediaTypeArray];
        TXConfigTableMenu *menu = [TXConfigTableMenu title:playerLocalize(@"SuperPlayerDemo.Vod.Config.SelectPlayerType") array:arr];
        [menu clickCellWithResultblock:^(NSInteger index) {
            weakSelf.mediaType = index;
            [weakSelf.mediaTypeBtn setTitle:[NSString stringWithFormat:@"%@%@",[weakSelf stringMediaType], arr[index]] forState:UIControlStateNormal];
        }];
    }];
    
    [self.decodeStrategyBtn clickButtonWithResultBlock:^{
        [weakSelf.view endEditing:YES];
        NSArray *arr = [weakSelf decodeStrategyArray];
        TXConfigTableMenu *menu = [TXConfigTableMenu title:playerLocalize(@"SuperPlayerDemo.Vod.Config.SelectVideoDecodingStrategy") array:arr];
        [menu clickCellWithResultblock:^(NSInteger index) {
            weakSelf.decodeStrategy = index;
            [weakSelf.decodeStrategyBtn setTitle:
             [NSString stringWithFormat:@"%@%@",[weakSelf stringDecodeStrategy], arr[index]]
                                        forState:UIControlStateNormal];
        }];
    }];
    
    [self.resourcesBtn clickButtonWithResultBlock:^{
        [weakSelf.view endEditing:YES];
        NSArray *arr = [weakSelf resourcesArray];
        TXConfigTableMenu *menu = [TXConfigTableMenu title:playerLocalize(@"SuperPlayerDemo.Vod.Config.SelectPayResource") array:arr];
        [menu clickCellWithResultblock:^(NSInteger index) {
            weakSelf.resources = index;
            [weakSelf.resourcesBtn setTitle:[NSString stringWithFormat:@"%@%@",[weakSelf stringResources], arr[index]] forState:UIControlStateNormal];
        }];
    }];
    
    [_saveBtn clickButtonWithResultBlock:^{
        [weakSelf saveConfig];
    }];
    
    [_resetBtn clickButtonWithResultBlock:^{
        [weakSelf resetConfig];
    }];
}

// 生成UILabel
- (UILabel *)labWithTitle:(NSString *)title {
    UILabel *lab = [[UILabel alloc] init];
    lab.text = title;
    lab.textColor = [UIColor blueColor];
    lab.font = [UIFont systemFontOfSize:20];
    return lab;
}

- (void)addCellToScroll:(UIView *)cuView preTPText:(UIView *)preView {
    [self.scrollView addSubview:cuView];
    [cuView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(preView.mas_bottom).offset(5);
       make.left.right.mas_equalTo(self.view);
       make.height.mas_equalTo(35);
    }];
}

- (NSArray *)mediaTypeArray {
    return @[playerLocalize(@"SuperPlayerDemo.Vod.Config.Self-developedPlaybackMediaAssets"),
             playerLocalize(@"SuperPlayerDemo.Vod.Config.VodMediaAssets"),
             playerLocalize(@"SuperPlayerDemo.Vod.Config.LiveMediaAssets")];
}

- (NSArray *)decodeStrategyArray {
    return @[playerLocalize(@"SuperPlayerDemo.Vod.Config.PrioritizeHardSolution"),
             playerLocalize(@"SuperPlayerDemo.Vod.Config.PrioritySoftSolution")];
}

- (NSArray *)resourcesArray {
    return @[playerLocalize(@"SuperPlayerDemo.Vod.Config.HLS"),
             playerLocalize(@"SuperPlayerDemo.Vod.Config.Dash")];
}

- (NSString *)stringMediaType {
    NSString *string = [NSString stringWithFormat:@"   %@:           ",
                        playerLocalize(@"SuperPlayerDemo.Vod.Config.PlayMediaAssetType")];
    return string;
}

- (NSString *)stringDecodeStrategy{
    NSString *string = [NSString stringWithFormat:@"   %@:           ",
                        playerLocalize(@"SuperPlayerDemo.Vod.Config.VideoDecodingStrategy")];
    return string;
}

- (NSString *)stringResources{
    NSString *string = [NSString stringWithFormat:@"   %@:           ",
                        playerLocalize(@"SuperPlayerDemo.Vod.Config.PlayResourceType")];
    return string;
}

- (void)setConfigAndFreshUI {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"vodConfig"];
    if (dic == nil) {
        [self defaultPlayerConfig];
        [self setConfigAndFreshUI];
        return;
    }
    
    self.accurateSeekTxtBox.selected = [(NSNumber*)[dic objectForKey:@"accurateSeek"] boolValue];
    self.smoothSwitchingBox.selected = [(NSNumber*)[dic objectForKey:@"smoothSwitch"] boolValue];
    self.rotatesAutomaticallyBox.selected = [(NSNumber*)[dic objectForKey:@"rotatesAuto"] boolValue];
    self.autoIndexBox.selected = [(NSNumber*)[dic objectForKey:@"autoIndex"] boolValue];
    self.renderProcessBox.selected = [(NSNumber*)[dic objectForKey:@"renderProcess"] boolValue];
    
    self.connectRetryCountTxt.textField.text = [NSString stringWithFormat:@"%ld", (long)[[dic objectForKey:@"connectRetryCount"] integerValue]];
    self.connectRetryIntervalTxt.textField.text = [NSString stringWithFormat:@"%ld", (long)[[dic objectForKey:@"connectRetryInterval"] integerValue]];
    self.timeoutTxt.textField.text = [NSString stringWithFormat:@"%ld", (long)[[dic objectForKey:@"timeout"] integerValue]];
    self.progressIntervalTxt.textField.text = [NSString stringWithFormat:@"%ld", (long)[[dic objectForKey:@"progressInterval"] integerValue]];
    self.cacheFloderPathTxt.textField.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cacheFloderPath"]];
    self.maxCacheSizeTxt.textField.text = [NSString stringWithFormat:@"%ld", (long)[[dic objectForKey:@"maxCacheSize"] integerValue]];
    self.maxPreloadSizeTxt.textField.text = [NSString stringWithFormat:@"%ld", (long)[[dic objectForKey:@"maxPreloadSize"] integerValue]];
    self.maxBufferSizeTxt.textField.text = [NSString stringWithFormat:@"%ld", (long)[[dic objectForKey:@"maxBufferSize"] integerValue]];
    self.preferredResolutionTxt.textField.text = [NSString stringWithFormat:@"%ld",[[dic objectForKey:@"preferredResolution"] longValue]];
    
    self.mediaType = [[dic objectForKey:@"mediaType"] integerValue];
    NSArray *mediaTypeArray = [self mediaTypeArray];
    [self.mediaTypeBtn setTitle:[NSString stringWithFormat:@"%@%@",[self stringMediaType], mediaTypeArray[self.mediaType]] forState:UIControlStateNormal];
    
    self.decodeStrategy = [[dic objectForKey:@"decodeStrategy"] integerValue];
    NSArray *decodeStrategyArray = [self decodeStrategyArray];
    [self.decodeStrategyBtn setTitle:
     [NSString stringWithFormat:@"%@%@",[self stringDecodeStrategy], decodeStrategyArray[self.decodeStrategy]]
                            forState:UIControlStateNormal];
    
    self.resources = [[dic objectForKey:@"resources"] integerValue];
    NSArray *resourcesArray = [self resourcesArray];
    [self.resourcesBtn setTitle:[NSString stringWithFormat:@"%@%@",[self stringResources], resourcesArray[self.resources]] forState:UIControlStateNormal];
}

#pragma mark - 保存配置

- (void)saveConfig {
    BOOL accurateSeek = self.accurateSeekTxtBox.selected;
    BOOL smoothSwitch = self.smoothSwitchingBox.selected;
    BOOL rotatesAuto = self.rotatesAutomaticallyBox.selected;
    BOOL autoIndex = self.autoIndexBox.selected;
    BOOL renderProcess = self.renderProcessBox.selected;
    
    NSInteger connectRetryCount = [self.connectRetryCountTxt.textField.text integerValue];
    NSInteger connectRetryInterval = [self.connectRetryIntervalTxt.textField.text integerValue];
    NSInteger timeout = [self.timeoutTxt.textField.text integerValue];
    NSInteger progressInterval = [self.progressIntervalTxt.textField.text integerValue];
    NSString *cacheFloderPath = self.cacheFloderPathTxt.textField.text;
    NSInteger maxCacheSize = [self.maxCacheSizeTxt.textField.text integerValue];
    NSInteger maxPreloadSize = [self.maxPreloadSizeTxt.textField.text integerValue];
    NSInteger maxBufferSize = [self.maxBufferSizeTxt.textField.text integerValue];
    long preferredResolution = [self.preferredResolutionTxt.textField.text longLongValue];
    
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    [mDic setObject:@(accurateSeek) forKey:@"accurateSeek"];
    [mDic setObject:@(smoothSwitch) forKey:@"smoothSwitch"];
    [mDic setObject:@(rotatesAuto) forKey:@"rotatesAuto"];
    [mDic setObject:@(autoIndex) forKey:@"autoIndex"];
    [mDic setObject:@(renderProcess) forKey:@"renderProcess"];
    
    [mDic setObject:@(connectRetryCount) forKey:@"connectRetryCount"];
    [mDic setObject:@(connectRetryInterval) forKey:@"connectRetryInterval"];
    [mDic setObject:@(timeout) forKey:@"timeout"];
    [mDic setObject:@(progressInterval) forKey:@"progressInterval"];
    [mDic setObject:cacheFloderPath forKey:@"cacheFloderPath"];
    [mDic setObject:@(maxCacheSize) forKey:@"maxCacheSize"];
    [mDic setObject:@(maxPreloadSize) forKey:@"maxPreloadSize"];
    [mDic setObject:@(maxBufferSize) forKey:@"maxBufferSize"];
    [mDic setObject:@(preferredResolution) forKey:@"preferredResolution"];
    
    [mDic setObject:@(self.mediaType) forKey:@"mediaType"];
    [mDic setObject:@(self.decodeStrategy) forKey:@"decodeStrategy"];
    [mDic setObject:@(self.resources) forKey:@"resources"];
    
    // 将字典保存到UD中
    [[NSUserDefaults standardUserDefaults] setObject:mDic forKey:@"vodConfig"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - 重置配置

- (void)resetConfig {
    [self defaultPlayerConfig];
    [self setConfigAndFreshUI];
}

- (void)defaultPlayerConfig {
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    [mDic setObject:@(YES) forKey:@"accurateSeek"];
    [mDic setObject:@(YES) forKey:@"smoothSwitch"];
    [mDic setObject:@(YES) forKey:@"rotatesAuto"];
    [mDic setObject:@(YES) forKey:@"autoIndex"];
    [mDic setObject:@(YES) forKey:@"renderProcess"];
    
    [mDic setObject:@(3) forKey:@"connectRetryCount"];
    [mDic setObject:@(3) forKey:@"connectRetryInterval"];
    [mDic setObject:@(10) forKey:@"timeout"];
    [mDic setObject:@(500) forKey:@"progressInterval"];
    [mDic setObject:@"txCache" forKey:@"cacheFloderPath"];
    [mDic setObject:@(200) forKey:@"maxCacheSize"];
    [mDic setObject:@(50) forKey:@"maxPreloadSize"];
    [mDic setObject:@(50) forKey:@"maxBufferSize"];
    [mDic setObject:@(720 * 1280) forKey:@"preferredResolution"];
    
    [mDic setObject:@(1) forKey:@"mediaType"];
    [mDic setObject:@(0) forKey:@"decodeStrategy"];
    [mDic setObject:@(0) forKey:@"resources"];
    
    [[NSUserDefaults standardUserDefaults] setObject:mDic forKey:@"vodConfig"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
