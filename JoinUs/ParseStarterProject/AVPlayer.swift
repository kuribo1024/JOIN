//
//  AVPlayer.swift
//  JoinUs
//
//  Created by 鈴木 嘉洋 on 2015/04/19.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView : UIView
{
    
    // UIViewのサブクラスを作りlayerClassメソッドをオーバーライドしてAVPlayerLayerに差し替える
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
    func player() -> AVPlayer {
        let layer: AVPlayerLayer = self.layer as AVPlayerLayer
        return layer.player!
    }
    
    func setPlayer(player: AVPlayer) {
        let layer: AVPlayerLayer = self.layer as AVPlayerLayer
        layer.player = player
    }
    
    func setVideoFillMode(fillMode: NSString) {
        let layer: AVPlayerLayer = self.layer as AVPlayerLayer
        layer.videoGravity = fillMode
    }
    
    func videoFillMode() -> NSString {
        let layer: AVPlayerLayer = self.layer as AVPlayerLayer
        return layer.videoGravity
    }
}

