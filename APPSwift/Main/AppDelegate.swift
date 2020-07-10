//
//  AppDelegate.swift
//  APPSwift
//
//  Created by 峰 on 2020/6/19.
//  Copyright © 2020 north_feng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    //SceneDelegate 是为了视频 iPadOS系统 一个应用多个窗口而用的，类型 Mac上面的一个应用可以打开多个窗口 ， 在 APP中直接删除
    /**
     info.olist 文件中的 Application Scene Manifest    一栏 直接删除
     
     swift中 没有main.m文件，APP程序入口 被隐藏了【只有在main.swift中的代码才可以作为   top_level_code()  来执行。
     而在其它文件中，是不能直接在文件中含有非声明类的语句，只能含有声明类的代码。】 解释：https://www.cnblogs.com/FranZhou/articles/5007900.html
     */
    
    ///APP内的窗口
    var window:UIWindow?
    
    
    ///是否允许屏幕旋转
    var allowRotate:Bool = false
    
    ///控制屏幕旋转方向  (默认竖屏)
    var orientat:UIInterfaceOrientationMask = .portrait
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //APP配置信息
        self.appConfiguration()
        
        //设置根视图
        self.setRootViewController()
        
    
        return true
    }

}

//MARK: ************************* AppDelegate扩展 ——> RootConTroller *************************
extension AppDelegate {
    
    ///APP配置
    func appConfiguration() {
        
        //设置界面按钮只能点击一个
        UIButton.appearance().isExclusiveTouch = true
        
        //设置键盘适配界面
        APPKeyboardApi.setKeyBoardlayout()
        
        
    }
    
    ///设置根视图
    func setRootViewController() {
        /**
         吐字 && 弹框 获取最上层的 VC时，必须这个方法走完！走完之前调用 获取nil！
         */
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // 让当前UIWindow变成keyWindow，并显示出来
        self.window?.makeKeyAndVisible()
        
        //tabBar
        let tabBar = APPTabBarController.tabBarVC
        
        ///导航条
        let navi = APPNavigationController.appNavi
        navi.navigationBar.isHidden = true//隐藏系统导航条
        
        //设置根视图
        self.window!.rootViewController = navi
        
        let homeVC = HomeVC()
        let middleVC = MiddleVC()
        let mineVC = MineVC()
        
        tabBar.viewControllers = [homeVC,middleVC,mineVC] // ——> 这补直接触发 HomeVC上viewLoad加载方法
        tabBar.createItems(defaultIndex: 0, normalImageNames: ["home_n","order_n","mine_n"], selectImageNames: ["home_s","order_s","mine_s"], itemsTitles: ["首页","发现","我的"])
    }
}
