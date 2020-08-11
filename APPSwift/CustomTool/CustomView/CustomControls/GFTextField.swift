//
//  GFTextField.swift
//  APPSwift
//  自定义输入框
//  Created by 峰 on 2020/8/11.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

class GFTextField: UITextField {
    
    ///是否输入手机号
    var isPhoneNum:Bool = false
    
    ///是否展示 菜单
    var showMenuAction:Bool = false
    
    ///上一次文本长度
    private var uptextLength = 0
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
