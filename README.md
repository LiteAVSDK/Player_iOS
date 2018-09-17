# SuperPlayer

SuperPlayer(超级播放器)是基于[腾讯云移动直播](https://cloud.tencent.com/document/product/454/7873)的播放器，能快速的集成视频信息拉取、横竖屏切换、清晰度选择、弹幕、直播时移等功能。灵活易用，可高度定制和二次开发。

## 概述

开发一个全功能播放器不止简单的能播放视频，还有要处理旋转、前后台切换、界面显示等一系列问题。SuperPlayer作为一个集成方案，几乎囊括了所有播放器应该具备的特性，大大减少界面开发工作量。SuperPlayer内部使用腾讯云自研的 TXLivePlayer 和 TXVodPlayer，比系统自带的AVPlayer支持更多格式和功能，打开速度更快，兼容性更好。

本播放器所有功能免费，无任何限制，可放心使用。

## 功能特性

- [x] 高可定制
- [x] 直播、点播首屏秒开
- [x] 码率自适应
- [x] 清晰度无缝切换
- [x] 支持小窗播放
- [x] 支持变速播
- [x] 直接加密视频
- [x] 支持设置封面图
- [x] 弹幕
- [x] 直播时移
- [x] 手势操作（调整亮度、声音、进度）
- [x] 截图
- [x] 支持视频旋转、镜像
- [x] 支持视频适应、填充模式
- [x] 支持265硬解
- [x] 支持RTMP、FLV、HLS、MP4
- [x] 支持HTTPS
- [x] 支持视频根据旋转角度自动旋转
- [x] 支持播放预加载
- [x] 支持多码率HLS
- [x] 支持软硬解自动切换
- [x] 支持 HLS 和 MP4 边播边下
- [x] 支持 HLS 离线下载
- [x] 支持断点下载
- [x] 支持 SEI 数据回调
- [x] 支持纯音频播放
- [x] 支持后台播放
- [x] 支持播放器静音
- [x] 支持循环播放
- [x] 支持自定义渲染
- [x] 支持自定义声音处理
- [x] 支持自定义HTTP Headers
- [x] 支持快速seek
- [x] 支持设置进度回调间隔
- [x] 支持视频缩略图
- [x] 支持进度打点

## 快速开始
### 工程配置

本项目支持cocoapods安装，只需要将如下代码添加到Podfile中：
```
pod 'SuperPlayer'
```
执行pod install或pod update.

<details>
<summary>Pod依赖进阶</summary>
<b markdown=1>

* 需要更多能力
本工程默认依赖TXLiveAVSDK_Player， 如果您不仅限于使用播放，还会用到推流、编辑等其它能力，需要修改子依赖
```
pod 'SuperPlayer', :subspecs => ['UGC_IJK'] # 编辑能力
```

* 工程已集成TXLiveAVSDK
如果您的工程已集成TXLiveAVSDK，可以只包含UI部分代码
```
pod 'SuperPlayer', :subspecs => ['Core']
```
> 注意：请确保工程中的TXLiveAVSDK和播放器匹配，否者可能有链接错误或其它bug


</b>
</details>

## 创建播放器

超级播放器主类为`SuperPlayerView`，您需要先创建它并添加到合适的容器View中。

```objective-c
_playerView = [[SuperPlayerView alloc] init];

// 设置代理
_playerView.delegate = self;

// 设置父View
_playerView.fatherView = self.holderView;

// 开始播放
[_playerView playWithModel:self.playerModel];
```

## 直播播放

### 如何播放
直播播放需要传入直播地址，常见的直播协议有一下几种：
![格式](https://mc.qcloudimg.com/static/img/94c348ff7f854b481cdab7f5ba793921/image.jpg)

推荐使用 FLV 协议(以 .flv 结尾的播放地址)。在超级播放使用方法如下：
```objc
self.playerModel = @"http://5815.liveplay.myqcloud.com/live/5815_62fe94d692ab11e791eae435c87f075e.flv";
[_playerView playWithModel:self.playerModel]; // 开始播放
```

### 清晰度无缝切换
在网络较差的情况下，可以适度降低画质，以减少卡顿；反之，网速变好的情况下可以切到更好的画质。
传统切流方式需要重新播放，会导致切换前后画面衔接不上。 超级播放器引入了无缝切换方案，在不中断直播的情况下切到另条流上。

无缝切换前，需要在播放前提供不同清晰度的流地址。
```
SuperPlayerUrl *url1 = [SuperPlayerUrl new];
url1.url = @"http://5815.liveplay.myqcloud.com/live/5815_62fe94d692ab11e791eae435c87f075e.flv";
url1.title = @"超清";
SuperPlayerUrl *url2 = [SuperPlayerUrl new];
url2.url = @"http://5815.liveplay.myqcloud.com/live/5815_62fe94d692ab11e791eae435c87f075e_900.flv";
url2.title = @"高清";
SuperPlayerUrl *url3 = [SuperPlayerUrl new];
url3.url = @"http://5815.liveplay.myqcloud.com/live/5815_62fe94d692ab11e791eae435c87f075e_550.flv";
url3.title = @"标清";

self.palyerModel.multiVideoURLs = @[url1, url2, url3];
```
在播放器中即可看到这几个清晰度，点击即可立即切换。

![直播清晰度](https://main.qcloudimg.com/raw/8cb10273fe2b6df81b36ddb79d0f4890.jpeg)

### 直播时移回看

时移功能是腾讯云推出的特色能力，可以在直播过程中，随时观看回退到任意直播历史时间点，并能在此时间点一直观看直播。非常适合游戏、球赛等互动性不高，但观看连续性较强的场景。

时移的原来是在直播的过程中，后台也在录制，当用户返回观看历史时间点时，等同于观看录制文件。具体原理可参考 [直播时移文档](https://cloud.tencent.com/document/product/267/18472)。



#### 接入准备

接入时移需要在后台打开2处配置：

1. 录制：配置时移时长、时移储存时长
2. 播放：时移获取元数据

时移功能处于公测申请阶段，如您需要可提交工单申请使用。



#### 开启时移

超级播放器开启时移非常简单，您只需要在播放前配置好appId

```objc
self.playerModel.appId = 1252463788;
```

appId在 腾讯云控制台 -> 账号信息 中可以查到。



配置好appId，播放直播流就能在下面看到进度条。往后拖动即可回到指定位置，点击“返回直播”可观看最新直播流。

![](https://main.qcloudimg.com/raw/a3a4a18819aed49b919384b782a13957.jpeg)



## 点播播放

### 如何播放

超级播放器支持两种点播方式，url和fileId。url方式播放与直播播放相同，只需要把直播流url换成点播url。

点播支持mp4、HLS、FLV格式，推荐使用mp4或hls格式。

| 视频格式 | 优点                           | 缺点                              |
| -------- | ------------------------------ | --------------------------------- |
| MP4      | 在PC和手机上兼容性好，存储简单 | 长视频加载较慢                    |
| HLS      | 苹果主推，加载快，支持多码率   | /                                 |
| FLV      | /                              | 由Adobe Flash延伸出的格式，不推荐 |

fileId播放需要填写 appId 和 fileId两个变量
```objc
self.playerModel.appId = 1252463788;
self.playerModel.fileId = @"4564972819219071679";
[_playerView playWithModel:self.playerModel]; // 开始播放
```
通过fileId方式播放，播放器界面会显示后台已转码的各个清晰度，并能实现自由切换。

#### fileId获取

fileId在一般是在视频上传后，由服务器返回：

1. 客户端视频发布后，服务器会返回[fileId](https://cloud.tencent.com/document/product/584/9367#8..E5.8F.91.E5.B8.83.E7.BB.93.E6.9E.9C)到客户端
2. 服务端视频上传，在[确认上传](https://cloud.tencent.com/document/product/266/9757)的通知中包含对应的fileId

如果文件已存在腾讯云，则可以进入 [点播视频管理](https://console.cloud.tencent.com/video/videolist) ，找到对应的文件。点开后在右侧视频详情中，可以看到appId和fileId。

![视频管理](https://mc.qcloudimg.com/static/img/fcad44c3392b229f3a53d5f8b2c52961/image.png)

### 清晰度无缝切换

通过fileId播放，如果视频有转码，播放器界面已经可以显示多个清晰度。无缝切换作为更好体验方式，在切换时不会明显感觉到重新加载的卡顿。

无缝切换需要转码时指定生成masterPlaylist和IDR对齐，配置后超级播放在播fileId时，就能取到多码率masterPlaylist的视频源地址。使用上和播普通fileId没有区别，超级播放器内部会自动处理多码率流，只需要在后台修改转码参数，修改方法请参考文档 [对视频文件进行处理](https://cloud.tencent.com/document/product/266/9642#.E8.AF.B7.E6.B1.82.E5.8F.82.E6.95.B0.E8.AF.B4.E6.98.8E)。



## 切换视频

在播放中可以随时切换到另一个视频，无需停止当前播放。您只需重新调用`playWithModel:`方法，在参数中填上对应的视频地址或fileId。

## 小窗播放

小窗播是指在App内，悬浮在主window上的播放器。使用小窗播放非常简单，只需要在适当位置调用下面代码即可：
```objective-c
SuperPlayerWindowShared.superPlayer = _playerView; // 设置小窗显示的播放器
SuperPlayerWindowShared.backController = self;  // 设置返回的view controller
[SuperPlayerWindowShared show]; // 悬浮显示
```


## 移除播放器

当不需要播放器时，调用resetPlayer清理播放器内部状态，防止干扰下次播放。

```objective-c
[_playerView resetPlayer];  //非常重要
```
