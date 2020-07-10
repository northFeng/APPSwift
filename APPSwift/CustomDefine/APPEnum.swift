//
//  APPEnum.swift
//  APPSwift
//  APP内的枚举
//  Created by 峰 on 2020/6/19.
//  Copyright © 2020 north_feng. All rights reserved.
//

//--------------------------------------- 系统框架 ---------------------------------------


//--------------------------------------------------------------------------------------------

//--------------------------------------- 第三方头文件 ---------------------------------------
@_exported import SnapKit//布局
//@_exported import KakaJSON//JSON数据 转 Model

//用法https://www.cnblogs.com/metaphors/p/9405432.html
//@_exported import SwiftyJSON//SwiftyJSON使用来处理JSON数据，把 字符串、data——>转成JSON

//RAS (OC版RAC) 会与 KKJson框架冲突
//@_exported import ReactiveSwift

//RxSwift 讲解系列https://www.jianshu.com/p/f61a5a988590
//@_exported import RxSwift
//@_exported import RxCocoa//纯Swift开发 这个框架不需要， RxCocoa：是基于 RxSwift针对于 iOS开发的一个库，它通过 Extension 的方法给原生的比如 UI 控件添加了 Rx 的特性，使得我们更容易订阅和响应这些控件的事件。

//--------------------------------------------------------------------------------------------


//MARK: ************************* 定义全局闭包函数 *************************
///常用回调
typealias APPBackClosure = (Bool, Any)->Void
///网络请求回调
typealias APPNetClosure = (Bool, Any, Int)->Void

///APP内的特征集合模式
enum APPFaceTraitStyle {
    ///跟随系统
    case systemModel
    ///浅色模式
    case lightModel
    ///深色模式
    case darkModel
}

///登录枚举
enum LoginType:Int {
    case sucess = 0
    case fail
}

