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
typealias NetFailure = (AFError, Int)->Void //网络失败回调
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
    
    ///请求方式
    enum NetMethod {
        ///get请求
        case get
        ///post请求
        case post
    }

    ///请求数据
    func requestData(method:NetMethod, url:String, parameters:[String:Any], success:@escaping NetSuccess, fail:@escaping NetFailure) {
        
        var httpMethod = HTTPMethod.post
        
        switch method {
        case .get:
            httpMethod = HTTPMethod.get
        case .post:
            httpMethod = HTTPMethod.post
        }
        
        let request:DataRequest = AF.request(url, method: httpMethod, parameters: parameters, headers: AFHeaders).responseJSON { response in
            
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
            self.removeDataRequest(URL: url)//移除观察
            
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
                    fail(error,response.response?.statusCode ?? 400)//AFError
                }
            }
        }
        
        allDataRequest.append(request)
    }
    
    ///移除 DataRequest元素
    func removeDataRequest(URL:String) {
        for index in 0..<allDataRequest.count {
            let dataRequest = allDataRequest.getItem_gf(index)
                    
            if dataRequest?.request?.url?.absoluteString.hasPrefix(URL) ?? false {
                allDataRequest.remove(at: index)//移除
                break
            }
        }
    }
    
    ///取消所有的请求
    func cancelAllRequest() {
        objc_sync_enter(allDataRequest)
        
        for request in allDataRequest {
            request.cancel()//取消请求
        }
        allDataRequest.removeAll()//移除所有request
        
        objc_sync_exit(allDataRequest)
    }
    
    ///根据URL取消请求
    func cancelRequest(url:String) {
        objc_sync_enter(allDataRequest)
        
        for index in 0..<allDataRequest.count {
            let request:DataRequest? = allDataRequest.getItem_gf(index)
            if request?.request?.url?.absoluteString.hasPrefix(url) ?? false {
                request!.cancel()
                allDataRequest.removeItem_gf(request!)
            }
        }
        
        objc_sync_exit(allDataRequest)
    }
    
    ///是否包含请求
    func containRequest(url:String) -> Bool {
        var contain = false
        
        for index in 0..<allDataRequest.count {
            let request:DataRequest? = allDataRequest.getItem_gf(index)
            if request?.request?.url?.absoluteString.hasPrefix(url) ?? false {
                contain = true
                break
            }
        }
        
        return contain
    }


    //MARK: 常规请求
    static func getData(method:NetMethod = .post, url:String, params:[String:Any], success:@escaping NetSuccess, fail:@escaping NetFailure) {
        
        self.netTool.requestData(method: method, url: url, parameters: params, success: success, fail: fail )
    }

    func getData(method:NetMethod = .post, url:String, params:[String:Any], success:@escaping NetSuccess, fail:@escaping NetFailure) {
        
        self.requestData(method: method, url: url, parameters: params, success: success, fail: fail )
    }

    
    //MARK: 根据APP内数据进行处理 结果统一处理
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
    static func netFailAnalyticalNetData(error:AFError, httpCode:Int, block:@escaping NetResultData) {
        
        var errorMsg = HTTPErrorOthersMessage //默认网络不给力
        
        ///errorMsg = error.errorDescription ?? ""
        
        let errorInfo:Error? = error.underlyingError
        Print("请求出错：\(String(describing: errorInfo))")
        
        let errorNS:NSError? = errorInfo as NSError?
        
        let errorCode:Int = errorNS?.code ?? -999 //如果 errorNS为nil，则证明 请求被取消
        
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
        
        if httpCode / 400 == 1 {
            //4XX 客户端错误
            /**
             400：当前请求无法被服务器理解，请求参数有误。
             401：当前请求需要用户验证。请求头里的携带的 数据错误
             402：该状态码是为了将来可能的需求而预留的。
             403：服务器已经理解请求，但是拒绝执行它。
             404：请求失败，请求所希望得到的资源未被在服务器上发现。
             405：请求行中指定的请求方法不能被用于请求相应的资源
             408：请求超时。
             */
        }
        
        if httpCode / 500 == 1 {
            //5XX 服务器错误
            errorMsg = "服务器错误：" + HTTPURLResponse.localizedString(forStatusCode: httpCode)
            //在此可以上传错误信息 到后台
        }
        
        block(false, errorMsg, APPNetStatus.failHttp(code: httpCode))
    }
}

//MARK: ************************* APP内常规请求 *************************
extension APPNetTool {
    ///普通请求
    static func getNetData(method:NetMethod = .post, url:String, params:[String:Any], block:@escaping NetResultData) {
        
        let URL = APPKeyInfo.hostUrl() + url
        
        self.getData(method: method, url: URL, params: params, success: { (response, code) in
            //统一处理结果
            self.netSucessAnalyticalNetdata(response: response, block: block)
        }) { (error, httpCode) in
            //统一处理错误
            self.netFailAnalyticalNetData(error: error, httpCode: httpCode, block: block)
        }
    }
}

