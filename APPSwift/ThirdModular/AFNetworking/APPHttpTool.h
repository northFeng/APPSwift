//
//  APPHttpTool.h
//  APPSwift
//  AFNetworking网络工具
//  Created by 峰 on 2020/6/28.
//  Copyright © 2020 north_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>//AF框架

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    
    StatusUnknown           = -1, //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
    
}NetworkStatus;

typedef void (^Success) (id response , NSInteger code);//成功回调
typedef void (^Failure) (NSError *error, NSInteger httpCode);//失败回调
typedef void(^Preogress)(NSProgress *progress);//进度回调


/**
 * 请求结果block
 * @param result  bool值 yes请求成功  No请求失败
 * @param idObject 请求成功后台返回数据JSON / 失败 string类型 ，描述失败原因
 * @param code  三个值  100：成功  99：网络原因失败  101：请求成功服务器原因
*/
typedef void (^NetResult) (BOOL result, id idObject, NSInteger code);


///请求失败 Error 错误信息
typedef NSString *HTTPErrorMessage;

///请求取消
extern HTTPErrorMessage const HTTPErrorCancleMessage;
///请求超时
extern HTTPErrorMessage const HTTPErrorTimeOutMessage;
///网络断开
extern HTTPErrorMessage const HTTPErrorNotConnectedMessage;
///网络不给力
extern HTTPErrorMessage const HTTPErrorOthersMessage;
///服务器返回错误
extern HTTPErrorMessage const HTTPErrorServerMessage;



@interface APPHttpTool : NSObject

/**
 *  获取网络
 */
@property (nonatomic,assign)NetworkStatus networkStats;

/**
 *  单例
 */
+ (instancetype)sharedNetworking;

/**
 *  开启网络监测
 */
+ (void)startMonitoring;

/**
 *  关闭网络监测
 */
+ (void)stopMonitoring;


#pragma mark - ************************* 常规请求 *************************

///取消所有网络请求
- (void)cancelAllRequest;

///取消对应的URL网络请求
- (void)cancelRequestWithURL:(NSString *)URL;

#pragma mark - GET
/**
 *  类方法——>get请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 */
+ (void)getWithUrl:(NSString *)url
            params:(NSDictionary *)params
           success:(Success)success
              fail:(Failure)fail;
///实例方法—> get请求方法,block回调
- (void)getWithUrl:(NSString *)url
            params:(NSDictionary *)params
           success:(Success)success
              fail:(Failure)fail;

#pragma mark - POST
/**
 *  类方法—>post请求方法,block回调
 *
 *  @param url     请求连接，根路径
 *  @param params  参数
 *  @param success 请求成功返回数据
 *  @param fail    请求失败
 */
+ (void)postWithUrl:(NSString *)url
            params:(NSDictionary *)params
           success:(Success)success
              fail:(Failure)fail;
///实例方法—>post请求方法,block回调
- (void)postWithUrl:(NSString *)url
            params:(NSDictionary *)params
           success:(Success)success
              fail:(Failure)fail;


#pragma mark - 上传文件

/**类方法—>上传文件
    @param url 请求路径
    @param params 参数
    @param name 文件名字
    @param filePath 文件路径
    @param progress 上传进度回调
    @param success 上传成功回调
    @param fail 上传失败回调
 */
+ (void)uploadFileWithURL:(NSString *)url
                   params:(NSDictionary *)params
                     name:(NSString *)name
                 filePath:(NSString *)filePath
            progressBlock:(Preogress)progress
                  success:(Success)success
                     fail:(Failure)fail;
/// 实例方法—>上传文件
- (void)uploadFileWithURL:(NSString *)url
                   params:(NSDictionary *)params
                     name:(NSString *)name
                 filePath:(NSString *)filePath
            progressBlock:(Preogress)progress
                  success:(Success)success
                     fail:(Failure)fail;


#pragma mark - 上传图片
/**
类方法—>上传图片

    @param url 请求地址
    @param params 请求参数
    @param name 图片对应服务器上的字段
    @param images 图片数组
    @param fileNames 图片文件名数组，传入nil时数组内的文件名默认为当前日期时间戳+索引
    @param imageScale 图片文件压缩比 范围 (0.f ~ 1.f)
    @param imageType 图片文件的类型，例:png、jpg(默认类型)....
    @param progress 上传进度回调
    @param success 请求回调
    @param fail 失败回调
*/
+ (void)uploadImagesWithURL:(NSString *)url
                     params:(NSDictionary *)params
                       name:(NSString *)name
                     images:(NSArray<UIImage *> *)images
                  fileNames:(NSArray<NSString *> *)fileNames
                 imageScale:(CGFloat)imageScale
                  imageType:(NSString *)imageType
              progressBlock:(Preogress)progress
                    success:(Success)success
                       fail:(Failure)fail;
///实例方法—>上传图片
- (void)uploadImagesWithURL:(NSString *)url
                     params:(NSDictionary *)params
                       name:(NSString *)name
                     images:(NSArray<UIImage *> *)images
                  fileNames:(NSArray<NSString *> *)fileNames
                 imageScale:(CGFloat)imageScale
                  imageType:(NSString *)imageType
              progressBlock:(Preogress)progress
                    success:(Success)success
                       fail:(Failure)fail;

