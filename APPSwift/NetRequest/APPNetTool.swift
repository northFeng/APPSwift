//
//  APPNetTool.swift
//  APPSwift
//  网络请求工具
//  Created by 峰 on 2020/6/28.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

import Alamofire//网络请求

//MARK: ************************* Alamofire用法 *************************
//官方文档：https://github.com/Alamofire/Alamofire
//https://www.cnblogs.com/jukaiit/p/9283498.html
//简书翻译中文版：https://www.jianshu.com/p/4381fe8e10b6   高级用法：https://github.com/Lebron1992/learning-notes/blob/master/docs/alamofire5/03%20-%20Alamofire%205%20的使用%20-%20高级用法.md

//MARK: ************************* 请求工具类 *************************

///网络请求回调
typealias NetSuccess = (Any?, Int)->Void
typealias NetFailure = (Error)->Void
typealias NetResultData = (Bool, Any?, Int)->Void

class APPNetTool {

    //创建一个静态或者全局变量，保存当前单例实例值
    private static let netTool = APPNetTool()

    //MARK: ************************* 网络请求失败常用语 *************************
    static let HTTPErrorCancleMessage = "请求被取消"
    static let HTTPErrorTimeOutMessage = "请求超时"
    static let HTTPErrorNotConnectedMessage = "网络连接断开"
    static let HTTPErrorOthersMessage = "网络不给力"
    static let HTTPErrorServerMessage = "服务器繁忙"

    static let resultCode = 20000;//成功码

    
    ///设置请求头信息
    var AFHeaders:HTTPHeaders {
       
        var headers = [String:String]()
        headers["type"] = "ios"
        headers["timestamp"] = APPDateTool.date_currentTimeStampString(precision: 1000)
       
        AF.sessionConfiguration.timeoutIntervalForRequest = 15//请求超时20秒
        
        return HTTPHeaders(headers)
    }

