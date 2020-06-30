//
//  APPExtension.swift
//  APPSwift
//
//  Created by 峰 on 2020/6/29.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

//MARK: ************************* String扩展 *************************
extension String {
    
    ///字符串截取
    func string_subscript(range:ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start...end])
    }
    
    
    
}

//MARK: ************************* Array扩展 *************************
extension Array {
    ///获取下标元素
    func getItem_gf(_ index:Int) -> Any? {
        if self.count > 0 && index >= 0 && index < self.count {
            return self[index]
        }else{
            return nil
        }
    }
    
    ///添加元素
    mutating func addItem_gf(_ item:Any?) {
        if let elemet = item {
            self.append(elemet as! Element)
        }
    }
    
    ///删除一个元素
    mutating func removeItem_gf(_ index:Int) {
        if index <= self.count - 1 && index >= 0 && self.count > 0 {
            self.remove(at: index)
        }
    }
}

//MARK: ************************* UIView扩展 *************************
extension UIView {
    
    ///frame
    var gf_Frame:CGRect {
        set {
            self.frame = newValue
        }
        get {
            self.frame
        }
    }
    
    ///坐标X
    var gf_X:CGFloat {
        set {
            var temp = self.frame
            temp.origin.x = newValue
            self.frame = temp
        }
        get {
            self.frame.origin.x
        }
    }
    
    ///坐标Y
    var gf_Y:CGFloat {
        set {
            var temp = self.frame
            temp.origin.y = newValue
            self.frame = temp
        }
        get {
            self.frame.origin.y
        }
    }
    
    ///宽度
    var gf_Width:CGFloat {
        set {
            var temp = self.frame
            temp.size.width = newValue
            self.frame = temp
        }
        get {
            self.frame.size.width
        }
    }
    
    ///高度
    var gf_Height:CGFloat {
        set {
            var temp = self.frame
            temp.size.height = newValue
            self.frame = temp
        }
        get {
            self.frame.size.height
        }
    }
    
    ///中心
    var gf_Center:CGPoint {
        set {
            self.center = newValue
        }
        get {
            self.center
        }
    }
    
    ///中心X
    var gf_CenterX:CGFloat {
        set {
            var temp = self.center
            temp.x = newValue
            self.center = temp
        }
        get {
            self.center.x
        }
    }
    
    
    ///中心Y
    var gf_CenterY:CGFloat {
        set {
            var temp = self.center
            temp.y = newValue
            self.center = temp
        }
        get {
            self.center.y
        }
    }
    
    ///最大X
    var gf_MaxX:CGFloat {
        self.gf_X + self.gf_Width
    }
    
    ///最大Y
    var gf_MaxY:CGFloat {
        self.gf_Y + self.gf_Height
    }
}

//MARK: ************************* UIButton扩展 *************************
extension UIButton {
    
    ///给按钮添加富文本
    func gf_addTitle(title:String, font:UIFont, color:UIColor, state:UIControl.State = .normal) {
        
        let attrString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:color])
        
        self.setAttributedTitle(attrString, for: state)
    }
}