//MARK: ************************* APP特殊网络请求 缓存 & 多次请求 *************************
extension APPNetTool {
    
    ///获取缓存数据 + 请求最新的数据&&更新缓存数据
    static func getNetDataCache(method:NetMethod = .post, url:String, params:[String:Any], block:@escaping NetResultData) {
        let URL = APPKeyInfo.hostUrl() + url
        
        let dataCache = HTTPCache.getCache(URL: URL, parameters: params)
        
        if dataCache != nil {
            //有缓存数据
            self.netSucessAnalyticalNetdata(response: dataCache, block: block)
        }else{
            //没有缓存数据 ——> 请求
            self.getData(method: method, url: URL, params: params, success: { (response, code) in
                //对数据进行保存
                let jsonData:[String:Any]? = response as? [String:Any]
                if jsonData != nil {
                    HTTPCache.setCache(responseData: jsonData!, URL: URL, parameters: params)
                }
                //统一处理结果
                self.netSucessAnalyticalNetdata(response: response, block: block)
            }) { (error, httpCode) in
                //统一处理错误
                self.netFailAnalyticalNetData(error: error, httpCode: httpCode,block: block)
            }
        }
    }
    
    ///取消上一次同一请求，获取最新次的请求
    static func getNetDataCancelUp(method:NetMethod = .post, url:String, params:[String:Any], block:@escaping NetResultData) {
        let URL = APPKeyInfo.hostUrl() + url
        
        netTool.cancelRequest(url: URL)
        self.getNetData(method: method, url: url, params: params, block: block)
    }
    
    ///重复请求只请求第一次
    static func getNetDataOnce(method:NetMethod = .post, url:String, params:[String:Any], block:@escaping NetResultData) {
        let URL = APPKeyInfo.hostUrl() + url
        
        if netTool.containRequest(url: URL) == false {
            //没有正在请求的
            self.getNetData(method: method, url: url, params: params, block: block)
        }
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


//MARK: ************************* HTTPCache *************************
import Cache

fileprivate struct HTTPCache {
    
    ///磁盘保存路径
    private static let diskPath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/AppData"
    ///磁盘配置     try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,appropriateFor: nil, create: true).appendingPathComponent("MyPreferences")     过期时间 .date(Date().addingTimeInterval(60*60*24*7))
    private static let diskConfig = DiskConfig(name: "CacheHttpData", expiry: .date(Date().addingTimeInterval(60*60*24*7)), directory: URL(fileURLWithPath: diskPath), protectionType: .complete)
    ///内存配置
    private static let memoryConfig = MemoryConfig(expiry: .never, countLimit: 20, totalCostLimit: 0)
    ///存储对象
    private static let dataManager = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forData())
    
    
    /// 异步缓存网络数据，根据请求的URL与parameters做KEY存储数据, 缓存多级页面的数据
    /// - Parameters:
    ///   - responseData: 服务器返回的数据
    ///   - URL: 请求的URL地址
    ///   - parameters: 请求的参数
    static func setCache(responseData:[String:Any], URL:String, parameters:[String:Any]) {
        
        var data:Data?
        
        if JSONSerialization.isValidJSONObject(responseData) {
            //利用自带的json库转换成Data
            //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
            data = try? JSONSerialization.data(withJSONObject: responseData, options: [])
        }
                
        if let dataCache = data {
            let key = self.cacheKey(URL: URL, parameters: parameters)            
            dataManager?.async.setObject(dataCache, forKey: key, completion: { (result) in
                switch result {
                  case .value:
                    print("saved successfully")
                  case .error(let error):
                    print(error)
                }
            })
        }
    }
    
    
    /// 根据请求的URL与parameters 取出缓存数据
    /// - Parameters:
    ///   - URL: 请求的URL地址
    ///   - parameters: 请求的参数
    /// - Returns: 缓存的服务器数据
    static func getCache(URL:String, parameters:[String:Any]) -> [String:Any]? {
        let key = self.cacheKey(URL: URL, parameters: parameters)
        let data = try? dataManager?.object(forKey: key)
        
        var dicJson:[String:Any]?
        if let dataCache = data {
            let json = try? JSONSerialization.jsonObject(with: dataCache, options: .mutableContainers)
            dicJson = json as? Dictionary<String, Any>
        }
        return dicJson
    }
    
    ///清除网络缓存数据
    static func clearCache() {
        dataManager?.async.removeAll(completion: { (result) in
            switch result {
              case .value:
                print("removal completes")
              case .error(let error):
                print(error)
            }
        })
    }
    
    
    ///获取key
    private static func cacheKey(URL:String, parameters:[String:Any]) -> String {
        if parameters.count > 0 {
            let paramData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            
            var paramStr = ""
            if let dataParam = paramData {
                paramStr = String(data: dataParam, encoding: .utf8) ?? ""
            }
            return (URL + paramStr).md5_gf()
        }else{
            return URL.md5_gf()
        }
    }
}
