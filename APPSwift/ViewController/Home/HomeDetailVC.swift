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
        
        imgView.image = image
    }
    
    //MARK: ************************* Action && Event *************************
    
    
    //MARK: ************************* 逻辑处理 *************************
    
    
    //MARK: ************************* tableViewDelegate *************************
    
    
    //MARK: ************************* 页面搭建 *************************
    func createView() {
        
        self.view.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(160)
        }
    }
    
}
