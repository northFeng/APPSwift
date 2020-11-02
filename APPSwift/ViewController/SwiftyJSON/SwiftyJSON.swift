//
//  SwiftyJSON.swift
//  APPSwift
//
//  Created by v_gaoyafeng on 2020/10/28.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

import SwiftyJSON


class SwiftyJSONController: APPBaseController {

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
    
    //用法 简书 https://www.jianshu.com/p/06376ca5a935
    
    /**
    方法一： 使用data数据创建一个JSON对象

     - parameter data:  用来解析的数据，data类型
     - parameter opt:   JSON解析的选项. 默认`.AllowFragments`.
     - parameter error: 用来返回错误的NSErrorPointer. 默认为`nil`.
     - returns: 创建的JSON对象
     */
    //public init(data:Data, options opt: JSONSerialization.ReadingOptions = .allowFragments, error: NSErrorPointer = nil)

    /**
     方法二：使用json字符串创建一个JSON对象

     - parameter string: 一个正常的json字符串，例如 '{"a":"b"}'
     - returns: 创建的JSON对象
     */
    //public static func parse(_ string:String) -> JSON

    /**
     方法三：使用一个对象创建一个JSON对象

     - parameter object:  这个对象必须有以下特性: 所有的对象是 NSString/String, NSNumber/Int/Float/Double/Bool, NSArray/Array, NSDictionary/Dictionary, 或 NSNull; 所有的字典的键是 NSStrings/String; NSNumbers 不允许是 NaN 或者 infinity.
     - returns: 创建的JSON对象
     */
    //public init(_ object: Any)
    
    /**
     方法四：用一个JSON对象的数组创建一个JSON对象

     - parameter jsonArray: 一个Swift数组，数组的元素为JSON对象

     - returns: 创建的JSON对象
     */
    //public init(_ jsonArray:[JSON])

    /**
     方法五：用一个值为JSON对象的字典创建一个JSON对象

     - parameter jsonDictionary: 一个Swif字典，字典的值是JSON对象

     - returns: 创建的JSON对象
     */
    //public init(_ jsonDictionary:[String: JSON])
    
    /**
     解析的数据类型包括(除了URL与null，其余的每种数据类型都包括有可选值和默认值，如果需要自定义默认值，可以使用解析结果为可选的类型，如果不需要，可以直接使用默认值，所有带有默认值的类型，都是在以Value为后缀。例如，string获取的就是可选的字符串，而stringValue获取的就是带有默认值的字符串，非可选)：
     */
    /**
     public var double: Double?
     public var doubleValue: Double
     public var float: Float?
     public var floatValue: Float
     public var int: Int?
     public var intValue: Int
     public var uInt: UInt?
     public var uIntValue: UInt
     public var int8: Int8?
     public var int8Value: Int8
     public var uInt8: UInt8?
     public var uInt8Value: UInt8
     public var int16: Int16?
     public var int16Value: Int16
     public var uInt16: UInt16?
     public var uInt16Value: UInt16
     public var int32: Int32?
     public var int32Value: Int32
     public var uInt32: UInt32?
     public var uInt32Value: UInt32
     public var int64: Int64?
     public var int64Value: Int64
     public var uInt64: UInt64?
     public var uInt64Value: UInt64

     public var URL: URL?

     public var null: NSNull?

     public var numberValue: NSNumber
     public var number: NSNumber?

     public var stringValue: String
     public var string: String?

     public var boolValue: Bool
     public var bool: Bool?

     public var dictionaryObject: [String : Any]?
     public var dictionaryValue: [String : JSON]
     public var dictionary: [String : JSON]?

     public var arrayObject: [Any]?
     public var arrayValue: [JSON]
     public var array: [JSON]?
     */
    
    
    func jsonData() {
        
        //创建json字典
        var jsonData: [String: Any] = [:]
        
        //填充数据
        jsonData["code"] = 200
        jsonData["result"] = true
        jsonData["message"] = "数据加载成功"
        jsonData["data"] = [["id"           : "资讯1_id",
                             "title"        : "资讯1_标题",
                             "pictrueUrl"   : "资讯1_图片",
                             "description"  : "资讯1_描述",
                             "categoryTitle": "资讯1_分类标题",
                             "tagArray"     : [["id":"yyy0bb1d82beb084718bbd88d45c39710d8","title":".net1"],
                                               ["id":"eee0bb1d82beb084718bbd88d45c39710d8","title":".net1"]],
                             "shareNumber"  : 1,
                             "clickNumber"  : 1],
                            
                            ["id"           : "资讯2_id",
                             "title"        : "资讯2_标题",
                             "pictrueUrl"   : "资讯2_图片",
                             "description"  : "资讯2_描述",
                             "categoryTitle": "资讯2_分类标题",
                             "tagArray"     : [["id":"yyy0bb1d82beb084718bbd88d45c39710d8","title":".net2"],
                                               ["id":"eee0bb1d82beb084718bbd88d45c39710d8","title":".net2"]],
                             "shareNumber"  : 2,
                             "clickNumber"  : 2]]
        
        
        /**
         JSON的实例对象 json[key] ——> 返回是 JSON 类型的实例！ ——>取值的时候，必须进行转换类型！
         */
        
        //获取JSON实例对象
        
        let jsonObj = JSON.init(jsonData)
            
        if jsonObj["result"].boolValue == false {
            print("获取失败")
        }
        if jsonObj["code"].intValue != 200 {
            print(jsonObj["message"].stringValue)
        }
        
        print(jsonObj["message"].stringValue)
        
        for dic in jsonObj["data"].arrayValue {
            print("id: ", dic["id"].stringValue)
            print("title: ", dic["title"].stringValue)
            print("pictrueUrl: ", dic["pictrueUrl"].stringValue)
            print("description: ", dic["description"].stringValue)
            print("categoryTitle: ", dic["categoryTitle"].stringValue)
            print("shareNumber: ", dic["shareNumber"].intValue)
            print("clickNumber: ", dic["clickNumber"].intValue)
            
            print("tagArray: ", dic["tagArray1"].arrayValue)
            for arr in dic["tagArray"].arrayValue {
                print("\t\ttagid: ", arr["id2"].stringValue)
                print("\t\ttitle: ", arr["title"].stringValue)
            }
        }
    }
    
}
