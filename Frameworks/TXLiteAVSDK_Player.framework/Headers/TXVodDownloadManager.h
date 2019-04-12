//
//  TXVodDownloadManager.h
//  TXLiteAVSDK
//
//  Created by annidyfeng on 2017/12/25.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXPlayerAuthParams.h"

/**
 * 下载视频的清晰度
 */
typedef NS_ENUM(NSInteger, TXVodQuality) {
    ///原画
    TXVodQualityOD = 0,
    ///流畅
    TXVodQualityFLU,
    ///标清
    TXVodQualitySD,
    ///高清
    TXVodQualityHD,
    ///全高清
    TXVodQualityFHD,
    ///2K
    TXVodQuality2K,
    ///4K
    TXVodQuality4K,
};

/**
 * 下载错误码
 */
typedef NS_ENUM(NSInteger, TXDownloadError) {
    /// 下载成功
    TXDownloadSuccess   = 0,
    /// fileid鉴权失败
    TXDownloadAuthFaild = -5001,
    /// 无此清晰度文件
    TXDownloadNoFile    = -5003,
    /// 格式不支持
    TXDownloadFormatError = -5004,
    /// 网络断开
    TXDownloadDisconnet = -5005,
    /// 获取HLS解密key失败
    TXDownloadHlsKeyError = -5006,
    /// 下载目录访问失败
    TXDownloadPathError = -5007,
};

/**
 * 下载源，通过fileid方式下载
 */
@interface TXVodDownloadDataSource : NSObject
/// fileid信息
@property TXPlayerAuthParams *auth;
/// 下载清晰度，默认原画
@property TXVodQuality quality;
/// 如地址有加密，请填写token
@property NSString *token;
/// 清晰度模板。如果后台转码是自定义模板，请在这里填写模板名。templateName和quality同时设置时，以templateName为v准
@property NSString *templateName;
@end

/// 下载文件对象
@interface TXVodDownloadMediaInfo : NSObject
/// fileid下载对象（可选）
@property TXVodDownloadDataSource *dataSource;
/// 下载地址
@property NSString *url;
///时长
@property (nonatomic) int duration;
/// 文件总大小, byte
@property (nonatomic) int size;
/// 已下载大小, byte
@property (nonatomic) int downloadSize;
/// 进度
@property float progress;
/// 播放路径，可传给TXVodPlayer播放
@property NSString *playPath;
/// 下载速度，byte每秒
@property int speed;
@end

/// 下载回调
@protocol TXVodDownloadDelegate <NSObject>
/// 下载开始
- (void)onDownloadStart:(TXVodDownloadMediaInfo *)mediaInfo;
/// 下载进度
- (void)onDownloadProgress:(TXVodDownloadMediaInfo *)mediaInfo;
/// 下载停止
- (void)onDownloadStop:(TXVodDownloadMediaInfo *)mediaInfo;
/// 下载完成
- (void)onDownloadFinish:(TXVodDownloadMediaInfo *)mediaInfo;
/// 下载错误
- (void)onDownloadError:(TXVodDownloadMediaInfo *)mediaInfo errorCode:(TXDownloadError)code errorMsg:(NSString *)msg;
/**
 * 下载HLS，遇到加密的文件，将解密key给外部校验
 * @param mediaInfo 下载对象
 * @param url Url地址
 * @param data 服务器返回
 * @return 0 - 校验正确，继续下载；否则校验失败，抛出下载错误（dk获取失败）
 */
- (int)hlsKeyVerify:(TXVodDownloadMediaInfo *)mediaInfo url:(NSString *)url data:(NSData *)data;
@end

/// 下载管理器
@interface TXVodDownloadManager : NSObject

/**
 * 下载任务回调
 */
@property (weak) id<TXVodDownloadDelegate> delegate;

/**
 * 设置http头
 */
@property NSDictionary *headers;

/**
 * 全局单例接口
 */
+ (TXVodDownloadManager *)shareInstance;

/**
 * 设置下载文件的根目录.
 * @param path 目录地址，如不存在，将自动创建
 * @warn 开始下载前必须设置，否者不能下载
 */
- (void)setDownloadPath:(NSString *)path;

/**
 * 下载文件
 *  @param source 下载源。
 *  @return 成功返回下载对象，否者nil
 *
 *  @waring 目前只支持hls下载
 */
- (TXVodDownloadMediaInfo *)startDownload:(TXVodDownloadDataSource *)source;

/**
 * 下载文件
 *  @param url 下载地址
 *  @return 成功返回下载对象，否者nil
 *
 *  @waring 目前只支持hls下载，不支持master playlist
 */
- (TXVodDownloadMediaInfo *)startDownloadUrl:(NSString *)url;

/**
 * 停止下载
 * @param media 停止下载对象
 */
- (void)stopDownload:(TXVodDownloadMediaInfo *)media;

/**
 * 删除下载产生的文件
 * @return 文件正在下载将无法删除，返回NO
 */
- (BOOL)deleteDownloadFile:(NSString *)playPath;

@end
