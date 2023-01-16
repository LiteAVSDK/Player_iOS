//
//  VideoCacheListCell.m
//  Pods
//
//  Created by 路鹏 on 2022/3/7.
//  Copyright © 2022年 Tencent. All rights reserved.

#import "VideoCacheListCell.h"
#import "VideoCacheListModel.h"
#import "J2Obj.h"
#import "SuperPlayerHelpers.h"
#import "SuperPlayerModel.h"
#import "TXVodDownloadCenter.h"
#import "DownloadCallback.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "TXVodDownloadManager.h"
#import "SuperPlayerModelInternal.h"
#import "AppLocalized.h"

#define BASE_URL   @"http://playvideo.qcloud.com/getplayinfo/v4"

@class TXVodDownloadMediaInfo;

@interface VideoCacheListCell()

@property (nonatomic, strong) UIImageView *videoImageView;

@property (nonatomic, strong) UILabel *durationLabel;

@property (nonatomic, strong) UILabel *videoNameLabel;

@property (nonatomic, strong) UILabel *resolutionLabel;

@property (nonatomic, strong) UILabel *cacheProgressLabel;

@property (nonatomic, strong) UIView *statusView;

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) TXVodDownloadCenter *manager;

@property (nonatomic, strong) DownloadCallback *callback;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) TXVodDownloadMediaInfo *mediaInfo;

@property (nonatomic, strong) NSDictionary *qualityDic;

@end

static NSDictionary *gQualityDic;

@implementation VideoCacheListCell

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gQualityDic = @ {playerLocalize(@"SuperPlayerDemo.MoviePlayer.original") : @(TXVodQualityOD),
                        playerLocalize(@"SuperPlayerDemo.MoviePlayer.smooth") : @(TXVodQualityFLU),
                        playerLocalize(@"SuperPlayerDemo.MoviePlayer.SD") : @(TXVodQualitySD),
                        playerLocalize(@"SuperPlayerDemo.MoviePlayer.HD") : @(TXVodQualityHD),
                        playerLocalize(@"SuperPlayerDemo.MoviePlayer.FHD") : @(TXVodQualityFHD),
                        playerLocalize(@"SuperPlayerDemo.MoviePlayer.2K") : @(TXVodQuality2K),
                        playerLocalize(@"SuperPlayerDemo.MoviePlayer.4K") : @(TXVodQuality4K)};
    });
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.videoImageView];
        [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(16);
            make.width.mas_equalTo(114);
            make.height.mas_equalTo(64);
        }];
        
        [self.videoImageView addSubview:self.durationLabel];
        [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.videoImageView).offset(-5);
            make.bottom.equalTo(self.videoImageView);
            make.height.mas_equalTo(24);
            make.width.mas_equalTo(40);
        }];
        
        [self addSubview:self.videoNameLabel];
        [self.videoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20 + 114 + 10);
            make.top.equalTo(self).offset(10 + 16);
            make.height.mas_equalTo(24);
            make.width.mas_equalTo(140);
        }];
        
        [self addSubview:self.cacheProgressLabel];
        [self.cacheProgressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20 + 114 + 10);
            make.top.equalTo(self).offset(10 + 16 + 24 + 4);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(120);
        }];
        
        [self addSubview:self.resolutionLabel];
        [self.resolutionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20 + 114 + 10 + 140 + 4);
            make.top.equalTo(self).offset(10 + 16 + 3);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(35);
        }];
        
        [self addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self).offset(10 + 16 + 24 + 2);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(20);
        }];
        
        [self addSubview:self.statusView];
        [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-(20 + 60 + 4));
            make.top.equalTo(self).offset(10 + 16 + 24 + 5);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(10);
        }];
        
        self.manager = [TXVodDownloadCenter sharedInstance];
    }
    return self;
}

