//
//  APPExtension.swift
//  APPSwift
//
//  Created by 峰 on 2020/6/29.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

//MARK: ************************* String扩展 *************************
import CommonCrypto
extension String {
    
    ///字符串截取
    func string_subscript(range:ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start...end])
    }
    
    ///MD5加密
    func md5_gf() -> String {
        let strs = self
        let str = strs.cString(using: String.Encoding.utf8)
         let strLen = CUnsignedInt(strs.lengthOfBytes(using: String.Encoding.utf8))
         let digestLen = Int(CC_MD5_DIGEST_LENGTH)
         let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
         CC_MD5(str!, strLen, result)
         let hash = NSMutableString()
         for i in 0 ..< digestLen {
             hash.appendFormat("%02x", result[i])
         }
         result.deallocate()
         return String(format: hash as String)
    }
    
}

//MARK: ************************* Array扩展 *************************
extension Array {
    ///获取下标元素
    func getItem_gf(_ index:Int) -> Element? {
        if self.count > 0 && index >= 0 && index < self.count {
            return self[index]
        }else{
            return nil
        }
    }
    
    ///添加元素
    mutating func addItem_gf(_ item:Element?) {
        if let elemet = item {
            self.append(elemet)
        }
    }
    
    ///删除一个元素
    mutating func removeAtIndex_gf(_ index:Int) {
        if index <= self.count - 1 && index >= 0 && self.count > 0 {
            self.remove(at: index)
        }
    }
    
    ///删除某个元素
    mutating func removeItem_gf(_ item:Element) {
        for index in indexs(item).reversed() {
            self.remove(at: index)
        }
    }
    
    ///获取相同元素的所有位置
    mutating func indexs(_ item:Element) -> [Int] {
        var indexs = [Int]()
        for index in 0..<count where self[index] as AnyObject === item as AnyObject  {
            indexs.append(index)
        }
        return indexs
    }
    
    ///获取元素首次出现的位置
    func indexFirst(_ item:Element) -> Int? {
        for (index, value) in self.enumerated() where value as AnyObject === item as AnyObject {
            
            return index
        }
        return nil
    }
    
    ///获取元素最后出现的位置
    mutating func indexLast(_ item:Element) -> Int? {
        return indexs(item).last
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
