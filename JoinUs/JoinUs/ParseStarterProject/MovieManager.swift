//
//  MovieManager.swift
//  JoinUs
//
//  Created by 鈴木 嘉洋 on 2015/04/11.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import Foundation
import AVFoundation

class MovieManager
{
    class func RemoveTmpFile()
    {
        var fileManager : NSFileManager = NSFileManager.defaultManager()
        for(var count = 0;count < 50;count++)
        {
            var outputPath = (NSTemporaryDirectory()+"output"+String(count)+".mp4") as String
            if(fileManager.fileExistsAtPath(outputPath))
            {
                fileManager.removeItemAtPath(outputPath, error: nil)
            }
        }
    }
    
    class func JoinMovie(OutPutPaths:Array<MovieData>,target:TakeMovieViewController)
    {
        var composition : AVMutableComposition = AVMutableComposition()
        
        var videoSize : CGSize = CGSize()
        var startTime : CMTime = kCMTimeZero
        var compositionVideoTrack :AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        var framerate : Float = 0.0
        var layerInst : AVMutableVideoCompositionLayerInstruction
        //複数ファイルの結合処理
        for item in OutPutPaths
        {
            var asset : AVAsset = AVAsset.assetWithURL(item.path) as AVAsset
            var videoTrack : AVAssetTrack = asset.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack
            videoSize = videoTrack.naturalSize
            var i : Int64
            var a : Int64 = Int64(asset.duration.value.value)
            var d : Double = Double(a)
            i = Int64(a / item.speed!)
            var slowly : CMTime = CMTimeMake(i, asset.duration.timescale);
            compositionVideoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, asset.duration), ofTrack: videoTrack, atTime: startTime, error: nil)
            compositionVideoTrack.scaleTimeRange(CMTimeRangeMake(startTime, asset.duration), toDuration: slowly)
            startTime = CMTimeAdd(startTime,slowly);
            framerate = videoTrack.nominalFrameRate;
            compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        }
        layerInst = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
        
        videoSize.height = 320;
        videoSize.width = 320;
        
        //合成ファイルの変換処理
        var transformVideo : CGAffineTransform = CGAffineTransformMakeTranslation(320, 0)
        var transformVideoRotate : CGAffineTransform = CGAffineTransformRotate(transformVideo, CGFloat(M_PI*0.5))
        var transformVideoMove : CGAffineTransform = CGAffineTransformTranslate(transformVideoRotate, 0, 0)
        var transform : CGAffineTransform = CGAffineTransformScale(transformVideoMove, 1, 1)
        layerInst.setTransform(transform, atTime: kCMTimeZero)
        
        var instraction :AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        instraction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(startTime, startTime))
        instraction.layerInstructions = NSArray(object: layerInst)
        var videoComposition : AVMutableVideoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.instructions = NSArray(object: instraction)
        videoComposition.frameDuration = CMTimeMake(1,24)
        //var durationSlow : CMTime = CMTimeSubtract(startTime, CMTimeMake(0,1));
        //var ii : Int64
        //ii = Int64(durationSlow.value.value) / 2
        //composition.scaleTimeRange(CMTimeRangeMake(CMTimeMake(0, 1),durationSlow), toDuration: CMTimeMake(ii , durationSlow.timescale))
        //[composition scaleTimeRange:CMTimeRangeMake(CMTimeMake(0, 1),durationSlow) toDuration:CMTimeMake(durationSlow.value /1.5, durationSlow.timescale)];

        
        //合成ファイルの出力
        var exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetMediumQuality)
        exporter.videoComposition = videoComposition
        let outputPath = (NSTemporaryDirectory()+"output"+String(0)+".mp4") as String
        let outputURL = NSURL(fileURLWithPath: outputPath)
        var fileManager : NSFileManager = NSFileManager.defaultManager()
        if(fileManager.fileExistsAtPath(outputPath))
        {
            fileManager.removeItemAtPath(outputPath, error: nil)
        }
        exporter.outputURL = outputURL
        exporter.outputFileType = AVFileTypeMPEG4
        exporter.exportAsynchronouslyWithCompletionHandler(
        {() -> Void in
          UISaveVideoAtPathToSavedPhotosAlbum(outputPath, self, nil, nil)
          target.finishJoinMovie()
        })
    }
}