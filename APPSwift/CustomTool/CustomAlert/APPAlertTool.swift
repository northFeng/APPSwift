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
        
        let topVC = self.topViewControllerWithRootViewController(rootViewController: navi)//APPNavigationController.appNavi
        
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
        
        if rootViewController is UINavigationController {
            
            let navigationController = rootViewController as! UINavigationController
            
            return self.topViewControllerWithRootViewController(rootViewController: navigationController.visibleViewController)
            
        }else if rootViewController is UITabBarController {
            
            let tabBarController = rootViewController as! UITabBarController
            
            return self.topViewControllerWithRootViewController(rootViewController: tabBarController.selectedViewController)
            
        }else if (rootViewController?.presentedViewController) != nil {
            
            let presentedViewController = rootViewController?.presentedViewController!
            
            return self.topViewControllerWithRootViewController(rootViewController: presentedViewController)
            
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
    static func showLoading(view:UIView? = nil, enable:Bool? = true) {
        
        if view != nil {
            APPAlertApi.showLoading(view!, enable: enable ?? true)
        }else{
            APPAlertApi.showLoading(forInterEnabled: enable ?? true)
        }
    }
    
    ///吐字 && 带菊花不自动隐藏
    static func showLoading(message:String, view:UIView? = nil) {
        if view != nil {
            APPAlertApi.showLoading(withMessage: message, on: view!)
        }else{
            APPAlertApi.showLoading(withMessage: message)
        }
    }
    
    ///隐藏  前VC的view上的菊花  && 指定view上的菊花
    static func hideLoading(view:UIView? = nil) {
        if view != nil {
            APPAlertApi.hideLoading(on: view!)
        }else{
            APPAlertApi.hideLoading()
        }
    }
    
    //MARK: ************************* 系统提示弹框 *************************
    
    ///系统 消息提示框 && 确定按钮
    static func systemAlertMsg(title:String, msg:String?, btnTitle:String? = "确定", block:APPBackClosure? = nil) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let cancleAction = UIAlertAction(title: btnTitle, style: .cancel) { (action) in
            //执行block
            if let blockResult = block {
                blockResult(true,0)
            }
        }
        
        alertController.addAction(cancleAction)
        
        let topVC = self.topViewControllerOfAPP()
        
        topVC?.present(alertController, animated: true, completion: nil)
    }
    
    ///系统 消息提示框  && 左右按钮 && 回调
    static func systemAlertActionEvent(title:String, msg:String?, letBtnTitle:String? = "取消", leftBlock:APPBackClosure? = nil, rightBtnTitle:String? = "确定", rightBlock:APPBackClosure? = nil) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        //左边按钮
        let cancleAction = UIAlertAction(title: letBtnTitle, style: .cancel) { (action) in
            //执行block
            if let blockResult = leftBlock {
                blockResult(true,0)
            }
        }
        
        //右边按钮
        let okAction = UIAlertAction(title: rightBtnTitle, style: .default) { (action) in
            //执行block
            if let blockResult = rightBlock {
                blockResult(true,0)
            }
        }
        
        alertController.addAction(cancleAction)
        alertController.addAction(okAction)
        
        let topVC = self.topViewControllerOfAPP()
        
        topVC?.present(alertController, animated: true, completion: nil)
    }
    
    ///消息提示列表选择
    static func systemAlertListAction(title:String, msg:String?, listTitles:[String], blockAction:@escaping APPBackClosure) {
    
        let alertTellController = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        
        for index in 0..<listTitles.count {
            
            let actionTitle = listTitles[index]
            
            let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
                //执行block
                blockAction(true,index)
            }
            
            alertTellController.addAction(action)
        }
        
        let cancaleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertTellController.addAction(cancaleAction)
        
        let topVC = self.topViewControllerOfAPP()
        topVC?.present(alertTellController, animated: true, completion: nil)
    }
}


//MARK: ************************* APPCustomAlertView *************************

fileprivate class APPCustomAlertView: UIView {
    
}
