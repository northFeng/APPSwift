//
//  APPStoreApi.swift
//  APPSwift
//
//  Created by 峰 on 2020/7/22.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

import KeychainAccess

//MARK: ************************* 钥匙串存储 *************************
struct APPKeyChainApi {
    
    private static let dataManager = Keychain(service: "APPKeyChain")//Keychain(service: "APPCahe", accessGroup: "12ABCD3E4F.shared")
    
    //let keychain2 = Keychain(server: "https://github.com", protocolType: .https, authenticationType: .htmlForm)

    ///是否 包含 某个key
    static func containKey(key:String) -> Bool {
        let have = try? dataManager.contains(key)
        return have ?? false
    }
    
    ///存储 字符串
    static func setString(text:String, key:String) {
        
        //dataManager[key] = text
        try? dataManager.set(text, key: key)
    }
    
    ///获取 字符串
    static func getString(key:String) -> String? {
        
        //dataManager[key]
        let text = try? dataManager.getString(key)
        return text
    }
    
    ///存储 data
    static func setData(data:Data, key:String) {
        
        //dataManager[key] = text
        try? dataManager.set(data, key: key)
    }
    
    ///获取 data
    static func getData(key:String) -> Data? {
        
        //dataManager[key]
        let data = try? dataManager.getData(key)
        return data
    }
    
    ///移除某个数据
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
    
    ///移除所有数据
    static func removeAllItem() {
        try? dataManager.removeAll()
    }
}


//MARK: ************************* 数据存储 *************************

import Cache //https://github.com/hyperoslo/Cache

struct APPCacheApi {
    
    /**
     持的类型

     Primitives like Int, Float, String, Bool, ...
     Array of primitives like [Int], [Float], [Double], ...
     Set of primitives like Set<String>, Set<Int>, ...
     Simply dictionary like [String: Int], [String: String], ...
     Date
     URL
     Data
     */
    
    
    ///磁盘保存路径
    private static let diskPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/AppCahceData"
    ///磁盘配置     try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,appropriateFor: nil, create: true).appendingPathComponent("MyPreferences")     过期时间 .date(Date().addingTimeInterval(60*60*24*7))
    private static let diskConfig = DiskConfig(name: "APPCacheData", expiry: .never, directory: URL(fileURLWithPath: diskPath), protectionType: .complete)
    ///内存配置
    private static let memoryConfig = MemoryConfig(expiry: .never, countLimit: 20, totalCostLimit: 0)
    ///存储对象
    private static let dataManager = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forData())
    
    ///是否 包含 某个key
    static func containKey(key:String) -> Bool {
        let have:Bool = try! dataManager?.existsObject(forKey: key) ?? false
        return have
    }
    
    ///存储 字符串
    static func setString(text:String, key:String) {

        let stringManager = dataManager?.transformCodable(ofType: String.self)
        
        stringManager?.async.setObject(text, forKey: key, completion: { (result) in
            switch result {
              case .value:
                print("saved successfully")
              case .error(let error):
                print(error)
            }
        })
    }
    
    ///获取 字符串
    static func getString(key:String) -> String? {
        
        let stringManager = dataManager?.transformCodable(ofType: String.self)
        
        let text = try? stringManager?.object(forKey: key)
        
        /**
        stringManager?.async.object(forKey: key, completion: { (result) in
            switch result {
              case .value(let city):
                print("my favorite city is \(city)")
              case .error(let error):
                print(error)
            }
        })
         */
        
        return text
    }
    
    ///存储 data
    static func setData(data:Data, key:String) {

        dataManager?.async.setObject(data, forKey: key, completion: { (result) in
            switch result {
              case .value:
                print("saved successfully")
              case .error(let error):
                print(error)
            }
        })
    }
    
    ///获取 data
    static func getData(key:String) -> Data? {
        
        let data = try? dataManager?.object(forKey: key)
        
        return data
    }
    
    ///移除某个数据
    static func removeItem(key:String) {
        dataManager?.async.removeObject(forKey: key, completion: { (result) in
            switch result {
              case .value:
                print("removal completes")
              case .error(let error):
                print(error)
            }
        })
    }
    
    ///移除所有数据
    static func removeAllItem() {
        dataManager?.async.removeAll(completion: { (result) in
            switch result {
              case .value:
                print("removal completes")
              case .error(let error):
                print(error)
            }
        })
    }
    
}
