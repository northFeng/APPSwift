//
//  APPSegmentBtnView.swift
//  APPSwift
//  按钮切换 (适用于按钮个数在5个以下，按钮全部展示不能滑动的情况下使用)
//  Created by 峰 on 2020/7/21.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

class APPSegmentBtnView: UIView, UIScrollViewDelegate {
    
    private var btnSelect = SegmentButton(type: .custom)
    
    ///按钮数组
    private var btnArray:[SegmentButton] = []
    
    ///底部下划线
    var lineUnder = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)))
    
    ///按钮底边 到 下划线 中心位置
    private var btnLineCenterHeight:CGFloat = 0
    
    ///block回调
    var blockIndex:((Int)->Void) = {index in }
    
    ///scrollView
    private var bridgeScrollView:UIScrollView?
    
    ///偏移量
    private var beginOffsetX:CGFloat = 0
    
    ///选中的item下标
    private var selectedItemIndex:Int = 0
    
    ///选中的item变形比例  默认1.3
    var selectedItemZoomScale:CGFloat = 1.3
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        bridgeScrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    
    ///设置 按钮数据 (必须先设置APPSegmentBtnView的frame )
    func setButtonsData(titlesNormal:[NSAttributedString], titlesSelect:[NSAttributedString], btnHeight:CGFloat, btnToLineCenterHeight:CGFloat, lineUnderSize:CGSize, lineColor:UIColor, defaultIndex:Int = 0, scrollView:UIScrollView) {
        
        btnLineCenterHeight = btnToLineCenterHeight
        
        selectedItemIndex = defaultIndex//默认位置
        
        if titlesNormal.count > 0 {
            
            lineUnder.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: lineUnderSize)
            lineUnder.backgroundColor = lineColor
            lineUnder.layer.cornerRadius = lineUnderSize.height / 2
            self.addSubview(lineUnder)
            
            var btnTotalWidth:CGFloat = 0 //按钮总长度
            
            for index in 0..<titlesNormal.count {
                
                let button:SegmentButton = SegmentButton(type: .custom)
                //按钮显示数据
                button.backgroundColor = UIColor.clear
                button.setAttributedTitle(titlesNormal[index], for: .normal)
                button.setAttributedTitle(titlesSelect[index], for: .selected)
                button.isSelected = false
                button.tag = 1000 + index
                
                //获取文字宽度
                let titleSelect:NSAttributedString = titlesSelect[index]
                let selectString = titleSelect.string
                var rang = NSMakeRange(0, selectString.count)
                
                let dicAttr = titleSelect.attributes(at: 0, effectiveRange: &rang)
                
                let option = NSStringDrawingOptions.usesLineFragmentOrigin
                let textRect = titleSelect.string.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: btnHeight),options: option,attributes: dicAttr,context:nil)
                
                button.textWidth = textRect.width + 5 //多加5个长度
                //button.frame = CGRect(origin: CGPoint(x: (btnSize.width + btnSpace) * CGFloat(index), y: 0), size: btnSize)
                
                self.addSubview(button)
                
                button.addTarget(self, action: #selector(onClickButton(button:)), for: .touchUpInside)
                
                btnArray.append(button)
                btnTotalWidth += button.textWidth
            }
            
            //计算出按钮间距
            let btnSpace = (self.frame.size.width - btnTotalWidth) / (CGFloat(titlesNormal.count) - 1)
            
            //进行按钮之间的布局
            for index in 0..<btnArray.count {
                let button = btnArray[index]
                if index == 0 {
                    button.frame = CGRect(x: 0, y: 0, width: button.textWidth, height: btnHeight)
                }else{
                    let upButton = btnArray[index - 1]
                    button.frame = CGRect(x: (upButton.frame.origin.x + upButton.frame.size.width) + btnSpace, y: 0, width: button.textWidth, height: btnHeight)
                }
                
                if defaultIndex == index {
                    //选中的位置
                    btnSelect = button
                    btnSelect.isSelected = true
                    lineUnder.center = CGPoint(x: btnSelect.center.x, y: (btnSelect.frame.origin.y + btnSelect.frame.size.height + btnLineCenterHeight))
                }
            }
            
            self.bringSubviewToFront(lineUnder)//把划线至于顶层
            
            bridgeScrollView = scrollView
            bridgeScrollView?.delegate = self
            bridgeScrollView?.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    
    ///设置选中按钮位置
    func setButtonIndex(index:Int) {
        selectedItemIndex = index
        let button:SegmentButton = self.viewWithTag(1000 + index) as! SegmentButton
        self.onClickButton(button: button)
    }
    
    ///滑动代理事件
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //没有滚动了 && 没有拖拽
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.setButtonIndex(index: index)
    }
    
    ///按钮点击事件
    @objc private func onClickButton(button:SegmentButton) {
        
        //旧版按钮改变样式
        btnSelect.isSelected = false
        
        //改变新按钮样式
        btnSelect = button
        btnSelect.isSelected = true
        
        UIView.animate(withDuration: 0.2) {
            self.lineUnder.center = CGPoint(x: self.btnSelect.center.x, y: (self.btnSelect.frame.origin.y + self.btnSelect.frame.size.height + self.btnLineCenterHeight))
            self.bridgeScrollView?.contentOffset = CGPoint(x: (self.bridgeScrollView?.frame.size.width ?? 0) * CGFloat(button.tag - 1000), y: 0)
        }
        
        blockIndex(btnSelect.tag - 1000)//回调点击位置
    }
    
    ///监听 scrollView的huado
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentOffset" && object is UIScrollView {
            
            //处理滑动条
            self.prepareMoveTrackerFollowScrollView(scorllView: bridgeScrollView!)
        }
    }
    
    ///处理滑动事件 滑动变化
    private func prepareMoveTrackerFollowScrollView(scorllView:UIScrollView) {
        // 这个if条件的意思是scrollView的滑动不是由手指拖拽产生
        if !scorllView.isDragging && !scorllView.isDecelerating {
            return
        }
        // 当滑到边界时，继续通过scrollView的bouces效果滑动时，直接return
        if scorllView.contentOffset.x < 0 || scorllView.contentOffset.x > scorllView.contentSize.width - scorllView.bounds.size.width {
            return
        }
        
        //当前偏移量
        let currentOffSetX:CGFloat = scorllView.contentOffset.x
        //偏移进度
        let offsetProgress:CGFloat = currentOffSetX / scorllView.bounds.size.width
        var progress = offsetProgress - floor(offsetProgress)
        
        
        var fromIndex = 0
        var toIndex = 0
        // 初始值不要等于scrollView.contentOffset.x,因为第一次进入此方法时，scrollView.contentOffset.x的值已经有一点点偏移了，不是很准确
        beginOffsetX = scorllView.bounds.size.width * CGFloat(selectedItemIndex)
        
        //以下注释的“拖拽”一词很准确，不可说成滑动，例如:当手指向右拖拽，还未拖到一半时就松开手，接下来scrollView则会往回滑动，这个往回，就是向左滑动，这也是_beginOffsetX不可时刻纪录的原因，如果时刻纪录，那么往回(向左)滑动时会被视为“向左拖拽”,然而，这个往回却是由“向右拖拽”而导致的
        if currentOffSetX - beginOffsetX > 0 {
            //向左拖拽了  ——> 求商,获取上一个item的下标
            fromIndex = Int(currentOffSetX / scorllView.bounds.size.width)
            //当前item的下标等于上一个item的下标加1
            toIndex = fromIndex + 1
            if toIndex >= btnArray.count {
                toIndex = fromIndex
            }
        }else if currentOffSetX - beginOffsetX < 0 {
            //向右拖拽了
            toIndex = Int(currentOffSetX / scorllView.bounds.size.width)
            fromIndex = toIndex + 1
            progress = 1.0 - progress
        }else {
            progress = 1.0
            fromIndex = selectedItemIndex
            toIndex = fromIndex
        }
        
        if currentOffSetX == scorllView.bounds.size.width * CGFloat(fromIndex) {
            //滚动停止了
            progress = 1
            toIndex = fromIndex
        }
        
        // 如果滚动停止，直接通过点击按钮选中toIndex对应的item
        if currentOffSetX == scorllView.bounds.size.width * CGFloat(toIndex) {
            // 这里toIndex==fromIndex
            //这一次赋值起到2个作用，一是点击toIndex对应的按钮，走一遍代理方法,二是弥补跟踪器的结束跟踪，因为本方法是在scrollViewDidScroll中调用，可能离滚动结束还有一丁点的距离，本方法就不调了,最终导致外界还要在scrollView滚动结束的方法里self.selectedItemIndex进行赋值,直接在这里赋值可以让外界不用做此操作
            if selectedItemIndex != toIndex {
                selectedItemIndex = toIndex
            }
            // 要return，点击了按钮，跟踪器自然会跟着被点击的按钮走
            return
        }
        
        self.moveTracker(progress: progress, fromIndex: fromIndex, toIndex: toIndex, currentOffsetX: currentOffSetX, beginOffsetX: beginOffsetX)
    }
    
    ///这个方法才开始真正滑动跟踪器，上面都是做铺垫
    private func moveTracker(progress:CGFloat, fromIndex:Int, toIndex:Int, currentOffsetX:CGFloat, beginOffsetX:CGFloat) {
        
        let fromButton = btnArray[fromIndex]
        let toButton = btnArray[toIndex]
        
        // 2个按钮之间的距离
        let xDistance = toButton.center.x - fromButton.center.x
        // 2个按钮宽度的差值
        //let wDistance = toButton.frame.size.width - fromButton.frame.size.width
        
        //var newFrame:CGRect = lineUnder.frame
        var newCenter = lineUnder.center
        newCenter.x = fromButton.center.x + xDistance * progress
        
        lineUnder.center = newCenter
        
        //开始变形
        /**
         let diff = selectedItemZoomScale - 1//变形大小
         fromButton.transform = CGAffineTransform(scaleX: (1 - progress) * diff + 1, y: (1 - progress) * diff + 1)
         toButton.transform = CGAffineTransform(scaleX: progress * diff + 1, y: progress * diff + 1)
         */
    }
    
    
}


