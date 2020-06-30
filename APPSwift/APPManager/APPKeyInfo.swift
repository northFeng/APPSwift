//
//  APPKeyInfo.swift
//  APPSwift
//  APP内第三方key处理
//  Created by 峰 on 2020/6/24.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

struct APPKeyInfo {
    
    ///测试服务器
    private static let debugHostUrl = "https://api.wdkid.com.cn/api/"
    
    ///release服务器
    private static let releaseHostUrl = "https://api.wdkid.com.cn/api/"
    
    ///APPId
    static let APPId = "1493177024"
    
    ///App Store商店地址
    static let appStoreUrl = String(format: "https://itunes.apple.com/app/id%@", APPKeyInfo.APPId)
    
    ///主机域名
    static func hostUrl() -> String {
        
        var hostUrl = APPKeyInfo.releaseHostUrl
        
        #if DEBUG
        
        hostUrl = APPKeyInfo.debugHostUrl
        
        #else
        
        hostUrl = APPKeyInfo.releaseHostUrl
        
        #endif
        
        return hostUrl
    }
        
}
