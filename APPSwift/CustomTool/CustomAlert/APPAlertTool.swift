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
    static func systemAlertMsg(title:String, msg:String?, btnTitle:String? = "确定", blockAction:APPBackClosure? = nil) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let cancleAction = UIAlertAction(title: btnTitle, style: .cancel) { (action) in
            //执行block
            if let blockResult = blockAction {
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
    
    ///backView
    let backView = UIView()
    
    ///标题
    let titleLabel = UILabel()
    
    ///描述
    let birfLabel = UILabel()
    let birfColor = DynamicColor(COLOR("#384A74"), UIColor.lightText)
    
    ///竖线
    let lineS = UIView()
    
    
    ///取消按钮
    let cancleBtn = UIButton(type: .custom)
    
    ///确定按钮
    let okBtn = UIButton(type: .custom)
    
    ///取消回调
    var cancleBlock:APPBackClosure?
    
    ///确定回调
    var okBlock:APPBackClosure?
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.backgroundColor = COLOR("#222F3A", alpha: 0.72)
        
        self.createView()//创建view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///创建view
    func createView() {
        //设置 backView 基本属性
        backView.frame = CG_Rect((kScreenWidth - 285*kIpadScale)/2.0, kScreenHeight*0.35, 285*kIpadScale, 285*kIpadScale*(176.0/285.0))
        backView.layer.cornerRadius = 16
        backView.alpha = 0
        self.addSubview(backView)
        
        //标题
        titleLabel.textColor = DynamicColor(COLOR("#384A74"), UIColor.lightText)
        titleLabel.font = kFontOfCustom(name: kMediumFont, font: 14*kIpadScale)
        titleLabel.textAlignment = .center
        titleLabel.text = "温馨提示"
        backView.addSubview(titleLabel)
        
        //描述
        birfLabel.textColor = birfColor
        birfLabel.font = kFontOfSystem(font: 14*kIpadScale)
        birfLabel.textAlignment = .center
        birfLabel.text = ""
        birfLabel.numberOfLines = 10;//最大10行文字
        backView.addSubview(birfLabel)
        
        //添加横线
        let lineH = UIView()
        lineH.backgroundColor = COLOR("#E4E4E4")
        backView.addSubview(lineH)
        
        lineS.backgroundColor = COLOR("E4E4E4")
        backView.addSubview(lineS)
        
        //取消按钮
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(DynamicColor(COLOR("#717B99"), UIColor.lightText), for: .normal)
        cancleBtn.titleLabel?.font = kFontOfCustom(name: kMediumFont, font: 14*kIpadScale)
        backView.addSubview(cancleBtn)
        
        //确定按钮
        okBtn.setTitle("确认", for: .normal)
        okBtn.setTitleColor(COLOR("#65BAFF"), for: .normal)
        okBtn.titleLabel?.font = kFontOfCustom(name: kMediumFont, font: 14*kIpadScale)
        backView.addSubview(okBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(20*kIpadScale)
            make.height.equalTo(20*kIpadScale)
        }
        
        birfLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalToSuperview().offset(FitIpad(55))
        }
        
        lineH.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(48*kIpadScale)
            make.height.equalTo(0.5)
        }
        
        lineS.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineH.snp.bottom).offset(1)
            make.bottom.equalToSuperview()
            make.width.equalTo(0.5)
        }
        
        lineS.isHidden = false
        cancleBtn.isHidden = true
        okBtn.isHidden = true
        
        cancleBtn.addTarget(self, action: #selector(onClickBtnCancle), for: .touchUpInside)
        okBtn.addTarget(self, action: #selector(onClickBtnOk), for: .touchUpInside)
    }
    
    ///点击取消
    @objc func onClickBtnCancle() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.backView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.backView.alpha = 0
        }) { (finished) in
            self.isHidden = true
            self.removeFromSuperview()
            if let block = self.cancleBlock {
                block(true,0)
            }
        }
    }
    
    ///点击确定
    @objc func onClickBtnOk() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.backView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.backView.alpha = 0
        }) { (finished) in
            self.isHidden = true
            self.removeFromSuperview()
            if let block = self.okBlock {
                block(true,0)
            }
        }
    }
    
    ///样式一 ：确定按钮
    func showAlertOneBtn(title:String? = "", msg:String, blockOk:@escaping APPBackClosure) {
        titleLabel.text = title
        birfLabel.attributedText = APPFunctionApi.string_getAttributeString(text: msg, font: kFontOfSystem(font: FitIpad(14)), color: birfColor, spacing: 2, alignment: .center)
        okBlock = blockOk
        
        okBtn.isHidden = false
        okBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(FitIpad(48))
            make.width.equalTo(FitIpad(100))
        }
        
        if let textTtitle = title {
            if textTtitle.count == 0 {
                //没有标题 ——> 更新描述约束
                birfLabel.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(FitIpad(20))
                }
            }
        }
        
        self.showAlertView()
    }
    
    ///样式二：两个按钮
    func showAlertTwoBtn(title:String? = "", msg:String, leftTitle:String = "取消", rightTitle:String = "确定", leftBlock:APPBackClosure? = nil, rightBlock:APPBackClosure? = nil) {
        titleLabel.text = title
        birfLabel.attributedText = APPFunctionApi.string_getAttributeString(text: msg, font: kFontOfSystem(font: FitIpad(14)), color: birfColor, spacing: 2, alignment: .center)
        cancleBtn.setTitle(leftTitle, for: .normal)
        okBtn.setTitle(rightTitle, for: .normal)
        
        cancleBlock = leftBlock
        okBlock = rightBlock
        
        lineS.isHidden = false
        cancleBtn.isHidden = false
        okBtn.isHidden = false
        
        cancleBtn.snp.makeConstraints { (make) in
            make.right.equalTo(lineS).offset(-10)
            make.centerY.equalTo(lineS)
            make.width.equalTo(FitIpad(100))
            make.height.equalTo(FitIpad(48))
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lineS).offset(10)
            make.centerY.equalTo(lineS)
            make.width.equalTo(FitIpad(100))
            make.height.equalTo(FitIpad(48))
        }
        
        if let textTtitle = title {
            if textTtitle.count == 0 {
                //没有标题 ——> 更新描述约束
                birfLabel.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(FitIpad(20))
                }
            }
        }
        
        self.showAlertView()
    }
    
    ///样式三：万能版本
    func showAlertCustom(title:String? = "", msg:String, leftTitle:NSAttributedString?, rightTitle:NSAttributedString?, leftBlock:APPBackClosure? = nil, rightBlock:APPBackClosure? = nil) {
        
        titleLabel.text = title
        birfLabel.attributedText = APPFunctionApi.string_getAttributeString(text: msg, font: kFontOfSystem(font: FitIpad(14)), color: birfColor, spacing: 2, alignment: .center)
        cancleBtn.setAttributedTitle(leftTitle, for: .normal)
        okBtn.setAttributedTitle(rightTitle, for: .normal)
        
        cancleBlock = leftBlock
        okBlock = rightBlock
        
        lineS.isHidden = false
        cancleBtn.isHidden = false
        okBtn.isHidden = false
        
        cancleBtn.snp.makeConstraints { (make) in
            make.right.equalTo(lineS).offset(-10)
            make.centerY.equalTo(lineS)
            make.width.equalTo(FitIpad(100))
            make.height.equalTo(FitIpad(48))
        }
        
        okBtn.snp.makeConstraints { (make) in
            make.left.equalTo(lineS).offset(10)
            make.centerY.equalTo(lineS)
            make.width.equalTo(FitIpad(100))
            make.height.equalTo(FitIpad(48))
        }
        
        if let textTtitle = title {
            if textTtitle.count == 0 {
                //没有标题 ——> 更新描述约束
                birfLabel.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(FitIpad(20))
                }
            }
        }
        
        self.showAlertView()
    }
    
    func showAlertView() {
        
        let birfHeight = APPFunctionApi.string_getTextHeight(text: <#T##String#>, font: <#T##UIFont#>, spacing: <#T##CGFloat#>, widthFix: <#T##CGFloat#>)
        
    }
    
    
}
