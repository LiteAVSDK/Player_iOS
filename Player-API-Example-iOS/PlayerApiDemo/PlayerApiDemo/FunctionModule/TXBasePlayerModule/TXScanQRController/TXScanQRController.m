//
//  TXScanQRController.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXScanQRController.h"

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

@interface TXScanQRController()

@property (nonatomic, assign) CGRect interestRect;

@end

@interface TXScanQRController ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation TXScanQRController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.qrResult = NO;
    
    // 设置扫码框
    CGSize size = [[UIScreen mainScreen] bounds].size;
    int c_x = size.width/2;
    int c_y = size.height/2;
    int roi = size.width * 0.4;
    
    self.interestRect = CGRectMake(c_x - roi, c_y - roi, roi*2, roi*2);
    
    // 开始扫码
    [self startScan];
    
    // 处理扫码框周边的View
    UIView* top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, c_y - roi)];
    top.backgroundColor = [UIColor blackColor];
    top.alpha = 0.8;
    [self.view addSubview:top];
    

    UIView* left = [[UIView alloc] initWithFrame:CGRectMake(0, c_y - roi, c_x - roi, 2*roi)];
    left.backgroundColor = [UIColor blackColor];
    left.alpha = 0.8;
    [self.view addSubview:left];

    UIView* right = [[UIView alloc] initWithFrame:CGRectMake(c_x + roi , c_y-roi, c_x - roi+1, 2*roi)];
    right.backgroundColor = [UIColor blackColor];
    right.alpha = 0.8;
    [self.view addSubview:right];
    
    UIView* bottom = [[UIView alloc] initWithFrame:CGRectMake(0, c_y + roi, size.width, c_y - roi)];
    bottom.backgroundColor = [UIColor blackColor];
    bottom.alpha = 0.8;
    [self.view addSubview:bottom];
}

// 开始扫码
- (void)startScan {
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([captureDevice lockForConfiguration:nil]) {
        //对焦模式，自动对焦
        if (captureDevice && [captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        else if(captureDevice && [captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]){
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        // 自动白平衡
        if (captureDevice && [captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            captureDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
        }
        else if (captureDevice && [captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            captureDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
        }
        
        if (captureDevice && [captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            captureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        }
        else if (captureDevice && [captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            captureDevice.exposureMode = AVCaptureExposureModeAutoExpose;
        }
        
        [captureDevice unlockForConfiguration];
    }
    
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return ;
    }
    
    // 创建会话
    self.captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    if ([self.captureSession canAddInput:input]) {
        [self.captureSession addInput:input];
    }
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 添加输出流
    if ([self.captureSession canAddOutput:captureMetadataOutput]) {
        [self.captureSession addOutput:captureMetadataOutput];
    }
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    // 创建输出对象
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer addSublayer:self.videoPreviewLayer];
    
    [self.captureSession startRunning];
    
    captureMetadataOutput.rectOfInterest = [self.videoPreviewLayer metadataOutputRectOfInterestForRect:self.interestRect];
}

// 停止扫码
- (void)stopScanQRCode {
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
    _videoPreviewLayer = nil;
}

// 回调扫码结果
- (void)handleScanResult:(NSString *)result {
    // 停止扫码
    [self stopScanQRCode];
    
    if (self.qrResult) {
        return;
    }
    self.qrResult = YES;

    if ([self.delegate respondsToSelector:@selector(onScanResult:)]) {
        [self.delegate onScanResult:result];
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self performSelectorOnMainThread:@selector(handleScanResult:) withObject:metadataObj.stringValue waitUntilDone:NO];
        }
        
    }
}

// 点击取消扫码
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stopScanQRCode];
    [self.navigationController popViewControllerAnimated:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelScanQR)]) {
        [self.delegate cancelScanQR];
    }
}

@end

