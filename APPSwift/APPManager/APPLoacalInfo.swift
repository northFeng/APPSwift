//
//  APPLoacalInfo.swift
//  APPSwift
//  APP在本机信息汇总
//  Created by 峰 on 2020/6/24.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

struct APPLoacalInfo {
    
    ///设备人名字
    static func deviceName() -> String {
        return UIDevice.current.name
    }
    
    ///获取UUID
    static func UUIDString() -> String? {
        UIDevice.current.identifierForVendor?.uuidString
    }
    
    ///获取随机UUID
    static func UUIDCFString() -> String {
        let uuid_ref = CFUUIDCreate(nil)
        let uuid_string_ref = CFUUIDCreateString(nil, uuid_ref)
        let uuid:String = uuid_string_ref! as String
        
        var CUID = uuid.lowercased()//转换小写
        
        let arrayStr:[String] = CUID.components(separatedBy: "-")
        
        CUID = arrayStr.joined(separator: "")
        
        return CUID
    }
    
    ///手机系统版本号
    static func iosVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    ///app版本号
    static func appVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    ///APP名称
    static func appName() -> String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }
    
    ///app build版本
    static func appBuildVersion() -> String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    ///跳转到苹果商店
    static func gotoAppStore() {
        let appStoreUrl:URL? = URL(string: APPKeyInfo.appStoreUrl)
        
        if let url = appStoreUrl {
            UIApplication.shared.open(url)
        }
    }
    
    ///App Store商店版本号
    static func appStoreVersion() -> String {
        
        let appUrl = "http://itunes.apple.com/lookup?id=\(APPKeyInfo.APPId)"//中国 .com/cn/lookup?id=123444
        
        let url:URL? = URL(string: appUrl)
        
        if let appurl = url {
            
            //APP商店的信息
            let appInfoString = String(contentsOf: appurl, encoding: .utf8)
        }
        
    }
}
