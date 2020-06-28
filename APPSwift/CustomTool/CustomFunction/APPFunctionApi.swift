//
//  APPFunctionApi.swift
//  APPSwift
//  自添功能方法API
//  Created by 峰 on 2020/6/28.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

import UIKit

class APPFunctionApi {
    
    //MARK: ************************* Base64编码 *************************
    ///编码字符串--->base64字符串
    class func base64_encodeBase64String(encodeStr:String) -> String {
        
        ""
    }
    
    ///编码字符串--->base64data
    class func base64_encodeBase64String(encodeData:Data) -> String {
        ""
    }
    
    ///解码----->原字符串
    class func base64_decodeBase64String(base64Str:String) -> String {
        ""
    }
    
    ///解码----->原Data
    class func base64_decodeBase64Data(base64Data:Data) -> Data {
        Data()
    }
    
    ///字符串编码
    class func string_encode(string:String) -> String {
        
        let allowedCharacters = NSCharacterSet.urlQueryAllowed
        
        guard let codeString = string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else { return "" }
        
        return codeString
    }
    
    ///字符串解码
    class func string_deCode(string:String) -> String {
        
        guard let encodeString = string.removingPercentEncoding else { return "" }
        
        return encodeString
    }
    
    
    //MARK: ************************* 字符串功能 *************************
    ///
    class func string_getTextHeight(text:String, font:UIFont, spacing:CGFloat, widthFix:CGFloat) -> CGFloat {
        
        let textStr = text.count > 0 ? text : ""
        
        var height:CGFloat = 0.0
        
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()//段落样式
        paragraphStyle.lineSpacing = spacing//段落高度
        paragraphStyle.alignment = .justified//两端对齐
        
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let textRect = textStr.boundingRect(with: CGSize(width: widthFix, height: CGFloat.greatestFiniteMagnitude),options: option,attributes: [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle],context:nil)
        
        height = textRect.height
        
        return height
    }
    
    ///获取文字的宽度
    class func string_getTextWidth(text:String, font:UIFont, spacing:CGFloat, heightFix:CGFloat) -> CGFloat {
        
        let textStr = text.count > 0 ? text : ""
        
        var width:CGFloat = 0.0
        
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()//段落样式
        paragraphStyle.lineSpacing = spacing//段落高度
        paragraphStyle.alignment = .justified//两端对齐
        
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let textRect = textStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: heightFix),options: option,attributes: [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle],context:nil)
        
        width = textRect.width
        
        return width
    }
    
}
