//
//  APPHttpCacheTool.h
//  APPSwift
//  HTTP请求缓存策略工具
//  Created by 峰 on 2020/6/28.
//  Copyright © 2020 north_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define HTTPCache(URL,Parameters) [APPHttpCacheTool cacheForURL:URL parameters:Parameters]

@interface APPHttpCacheTool : NSObject

/**
 异步缓存网络数据，根据请求的URL与parameters做KEY存储数据, 缓存多级页面的数据

 @param responseObject 服务器返回的数据
 @param URL 请求的URL地址
 @param parameters 请求的参数
 */
+ (void)setCache:(id)responseObject URL:(NSString *)URL parameters:(NSDictionary *)parameters;

/**
 根据请求的URL与parameters 取出缓存数据

 @param URL 请求的URL地址
 @param parameters 请求的参数
 @return 缓存的服务器数据
 */
+ (id)cacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters;

/**
 根据请求的URL与parameters 异步取出缓存数据

 @param URL 请求的URL
 @param parameters 请求的参数
 @param block 异步回调缓存的数据
 */
+ (void)cacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters withBlock:(void(^)(id<NSCoding> object))block;

/**
 获取网络缓存的总大小 动态单位(GB,MB,KB,B)

 @return 网络缓存的总大小
 */
+ (NSString *)cacheSize;

/**
 清除网络缓存
 */
+ (void)clearCache;


/// 请求某个URL缓存
/// @param URL 缓存url
/// @param parameters url的请求参数
+ (void)clearCacheForUrl:(NSString *)URL parameters:(NSDictionary *)parameters;

@end

NS_ASSUME_NONNULL_END
