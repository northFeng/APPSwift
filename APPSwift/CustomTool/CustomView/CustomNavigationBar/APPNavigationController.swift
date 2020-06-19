//
//  APPNavigationController.swift
//  APPSwift
//  导航VC
//  Created by 峰 on 2020/6/19.
//  Copyright © 2020 north_feng. All rights reserved.
//

import UIKit


class APPNavigationController: UINavigationController {
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.modalPresentationStyle = .fullScreen //模态模型为满屏
    }
    
    //MARK: 屏幕旋转受根控制器的影响（屏幕方向由根控制器控制）
    
    ///是否旋转
    override var shouldAutorotate: Bool {
        return self.visibleViewController?.shouldAutorotate ?? false
    }
    
    ///旋转方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.visibleViewController?.supportedInterfaceOrientations ?? UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.visibleViewController?.preferredInterfaceOrientationForPresentation ?? UIInterfaceOrientation.portrait
    }
    
    ///状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.visibleViewController?.preferredStatusBarStyle ?? UIStatusBarStyle.default
    }
    
    ///状态栏是否隐藏
    override var prefersStatusBarHidden: Bool {
        return self.visibleViewController?.prefersStatusBarHidden ?? false
    }
    
}
