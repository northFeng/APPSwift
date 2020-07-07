//
//  APPHttpTool.m
//  APPSwift
//
//  Created by 峰 on 2020/6/28.
//  Copyright © 2020 north_feng. All rights reserved.
//  获取缓存数据（url+参数——>MD5作为key） && 取消上一次请求  && 不重复请求  && 用户行为埋点统计 本地统计数据，分批次上传 减少网络请求减少耗电量
/**
针对建立连接这部分的优化就是这样的原则：能不发请求的就尽量不发请求，必须要发请求时，能合并请求的就尽量合并请求。然而，任何优化手段都是有前提的，而且也不能保证对所有需求都能起作用，有些API请求就是不符合这些优化手段前提的，那就老老实实发请求吧。不过这类API请求所占比例一般不大，大部分的请求都或多或少符合优化条件，所以针对发送请求的优化手段还是值得做的。

2、针对DNS域名解析做的优化，以及建立链接的优化 —> 索性直接走IP请求，那不就绕过DNS服务的耗时了嘛
*/

#import "APPHttpTool.h"

#import "APPHttpCacheTool.h"//缓存类

#import "APPSwift-Swift.h"//swift总类(隐藏的，直接使用)

@interface APPHttpTool ()

///AFNet网络管理者
@property (nonatomic,strong) APPHTTPSessionManager *afNetManager;

@end

///自定义返回数据code
NSInteger const resultCode = 20000;

///请求失败 Error 错误信息
HTTPErrorMessage const HTTPErrorCancleMessage = @"请求被取消";
HTTPErrorMessage const HTTPErrorTimeOutMessage = @"请求超时";
HTTPErrorMessage const HTTPErrorNotConnectedMessage = @"网络连接断开";
HTTPErrorMessage const HTTPErrorOthersMessage = @"网络不给力";
HTTPErrorMessage const HTTPErrorServerMessage = @"服务器错误";

@implementation APPHttpTool

///存储 请求任务
static NSMutableArray<NSURLSessionTask *> *_allSessionTask;

+ (instancetype)sharedNetworking{
    
    static APPHttpTool *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[APPHttpTool alloc] init];
    });
    return handler;
}

/**
 存储所有请求task的数组
 */
- (NSMutableArray *)allSessionTask
{
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

#pragma mark - 创建AFN管理者
- (APPHTTPSessionManager *)afNetManager{
    if (!_afNetManager) {
        
        //_afNetManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[APPKeyInfo hostURL]]];//[AFHTTPSessionManager manager];//初始化baseUrl 前提整个APP的请求都必须从是统一根IP
        _afNetManager = [APPHTTPSessionManager manager];
        //请求序列化
        _afNetManager.requestSerializer = [AFJSONRequestSerializer serializer];//设置请求数据为json
        _afNetManager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        _afNetManager.requestSerializer.timeoutInterval = 15;//超时时间
        
        //请求头信息设置
        /**
        //本地账户的token 和 账户ID 每次请求都放到请求头中，后台做判断，有异常就返回了，强制用户退出登录
        [_afNetManager.requestSerializer setValue:[HSAccountManager sharedAccountManager].token forHTTPHeaderField:@"token"];
        [_afNetManager.requestSerializer setValue:[HSAccountManager sharedAccountManager].userId forHTTPHeaderField:@"userId"];
        [_afNetManager.requestSerializer setValue:[HSAppInfo appBundleID] forHTTPHeaderField:@"packageName"];
         */
        
        //响应序列化
        _afNetManager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
        //响应数据格式设置
        _afNetManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                            @"application/json;charset=UTF-8",
                                                                                  @"text/html",
                                                                                  @"text/json",
                                                                                  @"text/plain",
                                                                                  @"text/javascript",
                                                                                  @"text/xml",
                                                                                  @"image/*"]];
        
        //审核期间 ——>版本号与线上版本号不同，只有审核期间的版本号 才会走测试登录
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [_afNetManager.requestSerializer setValue:appVersion forHTTPHeaderField:@"appversion"];
        
        //APP类型
        [_afNetManager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"type"];
    }
    
    
    //时间戳
    [_afNetManager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",(long)[self date_getNowTimeStampWithPrecision:1000]] forHTTPHeaderField:@"timestamp"];
    
    return _afNetManager;
}

