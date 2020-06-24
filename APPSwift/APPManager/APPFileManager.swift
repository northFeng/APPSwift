//
//  APPFileManager.swift
//  APPSwift
//  APP文件管理
//  Created by 峰 on 2020/6/24.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

struct APPFileManager {
    
    ///创建路径
    static func createFilePath(filePath:String) {
        
        let fm = FileManager.default
        
        if fm.fileExists(atPath: filePath) == false {
            //文件路径不存在
            try? fm.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    ///清除文件
    static func removeFileOfPath(filePath:String) {
        let fm = FileManager.default
        
        if fm.fileExists(atPath: filePath) == true {
            //文件路径不存在
            try? fm.removeItem(atPath: filePath)
        }
    }
    
    ///获取文件大小
    static func getFileSizeOfPath(filePath:String) -> UInt? {
        
        var size:UInt? = 0
        
        let attrFile: [FileAttributeKey : Any]? = try? FileManager.default.attributesOfItem(atPath: filePath)
        
        size = attrFile?[FileAttributeKey(rawValue: "NSFileSize")] as? UInt
        
        return size
    }
    
    ///遍历文件下所有文件计算大小
    static func getFolderSizeOfPath(folderPath:String, endBlock:@escaping APPBackClosure) {
        
        DispatchQueue.global().async {
            var size:UInt = 0
            
//            let fileEnumerator = FileManager.default.enumerator(atPath: folderPath)
//
//            while (fileEnumerator?.nextObject() as? String) != nil {
//
//                let itemPath = fileEnumerator?.nextObject() ?? ""
//
//                let filePath = folderPath + "/\(itemPath)"
//
//                size += self.getFileSizeOfPath(filePath: filePath) ?? 0
//
//            }
        
        
        
            let files:[String] = FileManager.default.subpaths(atPath: folderPath) ?? []
        
        
            if files.count > 0 {
                for fileName in files {
                    
                    let filePath = folderPath + "/" + fileName//子文件的路径
                    
                    let attrFile: [FileAttributeKey : Any]? = try? FileManager.default.attributesOfItem(atPath: filePath)
                    
                    let fileSize:UInt? = attrFile?[FileAttributeKey(rawValue: "NSFileSize")] as? UInt
                    
                    size += (fileSize ?? 0)
                }
            }
        
            DispatchQueue.main.async {
            
                endBlock(true, size)
            }
        }
    }
    
    ///获取Cache文件大小
    static func getCacheFileSize(endBlock:@escaping APPBackClosure) {
        
        let filePath = kAPP_File_CachePath!
        
        APPFileManager.getFolderSizeOfPath(folderPath: filePath, endBlock: endBlock)
    }
    
    
    ///清理Cache下的所有缓存
    static func clearDiskItemsOfCacheEndBlock(endBlock:@escaping APPBackClosure) {
        
        DispatchQueue.global().async {
        
            let folderPath = kAPP_File_CachePath!
            
            
            let files:[String] = FileManager.default.subpaths(atPath: folderPath) ?? []
            
            if files.count > 0 {
                    
                for fileName in files {
                        
                    let filePath = folderPath + "/" + fileName//子文件的路径
                        
                    APPFileManager.removeFileOfPath(filePath: filePath)//清除文件
                }
                
            }
            
            DispatchQueue.main.async {
                endBlock(true, 0)
            }
        }
    }
    
    
}
