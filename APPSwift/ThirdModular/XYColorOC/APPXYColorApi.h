//
//  APPXYColorApi.h
//  APPSwift
//  CGClor接口
//  Created by 峰 on 2020/6/28.
//  Copyright © 2020 north_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#define COLORA(str,a) [APPXYColorApi colorWithHexString:str alpha:a]
#define COLOR(str) COLORA(str,1.f)
//动态颜色
#define DynamicColor(lightcolor,darkcolor) [APPXYColorApi dynamicColorWithLightColor:lightcolor darkColor:darkcolor]

NS_ASSUME_NONNULL_BEGIN

@interface APPXYColorApi : NSObject

///颜色
+ (UIColor *)colorWithHexString:(NSString *)colorStr;

/**
 颜色值转换为Color

 @param stringToConvert 16进制的值比如：0x646364
 @param alpha 透明度
 @return 返回UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

///动态颜色
+ (UIColor *)dynamicColorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;



///赋值layer 边框颜色
+ (void)layerSupView:(UIView *)supview layer:(CALayer *)layer dynamicBorderColor:(UIColor *)borderColor;

///赋值layer 阴影颜色
+ (void)layerSupView:(UIView *)supview layer:(CALayer *)layer dynamicShadowColor:(UIColor *)shadowColor;

///赋值layer 背景颜色
+ (void)layerSupView:(UIView *)supview layer:(CALayer *)layer dynamicBackgrounColor:(UIColor *)backgrounColor;

@end

NS_ASSUME_NONNULL_END
