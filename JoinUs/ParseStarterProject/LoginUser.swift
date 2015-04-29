//
//  LoginUser.swift
//  JoinUs
//
//  Created by 鈴木 嘉洋 on 2015/03/30.
//  Copyright (c) 2015年 Parse. All rights reserved.
//

import Foundation
import Parse
class LoginUser
{
    var _PFUser : PFUser
    var UserName : String?
    var FBuserId : String?
    var _delegate:GotLoginUserInfo
    init(users:PFUser,delegate:GotLoginUserInfo)
    {
        _PFUser = users
        _delegate = delegate
        FBRequest.requestForMe().startWithCompletionHandler(self.startWith)
    }
    private func startWith(connection:FBRequestConnection!,FBUser:AnyObject!,error:NSError!)
    {
        var m_FBuser = FBUser as NSDictionary
        self.UserName = m_FBuser.objectForKey("name") as String?
        self.FBuserId = m_FBuser.objectForKey("id") as String?
        println("UserName:\(UserName)")
        println("FBuserId:\(FBuserId)")
        
        GetPFuserInfo()
    }
    private func GetPFuserInfo()
    {
        var query = PFQuery(className: "MT_UserInfo")
        query.whereKey("FBUserId", equalTo: FBuserId)
        var finds = query.findObjects() as Array
        if(finds.count > 0)
        {
            //既存ユーザ情報の取得
            var MT_UserInfo = finds.first as PFObject
            UserName = MT_UserInfo.objectForKey("UserName") as? String
        }
        else
        {
            //新規ユーザの登録
            var MT_UserInfo = PFObject(className: "MT_UserInfo")
            MT_UserInfo.setObject(UserName, forKey: "UserName")
            MT_UserInfo.setObject(FBuserId, forKey: "FBUserId")
            MT_UserInfo.save()
        }
        _delegate.LoginUserGetFin(self)
    }
}
protocol GotLoginUserInfo
{
    func LoginUserGetFin(logInUser:LoginUser)
}
class LoginUserIF : NSObject
{
    class func SetNew(user:PFUser,delegate:GotLoginUserInfo)
    {
        _loginUser = LoginUser(users: user,delegate:delegate);
    }
    class func Get()->LoginUser
    {
        return _loginUser!;
    }
}
private var _loginUser:LoginUser?;