///获取当前时间戳 && 精度1000毫秒 1000000微妙
- (NSInteger)date_getNowTimeStampWithPrecision:(NSInteger)precision{
    
    NSDate *date = [NSDate date];
    
    NSTimeInterval nowTime = date.timeIntervalSince1970 * precision;
    
    NSInteger nowStamp = nowTime / 1;
    
    return nowStamp;
}

- (NSString *)strUTF8Encoding:(NSString *)str{
    //编码
    NSCharacterSet *allowedCharacters = [NSCharacterSet URLQueryAllowedCharacterSet];

    return [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    //解码
    //[str stringByRemovingPercentEncoding];
}

///添加公共参数
- (NSDictionary *)addPublicParameterWithDic:(NSDictionary *)dicParams{
    
    NSMutableDictionary *dicMutable = [dicParams mutableCopy];
    
    /**
     NSInteger timeStamp = 100000;//[APPFunctionMethod date_getNowTimeStampWithPrecision:1000];
     NSString *publicStr = [NSString stringWithFormat:@"platform=IOS&version=1.0&timeSpan=%ld&token=%@",timeStamp,APPManagerUserInfo.token];
     NSString *sign = [GFEncryption md5LowercaseString_32:publicStr];
     
     //添加公共参数sign
     [dicMutable gf_setObject:sign withKey:@"sign"];
     
     [dicMutable gf_setObject:@"IOS" withKey:@"platform"];
     [dicMutable gf_setObject:@"1.0" withKey:@"version"];
     [dicMutable gf_setObject:[NSNumber numberWithInteger:timeStamp] withKey:@"timeSpan"];
     
     [dicMutable gf_setObject:APPManagerUserInfo.token withKey:@"token"];
     */
    
    return [dicMutable copy];
}

#pragma mark - ************************* 统一处理请求&&取消 *************************
///统一发送请求
- (void)requestWithMethod:(NSString *)method URLString:(NSString *)url parameters:(NSDictionary *)parameters success:(Success)success fail:(Failure)fail {
    
    //检查地址中是否有中文
    NSString *urlStr = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
        
    //添加公共参数
    parameters = [self addPublicParameterWithDic:parameters];
    
    NSURLSessionTask *sessionTask = [self.afNetManager requestWithMethod:method URLString:urlStr parameters:parameters sucessCompletion:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self.allSessionTask removeObject:task];//请求完成移除
        NSLog(@"请求结果=%@",responseObject);
        
        if (success) {
            success(responseObject,200);
        }
        
    } failCompletion:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.allSessionTask removeObject:task];//请求完成移除
        NSLog(@"error=%@",error);
        if ([error.domain isEqualToString:@"NSURLErrorDomain"] && error.code == NSURLErrorNotConnectedToInternet) {
            NSLog(@"没有网络");
        }
        if (fail) {
            fail(error);
        }
    }];
    
    [self.allSessionTask addObject:sessionTask];
}

- (void)cancelAllRequest{
    @synchronized(self) {
        [self.allSessionTask enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [self.allSessionTask removeAllObjects];
    }
}

- (void)cancelRequestWithURL:(NSString *)URL{
    if (!URL) return;
    @synchronized (self) {
        [self.allSessionTask enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [self.allSessionTask removeObject:task];
                *stop = YES;
            }
        }];
    }
}

- (BOOL)containSessionTaskForURl:(NSString *)URL{
    
    __block BOOL contain = NO;
    
    if (!URL) return contain;
    @synchronized (self) {
        [self.allSessionTask enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                
                contain = YES;
                *stop = YES;
            }
        }];
        
        return contain;
    }
}

#pragma mark - ************************* 常规请求 *************************

