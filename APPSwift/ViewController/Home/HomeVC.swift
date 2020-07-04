//
//  HomeVC.swift
//  APPSwift
//
//  Created by 峰 on 2020/6/22.
//  Copyright © 2020 north_feng. All rights reserved.
//

import UIKit

class HomeVC: APPBaseController {
    
    var array1 = [1,2,3,4,5]
    
    var array2 = ["a","b","c","d","f"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = UIColor.white
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        APPAlertTool.showLoading()
    }
    
}


