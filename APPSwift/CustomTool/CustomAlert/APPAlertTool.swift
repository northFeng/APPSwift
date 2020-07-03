//
//  APPAlertTool.swift
//  APPSwift
//  弹框 && 吐字 工具
//  Created by 峰 on 2020/6/30.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

class APPAlertTool {
    
    ///获取APP内最顶层的VC
    static func topViewControllerOfAPP() -> UIViewController? {
        
        let navi:UIViewController? = UIApplication.shared.delegate?.window??.rootViewController
        
        let topVC = self.topViewControllerWithRootViewController(rootViewController: navi)
        
        return topVC
    }
    
    ///获取APP内最顶部的View
    static func topViewOfTopVC() -> UIView? {
        
        let topVC:UIViewController? = self.topViewControllerOfAPP()
        
        if topVC != nil {
            return topVC?.view
        }else{
            return nil
        }
    }

    private static func topViewControllerWithRootViewController(rootViewController:UIViewController?) -> UIViewController? {
        
        if rootViewController is UITabBarController {
            
            let tabBarController = rootViewController as! UITabBarController
            
            return self.topViewControllerWithRootViewController(rootViewController: tabBarController.selectedViewController)
            
        }else if (rootViewController?.presentedViewController) != nil {
            
            let presentedViewController = rootViewController?.presentedViewController!
            
            return self.topViewControllerWithRootViewController(rootViewController: presentedViewController)
            
        }else if rootViewController is UINavigationController {
            
            let navigationController = rootViewController as! UINavigationController
            
            return self.topViewControllerWithRootViewController(rootViewController: navigationController)
            
        }else{
            return rootViewController
        }
    }
    
    
    //MARK: ************************* 吐字 && loading *************************
    
        ///展示文字   || 在 某个视图上
    static func showMessage(message:String, view:UIView? = nil) {
        if view != nil {
            APPAlertApi.showMessage(message, on: view!)
        }else{
            APPAlertApi.showMessage(message)
        }
    }
    
    ///显示菊花等待
    static func showLoading() {
        APPAlertApi.showLoading()
    }
    
    ///吐字带菊花不自动隐藏
    static func showLoading(message:String, view:UIView? = nil) {
        if view != nil {
            APPAlertApi.showLoading(withMessage: message, on: view!)
        }else{
            APPAlertApi.showLoading(withMessage: message)
        }
    }
    
    ///显示菊花在指定view上
    static func showLoading(view:UIView) {
        APPAlertApi.showLoading(on: view)
    }
    
    ///显示菊花（是否可以手势交互）
    static func showLoadingEnabled(enable:Bool) {
        APPAlertApi.showLoading(forInterEnabled: enable)
    }
    
    ///隐藏  前VC的view上的菊花  && 指定view上的菊花
    static func hideLoading(view:UIView? = nil) {
        if view != nil {
            APPAlertApi.hideLoading(on: view!)
        }else{
            APPAlertApi.hideLoading()
        }
    }
}
