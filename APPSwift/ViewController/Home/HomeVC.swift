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
        
        Print("array1:\(array1)\n  array2:\(array2)")
                
        array1.append("1")
        array1.append("2")
        array1.append("3")
        
        array2 = array1
        Print("array1:\(array1)\n  array2:\(array2)")
        
        array1.remove(at: 0)
        array2.addItem_gf(nil)
        
        
        Print("array1:\(array1)\n  array2:\(array2)")
        
    }
}
