# SuperPlayer

SuperPlayer(播放器组件)是基于[腾讯云移动直播](https://cloud.tencent.com/document/product/454/7873)的播放器，能快速的集成视频信息拉取、横竖屏切换、清晰度选择、弹幕、直播时移等功能。灵活易用，可高度定制和二次开发。

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

本项目支持cocoapods安装，只需要将如下代码添加到Podfile中：
```
pod 'SuperPlayer'
```
执行pod install或pod update.


## 集成使用

在[快速集成](https://github.com/tencentyun/SuperPlayer/wiki/Home)中介绍了主要功能使用。

本项目详细文档位于
https://github.com/tencentyun/SuperPlayer/wiki

## 联系方式
+ Issues: https://github.com/tencentyun/SuperPlayer/issues
+ QQ群: 781719018
