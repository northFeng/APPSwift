//
//  APPEnum.swift
//  APPSwift
//  APP内的枚举
//  Created by 峰 on 2020/6/19.
//  Copyright © 2020 north_feng. All rights reserved.
//

//--------------------------------------- 第三方头文件 ---------------------------------------
@_exported import SnapKit//布局
@_exported import KakaJSON//JSON数据 转 Model

//用法https://www.cnblogs.com/metaphors/p/9405432.html
@_exported import SwiftyJSON//SwiftyJSON使用来处理JSON数据，把 字符串、data——>转成JSON
@_exported import Kingfisher//图片加载

//--------------------------------------------------------------------------------------------


//MARK: ************************* 定义全局闭包函数 *************************
///常用回调
typealias APPBackClosure = (Bool, Any)->Void
///网络请求回调
typealias APPNetClosure = (Bool, Any, Int)->Void


///登录枚举
enum LoginType:Int {
    case sucess = 0
    case fail
}

