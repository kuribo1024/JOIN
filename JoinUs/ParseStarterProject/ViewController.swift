//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController,GotLoginUserInfo
{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginns(user:PFUser?, error:NSError?)
    {
        if ((user==nil))
            {
                if ((error==nil))
                {
                    NSLog("Facebook ログインをユーザーがキャンセル");
                }
                else
                {
                    NSLog("Facebook ログイン中にエラーが発生: %@", error!);
                }
        }
        else if (user!.isNew)
        {
            NSLog("Facebook サインアップ & ログイン完了!");
            LoginUserIF.SetNew(user!,delegate:self)
        }
        else
        {
            NSLog("Facebook ログイン完了!");
            NSLog("%@",user!.username);
            LoginUserIF.SetNew(user!,delegate:self)
        }
    }
    @IBAction func ButtonOn(sender: AnyObject)
    {
        var PermissionArray: NSArray;
        PermissionArray=["user_about_me", "user_relationships","user_birthday"];

        PFFacebookUtils.logInWithPermissions(PermissionArray, block: loginns);
    }
    func LoginUserGetFin(logInUser:LoginUser)
    {
        println("FBUserInfo Got")

    }
    
}

