//
//  APPBaseController.swift
//  APPSwift
//  APPBaseVC
//  Created by 峰 on 2020/6/19.
//  Copyright © 2020 north_feng. All rights reserved.
//

import UIKit

class APPBaseController: UIViewController,APPNavigationBarViewDelegate {
    
    ///导航条
    let naviBar = APPNavigationBarView()
    
    ///状态栏状态
    private var statusStyle:UIStatusBarStyle = .default
    
    ///状态栏是否隐藏
    private var statusIsHide:Bool {
        willSet {
            self.setNeedsStatusBarAppearanceUpdate()//刷新状态栏
        }
    }
    
    override var title: String? {
        willSet {
            naviBar.title = title ?? ""
        }
    }
    
    
    deinit {
        Print("---- \(NSStringFromClass(type(of: self))) 退出已释放 ----")
        NotificationCenter.default.removeObserver(self)
    }
    
    init() {
        statusIsHide = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///视图加载
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Print("---- \(NSStringFromClass(type(of: self))) 进入 ----")
        
        //注册登录通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginStateChange), name: NSNotification.Name(rawValue: kGlobal_LoginStateChange), object: nil)
        //接收网络状态变化通知
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityNetStateChanged(noti:)), name: NSNotification.Name(rawValue: kGlobal_NetworkingReachabilityChangeNotification), object: nil)
        //深浅模式切换
        NotificationCenter.default.addObserver(self, selector: #selector(changeVCLightOrDarkModel), name: NSNotification.Name(rawValue: kGlobal_LightOrDarkModelChange), object: nil)
        
        
        self.view.backgroundColor = DynamicColor(UIColor.white, UIColor.black)
        
        //设置导航条样式
        naviBar.title = self.title ?? ""
        naviBar.delegate = self
        self.view.addSubview(naviBar)
        naviBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTopNaviBarHeight)
        }
        
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            //设置返回按钮
            naviBar.isHidden = false//显示导航条
            naviBar.setLeftFirstButtonStyle(imgName: "back_s")
        }else{
            naviBar.isHidden = true//隐藏
        }
        
        self.initData()
        self.setNaviBarStyle()
    }
    
    
    ///初始化数据参数
    func initData() {
        
    }
    
    ///设置状态栏样式
    func setNaviBarStyle() {
        
    }
    
    //MARK: ************************* 设置状态栏 *************************
    ///设置状态栏样式为默认
    func setStatusBarStyleDefault() {
        statusStyle = .default
        self.setNeedsStatusBarAppearanceUpdate()//更新状态栏
    }
    
    ///设置状态栏样式为白色
    func setStatusBarStyleLight() {
        statusStyle = .lightContent
        self.setNeedsStatusBarAppearanceUpdate()//更新状态栏
    }
    
    ///设置状态栏样式为暗黑
    func setStatusBarStyleDark() {
        if #available(iOS 13.0, *) {
            statusStyle = .darkContent
            self.setNeedsStatusBarAppearanceUpdate()//更新状态栏
        }
    }
    
    //是否隐藏
    override var prefersStatusBarHidden: Bool {
        get {
            return statusIsHide
        }
    }
    
    //状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return statusStyle
        }
    }
    
    //状态栏隐藏动画
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        get {
            return .slide
        }
    }
    
    //MARK: ************************* 返回手势 开启 && 关闭 *************************
    ///禁止返回手势
    func removeBackGesture() {
        if ((self.navigationController?.interactivePopGestureRecognizer) != nil) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    ///恢复返回手势
    func resumeBackGesture() {
        if ((self.navigationController?.interactivePopGestureRecognizer) != nil) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    //MARK: ************************* 通知监听 *************************
    @objc func loginStateChange() {
        Print("登录状态发声变化")
    }
    
    @objc func reachabilityNetStateChanged(noti:NSNotification) {
        
    }
    
    @objc func changeVCLightOrDarkModel() {
        
        if #available(iOS 13.0, *) {
            
            
        }
    }
    
    ///暗黑模式改变的监听
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                //模式已变
                if statusStyle != .default {
                    //不是系统默认的
                    if self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.light {
                        //更新黑暗模式
                        self.setStatusBarStyleDark()
                    }else if self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark {
                        //更新亮色模式
                        self.setStatusBarStyleLight()
                    }
                }
            }
        }
        
        /** 这些布局方法也会触发
          - (void)drawRect;
          - (void)viewWillLayoutSubviews;
          - (void)viewDidLayoutSubviews;
        */
    }
    
    //MARK: ************************* 导航条代理 *************************
    func leftFirstButtonClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightFirstButtonClick() {
        
    }
    
    func rightSecondButtonClick() {
        
    }
    
}
