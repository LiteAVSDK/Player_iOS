//
//  ViewController.swift
//  SwiftDemo
//
//  Created by annidyfeng on 2018/10/26.
//  Copyright © 2018年 annidy. All rights reserved.
//

import UIKit
import MBProgressHUD
import SuperPlayer

class ViewController: UIViewController {
    
    var player: SuperPlayerView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let thePlayer = SuperPlayerView(frame: self.view.frame);
        thePlayer.fatherView = self.view
        let model = SuperPlayerModel()
        model.videoURL = "http://1253131631.vod2.myqcloud.com/26f327f9vodgzp1253131631/f4c0c9e59031868222924048327/f0.mp4"
        thePlayer.play(with: model)
        
        player = thePlayer
    }


}

