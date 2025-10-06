//
//  NSString+URL.h
//  SuperPlayer
//
//  Created by xcoderliu on 12/10/20.
//  Copyright © 2020 annidy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (URL)
/**
 * Get URL GET parameters
 * @param parameter key
 * @param originUrl url
 */
/**
 * 获取 URL GET 参数
 * @param parameter key
 * @param originUrl url
 */
+ (NSString *)getParameter:(NSString *)parameter WithOriginUrl:(NSString *)originUrl;
/**
  * Remove URL GET parameter
  * @param parameter key
  * @param originUrl url
  */
/**
 * 删除 URL GET 参数
 * @param parameter key
 * @param originUrl url
 */
+ (NSString *)deleteParameter:(NSString *)parameter WithOriginUrl:(NSString *)originUrl;
/**
   * Append URL GET parameters
   * @param queryString (@"key=value")
   * @param originUrl url
   */
/**
  * 追加 URL GET 参数
  * @param queryString (@"key=value")
  * @param originUrl url
  */
+ (NSString *)appendParameter:(NSString *)queryString WithOriginUrl:(NSString *)originUrl;
@end

NS_ASSUME_NONNULL_END
