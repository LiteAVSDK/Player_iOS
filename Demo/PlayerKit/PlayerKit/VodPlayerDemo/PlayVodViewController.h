//
//  PlayVodViewController.h
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2017/9/12.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PlayerKitCommonHeaders.h"

@interface PlayVodViewController : UIViewController {
    TXVodPlayer*       _txVodPlayer;
    UITextView*        _statusView;
    UITextView*        _logViewEvt;
    unsigned long long _startTime;
    unsigned long long _lastTime;

    UIButton* _btnPlay;
    UIButton* _btnClose;
    UIView*   _cover;

    BOOL              _screenPortrait;
    BOOL              _renderFillScreen;
    BOOL              _log_switch;
    BOOL              _play_switch;
    AVCaptureSession* _VideoCaptureSession;

    NSString* _logMsg;
    NSString* _tipsMsg;
    NSString* _testPath;
    NSInteger _cacheStrategy;

    UIButton* _btnCacheStrategy;
    UIView*   _vCacheStrategy;
    UIButton* _radioBtnFast;
    UIButton* _radioBtnSmooth;
    UIButton* _radioBtnAUTO;
    UIButton* _muteButton;

    UIButton* _helpBtn;

    TXVodPlayConfig* _config;
}

@property(nonatomic, retain) UITextField* txtRtmpUrl;

@end
