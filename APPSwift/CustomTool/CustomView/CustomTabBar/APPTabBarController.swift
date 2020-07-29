//
//  APPTabBarController.swift
//  APPSwift
//  自定义tabBarVC
//  Created by 峰 on 2020/6/22.
//  Copyright © 2020 north_feng. All rights reserved.
//

import UIKit

class APPTabBarController: UITabBarController {
    
    ///tabBarVC 单利
    static let tabBarVC:APPTabBarController = APPTabBarController()

    ///自定义tabBar
    private let customTabBar:UIView = UIView()
    ///tabBar颜色
    private let tabBarColr:UIColor = DynamicColor(UIColor.white, UIColor.black)
    
    ///按钮items条
    private let itemsView:UIView = UIView()
    
    ///分割线
    private let segmentLineView:UIView = UIView()
    private let lineColor = UIColor.gray
    
    
    
    ///记录上一次选中的按钮
    private var lastSelectBackBtn:UIButton = UIButton(type: .custom)
    ///记录上一次选中的图片
    private var lastSelectImage:UIImageView = UIImageView()
    ///记录上一次的label
    private var lastSelectLab:UILabel = UILabel()
    
    ///按钮数组
    private var backBtnArray:[UIButton] = [UIButton]()
    
    ///标题数组
    private var titleArray:[String] = [String]()
    ///默认图片数组
    private var normalImgsArray = [UIImage]()
    ///选中图片数组
    private var selectImgsArray = [UIImage]()
    
    //文字配置
    private let textFont = UIFont.systemFont(ofSize: 11)
    private let textNormalColor = UIColor.gray
    private let textSelectColor = UIColor.blue
    
    
    