- (void)setModel:(VideoCacheListModel *)model {
    
    _model = model;
    
    self.mediaInfo = model.mediaInfo;
    
    [self.manager registerListener:self.callback info:self.mediaInfo];
    
    __block TXVodDownloadDataSource *dataSource = self.mediaInfo.dataSource;
    [self updateQuality:dataSource.quality];
    [self updateProgress:self.mediaInfo.progress];
    [self updateCacheState:self.mediaInfo.downloadState];
    
    NSString *key = nil;
    if (dataSource.appId != 0 && dataSource.fileId.length != 0) {
        key = [NSString stringWithFormat:@"%d%@%ld",dataSource.appId,dataSource.fileId,(long)dataSource.quality];
    }

    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (dic.count > 0) {
        model.videoName = [dic objectForKey:@"videoName"];
        model.coverImageStr = [dic objectForKey:@"coverImage"];
        model.durationStr = [dic objectForKey:@"duration"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.coverImageStr.length > 0) {
                [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImageStr] placeholderImage:[UIImage imageNamed:@"img_video_loading"]];
            }
            self.durationLabel.text = model.durationStr;
            self.videoNameLabel.text = model.videoName;
        });
    } else {
        NSInteger duration = model.mediaInfo.duration;
        NSString *durationStr = [NSString stringWithFormat:@"%02ld:%02ld", duration /60, duration % 60];
        model.durationStr = durationStr;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.coverImageStr.length > 0) {
                [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImageStr] placeholderImage:[UIImage imageNamed:@"img_video_loading"]];
            }
            self.durationLabel.text = model.durationStr;
            self.videoNameLabel.text = model.videoName;
        });
    }
    
    __weak typeof(self) weakSelf = self;
    if (dataSource.appId != 0 && dataSource.fileId.length != 0) { // 增加参数判断，减少非必要的请求
        [self getPlayInfo:dataSource.appId fileId:dataSource.fileId psign:dataSource.pSign completion:^(NSMutableDictionary *dic, NSError *error) {
            if (error) {
                NSLog(@"%@",error.userInfo);
            } else {
                NSString *name = [dic objectForKey:@"videoDescription"];
                NSString *videoName = name.length > 0 ? name : [dic objectForKey:@"name"];
                NSString *coverImage = [dic objectForKey:@"coverUrl"];
                NSInteger duration = [[dic objectForKey:@"duration"] integerValue];
                NSString *durationStr = [NSString stringWithFormat:@"%02ld:%02ld", duration /60, duration % 60];
                weakSelf.model.videoName = videoName;
                weakSelf.model.coverImageStr = coverImage;
                weakSelf.model.durationStr = durationStr;
                
                NSDictionary *dic = @{@"videoName" : videoName, @"coverImage" : coverImage, @"duration" : durationStr};
                NSString *keyStr = [NSString stringWithFormat:@"%d%@%ld",dataSource.appId,dataSource.fileId,(long)dataSource.quality];
                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:keyStr];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (coverImage.length > 0) {
                        [weakSelf.videoImageView sd_setImageWithURL:[NSURL URLWithString:coverImage] placeholderImage:[UIImage imageNamed:@"img_video_loading"]];
                    }
                    weakSelf.durationLabel.text = durationStr;
                    weakSelf.videoNameLabel.text = videoName;
                });
            }
        }];
    }
    
    TXVodDownloadMediaInfo *info = [[TXVodDownloadManager shareInstance] getDownloadMediaInfo:self.mediaInfo];
    [self updateQuality:info.dataSource.quality];
    [self updateProgress:info.progress];
    [self updateCacheState:info.downloadState];
}

- (void)startDownload {
    [self updateCacheState:1];
    _model.mediaInfo.downloadState = 1;
    id drmbuilder = [self.mediaInfo valueForKey:@"drmBuilder"];
    if (drmbuilder) {
        [self.manager startDownloadWithDRMBuilder:drmbuilder];
    } else {
        [self.manager startDownload:self.mediaInfo];
    }
}

- (void)stopDownload {
    [self updateCacheState:2];
    _model.mediaInfo.downloadState = 2;
    [self.manager stopDownload:self.mediaInfo];
}

- (SuperPlayerModel *)getSuperPlayModel {
    SuperPlayerModel *playModel = [[SuperPlayerModel alloc] init];
    if (self.mediaInfo.playPath.length > 0 && self.mediaInfo.downloadState == TXVodDownloadMediaInfoStateFinish) {
        SuperPlayerUrl *playerUrl = [[SuperPlayerUrl alloc] init];
        [gQualityDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj integerValue] == self.mediaInfo.dataSource.quality) {
                playerUrl.title = key;
                *stop = YES;
            }
        }];
        playerUrl.url = self.mediaInfo.playPath;
        playModel.multiVideoURLs = @[playerUrl];
    } else { // 仅支持field下载
        SuperPlayerVideoId *videoId = [[SuperPlayerVideoId alloc] init];
        playModel.appId = self.mediaInfo.dataSource.appId;
        videoId.fileId = self.mediaInfo.dataSource.fileId;
        videoId.psign = self.mediaInfo.dataSource.pSign;
        playModel.videoId = videoId;
    }
    
    // 获取overlayKey和overlayIv
    NSString *overlayStr = [[TXVodDownloadManager shareInstance] getOverlayKeyIv:self.mediaInfo.dataSource.appId
                                                 userName:self.mediaInfo.dataSource.userName
                                                   fileId:self.mediaInfo.dataSource.fileId
                                                qualityId:(int)self.mediaInfo.dataSource.quality];
    if (overlayStr.length > 0) {
        NSArray *overlayArray = [overlayStr componentsSeparatedByString:@"_"];
        playModel.overlayKey = overlayArray.firstObject;
        playModel.overlayIv = overlayArray.lastObject;
    }
    
    playModel.customCoverImageUrl = _model.coverImageStr;
    playModel.action = 0;
    playModel.name = _model.videoName;
    playModel.mediaInfo = self.mediaInfo;
        
    return playModel;
}

