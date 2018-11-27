//
//  TXPlayerAuthParams.h
//  TXLiteAVSDK
//
//  Created by annidyfeng on 2017/12/13.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 点播fileid鉴权信息
@interface TXPlayerAuthParams : NSObject
///应用appId。必填
@property int appId;
///文件id。必填
@property NSString *fileId;
///加密链接超时时间戳，转换为16进制小写字符串，腾讯云 CDN 服务器会根据该时间判断该链接是否有效。可选
@property NSString *timeout;
///试看时长，单位：秒。可选
@property int exper;
///唯一标识请求，增加链接唯一性
@property NSString *us;
/**
 无防盗链不填
 
 普通防盗链签名：
 sign = md5(KEY+appId+fileId+t+us)
 带试看的防盗链签名：
 sign = md5(KEY+appId+fileId+t+exper+us)
 
 播放器API使用的防盗链参数(t, us, exper) 与CDN防盗链参数一致，只是sign计算方式不同
 参考防盗链产品文档: https://cloud.tencent.com/document/product/266/11243
 */
@property NSString *sign;
///是否用https请求，默认NO
@property BOOL https;
@end
