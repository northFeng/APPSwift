//
//  APPAlertApi.m
//  APPSwift
//
//  Created by 峰 on 2020/7/3.
//  Copyright © 2020 north_feng. All rights reserved.
//

#import "APPAlertApi.h"

#import <MBProgressHUD/MBProgressHUD.h>

#import "APPXYColorApi.h"

#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

#import "APPSwift-Swift.h"//swift类

@implementation APPAlertApi

///获取APP内最顶部的View
+ (UIView *)topViewOfTopVC {
    
    UIViewController *topVC = [self topViewControllerOfAPP];
    
    if (topVC) {
        return topVC.view;
    }else{
        return nil;
    }
}

///获取APP内最顶层的VC
+ (UIViewController *)topViewControllerOfAPP {
    
    UINavigationController *navi = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *topVC = [self topViewControllerWithRootViewController:navi];
    
    return topVC;
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    /**
    [[[UIApplication sharedApplication] keyWindow] rootViewController]有时为nil 比如当页面有菊花在转的时候，这个rootViewController就为nil;

    所以使用[[[[UIApplication sharedApplication] delegate] window] rootViewController]
    或者[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController]

    presentedViewController 和presentingViewController
    当A弹出B
    A.presentedViewController=B
    B.presentingViewController=A
     */
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
 
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if (rootViewController.presentedViewController) {
 
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
 
        UINavigationController *navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else {
        return rootViewController;
    }
}

///隐藏弹框
+ (void)hideMBProgressHUDAlertViewOnView:(UIView *)onView {
    
    NSEnumerator *subviewsEnum = [onView.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *hud = (MBProgressHUD *)subview;
            //hud.removeFromSuperViewOnHide = YES;
            //[hud hideAnimated:NO];
            [hud removeFromSuperview];
            hud = nil;
        }
    }
}

+ (void)showMessage:(NSString *)message{
    
    //先取消已有的
    [self hideMBProgressHUDAlertViewOnView:[UIApplication sharedApplication].keyWindow];
    
    //显示新的
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.userInteractionEnabled = NO;//不阻挡下面的手势
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    hud.bezelView.backgroundColor = DynamicColor([UIColor blackColor],[UIColor lightGrayColor]);
    hud.bezelView.layer.cornerRadius = 10.f;
    hud.detailsLabel.textColor = DynamicColor([UIColor whiteColor], [UIColor blackColor]);
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    hud.minShowTime = 1.5;
    hud.offset = CGPointMake(0, -kScreenHeight*0.1);//2/5处 (5/10 - 4/10)
    [hud hideAnimated:YES afterDelay:1.5];
}

///展示文字到某个视图上
+ (void)showMessage:(NSString *)message onView:(UIView *)view {
    
    if (view) {
        //先取消已有的
        [self hideMBProgressHUDAlertViewOnView:view];
        
        //显示新的
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;//不阻挡下面的手势
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = message;
        hud.bezelView.backgroundColor = DynamicColor([UIColor blackColor],[UIColor lightGrayColor]);
        hud.bezelView.layer.cornerRadius = 10.f;
        hud.detailsLabel.textColor = DynamicColor([UIColor whiteColor], [UIColor blackColor]);
        hud.detailsLabel.font = [UIFont systemFontOfSize:16];
        hud.minShowTime = 1.5;
        hud.offset = CGPointMake(0, -kScreenHeight*0.1);//2/5处 (5/10 - 4/10)
        [hud hideAnimated:YES afterDelay:1.5];
    }
}

