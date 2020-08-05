//
//  HomeDetailVC.swift
//  APPSwift
//
//  Created by 峰 on 2020/8/5.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation


class HomeDetailVC: APPBaseController {
    
    var image:UIImage?
    var oldFrame:CGRect?
    
    
    private var imgView:UIImageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        
        self.createView()
        self.bindViewModel()
    }
    
    ///数据计算
    override func initData() {
        
    }
    
    //设置状态栏
    override func setNaviBarStyle() {
        
    }
    
    //MARK: ************************* viewModel绑定 *************************
    ///数据绑定
    func bindViewModel() {
        
    }
    
    //MARK: ************************* Action && Event *************************
    
    
    //MARK: ************************* 逻辑处理 *************************
    ///显示
    func showImgview() {
        imgView.image = image
        imgView.frame = CGRect(x: (kAPPWidth - 120.0)/2.0, y: (kAPPHeight - 160.0)/2.0, width: 120, height: 160)
        imgView.isHidden = false
    }
    
    //MARK: ************************* tableViewDelegate *************************
    
    
    //MARK: ************************* 页面搭建 *************************
    func createView() {
        
        imgView.frame = CGRect(x: (kAPPWidth - 120.0)/2.0, y: (kAPPHeight - 160.0)/2.0, width: 120, height: 160)
        self.view.addSubview(imgView)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.4, animations: {
            self.imgView.frame = self.oldFrame!
            self.view.alpha = 0
        }) { (complete) in
            self.imgView.isHidden = true
        }
    }
    
    override func leftFirstButtonClick() {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.imgView.frame = self.oldFrame!
            self.view.alpha = 0
        }) { (complete) in
        }
    }
    
}
