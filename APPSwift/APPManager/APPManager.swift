//
//  APPManager.swift
//  APPSwift
//  APP管理者
//  Created by 峰 on 2020/6/23.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

class APPManager {
    
    ///管理者
    static let appManager:APPManager = APPManager()
    
    ///控制APP内的特征 模式 默认跟随系统
    var faceStyle:APPFaceTraitStyle = .systemModel
    
    ///用户信息
    var userInfo:APPUserInfoModel?
    
    ///是否已登录
    var isLogined:Bool = false
    
    ///是否登录过期
    var isLoginOverdue:Bool = false
    
    ///APP最新版本号
    var appVersion:String?
    
    ///存储用户信息的key
    private let Current_Login_User = "current_login_user"
    
    
    init() {
        //初始化本地数据 初始化本地用户信息(也可以指定到某个沙盒文件中去)
        let locaalData:Any? = UserDefaults.standard.object(forKey: Current_Login_User)
        
        var base64Data:NSData?
        
        if let data = locaalData as? NSData {
            base64Data = data
        }
        
        if base64Data != nil {
            
            let dataEncode = base64Data! as Data

            let dataUser = NSData(base64Encoded: dataEncode)
            
            userInfo = dataUser?.kj.model(APPUserInfoModel.self)//model转换
            
            isLogined = true
            isLoginOverdue = false
        }else{
            isLogined = false
            isLoginOverdue = false
        }
    }
    
    ///存储用户信息
    func storUserInfo(info:[String:Any]) {
        
        userInfo = info.kj.model(APPUserInfoModel.self)
        isLogined = true
        isLoginOverdue = false
        
        //let jsonStr:String = JSONString(from: userInfo ?? "")
        

    }
    
    
}