///吐字带菊花不自动隐藏
+ (void)showLoadingWithMessage:(NSString *)message {
    
    [self hideMBProgressHUDAlertViewOnView:[UIApplication sharedApplication].keyWindow];
    
    //显示新的
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.userInteractionEnabled = NO;//不阻挡下面的手势
    hud.bezelView.backgroundColor = DynamicColor([UIColor blackColor], COLOR(@"#2C2C2C"));
    hud.contentColor = [UIColor whiteColor];//菊花颜色
    
    hud.detailsLabel.text = message;
    hud.bezelView.backgroundColor = DynamicColor([UIColor blackColor],[UIColor lightGrayColor]);
    hud.bezelView.layer.cornerRadius = 10.f;
    hud.detailsLabel.textColor = DynamicColor([UIColor whiteColor], [UIColor blackColor]);
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    hud.offset = CGPointMake(0, -kScreenHeight*0.1);//2/5处 (5/10 - 4/10)
}

///吐字带菊花不自动隐藏
+ (void)showLoadingWithMessage:(NSString *)message onView:(UIView *)view {
    
    [self hideMBProgressHUDAlertViewOnView:view];
    
    //显示新的
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;//不阻挡下面的手势
    hud.bezelView.backgroundColor = DynamicColor([UIColor blackColor], COLOR(@"#2C2C2C"));
    hud.contentColor = [UIColor whiteColor];//菊花颜色
    
    hud.detailsLabel.text = message;
    hud.bezelView.backgroundColor = DynamicColor([UIColor blackColor],[UIColor lightGrayColor]);
    hud.bezelView.layer.cornerRadius = 10.f;
    hud.detailsLabel.textColor = DynamicColor([UIColor whiteColor], [UIColor blackColor]);
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    hud.offset = CGPointMake(0, -kScreenHeight*0.1);//2/5处 (5/10 - 4/10)
}


+ (void)showLoading{
    
    UIView *view = [self topViewOfTopVC];
    if (view) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.userInteractionEnabled = NO;
        hud.bezelView.backgroundColor = DynamicColor([UIColor blackColor], COLOR(@"#2C2C2C"));
        hud.contentColor = UIColor.whiteColor;
        hud.offset = CGPointMake(0, -kScreenHeight*0.1);//2/5处 (5/10 - 4/10)
    }
}

///显示菊花在指定view上
+ (void)showLoadingOnView:(UIView *)onView {
    
    if (onView) {
        [MBProgressHUD hideHUDForView:onView animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:onView animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.userInteractionEnabled = NO;
        hud.bezelView.backgroundColor = DynamicColor([UIColor blackColor], COLOR(@"#2C2C2C"));
        hud.contentColor = UIColor.whiteColor;
        hud.offset = CGPointMake(0, -kScreenHeight*0.1);//2/5处 (5/10 - 4/10)
    }
}

///显示菊花在当前VC的view上是否可触摸
+ (void)showLoadingForInterEnabled:(BOOL)enable{
    
    UIView *view = [self topViewOfTopVC];
    if (view) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.userInteractionEnabled = !enable;
        hud.bezelView.backgroundColor = DynamicColor([UIColor whiteColor], COLOR(@"#2C2C2C"));
        hud.contentColor = [UIColor whiteColor];//菊花颜色
        hud.offset = CGPointMake(0, -kScreenHeight*0.1);//2/5处 (5/10 - 4/10)
    }
}

///合并上面三个
+ (void)showLoading:(UIView *)onView enable:(BOOL)enable {
    
    UIView *view = onView ? onView : [self topViewOfTopVC];
    
    if (view) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.userInteractionEnabled = !enable;
        hud.bezelView.backgroundColor = DynamicColor([UIColor whiteColor], COLOR(@"#2C2C2C"));
        hud.contentColor = [UIColor whiteColor];//菊花颜色
        hud.offset = CGPointMake(0, -kScreenHeight*0.1);//2/5处 (5/10 - 4/10)
    }
}

///隐藏当前VC的view上的菊花
+ (void)hideLoading{
    
    UIView *view = [self topViewOfTopVC];
    
    if (view) {
        [MBProgressHUD hideHUDForView:view animated:YES];
    }
}

///隐藏指定view上的菊花
+ (void)hideLoadingOnView:(UIView *)onView {
    
    if (onView) {
        [MBProgressHUD hideHUDForView:onView animated:YES];
    }
}


@end