#pragma mark - GET方法
+ (void)getWithUrl:(NSString *)url params:(NSDictionary *)params success:(Success)success fail:(Failure)fail {
    [[APPHttpTool sharedNetworking] getWithUrl:url params:params success:success fail:fail];
}
- (void)getWithUrl:(NSString *)url params:(NSDictionary *)params success:(Success)success fail:(Failure)fail {
    
    [self requestWithMethod:@"GET" URLString:url parameters:params success:success fail:fail];
}

#pragma mark - POST
+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(Success)success fail:(Failure)fail {
    [[APPHttpTool sharedNetworking] postWithUrl:url params:params success:success fail:fail];
}
- (void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(Success)success fail:(Failure)fail {
    
    [self requestWithMethod:@"POST" URLString:url parameters:params success:success fail:fail];
}

#pragma mark - UPLOAD上传文件
+ (void)uploadFileWithURL:(NSString *)url params:(NSDictionary *)params name:(NSString *)name filePath:(NSString *)filePath progressBlock:(Preogress)progress success:(Success)success fail:(Failure)fail {
    [[APPHttpTool sharedNetworking] uploadFileWithURL:url params:params name:name filePath:filePath progressBlock:progress success:success fail:fail];
}
- (void)uploadFileWithURL:(NSString *)url params:(NSDictionary *)params name:(NSString *)name filePath:(NSString *)filePath progressBlock:(Preogress)progress success:(Success)success fail:(Failure)fail {
    
    //检查地址中是否有中文
    NSString *urlStr = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    /**
     加密处理：对字段进行json序列化进行加密成字符串，进行发送到后台
     一定要判断请求的URL是否为上传图片，若为上传图片则不进行加密处理
     */
        
    //添加公共参数
    params = [self addPublicParameterWithDic:params];
    
    [self.afNetManager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name error:&error];
        if (error && fail) {
            fail(error);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (progress)
                progress(uploadProgress);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSInteger code = [responseObject[@"status"] integerValue];
            success(responseObject,code);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        if (fail) {
            fail(error);
        }
    }];
}

#pragma mark - 上传图片和视频
+ (void)uploadImagesWithURL:(NSString *)url params:(NSDictionary *)params name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType progressBlock:(Preogress)progress success:(Success)success fail:(Failure)fail {
    [[APPHttpTool sharedNetworking] uploadImagesWithURL:url params:params name:name images:images fileNames:fileNames imageScale:imageScale imageType:imageType progressBlock:progress success:success fail:fail];
}
- (void)uploadImagesWithURL:(NSString *)url params:(NSDictionary *)params name:(NSString *)name images:(NSArray<UIImage *> *)images fileNames:(NSArray<NSString *> *)fileNames imageScale:(CGFloat)imageScale imageType:(NSString *)imageType progressBlock:(Preogress)progress success:(Success)success fail:(Failure)fail {
    
    //检查地址中是否有中文
    NSString *urlStr = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    /**
     加密处理：对字段进行json序列化进行加密成字符串，进行发送到后台
     一定要判断请求的URL是否为上传图片，若为上传图片则不进行加密处理
     */
        
    //添加公共参数
    params = [self addPublicParameterWithDic:params];
    
    [self.afNetManager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSUInteger i = 0; i < images.count; i++) {
            // 压缩图片
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale ?: 1.f);
            // 图片名
            NSString *fileName = fileNames ? [NSString stringWithFormat:@"%@.%@", fileNames[i], imageType ?: @"jpg"] : [NSString stringWithFormat:@"%f%ld.%@",[[NSDate date] timeIntervalSince1970], (unsigned long)i, imageType ?: @"jpg"];
            // MIME类型
            NSString *mimeType = [NSString stringWithFormat:@"image/%@",imageType ?: @"jpg"];
            // 添加表单数据
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (progress)
                progress(uploadProgress);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSInteger code = [responseObject[@"status"] integerValue];
            success(responseObject,code);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        if (fail) {
            fail(error);
        }
    }];
}