    ///重写 veiwDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建tabBar基本视图
        self.createCustomTabBar()
    }

    //MARK: ************************* 对外接口 *************************
    
    ///创建items
    func createItems(defaultIndex:Int = 0, normalImageNames:[String], selectImageNames:[String], itemsTitles:[String]) {
        
        self.selectedIndex = defaultIndex
        
        titleArray = itemsTitles
        for normalName in normalImageNames {
            normalImgsArray.append(UIImage(named: normalName) ?? UIImage())
        }
        for selectName in selectImageNames {
            selectImgsArray.append(UIImage(named: selectName) ?? UIImage())
        }
        
        self.createItemsBtn()//创建items
    }
    
    ///设置tabBar上的VC显示位置
    func setSelectViewController(index:Int) {
        let button:UIButton = itemsView.viewWithTag(index + 10) as? UIButton ?? UIButton(type: .custom)
        self.onClickTabBarItemsBtn(button: button)
    }
    
    ///获取tabBar当前的栏对应的VC
    func getCurrentItemController() -> UIViewController? {
        guard let currentVC = self.selectedViewController else { return nil }
        return currentVC
    }
    
    ///设置tabBar的背景颜色 && items条的背景颜色
    func setBackgroundColor(tabBarColor:UIColor, itemsBarColor:UIColor) {
        customTabBar.backgroundColor = tabBarColor
        itemsView.backgroundColor = itemsBarColor
    }
    
    
    //MARK: ************************* 私有方法 *************************
    private func createItemsBtn() {
        ///按钮宽度
        let btnWidth:CGFloat = kAPPWidth / CGFloat(titleArray.count)
        
        for index in 0..<titleArray.count {
            
            //按钮
            let button:UIButton = UIButton(type: .custom)
            button.tag = 10 + index
            
            //图片
            let btnImgView = UIImageView()
            btnImgView.backgroundColor = UIColor.clear
            btnImgView.image = normalImgsArray[index]
            btnImgView.tag = 20 + index
            button.addSubview(btnImgView)
            
            //文字
            let label = UILabel()
            label.backgroundColor = UIColor.clear
            label.tag = 30 + index
            label.text = titleArray[index]
            label.textColor = textNormalColor
            label.font = textFont
            label.textAlignment = .center
            button.addSubview(label)
            
            //约束
            let imgSize = normalImgsArray[0].size
            
            btnImgView.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(10)
                make.width.equalTo(imgSize.width)
                make.height.equalTo(imgSize.height)
            }
            
            label.snp.makeConstraints { (make) in
                make.centerX.equalTo(btnImgView)
                make.top.equalTo(btnImgView.snp.bottom).offset(2)
                make.width.equalTo(btnWidth)
                make.height.equalTo(14)
            }
            
            //设置选中的样式
            if index == self.selectedIndex {
                
                //设置按钮样式
                btnImgView.image = selectImgsArray[self.selectedIndex]
                label.textColor = textSelectColor
                
                lastSelectBackBtn = button
                lastSelectImage = btnImgView
                lastSelectLab = label
            }
            
            button.addTarget(self, action: #selector(onClickTabBarItemsBtn(button:)), for: .touchUpInside)
            
            itemsView.addSubview(button)
            
            backBtnArray.append(button)
        }
        
        //布局items约束
        self.layoutItemsConstraints()
    }
    
    ///点击 tabBar上的按钮事件
    @objc private func onClickTabBarItemsBtn(button:UIButton) {
        
        if button != lastSelectBackBtn {
            
            //这个是UITabBarController的属性
            self.selectedIndex = button.tag - 10
            
            //把上一次选中的btn的selected = NO
            lastSelectImage.image = normalImgsArray[lastSelectImage.tag - 20]
            lastSelectLab.textColor = textNormalColor
            
            //把本次的点击的btn的selected = YES
            let btnImgView:UIImageView = itemsView.viewWithTag(self.selectedIndex + 20) as? UIImageView ?? UIImageView()
            btnImgView.image = selectImgsArray[self.selectedIndex]
            let label:UILabel = itemsView.viewWithTag(self.selectedIndex + 30) as? UILabel ?? UILabel()
            label.textColor = textSelectColor
            
            lastSelectBackBtn = button
            lastSelectImage = btnImgView
            lastSelectLab = label
        }
    }
    
    ///对所有的按钮进行布局
    private func layoutItemsConstraints() {
        
        for index in 0..<backBtnArray.count {
            
            let button:UIButton = backBtnArray[index]
            
            if index == 0 {
                if backBtnArray.count > 1 {
                    //多个按钮
                    let btnNext:UIButton = backBtnArray[index + 1]//下一个按钮
                    button.snp.makeConstraints { (make) in
                        make.left.top.bottom.equalToSuperview()
                        make.width.equalTo(btnNext)
                    }
                }else{
                    //只有一个按钮
                    button.snp.makeConstraints { (make) in
                        make.left.top.right.bottom.equalToSuperview()
                    }
                }
            }else{
                //第二个按钮 往后
                let btnSuper:UIButton = backBtnArray[index - 1]
                
                if index == backBtnArray.count - 1 {
                    //最后一个按钮
                    button.snp.makeConstraints { (make) in
                        make.left.equalTo(btnSuper.snp.right)
                        make.top.bottom.width.equalTo(btnSuper)
                        make.right.equalToSuperview()
                    }
                }else{
                    //中间的按钮
                    button.snp.makeConstraints { (make) in
                        make.left.equalTo(btnSuper.snp.right)
                        make.top.bottom.width.equalTo(btnSuper)
                    }
                }
            }
            
        }
    }

    
    ///创建自定义的tabBar
    private func createCustomTabBar() {
        
        self.tabBar.isHidden = true//隐藏系统自己的tabBar
        
        //添加自定义 tabBar
        customTabBar.backgroundColor = tabBarColr
        self.view.addSubview(customTabBar)
        customTabBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kTabBarHeight)
        }
        
        //items按钮条
        itemsView.backgroundColor = UIColor.clear
        customTabBar.addSubview(itemsView)
        itemsView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kTabBar_ItemsHeight)
        }
        
        //分割线
        segmentLineView.backgroundColor = lineColor
        customTabBar.addSubview(segmentLineView)
        segmentLineView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    
    //MARK: 底层视图 屏幕 && 状态栏 控制
    ///是否旋转
    override var shouldAutorotate: Bool {
        return self.selectedViewController?.shouldAutorotate ?? false
    }
    
    ///旋转方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.selectedViewController?.preferredInterfaceOrientationForPresentation ?? UIInterfaceOrientation.portrait
    }
    
    ///状态栏样式
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.selectedViewController?.preferredStatusBarStyle ?? UIStatusBarStyle.default
    }
    
    ///状态栏是否隐藏
    override var prefersStatusBarHidden: Bool {
        return self.selectedViewController?.prefersStatusBarHidden ?? false
    }

    
}
