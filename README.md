# 超级播放器

超级播放器是基于[腾讯云播放器SDK](https://cloud.tencent.com/document/product/881/20191)的播放器，能快速的集成视频信息拉取、横竖屏切换、清晰度选择、弹幕、直播时移等功能。灵活易用，可高度定制和二次开发。

## 功能截图
+ 手势操作

![gues](https://main.qcloudimg.com/raw/0e9b27aeb27f8042ccd8842ea6534432.gif)

+ 清晰度切换

![hd](https://main.qcloudimg.com/raw/bd65daadf000adcbd26c0ebd6676330c.gif)

+ 倍速播放

![spd](https://main.qcloudimg.com/raw/dc47218e438295e2f9942d99c1f315b0.gif)

+ 打点、缩略图

![p](https://main.qcloudimg.com/raw/881148817fa0d5e267fe41c2aa71f3f6.gif)

+ 一键换肤

![sk](https://main.qcloudimg.com/raw/82899ea7e1917c6dd85be5d36900e279.gif)

+ 列表播放

![list](https://main.qcloudimg.com/raw/3ece479b33cdc7a458483d3eb1e78b1b.gif) ![fu](https://main.qcloudimg.com/raw/3af5501454ca107882b618dbb2c0d8ef.gif)

+ 文件下载

![download](https://main.qcloudimg.com/raw/9b4e5a1809e92523094e67c761791e4a.jpeg)


## 概述

开发一个全功能播放器不止简单的能播放视频，还有要处理旋转、前后台切换、界面显示等一系列问题。SuperPlayer作为一个集成方案，几乎囊括了所有播放器应该具备的特性，大大减少界面开发工作量。SuperPlayer内部使用腾讯云自研的 TXLivePlayer 和 TXVodPlayer，比系统自带的AVPlayer支持更多格式和功能，打开速度更快，兼容性更好。

本播放器所有功能免费，无任何限制，可放心使用。

## 功能特性

- [x] 加密视频播放（FairPlay、SimpleAES）
- [x] 多种视频格式（RTMP、FLV、HLS、MP4）
- [x] 直播、点播首屏秒开
- [x] 码率自适应
- [x] 清晰度无缝切换
- [x] 无缝循环播放
- [x] 小窗播放
- [x] 变速播放，变速不变调
- [x] 边播边下
- [x] 自定义播放起始时间
- [x] 直播录制
- [x] 后台播放
- [x] 自定义视频渲染
- [x] 弹幕
- [x] 直播时移
- [x] 视频截图
- [x] 视频旋转
- [x] 视频镜像
- [x] 视频适应、填充模式
- [x] H.265硬解
- [x] 支持HTTPS
- [x] 支持视频自动旋转
- [x] 播放器预加载
- [x] 多码率HLS（Master Playlist）
- [x] 软硬解自动切换
- [x] 静音
- [x] 自定义HTTP Headers
- [x] 快速seek
- [x] 手势操作（调整亮度、声音、进度）
- [x] 重力感应
- [x] 设置封面图
- [x] 自定义进度回调间隔
- [x] 视频缩略图预览
- [x] 进度条打点
- [x] 根据网络自动选择清晰度
- [x] 自定义皮肤

## 快速开始

本项目支持cocoapods安装，只需要将如下代码添加到Podfile中：
```
pod 'SuperPlayer'
```
执行pod install或pod update.


## 集成使用

在[快速集成](https://github.com/tencentyun/SuperPlayer_iOS/wiki/Home)中介绍了主要功能使用。

本项目详细文档位于
https://github.com/tencentyun/SuperPlayer_iOS/wiki

## 联系方式
+ Android: https://github.com/tencentyun/SuperPlayer_Android
+ Issues: https://github.com/tencentyun/SuperPlayer_iOS/issues
+ 专人解答/技术交流 QQ群: 781719018 
+ SDK常见问题: http://faq.qcloudtrtc.com/
