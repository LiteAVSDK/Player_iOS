/**
 * Module: TCUtil
 *
 * Function: 实用函数
 */

#import <UIKit/UIKit.h>

#import "TCLog.h"

#ifndef weakify
    #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
    #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
    #endif
#endif


#ifndef strongify
    #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
    #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
    #endif
#endif

#define IPHONE_X                                                                                        \
    ({                                                                                                  \
        BOOL isPhoneX = NO;                                                                             \
        if (@available(iOS 11.0, *)) {                                                                  \
            isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0; \
        }                                                                                               \
        (isPhoneX);                                                                                     \
    })

typedef void (^videoIsReadyBlock)(void);
#define DEBUGSwitch [TCUtil getDEBUGSwitch]

static NSString *const kMainMenuDEBUGSwitch = @"kMainMenuDEBUGSwitch";
static NSString *const kIsFirstStart = @"kIsFirstStart";

@interface TCUtil : NSObject

+ (NSData *)dictionary2JsonData:(NSDictionary *)dict;

+ (NSDictionary *)jsonData2Dictionary:(NSString *)jsonData;

+ (NSString *)getFileCachePath:(NSString *)fileName;

+ (NSUInteger)getContentLength:(NSString *)string;

+ (void)asyncSendHttpRequest:(NSDictionary *)param handler:(void (^)(int resultCode, NSDictionary *resultDict))handler;
+ (void)asyncSendHttpRequest:(NSString *)command params:(NSDictionary *)params handler:(void (^)(int resultCode, NSString *message, NSDictionary *resultDict))handler;
+ (void)asyncSendHttpRequest:(NSString *)command token:(NSString *)token params:(NSDictionary *)params handler:(void (^)(int resultCode, NSString *message, NSDictionary *resultDict))handler;

+ (NSString *)transImageURL2HttpsURL:(NSString *)httpURL;

+ (NSString *)getStreamIDByStreamUrl:(NSString *)strStreamUrl;

+ (UIImage *)gsImage:(UIImage *)image withGsNumber:(CGFloat)blur;

+ (UIImage *)scaleImage:(UIImage *)image scaleToSize:(CGSize)size;

+ (UIImage *)clipImage:(UIImage *)image inRect:(CGRect)rect;

+ (void)toastTip:(NSString *)toastInfo parentView:(UIView *)parentView;

+ (float)heightForString:(UITextView *)textView andWidth:(float)width;

+ (BOOL)isSuitableMachine:(int)targetPlatNum;

// - Remove From Github
#pragma mark - 分享相关
+ (void)initializeShare;

+ (void)dismissShareDialog;

+ (BOOL)getDEBUGSwitch;

+ (void)changeDEBUGSwitch;

@end

#pragma mark - UIActivityViewController图片处理
@interface UIImage (TCUtilUIActivity)
/**
 * 通过UIActivityViewController分享图片，微信、QQ对系统图像分享都要尺寸要求，需要压缩处理。
 * @brief 宽高均 <= 1280，图片尺寸大小保持不变
 *        宽或高 > 1280，取较大值等于1280，较小值等比例压缩
 *        大小限制： 微信最大10M,  QQ最大5M，
 * @return 处理后的图片
 */
- (UIImage *)shareActivityImage;

@end

// 频率控制类，如果频率没有超过 nCounts次/nSeconds秒，canTrigger将返回true
@interface TCFrequeControl : NSObject

- (instancetype)initWithCounts:(NSInteger)counts andSeconds:(NSTimeInterval)seconds;
- (BOOL)canTrigger;

@end

// 日志
#ifdef DEBUG

#ifndef DebugLog
//#define DebugLog(fmt, ...) NSLog((@"[%s Line %d]" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define DebugLog(fmt, ...) [[TCLog shareInstance] log:fmt, ##__VA_ARGS__]
#endif

#else

#ifndef DebugLog
#define DebugLog(fmt, ...) [[TCLog shareInstance] log:fmt, ##__VA_ARGS__]
#endif
#endif

#ifndef TC_PROTECT_STR
#define TC_PROTECT_STR(x) (x == nil ? @"" : x)
#endif