#pragma mark - 下载
+ (void)downloadWithURL:(NSString *)url fileDir:(NSString *)fileDir progressBlock:(Preogress)progress success:(Success)success fail:(Failure)fail {
    [[APPHttpTool sharedNetworking] downloadWithURL:url fileDir:fileDir progressBlock:progress success:success fail:fail];
}
- (void)downloadWithURL:(NSString *)url fileDir:(NSString *)fileDir progressBlock:(Preogress)progress success:(Success)success fail:(Failure)fail {
    //检查地址中是否有中文
    NSString *urlStr = [NSURL URLWithString:url] ? url : [self strUTF8Encoding:url];
    
    /**
     加密处理：对字段进行json序列化进行加密成字符串，进行发送到后台
     一定要判断请求的URL是否为上传图片，若为上传图片则不进行加密处理
     */
        
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [self.afNetManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (progress)
                progress(downloadProgress);
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        // 获取本机保存目录 = 沙盒地址 + 下载目录(暂未提供自定义默认保存文件夹名)
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"NetworkDownload"];
        // 如果文件夹不存在则先创建
        [[NSFileManager defaultManager] createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        // 文件保存全路径 = 本机保存地址 + NSURLResponse对象的建议文件名(其实就是原文件名)
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (fail) {
                fail(error);
            }
        } else {
            if (success) {
                success(filePath.absoluteString,200);
            }
        }
    }];
}

#pragma mark - ************************** 网络监测 **************************
#pragma makr - 开始监听网络连接
+ (void)startMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status){
                
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                [APPHttpTool sharedNetworking].networkStats=StatusUnknown;
                
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络");
                [APPHttpTool sharedNetworking].networkStats=StatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                [APPHttpTool sharedNetworking].networkStats=StatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                
                [APPHttpTool sharedNetworking].networkStats=StatusReachableViaWiFi;
                NSLog(@"WIFI网络");
                break;
        }
        //网络发生变化在此进行通知
        [NSNotificationCenter.defaultCenter postNotificationName:@"GFNetworkingReachabilityDidChangeNotification" object:nil];
    }];
    
    [mgr startMonitoring];
}

/**
 *  关闭网络监测
 */
