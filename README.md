简体中文| [English](./README-EN.md)

## 目录结构说明

本目录包含 iOS 版 播放器(Player) SDK 的Demo 源代码，主要演示接口如何调用以及最基本的功能。

```
├─ Demo // 播放器Demo
└── TXLiteAVDemo
    ├── App               // 程序入口界面
    ├── SuperPlayerDemo   // 播放器组件Demo
    └── SuperPlayerKit    // 播放器组件
    ├── SuperPlayFeedDemo   // Feed流播放器Demo
    └── UGCShortVideoPlayDemo    // 短视频播放器Demo
├─ Demo // 播放器Demo
├─ Player-API-Example-iOS // 播放器API相关Demo
├─ Swift-Call-OC-Example  // Swift调用SDK API的实现样例
```
## **集成说明**
请参考[Wiki部分相关内容](https://github.com/LiteAVSDK/Player_iOS/wiki)

## **配置说明**
请参考[播放器集成相关配置](https://github.com/LiteAVSDK/Player_iOS/wiki/播放器集成相关配置)

## **Demo体验说明**
下载新版Demo后，需通过[TXLiveBase setLicence] 设置 Licence 后方可成功播放， 否则将播放失败（黑屏），全局仅设置一次即可。直播 Licence、短视频 Licence 和视频播放 Licence 均可使用，若您暂未获取上述 Licence ，可[快速免费申请测试版 Licence](https://cloud.tencent.com/act/event/License) 以正常播放，正式版 License 需[购买](https://cloud.tencent.com/document/product/881/74588#.E8.B4.AD.E4.B9.B0.E5.B9.B6.E6.96.B0.E5.BB.BA.E6.AD.A3.E5.BC.8F.E7.89.88-license)。

申请到Licence URL 和 Licence URL 后，请用它们赋值给`Demo/TXLiteAVDemo/App/config/Player.plist`文件的 licenceUrl 和 licenceKey 字段。

## **升级说明**

播放器 SDK 移动端10.1（Android & iOS & Flutter）开始 版本采用“腾讯视频”同款播放内核打造，视频播放能力获得全面优化升级。

同时从该版本开始将增加对“视频播放”功能模块的授权校验，**如果您的APP已经拥有直播推流 License 或者短视频 License 授权，当您升级至10.1 版本后仍可以继续正常使用，**不受到此次变更影响，您可以登录 [腾讯云视立方控制台](https://console.cloud.tencent.com/vcube) 查看您当前的 License 授权信息。

如果您在此之前从未获得过上述License授权**，且需要使用新版本SDK（10.1及其更高版本）中的直播播放或点播播放功能，则需购买指定 License 获得授权**，详情参见[授权说明](https://cloud.tencent.com/document/product/881/74199#.E6.8E.88.E6.9D.83.E8.AF.B4.E6.98.8E)；若您无需使用相关功能或未升级至最新版本SDK，将不受到此次变更的影响。

## SDK 分类和下载

腾讯云 Player SDK 提供**基础版本和高级版本**，产品功能的差异可查看播放器 SDK 官网[产品简介>产品功能](https://cloud.tencent.com/document/product/881/61375)：

- 如果您追求最小化体积增量，可以下载 Player 基础版：[TXLiteAVSDK_Player.zip](https://liteav.sdk.qcloud.com/download/latest/TXLiteAVSDK_Player_iOS_latest.zip)
- 如果您需要使用外挂字幕、多音轨、DRM 播放等高级功能，可以下载 Player 高级版：[TXLiteAVSDK_Player_Premium.zip](https://liteav.sdk.qcloud.com/download/latest/TXLiteAVSDK_Player_Premium_iOS_latest.zip)

## 相关文档链接

- [SDK 的版本更新历史](https://github.com/tencentyun/SuperPlayer_iOS/releases)
- [常见移动端播放问题](https://cloud.tencent.com/document/product/881/73976)
- [SDK 的 API 文档](https://github.com/tencentyun/SuperPlayer_iOS/wiki)
- [SDK 的官方体验 App](https://cloud.tencent.com/document/product/881/20204)

