//
//  APPAlertApi.h
//  APPSwift
//
//  Created by 峰 on 2020/7/3.
//  Copyright © 2020 north_feng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPAlertApi : NSObject

#pragma mark - MBProgressHUD ——> 吐字 && loadingView
///获取APP内最顶层的VC
+ (UIViewController *)topViewControllerOfAPP;

///弹出文字提示
+ (void)showMessage:(NSString *)message;

///展示文字到某个视图上
+ (void)showMessage:(NSString *)message onView:(UIView *)view;

///吐字带菊花不自动隐藏
+ (void)showLoadingWithMessage:(NSString *)message;

///吐字带菊花不自动隐藏
+ (void)showLoadingWithMessage:(NSString *)message onView:(UIView *)view;

///显示菊花等待
+ (void)showLoading;

///显示菊花在指定view上
+ (void)showLoadingOnView:(UIView *)onView;

///显示菊花（是否可以手势交互）
+ (void)showLoadingForInterEnabled:(BOOL)enable;

///隐藏当前VC的view上的菊花
+ (void)hideLoading;

///隐藏指定view上的菊花
+ (void)hideLoadingOnView:(UIView *)onView;



@end

NS_ASSUME_NONNULL_END