fileprivate class SegmentButton: UIButton {
    
    ///文字宽度
    var textWidth:CGFloat = 0
    
    
}

/**
self.view.addSubview(btnsView)
let oneN = NSAttributedString(string: "一博", attributes: [NSAttributedString.Key.font:FontOfSystem(font: 15),NSAttributedString.Key.foregroundColor:UIColor.black])
let ones = NSAttributedString(string: "一博", attributes: [NSAttributedString.Key.font:FontOfCustom(name: kMediumFont, font: 15),NSAttributedString.Key.foregroundColor:UIColor.yellow])

let twoN = NSAttributedString(string: "嘉尔", attributes: [NSAttributedString.Key.font:FontOfSystem(font: 15),NSAttributedString.Key.foregroundColor:UIColor.black])
let twos = NSAttributedString(string: "王嘉尔", attributes: [NSAttributedString.Key.font:FontOfCustom(name: kMediumFont, font: 15),NSAttributedString.Key.foregroundColor:UIColor.yellow])

let thrN = NSAttributedString(string: "张艺兴努力", attributes: [NSAttributedString.Key.font:FontOfSystem(font: 15),NSAttributedString.Key.foregroundColor:UIColor.black])
let thrs = NSAttributedString(string: "张艺兴努力", attributes: [NSAttributedString.Key.font:FontOfCustom(name: kMediumFont, font: 15),NSAttributedString.Key.foregroundColor:UIColor.yellow])

let forN = NSAttributedString(string: "良", attributes: [NSAttributedString.Key.font:FontOfSystem(font: 15),NSAttributedString.Key.foregroundColor:UIColor.black])
let fors = NSAttributedString(string: "良", attributes: [NSAttributedString.Key.font:FontOfCustom(name: kMediumFont, font: 15),NSAttributedString.Key.foregroundColor:UIColor.yellow])

btnsView.setButtonsData(titlesNormal: [oneN,twoN,thrN,forN], titlesSelect: [ones,twos,thrs,fors], btnHeight: 25, btnToLineCenterHeight: 7, lineUnderSize: CGSize(width: 20, height: 6), lineColor: UIColor.green, scrollView: scrollView)

btnsView.blockIndex = {
    //[unowned self]
    index in
    
}
 */
