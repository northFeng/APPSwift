//
//  APPColorDefine.swift
//  APPSwift
//  颜色定义
//  Created by 峰 on 2020/6/28.
//  Copyright © 2020 north_feng. All rights reserved.
//

import UIKit

struct APPColorDefine {

    ///颜色 16进制的字符串
    static func colorHexString(color:String, alpha:CGFloat = 1.0) -> UIColor {
        
        // 存储转换后的数值
        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        
        var hex = color
        // 如果传入的十六进制颜色有前缀，去掉前缀
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 2)...])
        } else if hex.hasPrefix("#") {
            hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
        }
        // 如果传入的字符数量不足6位按照后边都为0处理，当然你也可以进行其它操作
        if hex.count < 6 {
            for _ in 0..<6-hex.count {
                hex += "0"
            }
        }

        // 分别进行转换
        // 红
        Scanner(string: String(hex[..<hex.index(hex.startIndex, offsetBy: 2)])).scanHexInt32(&red)
        // 绿
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)])).scanHexInt32(&green)
        // 蓝
        Scanner(string: String(hex[hex.index(hex.startIndex, offsetBy: 4)...])).scanHexInt32(&blue)

        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    ///获取动态颜色
    static func colorDynamicColor(lightStylecolor:UIColor, darkStylecolor:UIColor) -> UIColor {
        
        var color:UIColor = lightStylecolor
        
        if #available(iOS 13.0, *) {
            color = UIColor { (traitCollection:UITraitCollection) -> UIColor in
            
                if traitCollection.userInterfaceStyle == .light {
                    //浅色模式
                    return lightStylecolor
                } else if traitCollection.userInterfaceStyle == .dark  {
                    //黑暗模式
                    return darkStylecolor
                } else {
                    //默认浅色模式
                    return lightStylecolor
                }
            }
        }
        
        return color
    }
    
    
    //MARK: ************************* CGColor的动态颜色 *************************
    
    ///添加layer 边框颜色
    static func layerBorderColor(colorView:UIView, layer:CALayer, dynamicCOlor:UIColor) {
        APPXYColorApi.layerSupView(colorView, layer: layer, dynamicBorderColor: dynamicCOlor)
    }
    
    ///添加layer 阴影颜色
    static func layerShadowColor(colorView:UIView, layer:CALayer, dynamicCOlor:UIColor) {
        APPXYColorApi.layerSupView(colorView, layer: layer, dynamicShadowColor: dynamicCOlor)
    }
    
    ///添加layer 背景颜色
    static func layerBackgroundColor(colorView:UIView, layer:CALayer, dynamicCOlor:UIColor) {
        APPXYColorApi.layerSupView(colorView, layer: layer, dynamicBackgrounColor: dynamicCOlor)
    }
    
    //MARK: ************************* 定义颜色 *************************
    ///基础黑色
    static let black = COLOR("#000000")
    
    ///弹框暗黑模式黑色
    static let blackAlert = COLOR("2C2C2C")
    
    ///基础白色
    static let white = COLOR("#FFFFFF")
    
    ///系统黑暗模式 白亮文字颜色
    static let lightText = UIColor.lightText
}
