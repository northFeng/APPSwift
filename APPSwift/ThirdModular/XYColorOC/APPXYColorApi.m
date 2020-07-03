//
//  APPXYColorApi.m
//  APPSwift
//
//  Created by 峰 on 2020/6/28.
//  Copyright © 2020 north_feng. All rights reserved.
//

#import "APPXYColorApi.h"

#import <XYColorOC/CALayer+XYColorOC.h>

@implementation APPXYColorApi

///颜色
+ (UIColor *)colorWithHexString:(NSString *)colorStr {
    
    return [self colorWithHexString:colorStr alpha:1.];
}

/**
 *    @brief  颜色值转换为Color
 *
 *  @stringToConvert  16进制的值比如：646364
 *
 *    @return 返回UIColor
 */
+ (UIColor *)colorWithHexString:(NSString*)stringToConvert alpha:(CGFloat)alpha {
    
    stringToConvert = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range = (NSRange){0, 2};
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

///动态颜色
+ (UIColor *)dynamicColorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    
    //UITraitCollection.currentTraitCollection.userInterfaceStyle;
    UIColor *color = lightColor;
    if (@available(iOS 13.0, *)) {
        color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return lightColor;
            }else if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
                return darkColor;
            }else{
                return lightColor;
            }
        }];
    }
    
    return color;
}


///赋值layer 边框颜色
+ (void)layerSupView:(UIView *)supview layer:(CALayer *)layer dynamicBorderColor:(UIColor *)borderColor {
    
    [layer xy_setLayerBorderColor:borderColor with:supview];
}

///赋值layer 阴影颜色
+ (void)layerSupView:(UIView *)supview layer:(CALayer *)layer dynamicShadowColor:(UIColor *)shadowColor {
    
    [layer xy_setLayerShadowColor:shadowColor with:supview];
}

///赋值layer 背景颜色
+ (void)layerSupView:(UIView *)supview layer:(CALayer *)layer dynamicBackgrounColor:(UIColor *)backgrounColor {
    
    [layer xy_setLayerBackgroundColor:backgrounColor with:supview];
}

@end
