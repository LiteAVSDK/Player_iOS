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
#import "TXBasePlayerMacro.h"
#import "TXConfigTableMenu.h"
#import <Masonry/Masonry.h>

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

@property (nonatomic, strong)TXConfigBlockButton  *saveBtn;
@property (nonatomic, strong)TXConfigBlockButton  *resetBtn;

@end

@implementation TXConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigUI];
    [self setConfigAndFreshUI];
}

#pragma mark - Private Method

- (void)initConfigUI {
    self.title = @"播放器配置";
    
    // 添加scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*1.5)];
    [self.view addSubview:self.scrollView];
    
    UILabel *labConfig = [self labWithTitle:@"播放器配置"];
    [self.scrollView addSubview:labConfig];
    [labConfig mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(TX_BasePlayer_Config_Cell_Height);
    }];
    
    self.accurateSeekTxtBox = [TXConfigCheckBox boxWithTitle:@"是否使用精准seek"];
    [self.scrollView addSubview:self.accurateSeekTxtBox];
    [self.accurateSeekTxtBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(labConfig.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(TX_BasePlayer_Config_Btn_Height);
        make.width.mas_equalTo(140);
    }];
    
    self.smoothSwitchingBox = [TXConfigCheckBox boxWithTitle:@"平滑切换多码率"];
    [self.scrollView addSubview:self.smoothSwitchingBox];
    [self.smoothSwitchingBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.accurateSeekTxtBox.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(TX_BasePlayer_Config_Btn_Height);
        make.width.mas_equalTo(140);
    }];
    
    self.rotatesAutomaticallyBox = [TXConfigCheckBox boxWithTitle:@"视频角度自动旋转"];
    [self.scrollView addSubview:self.rotatesAutomaticallyBox];
    [self.rotatesAutomaticallyBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.smoothSwitchingBox.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(TX_BasePlayer_Config_Btn_Height);
        make.width.mas_equalTo(140);
    }];
    
    self.autoIndexBox = [TXConfigCheckBox boxWithTitle:@"开启自适应码率"];
    [self.scrollView addSubview:self.autoIndexBox];
    [self.autoIndexBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rotatesAutomaticallyBox.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(TX_BasePlayer_Config_Btn_Height);
        make.width.mas_equalTo(140);
    }];
    
    self.renderProcessBox = [TXConfigCheckBox boxWithTitle:@"开启超分后处理"];
    [self.scrollView addSubview:self.renderProcessBox];
    [self.renderProcessBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.autoIndexBox.mas_bottom).offset(15);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(TX_BasePlayer_Config_Btn_Height);
        make.width.mas_equalTo(140);
    }];
    
    NSString *holder = @"请输入整数";
    self.connectRetryCountTxt = [TXConfigCellText cellWithTitle:@"播放器重连次数" placeholder:holder];
    [self addCellToScroll:self.connectRetryCountTxt preTPText:self.renderProcessBox];
    
    self.connectRetryIntervalTxt = [TXConfigCellText cellWithTitle:@"播放器重连间隔" placeholder:holder];
    [self addCellToScroll:self.connectRetryIntervalTxt preTPText:self.connectRetryCountTxt];
    
    self.timeoutTxt = [TXConfigCellText cellWithTitle:@"播放器链接超时时间" placeholder:holder];
    [self addCellToScroll:self.timeoutTxt preTPText:self.connectRetryIntervalTxt];
    
    self.progressIntervalTxt = [TXConfigCellText cellWithTitle:@"播放器进度回调间隔" placeholder:holder];
    [self addCellToScroll:self.progressIntervalTxt preTPText:self.timeoutTxt];
    
    self.cacheFloderPathTxt = [TXConfigCellText cellWithTitle:@"设置播放引擎的cache目录" placeholder:@"请输入cache目录"];
    [self addCellToScroll:self.cacheFloderPathTxt preTPText:self.progressIntervalTxt];
    
    self.maxCacheSizeTxt = [TXConfigCellText cellWithTitle:@"播放引擎cache目录的最大缓存(MB)" placeholder:holder];
    [self addCellToScroll:self.maxCacheSizeTxt preTPText:self.cacheFloderPathTxt];
    
    self.maxPreloadSizeTxt = [TXConfigCellText cellWithTitle:@"预加载最大缓存(MB)" placeholder:holder];
    [self addCellToScroll:self.maxPreloadSizeTxt preTPText:self.maxCacheSizeTxt];
    
    self.maxBufferSizeTxt = [TXConfigCellText cellWithTitle:@"最大播放缓冲大小(MB)" placeholder:holder];
    [self addCellToScroll:self.maxBufferSizeTxt preTPText:self.maxPreloadSizeTxt];
    
    self.preferredResolutionTxt = [TXConfigCellText cellWithTitle:@"启播偏好分辨率(width*height)" placeholder:@"请输入宽*高"];
    [self addCellToScroll:self.preferredResolutionTxt preTPText:self.maxBufferSizeTxt];
    
    self.mediaTypeBtn = [TXConfigBlockButton tagWithTitle:@"   播放媒资类型：           (默认)"];
    self.mediaTypeBtn.backgroundColor = [UIColor lightGrayColor];
    [self addCellToScroll:self.mediaTypeBtn preTPText:self.preferredResolutionTxt];
    
    self.decodeStrategyBtn = [TXConfigBlockButton tagWithTitle:@"   视频解码策略               (默认)"];
    self.decodeStrategyBtn.backgroundColor = [UIColor lightGrayColor];
    [self addCellToScroll:self.decodeStrategyBtn preTPText:self.mediaTypeBtn];
    
    self.saveBtn = [TXConfigBlockButton btnWithTitle:@"保存"];
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.saveBtn.backgroundColor = TX_RGBA(59, 144, 177, 1);
    [self.scrollView addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.decodeStrategyBtn.mas_bottom).offset(40);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    
    self.resetBtn = [TXConfigBlockButton btnWithTitle:@"重置"];
    [self.resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.resetBtn.backgroundColor = TX_RGBA(59, 144, 177, 1);
    [self.scrollView addSubview:self.resetBtn];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.decodeStrategyBtn.mas_bottom).offset(40);
        make.left.mas_equalTo(self.saveBtn.mas_right).offset(30);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    
    __weak __typeof(self) weakSelf = self;
    
    [self.mediaTypeBtn clickButtonWithResultBlock:^{//播放器类型
        NSArray *arr = [weakSelf mediaTypeArray];
        TXConfigTableMenu *menu = [TXConfigTableMenu title:@"选中播放器类型" array:arr];
        [menu clickCellWithResultblock:^(NSInteger index) {
            weakSelf.mediaType = index + 1;//+1是为了和枚举的Type对应
            [weakSelf.mediaTypeBtn setTitle:[NSString stringWithFormat:@"%@%@",[weakSelf stringMediaType], arr[index]] forState:UIControlStateNormal];
        }];
    }];
    
    [self.decodeStrategyBtn clickButtonWithResultBlock:^{
        NSArray *arr = [weakSelf decodeStrategyArray];
        TXConfigTableMenu *menu = [TXConfigTableMenu title:@"选中视频解码策略" array:arr];
        [menu clickCellWithResultblock:^(NSInteger index) {
            weakSelf.decodeStrategy = index + 1;
            [weakSelf.decodeStrategyBtn setTitle:[NSString stringWithFormat:@"%@%@",[weakSelf stringDecodeStrategy], arr[index]] forState:UIControlStateNormal];
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
    return @[@"自研播放媒资(默认)", @"点播媒资", @"直播媒资"];
}

- (NSArray *)decodeStrategyArray {
    return @[@"优先硬解(默认)",@"优先软码"];
}

- (NSString *)stringMediaType {
    return @"   播放媒资类型：           ";
}

- (NSString *)stringDecodeStrategy{
    return @"   视频解码策略           ";
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
    [self.decodeStrategyBtn setTitle:[NSString stringWithFormat:@"%@%@",[self stringDecodeStrategy], decodeStrategyArray[self.decodeStrategy]] forState:UIControlStateNormal];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:mDic forKey:@"vodConfig"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
