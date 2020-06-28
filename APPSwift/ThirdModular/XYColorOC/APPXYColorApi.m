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
