//
//  Middle.swift
//  APPSwift
//  ReactiveSwift 用法
//  Created by 峰 on 2020/6/22.
//  Copyright © 2020 north_feng. All rights reserved.
//
import UIKit

import ReactiveSwift


class MiddleVC: APPBaseController {
    
    let textField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.createSignalMethods()
    }
    
    
    func createSignalMethods() {
        
        //通过信号发生器 创建冷信号
        let (signal, observer) = Signal<String, Error>.pipe()
        
        signal.map{string in string.uppercased()}.observe{value in Print(value)}
        
        observer.send(value: "a")
        
        observer.send(value: "b")

        observer.send(value: "c")
        
    }
}
