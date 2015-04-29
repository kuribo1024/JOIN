//
//  CreateItem.swift
//  JoinUs
//
//  Created by 鈴木 嘉洋 on 2015/04/05.
//  Copyright (c) 2015年 Parse. All rights reserved.
//
import Foundation
import AVFoundation

//class AVPlayerView
//{
    //class func layerClass()
   // {
       // return AVPlayerLayer()
  //  }
//}
class CreateItemViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    @IBOutlet weak var PlayerBaseView: UIView!
    @IBOutlet weak var Member1: UIImageView!
    @IBOutlet weak var Member2: UIImageView!
    @IBOutlet weak var Member3: UIImageView!
    @IBOutlet weak var Member4: UIImageView!
    @IBOutlet weak var Member1Add: UIButton!
    @IBOutlet weak var Member2Add: UIButton!
    @IBOutlet weak var Member3Add: UIButton!
    @IBOutlet weak var Member4Add: UIButton!
    //var PlayerView : AVPlayerView?
    var nowMember:UIImageView?
    var nowAddButton:UIButton?
    var nextMember:UIImageView?
    var nextAddButton:UIButton?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Member1.hidden = true
        Member2.hidden = true
        Member3.hidden = true
        Member4.hidden = true
        Member2Add.hidden = true
        Member3Add.hidden = true
        Member4Add.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func AddAct()
    {
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            return
        }
        
        var pickercontroller : UIImagePickerController
        pickercontroller = UIImagePickerController()
        pickercontroller.delegate = self
        pickercontroller.sourceType = UIImagePickerControllerSourceType.Camera
        
        pickercontroller.allowsEditing = true
        self.presentViewController(pickercontroller, animated: true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        var originalImage : UIImage
        originalImage = image
        var width : CGFloat = 100
        var height : CGFloat = 100
        UIGraphicsBeginImageContext(CGSize(width: width, height: height));
        originalImage.drawInRect(CGRect(x: 0, y: 0, width: width, height: height))
        nowMember!.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        nowMember!.hidden = false
        nowAddButton!.hidden = true
        if(!(nextAddButton == nil))
        {
            nextAddButton!.hidden = false
        }
    }
    @IBAction func TakeMovie_TouchUp(sender: AnyObject)
    {
        //動画撮影画面に遷移させる
        var nextViewController : TakeMovieViewController = storyboard!.instantiateViewControllerWithIdentifier("TakeMovieViewController") as TakeMovieViewController
        presentViewController(nextViewController, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func Member1AddAct(sender: AnyObject)
    {
        nowMember = Member1
        nowAddButton = Member1Add
        nextMember = Member2
        nextAddButton = Member2Add
        AddAct()
    }
    @IBAction func Member2AddAct(sender: AnyObject)
    {
        nowMember = Member2
        nowAddButton = Member2Add
        nextMember = Member3
        nextAddButton = Member3Add
        AddAct()
    }
    @IBAction func Member3AddAct(sender: AnyObject)
    {
        nowMember = Member3
        nowAddButton = Member3Add
        nextMember = Member4
        nextAddButton = Member4Add
        AddAct()
    }
    @IBAction func Member4AddAct(sender: AnyObject)
    {
        nowMember = Member4
        nowAddButton = Member4Add
        nextMember = nil
        nextAddButton = nil
        AddAct()
    }
    
    
}

