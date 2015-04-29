//
//  UserAdd.swift
//  JoinUs
//
//  Created by 鈴木 嘉洋 on 2015/04/19.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import UIKit

class UserAdd : UIView,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    @IBOutlet weak var UIImage1: UIImageView!
    @IBOutlet weak var UIImage2: UIImageView!
    @IBOutlet weak var UIImage3: UIImageView!
    @IBOutlet weak var UIImage4: UIImageView!
    @IBOutlet weak var AddBTN1: UIButton!
    @IBOutlet weak var AddBTN2: UIButton!
    @IBOutlet weak var AddBTN3: UIButton!
    @IBOutlet weak var AddBTN4: UIButton!
    var parent : UIViewController?
    var imageSize : CGSize?
    var OriginalImageList : Array<UIImage> = Array<UIImage>()
    class func instance() -> UserAdd
    {
        return UINib(nibName: "UserAdd", bundle: nil).instantiateWithOwner(self, options: nil)[0] as UserAdd
    }
    
    func reinit(width : CGFloat,parent : UIViewController)
    {
        self.parent = parent
        var height : CGFloat = width / (1.618*1.618*1.618)
        self.frame.size.width = width
        self.frame.size.height = height
        imageSize = CGSize(width: height-5, height: height-5)
        UIImage1.frame.size = imageSize!
        UIImage2.frame.size = imageSize!
        UIImage3.frame.size = imageSize!
        UIImage4.frame.size = imageSize!
        UIImage1.frame.origin.y = 2.5
        UIImage2.frame.origin.y = 2.5
        UIImage3.frame.origin.y = 2.5
        UIImage4.frame.origin.y = 2.5
        UIImage1.frame.origin.x = 2
        UIImage2.frame.origin.x = UIImage1.frame.origin.x + imageSize!.width + 2
        UIImage3.frame.origin.x = UIImage2.frame.origin.x + imageSize!.width + 2
        UIImage4.frame.origin.x = UIImage3.frame.origin.x + imageSize!.width + 2
        AddBTN1.frame = UIImage1.frame
        AddBTN2.frame = UIImage2.frame
        AddBTN3.frame = UIImage3.frame
        AddBTN4.frame = UIImage4.frame
        disposition()
    }
    
    @IBAction func AddImage(sender: AnyObject)
    {
        AddAct()
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
        parent!.presentViewController(pickercontroller, animated: true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        parent!.dismissViewControllerAnimated(true, completion: nil)
        var originalImage : UIImage
        originalImage = image
        var width : CGFloat = imageSize!.width
        var height : CGFloat = imageSize!.height
        UIGraphicsBeginImageContext(CGSize(width: width, height: height));
        originalImage.drawInRect(CGRect(x: 0, y: 0, width: width, height: height))
        originalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        OriginalImageList.append(image)
        disposition()
    }
    
    func disposition()
    {
        
        switch OriginalImageList.count
        {
            case 4:
                UIImage1.hidden = false
                UIImage2.hidden = false
                UIImage3.hidden = false
                UIImage4.hidden = false
                AddBTN1.hidden = true
                AddBTN2.hidden = true
                AddBTN3.hidden = true
                AddBTN4.hidden = true
                break
            case 3:
                UIImage1.hidden = false
                UIImage2.hidden = false
                UIImage3.hidden = false
                UIImage4.hidden = true
                AddBTN1.hidden = true
                AddBTN2.hidden = true
                AddBTN3.hidden = true
                AddBTN4.hidden = false
                break
            case 2:
                UIImage1.hidden = false
                UIImage2.hidden = false
                UIImage3.hidden = true
                UIImage4.hidden = true
                AddBTN1.hidden = true
                AddBTN2.hidden = true
                AddBTN3.hidden = false
                AddBTN4.hidden = true
                break
            case 1:
                UIImage1.hidden = false
                UIImage2.hidden = true
                UIImage3.hidden = true
                UIImage4.hidden = true
                AddBTN1.hidden = true
                AddBTN2.hidden = false
                AddBTN3.hidden = true
                AddBTN4.hidden = true
                break
            case 0:
                UIImage1.hidden = true
                UIImage2.hidden = true
                UIImage3.hidden = true
                UIImage4.hidden = true
                AddBTN1.hidden = false
                AddBTN2.hidden = true
                AddBTN3.hidden = true
                AddBTN4.hidden = true
                break
            default:
                break
        }
        switch OriginalImageList.count
        {
            case 4:
            UIImage4.image = OriginalImageList[3]
            case 3:
            UIImage3.image = OriginalImageList[2]
            case 2:
            UIImage2.image = OriginalImageList[1]
            case 1:
            UIImage1.image = OriginalImageList[0]
            default:
            break

        }
        
    }
    
    
}