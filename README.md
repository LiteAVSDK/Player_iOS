## 目录结构说明

本目录包含 iOS 版 超级播放器(SuperPlayer) SDK 的Demo 源代码，主要演示接口如何调用以及最基本的功能。

```
├─ SDK 
|  ├─ TXLiteAVSDK_Professional.framework // 如果您下载的是专业版 zip 包，解压后将出现此文件
|  ├─ TXLiteAVSDK_Enterprise.framework   // 如果您下载的是企业版 zip 包，解压后将出现此文件
|  ├─ TXLiteAVSDK_Player.framework   // 录屏直播需要的framework
├─ Demo // 超级播放器Demo，包括演示直播、点播、短视频、RTC 在内的多项功能
├── ReplaykitUpload
└── TXLiteAVDemo
    ├── App               // 程序入口界面
    ├── SuperPlayerDemo   // 超级播放器 Demo，ugc视频发布后，会使用超级播放器进行播放
    └── SuperPlayerKit    // 超级播放器组件
```

## SDK 分类和下载

腾讯云 Player SDK 基于 LiteAVSDK 统一框架设计和实现，该框架包含直播、点播、短视频、RTC、AI美颜在内的多项功能：

- 如果您追求最小化体积增量，可以下载 Player 版：[TXLiteAVSDK_Player.zip](https://cloud.tencent.com/document/product/881/20205)
- 如果您需要使用多个功能而不希望打包多个 SDK，可以下载专业版：[TXLiteAVSDK_Professional.zip](https://cloud.tencent.com/document/product/647/32689#Professional)
- 如果您已经通过腾讯云商务购买了 AI 美颜 License，可以下载企业版：[TXLiteAVSDK_Enterprise.zip](https://cloud.tencent.com/document/product/647/32689#Enterprise)

## 相关文档链接

- [SDK 的版本更新历史](https://github.com/tencentyun/SuperPlayer_iOS/releases)
- [SDK 的 API 文档](https://github.com/tencentyun/SuperPlayer_iOS/wiki)
- [SDK 的官方体验 App](https://cloud.tencent.com/document/product/881/20204)

