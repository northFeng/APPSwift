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
    static func appVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
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
        
        var appStoreVersion = ""//商店版本号
        
        
        let url:URL? = URL(string: appUrl)
        
        if let appurl = url {
            
            //APP商店的信息
            let appInfoString = try? String(contentsOf: appurl, encoding: .utf8)
            
            let infoData:Data? = appInfoString?.data(using: .utf8)
            
            if let dataAPP = infoData {
                
                let appInfoDic = try? JSONSerialization.jsonObject(with: dataAPP, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                
                let arrayInfo:[Any]? = appInfoDic?["results"] as? [Any]
                
                let resultDic:[String:Any]? = arrayInfo?[0] as? [String:Any]
                
                //版本号
                let version:String? = resultDic?["version"] as? String
                
                appStoreVersion = version ?? ""
            }
        }
        
        return appStoreVersion
    }
    
    ///判断是否有新版本更新
    static func appHaveUpdate() -> String {
        
        let appStoreVersion = APPLoacalInfo.appStoreVersion()
        
        APPManager.appManager.appVersion = appStoreVersion
        
        let appLocalVerson = APPLoacalInfo.appVersion()
        
        let isUpdate = APPLoacalInfo.compareVersion(version1: appStoreVersion, version2: appLocalVerson)
        
        if isUpdate {
            return appStoreVersion
        }else{
            return ""
        }
    }

    ///版本大小比较  version1 > version2 ：true     version1 <= version2 ：false
    static func compareVersion(version1:String, version2:String) -> Bool {
        
        var isHaveUpdate:Bool = false//是否更新
        
        if version1.count > 0 && version2.count > 0 && version1 != version2 {
            let arrayOne:[String] = version1.components(separatedBy: ".")
            let arrayTwo:[String] = version2.components(separatedBy: ".")
            
            //取最长的
            let count = arrayOne.count >= arrayTwo.count ? arrayOne.count : arrayTwo.count
            
            for index in 0..<count {
                
                let numStrOne = index < arrayOne.count ? arrayOne[index] : ""
                let numStrTwo = index < arrayTwo.count ? arrayTwo[index] : ""
                
                if numStrOne.count > 0 && numStrTwo.count > 0 {
                    
                    //进行比较
                    let num1:Int = Int(numStrOne) ?? 0
                    let num2:Int = Int(numStrTwo) ?? 0
                    
                    if num1 > num2 {
                        isHaveUpdate = true
                        break;
                    } else if num1 < num2 {
                        //本地版本大于商店版本 ——> 这种情况只有未上线版本会出现
                        isHaveUpdate = false
                        break
                    } else {
                        //相等 继续循环
                    }
                    
                } else {
                    if numStrOne.count == 0 && numStrTwo.count > 0 {
                        //本地版本提前更新 && 本地版本号 长度变长
                        isHaveUpdate = false
                        break
                    } else if numStrOne.count > 0 && numStrTwo.count == 0{
                        //线上版本出现新版本
                        isHaveUpdate = true
                        break
                    }
                }
            }
            
        }
        
        return isHaveUpdate
    }
    
    
}
