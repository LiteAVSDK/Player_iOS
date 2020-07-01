//
//  ScanQRController.m
//  RTMPiOSDemo
//
//  Created by 蓝鲸 on 16/4/1.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "ScanQRController.h"

static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";


@interface ScanQRController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    CGRect _interestRect;
}

@end

@implementation ScanQRController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _qrResult = NO;
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    int c_x = size.width/2;
    int c_y = size.height/2;
    int roi = size.width * 0.4;
    
    _interestRect = CGRectMake(c_x - roi, c_y - roi, roi*2, roi*2);
    
    [self startScan];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startScan
{
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
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    captureMetadataOutput.rectOfInterest = [_videoPreviewLayer metadataOutputRectOfInterestForRect:_interestRect];    
}


- (void)stopScanQRCode {
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
    _videoPreviewLayer = nil;
}



- (void)handleScanResult:(NSString *)result
{
    [self stopScanQRCode];
    if (_qrResult) {
        return;
    }
    _qrResult = YES;

    if ([self.delegate respondsToSelector:@selector(onScanResult:)]) {
        [self.delegate onScanResult:result];
    }
    
//    [self.navigationController popToViewController:self.pvc animated:NO];
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

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self stopScanQRCode];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
