//
//  HomeVC.swift
//  APPSwift
//
//  Created by 峰 on 2020/6/22.
//  Copyright © 2020 north_feng. All rights reserved.
//

import UIKit

class HomeVC: APPBaseController {
    
    var array1 = [String]()
    
    var array2 = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = UIColor.white
        
        Print("时间戳---\(APPDateTool.date_currentTimeStamp(precision: 1))")
        
    }
}
