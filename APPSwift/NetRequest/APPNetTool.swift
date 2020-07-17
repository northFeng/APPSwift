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
//Alamofire全面讲解系列 https://www.jianshu.com/p/f39ad2a3c10b
//MARK: ************************* 请求工具类 *************************

///网络请求 响应code
enum APPNetStatus {
    ///请求成功
    case sucess(code:Int)
    ///后台请求成功 数据code异常
    case fail(code:Int)
    ///http错误
    case failHttp(code:Int)
    ///只携带code
    case result(code:Int)
}

///网络请求回调
typealias NetSuccess = (Any?, Int)->Void //网络请求成功回调
typealias NetFailure = (AFError)->Void //网络失败回调
typealias NetResultData = (Bool, Any?, APPNetStatus)->Void //网络请求回调（包括成功 与 失败）

///APP请求类
class APPNetTool {
    
    //创建一个静态或者全局变量，保存当前单例实例值
    static let netTool = APPNetTool()
    
    //网络状态类型
    enum NetworkStatus:Int {
        case StatusUnknown = -1 //未知网络
        case StatusNotReachable = 0 //没有网络
        case StatusReachableViaWWAN = 1 //蜂窝网络
        case StatusReachableViaWiFi = 2 //WiFi
    }
    var networkStats:NetworkStatus = NetworkStatus.StatusReachableViaWWAN
    let netManager = NetworkReachabilityManager(host: "www.baidu.com")
    
    //网络请求管理数组
    var allDataRequest = [DataRequest]()
    
}


//MARK: ************************* 网络状态监控 *************************
extension APPNetTool {
    
    ///开始网络监测
    func startNetworkMonitoring() {
        
        netManager?.startListening(onQueue: DispatchQueue.global(), onUpdatePerforming: { (status) in
            switch status {
            case .unknown:
                //It is unknown whether the network is reachable. 未知网络
                self.networkStats = .StatusUnknown
            case .notReachable:
                //The network is not reachable. 网络不可访问
                self.networkStats = .StatusNotReachable
            case .reachable(let netType):
                switch netType {
                case .ethernetOrWiFi:
                    //The connection type is either over Ethernet or WiFi.
                    self.networkStats = .StatusReachableViaWWAN
                case .cellular:
                    //The connection type is a cellular connection. 蜂窝网络
                    self.networkStats = .StatusReachableViaWiFi
                }
            }
            Print("网络状态变化--->\(String(describing: self.networkStats))")
            //网络发生变化在此进行通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kGlobal_NetworkingReachabilityChangeNotification), object: self.networkStats)
        })
    }
}

//MARK: ************************* 网络请求 *************************
extension APPNetTool {
    
    /**************************** 网络请求失败常用语 **************************/
    static let HTTPErrorCancleMessage = "请求被取消"
    static let HTTPErrorTimeOutMessage = "请求超时"
    static let HTTPErrorNotConnectedMessage = "网络连接断开"
    static let HTTPErrorOthersMessage = "网络不给力"
    static let HTTPErrorServerMessage = "服务器繁忙"
    static let HTTPErrorDataMessage = "数据错误"

    private static let resultCode = 20000;//与后台商定成功码

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
        
        let request:DataRequest = AF.request(url, method: method, parameters: parameters, headers: AFHeaders).responseJSON { response in
            
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
            
            //DataResponse 类型
            switch response.result {
            
            case .success:
                //处理成功
                if let jsonData = response.value  {
                    success(jsonData,200)
                }else{
                    success([:],200)
                }
            case .failure:
                //处理失败
                if let error = response.error {
                    fail(error)//AFError
                }
            }
        }
        
