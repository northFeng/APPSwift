//
//  APPNavigationBarView.swift
//  APPSwift
//  导航条barView
//  Created by 峰 on 2020/6/20.
//  Copyright © 2020 north_feng. All rights reserved.
//

import UIKit

protocol APPNavigationBarViewDelegate:NSObject {
    
    ///点击左边第一个按钮
    func leftFirstButtonClick() -> Void
    
    ///点击右边第一个按钮
    func rightFirstButtonClick() -> Void
    
    ///点击右边第二个按钮
    func rightSecondButtonClick() -> Void
    
}


class APPNavigationBarView: UIView {
    
    unowned var delegate:APPNavigationBarViewDelegate?
    
    var title:String {
        willSet {
            titleLabel.text = newValue
        }
    }
    
    ///按钮条
    let naviBarView:UIView
    
    ///标题label
    let titleLabel:UILabel
    
    ///左边第一个按钮
    let leftFirstBtn:UIButton
    
    ///右边第一个按钮
    let rightFirstBtn:UIButton
    
    ///右边第二个按钮
    let rightSecondBtn:UIButton
    
    ///底部分割线view
    let segmentLineView:UIView
    
    
    init() {
        
        //初始化
        title = ""
        naviBarView = UIView()
        titleLabel = UILabel()
        leftFirstBtn = UIButton(type: .custom)
        rightFirstBtn = UIButton(type: .custom)
        rightSecondBtn = UIButton(type: .custom)
        segmentLineView = UIView()
        
        super.init(frame: CGRect(origin: CGPoint(), size: CGSize()))
        
        ///布局界面
        self.layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///布局界面
    private func layoutViews() {
        
        self.backgroundColor = DynamicColor(lightStylecolor: UIColor.white, darkStylecolor: UIColor.black)

        //按钮条
        naviBarView.backgroundColor = UIColor.clear
        self.addSubview(naviBarView)
        naviBarView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kNaviBar_ItemBarHeight)
        }
        
        //标题
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont(name: "PingFangSC-Medium", size: 18)
        titleLabel.textColor = DynamicColor(lightStylecolor: UIColor.black, darkStylecolor: UIColor.white)
        titleLabel.textAlignment = .center
        naviBarView.addSubview(titleLabel)
        
        //左边按钮
        leftFirstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        leftFirstBtn.addTarget(self, action: #selector(leftFirstButtonClick), for: .touchUpInside)
        naviBarView.addSubview(leftFirstBtn)
        
        //右边第一个按钮
        rightFirstBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        rightFirstBtn.addTarget(self, action: #selector(rightFirstButtonClick), for: .touchUpInside)
        naviBarView.addSubview(rightFirstBtn)
        
        //右边第二个按钮
        rightSecondBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        rightSecondBtn.addTarget(self, action: #selector(rightSecondButtonClick), for: .touchUpInside)
        naviBarView.addSubview(rightSecondBtn)
        
        //分割线
        segmentLineView.backgroundColor = UIColor.clear
        self.addSubview(segmentLineView)
        
        //建立约束
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(26)
            make.width.equalTo(150)
        }
        
        leftFirstBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.left.equalToSuperview().offset(5)
            make.width.height.equalTo(40)
        }
        
        rightFirstBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-5)
            make.width.height.equalTo(40)
        }
        
        rightSecondBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(rightFirstBtn)
            make.right.equalTo(rightFirstBtn.snp.left).offset(-5)
            make.width.height.equalTo(40)
        }
        
        segmentLineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        //默认样式
        leftFirstBtn.isHidden = true
        rightFirstBtn.isHidden = true
        rightSecondBtn.isHidden = true
        segmentLineView.isHidden = true
    }

    //MARK: ************************* 设置样式 *************************
    
    ///设置导航条背景颜色
    func setNaviBarBackgroundColor(bgColor:UIColor) {
        
        self.backgroundColor = bgColor
    }
    
    ///设置分割线颜色
    func setSegmentLineColor(color:UIColor) {
        segmentLineView.isHidden = false
        segmentLineView.backgroundColor = color
    }
    
    ///设置 左边第一个按钮 图片name || 标题
    func setLeftFirstButtonStyle(imgName:String = "", title:String = "") {
        if imgName.count > 0 {
            leftFirstBtn.isHidden = false
            leftFirstBtn.setImage(UIImage(named: imgName), for: .normal)
        }
        if title.count > 0 {
            leftFirstBtn.isHidden = false
            leftFirstBtn.setTitle(title, for: .normal)
        }
    }
    
    ///设置 右边第一个按钮 图片name || 标题
    func setRightFirstButtonStyle(imgName:String = "", title:String = "") {
        if imgName.count > 0 {
            rightFirstBtn.isHidden = false
            rightFirstBtn.setImage(UIImage(named: imgName), for: .normal)
        }
        if title.count > 0 {
            rightFirstBtn.isHidden = false
            rightFirstBtn.setTitle(title, for: .normal)
        }
    }
    
    ///设置 右边第二个按钮 图片name || 标题
    func setRightSecondButtonStyle(imgName:String = "", title:String = "") {
        if imgName.count > 0 {
            rightSecondBtn.isHidden = false
            rightSecondBtn.setImage(UIImage(named: imgName), for: .normal)
        }
        if title.count > 0 {
            rightSecondBtn.isHidden = false
            rightSecondBtn.setTitle(title, for: .normal)
        }
    }

    //MARK: ************************* 点击事件 *************************
    ///点击左边第一个按钮
    @objc func leftFirstButtonClick() -> Void {
        if delegate?.responds(to: #selector(leftFirstButtonClick)) ?? false {
            delegate?.leftFirstButtonClick()
        }
    }
    
    ///点击右边第一个按钮
    @objc func rightFirstButtonClick() -> Void {
        if delegate?.responds(to: #selector(rightFirstButtonClick)) ?? false {
            delegate?.rightFirstButtonClick()
        }
    }
    
    ///点击右边第二个按钮
    @objc func rightSecondButtonClick() -> Void {
        if delegate?.responds(to: #selector(rightSecondButtonClick)) ?? false {
            delegate?.rightSecondButtonClick()
        }
    }
}
