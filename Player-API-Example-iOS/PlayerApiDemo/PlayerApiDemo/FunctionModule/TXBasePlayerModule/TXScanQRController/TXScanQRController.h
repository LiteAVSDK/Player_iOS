//
//  TXScanQRController.h
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ScanQRDelegate <NSObject>

/**
 *   扫码成功的回调
 *   @param result 扫码的结果
 */
- (void)onScanResult:(NSString *)result;

/**
 *   取消扫码的回调
 */
- (void)cancelScanQR;

@end

@interface TXScanQRController : UIViewController

@property (nonatomic, assign) BOOL qrResult;

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, weak)   id<ScanQRDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