        allDataRequest.append(request)
    }


    //MARK: 常规get请求
    static func getData(url:String, params:[String:Any], success:@escaping NetSuccess, fail:@escaping NetFailure) {
        
        self.netTool.requestData(method: HTTPMethod.get, url: url, parameters: params, success: success, fail: fail )
    }

    func getData(url:String, params:[String:Any], success:@escaping NetSuccess, fail:@escaping NetFailure) {
        
        self.requestData(method: HTTPMethod.get, url: url, parameters: params, success: success, fail: fail )
    }

    //MARK: 常规post请求
    static func postData(url:String, params:[String:Any], success:@escaping NetSuccess, fail:@escaping NetFailure) {
        
        self.netTool.requestData(method: HTTPMethod.post, url: url, parameters: params, success: success, fail: fail )
    }

    func postData(url:String, params:[String:Any], success:@escaping NetSuccess, fail:@escaping NetFailure) {
        
        self.requestData(method: HTTPMethod.post, url: url, parameters: params, success: success, fail: fail )
    }


    //MARK: 普通请求
    ///普通get请求
    static func getNetData(url:String, params:[String:Any], block:@escaping NetResultData) {
        
        let httpUrl:String = APPKeyInfo.hostUrl() + url
        
        self.getData(url: httpUrl, params: params, success: { (response, code) in
            //统一处理结果
            self.netSucessAnalyticalNetdata(response: response, block: block)
        }) { (error) in
            //统一处理错误
            self.netFailAnalyticalNetData(error: error, block: block)
        }
    }

    ///普通post请求
    static func postNetData(url:String, params:[String:Any], block:@escaping NetResultData) {
        
        let httpUrl:String = APPKeyInfo.hostUrl() + url
        
        self.postData(url: httpUrl, params: params, success: { (response, code) in
            //统一处理结果
            self.netSucessAnalyticalNetdata(response: response, block: block)
        }) { (error) in
            //统一处理错误
            self.netFailAnalyticalNetData(error: error, block: block)
        }
    }
    
    ///统一处理数据
    static func netSucessAnalyticalNetdata(response:Any?, block:@escaping NetResultData) {
        
        let jsonData:[String:Any]? = response as? [String:Any]
        
        let code:Int = jsonData?["code"] as? Int ?? resultCode
        
        let message:String = jsonData?["message"] as? String ?? HTTPErrorDataMessage
        
        let data = jsonData?["data"]//内容数据
        
        if code == resultCode {
            block(true, data, APPNetStatus.sucess(code: code))
        }else{
            block(false, message, APPNetStatus.fail(code: code))
        }
        
        //后台协商进行用户登录异常提示 && 强制用户退出
        if (code == 20019) {

            //用户登录过期 && 执行退出
            APPManager.appManager.forcedExitUserWithShowController(showIndex: 0)
        }
    }
    
    ///统一处理失败 处理
    static func netFailAnalyticalNetData(error:AFError, block:@escaping NetResultData) {
        
        var errorMsg = HTTPErrorOthersMessage //默认网络不给力
        
        ///errorMsg = error.errorDescription ?? ""
        
        let errorInfo:Error? = error.underlyingError
        Print("请求出错：\(String(describing: errorInfo))")
        
        let errorNS:NSError? = errorInfo as NSError?
        
        let errorCode:Int = errorNS?.code ?? 404
        switch errorCode {
        case NSURLErrorCancelled:
            //被取消
            errorMsg = HTTPErrorCancleMessage
        case NSURLErrorTimedOut:
            //超时
            errorMsg = HTTPErrorTimeOutMessage
        case NSURLErrorNotConnectedToInternet:
            //断网
            errorMsg = HTTPErrorNotConnectedMessage
        default:
            errorMsg = HTTPErrorOthersMessage
        }
        
        block(false, errorMsg, APPNetStatus.failHttp(code: errorCode))
    }
}

//MARK: ************************* 封装AFNetworking *************************
extension APPNetTool {
    ///get请求（AFNetworking框架）
    static func getRequestData(url:String, params:[String:Any], block:@escaping NetResultData) {
        
        let httpUrl:String = APPKeyInfo.hostUrl() + url
        
        APPHttpTool.getRequestNetDicDataUrl(httpUrl, params: params) { (result:Bool, idObject:Any, code:Int) in
            
            block(result, idObject, APPNetStatus.result(code: code));//逃逸闭包注意 循环引用
        }
    }

    ///post请求（AFNetworking框架）
    static func postRequestData(url:String, params:[String:Any], block:@escaping NetResultData) {
        
        let httpUrl:String = APPKeyInfo.hostUrl() + url
       
        APPHttpTool.postRequestNetDicDataUrl(httpUrl, params: params) { (result:Bool, idObject:Any, code:Int) in
            
            block(result, idObject, APPNetStatus.result(code: code));
        }
    }
}

//MARK: ************************* Model <——> 模型 *************************
extension APPNetTool {
    
    ///模型转换 jsonToModel(json:data, Model: Model.self)    ——> AnyClass.Type ——> Convertible.Type ——> BaseModel.Type
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