#pragma mark - 下载

/** 下载文件
    @param url 下载URL
    @param fileDir 文件存储目录(默认存储目录为Download)
    @param progress 文件下载的进度回调
    @param success 请求回调，filePath为文件保存路径
    @param fail 失败回调
 */
+ (void)downloadWithURL:(NSString *)url
                fileDir:(NSString *)fileDir
          progressBlock:(Preogress)progress
                success:(Success)success
                   fail:(Failure)fail;
/// 下载文件
- (void)downloadWithURL:(NSString *)url
                fileDir:(NSString *)fileDir
          progressBlock:(Preogress)progress
                success:(Success)success
                   fail:(Failure)fail;

@end


#pragma mark - ************************* 添加自定义方法 *************************

/** 请求任务Block */
typedef void(^APPNetworkTaskSucessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void(^APPNetworkTaskFailBlock)(NSURLSessionDataTask *task, NSError *error);

/**
 遵守协议，让编译通过，调用AFN私有API
 - dataTaskWithHTTPMethod:URLString:parameters:success:failure
 */
@protocol DKNetWorkSessionManagerProtocol <NSObject>

@optional

/**
 AFN底层网络请求方法

 @param method HTTP请求方法
 @param URLString 请求地址
 @param parameters 参数字典
 @param success 成功回调
 @param failure 失败回调
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(void (^)(NSProgress *uploadProgress))uploadProgress
                                downloadProgress:(void (^)(NSProgress *downloadProgress))downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end

@interface APPHTTPSessionManager : AFHTTPSessionManager <DKNetWorkSessionManagerProtocol>


/// 自定义网络请求底层方法
/// @param method HTTP请求方法
/// @param URLString 请求地址
/// @param parameters 请求参数
/// @param sucessCompletion 成功回调
/// @param failCompletion 失败回调
- (NSURLSessionDataTask *)requestWithMethod:(NSString *)method
                                  URLString:(NSString *)URLString
                                 parameters:(id)parameters
                                 sucessCompletion:(APPNetworkTaskSucessBlock)sucessCompletion
                             failCompletion:(APPNetworkTaskFailBlock)failCompletion;


@end


#pragma mark - ************************* 根据项目需求进行快速请求分类 *************************
@interface APPHttpTool (APPHTTPRequest)

#pragma mark - ************************* 普通请求 *************************
///get请求一个字典
+ (void)getRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block;

///post请求一个字典
+ (void)postRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block;


#pragma mark - ************************* 特殊网络请求 *************************
///GET取缓存数据 + 请求最新的数据&&更新缓存数据
+ (void)cacheGetRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block;

///POST取缓存数据 + 请求最新的数据&&更新缓存数据
+ (void)cachePostRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block;

///取消上一次GET同一请求,取最新次的请求
+ (void)cancelUpGetRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block;

///取消上一次POST同一请求,取最新次的请求
+ (void)cancelUpPostRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block;

///重复GET请求只请求第一次
+ (void)oneceGetRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block;

///重复POST请求只请求第一次
+ (void)onecePostRequestNetDicDataUrl:(NSString *)url params:(NSDictionary *)params WithBlock:(NetResult)block;


///获取字典
+ (NSDictionary *)dictionaryWithJSOn:(id)json;

@end


NS_ASSUME_NONNULL_END

/**
///获取网络数据
+ (void)getData<#XXXX#> blockResult:(APPBackBlock)blockResult {
    
    NSMutableDictionary *dicJson = [NSMutableDictionary dictionary];
    [dicJson gf_setObject:@"" withKey:@""];
    
    [APPHttpTool <#Ttype#>RequestNetDicDataUrl:@"lucidababyshow" params:dicJson WithBlock:^(BOOL result, id  _Nonnull idObject) {
        
        if (result) {
            NSDictionary *dic = (NSDictionary *)idObject;
            NSArray *list = dic[@"lucidaBabyList"];
            NSMutableArray *arrayModel = [NSMutableArray array];
            if (list.count && [list isKindOfClass:[NSArray class]]) {
                for (NSDictionary *json in list) {
                    [arrayModel addObject:[<#Model#> yy_modelWithJSON:json]];
                }
            }
            
            blockResult(YES,arrayModel);
        }else{
            blockResult(NO,(NSString *)idObject);
        }
    }];
}

///上拉请求
- (void)getDataFormNet {
    if (_page == 1) {
        [_dataModelArray removeAllObjects];//清空数据
    }
    
    [CBHomeClassroomModel getRecommendClassroomDataWithPage:_page pageSize:10 classFlag:_indexVC WithBlockData:^(BOOL result, id idObject, NSInteger code) {
        if (result) {
            [self.dataModelArray addObjectsFromArray:(NSArray *)idObject];
            if (((NSArray *)idObject).count < 10) {
                self.collectionView.mj_footer.hidden = YES;
            }else{
                self.collectionView.mj_footer.hidden = NO;
            }
        }else{
            AlertMsgView((NSString *)idObject, self.view);
        }
        
        if (self.dataModelArray.count) {
            //隐藏  占位图 && 网络占位图
            
        }else{
            if (code == 100) {
                //显示无数据占位图
            }else{
                //显示无网络占位图
            }
        }
    
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

*/
