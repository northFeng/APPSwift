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
        
        
        let oneView = UIView()
        oneView.backgroundColor = UIColor.red
        self.view.addSubview(oneView)
        
        oneView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100)
            make.top.equalToSuperview().offset(150)
            make.width.height.equalTo(100)
        }
        
        let twoView = UIView()
        twoView.backgroundColor = UIColor.green
        self.view.addSubview(twoView)
        
        twoView.snp.makeConstraints { (make) in
            make.left.equalTo(oneView.snp.right)
            make.top.equalToSuperview().offset(150)
            make.width.height.equalTo(oneView).multipliedBy(2)
        }
        
        APPCache.setString(text: "点击的京东到家", key: "ffff")
                    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        

    }
    
}