#pragma mark - Private Method
// 更新清晰度
- (void)updateQuality:(NSInteger)quality {
    __weak __typeof(self) weakSelf = self;
    [gQualityDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj integerValue] == quality) {
            weakSelf.resolutionLabel.text = key;
            *stop = YES;
        }
    }];
}

// 更新缓存状态
- (void)updateCacheState:(NSInteger)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (state) {
            case 0 : {
                self.statusView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:147.0/255.0 blue:33.0/255.0 alpha:1.0];
                self.statusLabel.text = playerLocalize(@"SuperPlayerDemo.MoviePlayer.incache");
            }
                break;
            case 1: {
                self.statusView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:147.0/255.0 blue:33.0/255.0 alpha:1.0];
                self.statusLabel.text = playerLocalize(@"SuperPlayerDemo.MoviePlayer.incache");
            }
                break;
            case 2: {
                self.statusView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:118.0/255.0 blue:87.0/255.0 alpha:1.0];
                self.statusLabel.text = playerLocalize(@"SuperPlayerDemo.MoviePlayer.cachepause");
            }
                break;
            case 3: {
                self.statusView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:118.0/255.0 blue:87.0/255.0 alpha:1.0];
                self.statusLabel.text = playerLocalize(@"SuperPlayerDemo.MoviePlayer.cachepause");
            }
                break;
            case 4: {
                self.statusView.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:201.0/255.0 blue:111.0/255.0 alpha:1.0];
                self.statusLabel.text = playerLocalize(@"SuperPlayerDemo.MoviePlayer.cacheend");
            }
                break;
        }
    });
}

- (void)updateProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.cacheProgressLabel.text = LocalizeReplaceXX(playerLocalize(@"SuperPlayerDemo.MoviePlayer.cacheprogress：xx"),
                                                         [[NSString stringWithFormat:@"%d",(int)(ceil(progress * 100))] stringByAppendingString:@"%"]);
    });
}

#pragma mark - 请求相关
- (void)getPlayInfo:(int)appId fileId:(NSString *)fileId psign:(NSString *)psign
         completion:(void (^)(NSMutableDictionary *dic, NSError *error))completion {
    if (appId == 0 || fileId.length == 0) {
        if (completion) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"parameter error"]};
            NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:userInfo];
            completion(nil, error);
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (psign) {
        params[@"psign"] = psign;
    }
    
    NSString *httpBodyString = [self makeParamtersString:params withEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [NSString stringWithFormat:@"%@/%ld/%@", BASE_URL, (long)appId, fileId];
    if (httpBodyString) {
        urlStr = [urlStr stringByAppendingFormat:@"?%@", httpBodyString];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (completion) {
                completion(nil, error);
            }
        }
        
        if (data.length == 0) {
            if (completion) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"request error", NSLocalizedFailureReasonErrorKey : @"content is nil"};
                NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:userInfo];
                completion(nil, error);
            }
        }
        
        @try {
            NSError *error;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:&error];
            if (dict == nil) {
                if (completion) {
                    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:-2 userInfo:@{NSLocalizedDescriptionKey : @"invalid format"}];
                    completion(nil, error);
                }
            }
            
            if ([dict objectForKey:@"code"]) {
                int code = [[dict objectForKey:@"code"] intValue];
                if (code != 0) {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : dict[@"message"]};
                    NSError *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:code userInfo:userInfo];
                    completion(nil, error);
                }
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            int ver = dict[@"version"] ? J2Num(dict[@"version"]).intValue : 2;
            if (ver == 2) {
                [dic setObject:J2Str([dict valueForKeyPath:@"videoInfo.basicInfo.name"]) forKey:@"name"];
                [dic setObject:J2Str([dict valueForKeyPath:@"coverInfo.coverUrl"]) forKey:@"coverUrl"];
                [dic setObject:J2Str([dict valueForKeyPath:@"videoInfo.sourceVideo.duration"]) forKey:@"duration"];
                [dic setObject:J2Str([dict valueForKeyPath:@"videoInfo.basicInfo.description"]) forKey:@"videoDescription"];
            } else {
                [dic setObject:J2Str([dict valueForKeyPath:@"media.basicInfo.name"]) forKey:@"name"];
                [dic setObject:J2Str([dict valueForKeyPath:@"media.basicInfo.coverUrl"]) forKey:@"coverUrl"];
                [dic setObject:J2Str([dict valueForKeyPath:@"media.basicInfo.duration"]) forKey:@"duration"];
                [dic setObject:J2Str([dict valueForKeyPath:@"media.basicInfo.description"]) forKey:@"videoDescription"];
            }
            
            if (completion) {
                completion(dic, nil);
            }
            
        } @catch (NSException *exception) {
            if (completion) {
                NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                     code:-2
                                                 userInfo:@{NSLocalizedDescriptionKey : @"invalid format"}];
                completion(nil, error);
            }
        }
    }];
    
    [dataTask resume];
}