    ///请求数据
    func requestData(method:HTTPMethod, url:String, parameters:[String:Any], success:@escaping NetSuccess, fail:@escaping NetFailure) {
        
        AF.request(url, method: method, parameters: parameters, headers: AFHeaders).responseJSON { response in
            
            /**
             switch response.result {
             case .success:

                 //AFDataResponse
                 /**
                  if let data = response.data {
                              
                      success(data,100)
                  }
                  print(response.request)  // original URL request
                  print(response.response) // HTTP URL response
                  print(response.data)     // server data
                  print(response.result)   // result of response serialization
                  */
                 print("Validation Successful")
             case let .failure(error):
                 print(error)
             }
             */
            
            
            switch response.result {
            
            case .success:
                //处理成功
                if let jsonData = response.value  {
                    success(jsonData,200)
                }
            case .failure:
                //处理失败
                if let error = response.value {
                    fail(error as! Error)
                }
                break
            }
        }
    }


    //MARK: ************************* 常规get请求 *************************
    static func getData(url:String, params:[String:Any], success:@escaping NetSuccess, fail:@escaping NetFailure) {
        
        self.netTool.requestData(method: HTTPMethod.get, url: url, parameters: params, success: success, fail: fail )
    }

    func getData(url:String, params:[String:Any], success:@escaping NetSuccess, fail:@escaping NetFailure) {
        
        self.requestData(method: HTTPMethod.get, url: url, parameters: params, success: success, fail: fail )
    }

    //MARK: ************************* 常规post请求 *************************
    static func postData(url:String, params:[String:Any], success:@escaping NetSuccess, fail:@escaping NetFailure) {
        
        self.netTool.requestData(method: HTTPMethod.post, url: url, parameters: params, success: success, fail: fail )
    }

    func postData(url:String, params:[String:Any], success:@escaping NetSuccess, fail:@escaping NetFailure) {
        
        self.requestData(method: HTTPMethod.post, url: url, parameters: params, success: success, fail: fail )
    }


    //MARK: ************************* 普通请求 *************************
    static func getNetData(url:String, params:[String:Any], block:@escaping NetResultData) {
        
        let httpUrl:String = APPKeyInfo.hostUrl() + url
        
        self.getData(url: httpUrl, params: params, success: { (response, code) in
            //统一处理结果
            self.netSucessAnalyticalNetdata(response: response, block: block)
        }) { (error:Error) in
            block(false, HTTPErrorOthersMessage, 99)
        }
    }

    static func postNetData(url:String, params:[String:Any], block:@escaping NetResultData) {
        
        let httpUrl:String = APPKeyInfo.hostUrl() + url
        
        self.postData(url: httpUrl, params: params, success: { (response, code) in
            //统一处理结果
            self.netSucessAnalyticalNetdata(response: response, block: block)
        }) { (error:Error) in
            block(false, HTTPErrorOthersMessage, 99)
        }
    }
    
    ///统一处理数据
    static func netSucessAnalyticalNetdata(response:Any?, block:@escaping NetResultData) {
        
        let jsonData:[String:Any]? = response as? [String:Any]
        
        let code:Int = jsonData?["code"] as? Int ?? 99
        
        let message:String = jsonData?["message"] as? String ?? HTTPErrorOthersMessage
        
        let data = jsonData?["data"]
        
        if code == resultCode {
            block(true, data, 100)
        }else{
            block(false, message, code)
        }
        
        //后台协商进行用户登录异常提示 && 强制用户退出
        if (code == 20019) {

            //用户登录过期 && 执行退出
            APPManager.appManager.forcedExitUserWithShowController(showIndex: 0)
        }
    }

    //pod 'Networking', '~> 4'  https://github.com/3lvis/Networking
    //MARK: ************************* 封装AFNetworking *************************
    static func getRequestData(url:String, params:[String:Any], block:@escaping NetResultData) {
        
        let httpUrl:String = APPKeyInfo.hostUrl() + url
        
        APPHttpTool.getRequestNetDicDataUrl(httpUrl, params: params) { (result:Bool, idObject:Any, code:Int) in
            
            block(result, idObject, code);//逃逸闭包注意 循环引用
        }
    }

    static func postRequestData(url:String, params:[String:Any], block:@escaping NetResultData) {
        
        let httpUrl:String = APPKeyInfo.hostUrl() + url
       
        APPHttpTool.postRequestNetDicDataUrl(httpUrl, params: params) { (result:Bool, idObject:Any, code:Int) in
            
            block(result, idObject, code);
        }
    }

    //MARK: ************************* Model <——> 模型 *************************
    ///模型转换 jsonToModel(json:data, Model: Model.self)
    static func jsonToModel(json:Any, Model:BaseModel.Type) -> Any? {

        var model:Any?;
        if json is [String:Any] {
            //字典
            let jsonDic:[String : Any] = json as! [String : Any]
            
            model = jsonDic.kj.model(Model.self)//json.kj.model(model.self)

        } else if json is [Any] {
            //数组
            let jsonArray:[Any] = json as! [Any]
            
            model = jsonArray.kj.modelArray(Model.self)
            
        } else if json is String {
            //字符串
            let jsonString = json as! String
            model = jsonString.kj.model(Model.self)
        } else {
            model = nil
        }
        return model
    }

    ///model 转  字典
    static func modelToJsonObject(model:BaseModel) -> [String : Any] {
        
        let jsonDic:[String : Any] = model.kj.JSONObject()
        
        return jsonDic
    }

    ///model 转  字符串
    static func modelToJsonString(model:BaseModel) -> String {
        
        let jsonString:String = model.kj.JSONString()
        
        return jsonString
    }
    
    ///model 转 data
    static func modelToJsonData(model:BaseModel) -> Data {
        
        let jsonString:String = model.kj.JSONString()
        let data = jsonString.data(using: .utf8)
        
        return data ?? Data()
    }
}
