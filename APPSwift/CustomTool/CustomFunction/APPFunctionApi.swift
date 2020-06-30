//
//  APPFunctionApi.swift
//  APPSwift
//  自添功能方法API
//  Created by 峰 on 2020/6/28.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation


class APPFunctionApi {
    
    //MARK: ************************* 数据 转 字典 *************************
    ///json 转 字典
    static func dictionaryFromJson(json:Any?) -> [String:Any] {
        
        var dic:[String:Any]? = nil
        
        var jsonDta:Data? = nil
        
        if json is [String:Any] {
            //字典
            dic = json as? [String:Any]
        }else if json is String {
            //字符串
            let jsonString = json as! String
            jsonDta = jsonString.data(using: .utf8)
        }else if json is Data {
            //数据
            let dataJson = json as! Data
            jsonDta = dataJson
        }
        
        if let dataJson = jsonDta {
            let dicJson = try? JSONSerialization.jsonObject(with: dataJson, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
            dic = dicJson
        }
        
        return dic ?? [:]
    }
    
    //MARK: ************************* 字符串 编码处理 *************************
    ///编码字符串--->base64字符串
    class func base64_encodeBase64String(encodeStr:String) -> String? {
        
        let encodeData = encodeStr.data(using: .utf8)
        
        let base64Str:String? = encodeData?.base64EncodedString()
        
        return base64Str
    }
    
    ///编码字符串--->base64data
    class func base64_encodeBase64String(encodeData:Data) -> String {
        
        let encodeStr = encodeData.base64EncodedString()
        
        return encodeStr
    }
    
    ///解码----->原字符串
    class func base64_decodeBase64String(base64Str:String) -> String? {
        
        let decodeStr:String? = String(data: Data(base64Encoded: base64Str) ?? Data(), encoding: .utf8)
        
        return decodeStr
    }
    
    ///解码----->原Data
    class func base64_decodeBase64Data(base64Data:Data) -> Data? {
        
        let decodeData:Data? = Data(base64Encoded: base64Data)
        
        return decodeData
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
    
    ///获取富文本字符串
    class func string_getAttributeString(text:String, font:UIFont, color:UIColor, spacing:CGFloat, alignment:NSTextAlignment) -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        paragraphStyle.alignment = alignment
        
        let attrString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:color,NSAttributedString.Key.paragraphStyle:paragraphStyle])
        
        return attrString
    }
    
    ///获取文字段内指定文字所有的范围集合1
    class func string_getSameStringRangeArray_1(superStr:String, searchStr:String) -> [NSRange] {
        
        var rangArray:[NSRange] = [NSRange]()
        
        var searchRange = NSMakeRange(0, superStr.count)
        
        var range = NSMakeRange(0, 0)
        
        
        //无限循环处理 找 位置
        while range.location != NSNotFound && searchRange.location < superStr.count {
            
            let rangSearch:Range? = superStr.range(of: searchStr)
            
            if let rangeSea = rangSearch {
                range = NSRange(rangeSea,in: superStr)
                if range.location != NSNotFound {
                    searchRange.location = range.location + range.length
                    searchRange.length = superStr.count - searchRange.location
                    let rangeTwo = range
                    rangArray.append(rangeTwo)
                }
            }
        }
        
        return rangArray
    }
    
    //////获取文字段内指定文字所有的范围集合2
    class func string_getSameStringRangeArray_2(superStr:String, searchStr: String) -> [Range<String.Index>] {
        var rangeArray = [Range<String.Index>]()
        var searchedRange: Range<String.Index>
        
        guard let sr = superStr.range(of: superStr) else {
            return rangeArray
        }
        searchedRange = sr

        var resultRange = superStr.range(of: searchStr, options: .regularExpression, range: searchedRange, locale: nil)
        
        while let range = resultRange {
            rangeArray.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = superStr.range(of: searchStr, options: .regularExpression, range: searchedRange, locale: nil)
        }
        
        return rangeArray
    }
    
    ///获取文字段内指定文字所有的范围集合3
    func string_getSameStringRangeArray_3(superStr:String, searchStr: String) -> [NSRange] {
        return APPFunctionApi.string_getSameStringRangeArray_2(superStr: superStr, searchStr: searchStr).map { (range) -> NSRange in
            APPFunctionApi.range_toNSRange(fromRange: range, superStr: superStr)
        }
    }
    
    //MARK: ************************* NSRange <——> Range *************************
    class func range_toNSRange(fromRange range : Range<String.Index>, superStr:String) -> NSRange {
        
        return NSRange(range, in: superStr)
    }
    
    class func rnageNs_toRange(fromRange range:NSRange, superStr:String) -> Range<String.Index>? {
        
        return Range(range,in: superStr)
    }
}
