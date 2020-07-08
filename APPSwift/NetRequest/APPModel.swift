//
//  APPModel.swift
//  APPSwift
//  BaseModel类
//  Created by 峰 on 2020/6/28.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

import KakaJSON//JSON数据 转 Model

import ObjectMapper//模型转换

/**
 为了方便起见：所有的model的属性全部直接初始化！
 */

class BaseModel: Convertible {
    
    //类的属性，最后直接初始化一个值！
    //var name: String = ""
    //var age: Int = 0
    
    // 测试表明：在真机release模式下，对数字类型的let限制比较严格
    // 值虽然修改成功了（可以打印Cat结构体发现weight已经改掉了），但get出来还是0.0
    // 所以建议使用`private(set) var`取代`let`
    //private(set) var weight: Double = 0.0
    
    //NSNull类型
    //var data: NSNull?
    
    //Set要求存放的元素 【遵守Hashable协议】
    //var books:Set<BaseStruct>?
    
    
    // 由于Swift初始化机制的原因，`Convertible`协议强制要求实现init初始化器
    // 这样框架内部才可以完整初始化一个实例
    
    //子类可以重写该方法，进行key的 映射匹配
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        // 根据属性名来返回对应的key
        switch property.name {
            
        //1、模型的`nickName`属性 对应 JSON中的`nick_name`
        //case "nickName": return "nick_name" //采用枚举形式进行返回映射的key
            
        //2、模型剩下的其他属性，直接用属性名作为JSON的key（属性名和key保持一致）
        default: return property.name
            
        }
    }
    
    
    required init() {} //所有继承 BaseModel的类，则不用写这个方法了
}


/**  写法太麻烦了    用法：https://www.jianshu.com/p/609fbdb62274
 class User:, Mappable {
     var name: String?
     var age: Int?
     var nickname: String?
     var job: String?
     
     required init?(map: Map) {
         
     }
     func mapping(map: Map) {
         name <- map["name"]
         age <- map["age"]
         nickname <- map["nickname"]
         job <- map["job"]
     }
 }
 let jsonString = "{\"name\":\"objectmapper\",\"age\": 18,\"nickname\": \"mapper\",\"job\": \"swifter\"}"
 let user = User(JSONString: jsonString)
 let user = Mapper<User>().map(JSONString: JSONString)
 
 let JSONString = user.toJSONString(prettyPrint: true)
 let JSONString = Mapper().toJSONString(user, prettyPrint: true)
 */
