//
//  APPCache.swift
//  APPSwift
//  数据存储管理
//  Created by 峰 on 2020/7/7.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

import KeychainAccess

struct APPCache {
    
    private static let dataManager = Keychain(service: "APPCache")//Keychain(service: "APPCahe", accessGroup: "12ABCD3E4F.shared")
    
    //let keychain2 = Keychain(server: "https://github.com", protocolType: .https, authenticationType: .htmlForm)

    
    ///存储字符串
    static func setString(text:String, key:String) {
        
        //dataManager[key] = text
        try? dataManager.set(text, key: key)
    }
    
    ///获取字符串
    static func getString(key:String) -> String? {
        
        //dataManager[key]
        let text = try? dataManager.getString(key)
        return text
    }
    
    ///存储data
    static func setData(data:Data, key:String) {
        
        //dataManager[key] = text
        try? dataManager.set(data, key: key)
    }
    
    ///获取data
    static func getData(key:String) -> Data? {
        
        //dataManager[key]
        let data = try? dataManager.getData(key)
        return data
    }
    
    ///移除数据
    static func removeItem(key:String) {
        //dataManager[key] = nil
        try? dataManager.remove(key)
        /**
         do {
             try keychain.remove("kishikawakatsumi")
         } catch let error {
             print("error: \(error)")
         }
         */
    }
}
