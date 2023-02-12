//
//  ViewController.swift
//  SwiftCallOC
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

import UIKit
import TXLiteAVSDK_Player

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 方式一：使用桥接头文件
        // a.创建桥接头文件，例如 ‘***-Bridging-Header.h’，并添加如下代码 ‘#import <TXLiteAVSDK_Player/TXLiteAVSDK.h>’
        
        // b.配置工程 'BuildSetting' 的 'Objective-c Bridging header' 选项。设置桥接文件的路径添加到Objective-c Bridging header中,编译运行即可。
        // 如：$(SRCROOT)/SwiftCallOC/***-Bridging-Header.h
        
        let vodPlayer : TXVodPlayer = TXVodPlayer()
        vodPlayer.setMute(true)
        
        let vodPlayerConfig : TXVodPlayConfig = TXVodPlayConfig()
        vodPlayerConfig.playerType = 1
        vodPlayer.config = vodPlayerConfig
        
        // 方式二：使用SDK内的 module.modulemap 文件
        // a.检查 ‘TXLiteAVSDK_Player.framework’里是否有包含 ‘Modules - module.modulemap’ 文件
        
        // b.配置工程 'BuildSetting' 的 'Swift Compiler - Search Paths' 选项。添加 ‘module.modulemap’ 文件所在的目录路径或其上层目录路径，此处可为：
        // ${PODS_ROOT}/TXLiteAVSDK_Player/TXLiteAVSDK_Player/TXLiteAVSDK_Player.framework/Modules
        
        // c.在需要调用的类顶部，使用 ‘import TXLiteAVSDK_Player’ 来进行引入并调用相关的方法
    }
    


}