- (NSString *)makeParamtersString:(NSDictionary *)parameters withEncoding:(NSStringEncoding)encoding {
    if (nil == parameters || [parameters count] == 0) return nil;

    NSMutableString *stringOfParamters = [[NSMutableString alloc] init];
    NSEnumerator *   keyEnumerator     = [parameters keyEnumerator];
    id               key               = nil;
    while ((key = [keyEnumerator nextObject])) {
        [stringOfParamters appendFormat:@"%@=%@&", key, [parameters valueForKey:key]];
    }

    // Delete last character of '&'
    NSRange lastCharRange = {[stringOfParamters length] - 1, 1};
    [stringOfParamters deleteCharactersInRange:lastCharRange];
    return stringOfParamters;
}

#pragma mark - 懒加载
- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.clipsToBounds = YES;
    }
    return _videoImageView;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.font = [UIFont systemFontOfSize:12];
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.textAlignment = NSTextAlignmentRight;
    }
    return _durationLabel;
}

- (UILabel *)videoNameLabel {
    if (!_videoNameLabel) {
        _videoNameLabel = [[UILabel alloc] init];
        _videoNameLabel.font = [UIFont systemFontOfSize:16];
        _videoNameLabel.textColor = [UIColor whiteColor];
        _videoNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _videoNameLabel;
}

- (UILabel *)cacheProgressLabel {
    if (!_cacheProgressLabel) {
        _cacheProgressLabel = [[UILabel alloc] init];
        _cacheProgressLabel.font = [UIFont systemFontOfSize:12];
        _cacheProgressLabel.textColor = [UIColor grayColor];
        _cacheProgressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _cacheProgressLabel;
}

- (UILabel *)resolutionLabel {
    if (!_resolutionLabel) {
        _resolutionLabel = [[UILabel alloc] init];
        _resolutionLabel.backgroundColor = [UIColor grayColor];
        _resolutionLabel.font = [UIFont systemFontOfSize:10];
        _resolutionLabel.textColor = [UIColor whiteColor];
        _resolutionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _resolutionLabel;
}

- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] init];
        _statusView.layer.cornerRadius = 5;
        _statusView.layer.masksToBounds = YES;
    }
    return _statusView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:12];
        _statusLabel.textColor = [UIColor colorWithRed:141.0/255.0 green:147.0/255.0 blue:155.0/255.0 alpha:1.0];
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:defaultConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (DownloadCallback *)callback {
    if (!_callback) {
        _callback = [[DownloadCallback alloc] init];
        __weak typeof(self) weakSelf = self;
        _callback.downloadSuccess = ^(TXVodDownloadMediaInfo * _Nonnull mediaInfo, VodDownloadState state) {
            weakSelf.mediaInfo = mediaInfo;
            [weakSelf updateProgress:mediaInfo.progress];
            [weakSelf updateCacheState:mediaInfo.downloadState];
            weakSelf.model.mediaInfo = mediaInfo;
        };
        
        _callback.downloadError = ^(TXVodDownloadMediaInfo * _Nonnull mediaInfo, NSInteger errCode, NSString * _Nonnull errorMsg) {
            weakSelf.mediaInfo = mediaInfo;
            [weakSelf updateProgress:mediaInfo.progress];
            [weakSelf updateCacheState:mediaInfo.downloadState];
            weakSelf.model.mediaInfo = mediaInfo;
        };
    }
    return _callback;
}

- (void)dealloc {
    [self.manager unRegisterListener:self.mediaInfo];
}

@end
