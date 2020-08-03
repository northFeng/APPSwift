//
//  APPSegmentBtnView.swift
//  APPSwift
//  按钮切换
//  Created by 峰 on 2020/7/21.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

class APPSegmentBtnView: UIView {
    
    private var btnSelect = SegmentButton(type: .custom)
    
    ///按钮数组
    private var btnArray:[SegmentButton] = []
    
    ///底部下划线
    var lineUnder = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)))
    
    ///按钮底边 到 下划线 中心位置
    private var btnLineCenterHeight:CGFloat = 0
    
    ///block回调
    var blockIndex:((Int)->Void) = {index in }
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///设置选中按钮位置
    func setButtonIndex(index:Int) {
        let button:SegmentButton = self.viewWithTag(1000 + index) as! SegmentButton
        self.onClickButton(button: button)
    }
    
    ///设置 按钮数据 (必须先设置APPSegmentBtnView的frame )
    func setButtonsData(titlesNormal:[NSAttributedString], titlesSelect:[NSAttributedString], btnSize:CGSize, btnToLineCenterHeight:CGFloat, lineUnderSize:CGSize, lineColor:UIColor, defaultIndex:Int = 0) {
        
        btnLineCenterHeight = btnToLineCenterHeight
        
        if titlesNormal.count > 0 {
            
            lineUnder.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: lineUnderSize)
            lineUnder.backgroundColor = lineColor
            lineUnder.layer.cornerRadius = lineUnderSize.height / 2
            self.addSubview(lineUnder)
            
            let btnSpace = (self.frame.size.width - (btnSize.width * CGFloat(titlesNormal.count))) / (CGFloat(titlesNormal.count) - 1)
                        
            for index in 0..<titlesNormal.count {
                
                let button:SegmentButton = SegmentButton(type: .custom)
                //按钮显示数据
                button.backgroundColor = UIColor.clear
                button.setAttributedTitle(titlesNormal[index], for: .normal)
                button.setAttributedTitle(titlesSelect[index], for: .selected)
                button.isSelected = false
                button.tag = 1000 + index
                button.frame = CGRect(origin: CGPoint(x: (btnSize.width + btnSpace) * CGFloat(index), y: 0), size: btnSize)
                
                self.addSubview(button)
                
                if defaultIndex == index {
                    //选中的位置
                    btnSelect = button
                    btnSelect.isSelected = true
                    lineUnder.center = CGPoint(x: btnSelect.center.x, y: btnSelect.frame.size.height + btnLineCenterHeight)
                }
                button.addTarget(self, action: #selector(onClickButton(button:)), for: .touchUpInside)
                
                btnArray.append(button)
            }
            
            self.bringSubviewToFront(lineUnder)//把划线至于顶层
        }
    }
    
    ///按钮点击事件
    @objc private func onClickButton(button:SegmentButton) {
        
        //旧版按钮改变样式
        btnSelect.isSelected = false
        
        //改变新按钮样式
        btnSelect = button
        btnSelect.isSelected = true
        
        UIView.animate(withDuration: 0.2) {
            self.lineUnder.center = CGPoint(x: self.btnSelect.center.x, y: self.btnSelect.frame.size.height + self.btnLineCenterHeight)
        }
        
        blockIndex(btnSelect.tag - 1000)//回调点击位置
    }
    
}


fileprivate class SegmentButton: UIButton {
    
    
    
    
}
