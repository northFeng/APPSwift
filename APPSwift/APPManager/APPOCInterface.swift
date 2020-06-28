//
//  APPOCInterface.swift
//  APPSwift
//  OC使用Swift接口
//  Created by 峰 on 2020/6/28.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

class APPOCInterface: NSObject {
    
    @objc class func forcedExitUserWithShowControllerItemIndex(index:NSInteger) {
        
        APPManager.appManager.forcedExitUserWithShowController(showIndex: index)
    }
    
    
}