+ (void)stopMonitoring{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

@end

#pragma mark - *************************  *************************

@implementation APPHTTPSessionManager

- (NSURLSessionDataTask *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters sucessCompletion:(APPNetworkTaskSucessBlock)sucessCompletion failCompletion:(APPNetworkTaskFailBlock)failCompletion {
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:method URLString:URLString parameters:parameters uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (sucessCompletion) {
            sucessCompletion(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failCompletion) {
            failCompletion(task,error);
        }
    }];
    /**
    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:method URLString:URLString parameters:parameters uploadProgress:nil downloadProgress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (sucessCompletion) {
            sucessCompletion(task,responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failCompletion) {
            failCompletion(task,error);
        }
    }];
     */
    
    [dataTask resume];
    
    return dataTask;
}

@end


#pragma mark - ************************* 根据项目需求进行快速请求分类 *************************
@implementation APPHttpTool (APPHTTPRequest)

#pragma mark - ************************* 普通请求 *************************
///get请求一个字典
+ (void)getRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block{
    
    [APPHttpTool getWithUrl:url params:params success:^(id response, NSInteger code) {
        [self netSucessAnalyticalNetdata:response block:block];
    } fail:^(NSError *error) {
        [self netFailAnalyticalNetdata:error block:block];
    }];
}

///post请求一个字典
+ (void)postRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block {
    
    [APPHttpTool postWithUrl:url params:params success:^(id response, NSInteger code) {
        [self netSucessAnalyticalNetdata:response block:block];
    } fail:^(NSError *error) {
        [self netFailAnalyticalNetdata:error block:block];
    }];
}

///统一处理数据 成功
+ (void)netSucessAnalyticalNetdata:(id)netData block:(NetResult)block {
    
    //code
    NSNumber *codeNum = [netData objectForKey:@"code"];
    NSInteger code = codeNum.integerValue;
    
    //返回消息
    NSString *errorMessage = [netData objectForKey:@"msg"];
    id dataDic = [netData objectForKey:@"data"];//数据
    
    if ([dataDic isKindOfClass:[NSNull class]]) {
        dataDic = @{};
    }
    
    if (code == resultCode) {
        //请求成功
        if (block) {
            block(YES,dataDic,100);
        }
    }else{
        // 错误处理
        if (block) {
            block(NO,errorMessage,code);
        }
    }

    //后台协商进行用户登录异常提示 && 强制用户退出
    if (code == 20019) {

        //用户登录过期 && 执行退出
        //[[APPManager sharedInstance] forcedExitUserWithShowControllerItemIndex:2];
        [APPOCInterface forcedExitUserWithShowControllerItemIndexWithIndex:0];
    }
}

///统一处理数据 失败
+ (void)netFailAnalyticalNetdata:(NSError *)error block:(NetResult)block {
    
    NSString *errorMessage = HTTPErrorOthersMessage;//error.localizedDescription;
    switch (error.code) {
        case NSURLErrorCancelled:
            //被取消
            errorMessage = HTTPErrorCancleMessage;
            break;
        case NSURLErrorTimedOut:
            //超时
            errorMessage = HTTPErrorTimeOutMessage;
            break;
        case NSURLErrorNotConnectedToInternet:
            //断网
            errorMessage = HTTPErrorNotConnectedMessage;
            break;
            
        default:
            
            break;
    }
    if (block) {
        block(NO,errorMessage,99);
    }
}

#pragma mark - ************************* 特殊网络请求 *************************

///GET取缓存数据 + 请求最新的数据&&更新缓存数据
+ (void)cacheGetRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block {
    
    id dataCache = HTTPCache(url, params);
    
    if (dataCache) {
        //有缓存
        if (block) {
            block(YES,dataCache,100);
        }
    }else{
        //没有缓存 ——> 请求
        [APPHttpTool getRequestNetDicDataUrl:url params:params WithBlock:block];
    }
}

///POST取缓存数据 + 请求最新的数据&&更新缓存数据
+ (void)cachePostRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block {
    
    id dataCache = HTTPCache(url, params);
    
    if (dataCache) {
        //有缓存
        if (block) {
            block(YES,dataCache,100);
        }
    }else{
        //没有缓存 ——> 请求
        [APPHttpTool postRequestNetDicDataUrl:url params:params WithBlock:block];
    }
}

///取消上一次GET同一请求,取最新次的请求
+ (void)cancelUpGetRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block {
    
    [[APPHttpTool sharedNetworking] cancelRequestWithURL:url];
    [APPHttpTool getRequestNetDicDataUrl:url params:params WithBlock:block];
}

///取消上一次POST同一请求,取最新次的请求
+ (void)cancelUpPostRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block {
    
    [[APPHttpTool sharedNetworking] cancelRequestWithURL:url];
    [APPHttpTool postRequestNetDicDataUrl:url params:params WithBlock:block];
}

///重复GET请求只请求第一次
+ (void)oneceGetRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block {
    
    if (![[APPHttpTool sharedNetworking] containSessionTaskForURl:url]) {
        //没有在请求
        [APPHttpTool getRequestNetDicDataUrl:url params:params WithBlock:block];
    }
}

///重复POST请求只请求第一次
+ (void)onecePostRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block {
    
    if (![[APPHttpTool sharedNetworking] containSessionTaskForURl:url]) {
        //没有在请求
        [APPHttpTool postRequestNetDicDataUrl:url params:params WithBlock:block];
    }
}

///获取字典
+ (NSDictionary *)dictionaryWithJSOn:(id)json {
    
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

/**
 1.字符串转字典

 NSString * jsonString = @"";

 NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

 NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];

 2.字典转字符串

 // NSJSONWritingPrettyPrinted 转换的字符串有\n   NSJSONWritingSortedKeys:转换的没有\n
 SData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

 NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
 */

@end
