//
//  TakeMovie.swift
//  JoinUs
//
//  Created by 鈴木 嘉洋 on 2015/04/11.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation
class MovieData
{
    var speed : Int64?
    var path :NSURL?
}

class ButtonState
{
    var N_NowTake : Bool = false;
    var H_NowTake : Bool = false;
    var N_Down : Bool = false;
    var H_Down : Bool = false;
}

class TakeMovieViewController :UIViewController,AVCaptureFileOutputRecordingDelegate
{
    @IBOutlet weak var TakeMovieButton: UIButton!
    @IBOutlet weak var TakeMovie3baiButton: UIButton!
    
    @IBOutlet weak var PreView: UIView!
    @IBOutlet weak var ProgressBar: UIProgressView!
    //撮影動画数
    var _MovieCount : Int32 = 1
    //撮影動画出力先パスリスト
    var _MovieOutPutPaths : Array<MovieData>?
    //AVセッション
    var _Session : AVCaptureSession?
    //出力でバイス
    var _Output : AVCaptureMovieFileOutput?
    var _Output2 : AVCaptureMovieFileOutput?
    //プレビュー用のアウトプット
    var _StillImageOutput : AVCaptureStillImageOutput?
    //進捗制御用のタイマー
    var _Timer : NSTimer?
    var _BState : ButtonState = ButtonState();
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //動画取得数の初期化
        _MovieCount  = 1;
        _MovieOutPutPaths = Array<MovieData>()
        //*****************
        //セッッションの初期化
        //*****************
        _Session = AVCaptureSession()
        _Session!.sessionPreset = AVCaptureSessionPresetMedium
        
        //*****************
        //入力デバイスの設定
        //*****************
        var _AVCaptureDevice : AVCaptureDevice?
        _AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var Input :AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(_AVCaptureDevice, error: nil) as AVCaptureDeviceInput
        
        //セッションに入力デバイスを追加
        _Session?.addInput(Input)
        
        //*****************
        //出力デバイスの追加
        //*****************
        _Output  = AVCaptureMovieFileOutput()
        var MaxDuration : CMTime
        MaxDuration = CMTimeMakeWithSeconds(60, 30)
        
        _Output!.maxRecordedDuration = MaxDuration
        _Output!.minFreeDiskSpaceLimit = 1024 * 1024
        
        //セッションに出力デバイスを追加
        _Session?.addOutput(_Output!)
        
        //*****************
        //プレビューの作成
        //*****************
        _StillImageOutput = AVCaptureStillImageOutput()
        
        //セッッションに出力デバイスを追加
        _Session!.addOutput(_StillImageOutput!)
        
        
        //キャプチャーセッションから入力のプレビュー表示を追加
        var previewLayer : AVCaptureVideoPreviewLayer?
        previewLayer = AVCaptureVideoPreviewLayer(session: _Session)
        previewLayer?.frame = PreView.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        var viewLayer : CALayer = PreView.layer
        
        viewLayer.masksToBounds = true
        viewLayer.addSublayer(previewLayer)
        
        //セッションの開始
        _Session?.startRunning()
        
        
        //*****************
        //入力デバイスの設定
        //*****************
        var frontInput : AVCaptureDeviceInput?
        var devices : Array<AVCaptureDevice> = AVCaptureDevice.devices() as Array<AVCaptureDevice>
        for device in devices
        {
            if(device.hasMediaType(AVMediaTypeVideo))
            {
                if(device.position == AVCaptureDevicePosition.Front)
                {
                    frontInput = AVCaptureDeviceInput(device: device, error: nil)
                }
            }
        }
        
        
        //TMPファイルの削除
        MovieManager.RemoveTmpFile()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func TakeMovie3bai_TouchDown(sender: UIButton)
    {
        _BState.H_Down = true;
        if(!_BState.N_NowTake)
        {
            _BState.H_NowTake = true;
            TakeMovieButton.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
            //動画撮影の準備
            var outputPath = String(NSTemporaryDirectory()+"output"+String(_MovieCount)+".mp4")
            var fileUrl = NSURL(fileURLWithPath: outputPath)
            //動画撮影の開始
            _Output?.startRecordingToOutputFileURL(fileUrl, recordingDelegate: self)
        }
    }
    @IBAction func TakeMovie_TouchDown(sender: UIButton)
    {
        _BState.N_Down = true;
        if(!_BState.H_NowTake)
        {
            _BState.N_NowTake = true;
            TakeMovie3baiButton.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
            //動画撮影の準備
            var outputPath = String(NSTemporaryDirectory()+"output"+String(_MovieCount)+".mp4")
            var fileUrl = NSURL(fileURLWithPath: outputPath)
            //動画撮影の開始
            _Output?.startRecordingToOutputFileURL(fileUrl, recordingDelegate: self)
        }
    }
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!)
    {
        
        _Timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "Timer", userInfo: nil, repeats: true)
        
        _Timer?.fire()
    }
    func Timer()
    {
        if(_BState.N_NowTake)
        {
            ProgressBar.setProgress(ProgressBar.progress + 0.00166, animated:true)
        }
        if(_BState.H_NowTake)
        {
            ProgressBar.setProgress(ProgressBar.progress + 0.00166 / 3, animated:true)
        }
        if(ProgressBar.progress >= 1)
        {
            _Output?.stopRecording()
        }
    }
    @IBAction func TakeMovie_TouchUpOutSide(sender: UIButton)
    {
        _BState.N_Down = false;
        if(_BState.N_NowTake)
        {
            _Output?.stopRecording()
        }
    }
    
    @IBAction func TakeMovie_TouchUp(sender: UIButton)
    {
        _BState.N_Down = false;
        if(_BState.N_NowTake)
        {
            _Output?.stopRecording()
        }
    }
    
    @IBAction func TakeMovie3bai_TouchUpOutSide(sender: AnyObject)
    {
        _BState.H_Down = false;
        if(_BState.H_NowTake)
        {
            _Output?.stopRecording()
        }
        
    }
    
    @IBAction func TakeMovie3bai_TouchUp(sender: AnyObject)
    {
        _BState.H_Down = false;
        if(_BState.H_NowTake)
        {
            _Output?.stopRecording()
        }
    }
    //AVCaptureFileOutputRecordingDelegate
    //動画の取得処理終了
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!)
    {
        _Timer?.invalidate()
        var movieData = MovieData()
        movieData.path = outputFileURL
        if(_BState.N_NowTake)
        {
            movieData.speed = 1
            _BState.N_NowTake = false;
            TakeMovie3baiButton.backgroundColor = TakeMovieButton.backgroundColor
            
        }
        else if(_BState.H_NowTake)
        {
            movieData.speed = 3
            _BState.H_NowTake = false;
            TakeMovieButton.backgroundColor = TakeMovie3baiButton.backgroundColor
            
        }
        _MovieOutPutPaths?.insert(movieData, atIndex: _MovieOutPutPaths!.count)
        _MovieCount += 1
        
        
        if(ProgressBar.progress >= 1)
        {
            TakeMovie3baiButton.enabled = false;
            TakeMovieButton.enabled = false;
            MovieManager.JoinMovie(_MovieOutPutPaths!,target: self)
            
        }
        if(_BState.H_Down)
        {
            if(ProgressBar.progress < 1)
            {
                TakeMovie3bai_TouchDown(TakeMovie3baiButton)
            }
        }
        else if(_BState.N_Down)
        {
            if(ProgressBar.progress < 1)
            {
                TakeMovie_TouchDown(TakeMovie3baiButton)
            }
        }
        
    }
    
    @IBAction func BackButton(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func finishJoinMovie()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}