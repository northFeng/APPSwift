//
//  GFTextField.swift
//  APPSwift
//  自定义输入框
//  Created by 峰 on 2020/8/11.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation


class GFTextField: UITextField {
    
    ///输入框类型
    enum TextFieldType {
        //默认（输入任何文本）
        case Default
        ///手机号（只能11位数字）
        case Mobile
        ///验证码 密文
        case Code_Cipher
        ///验证码 明文
        case Code_Clear
    }
    
    ///限制文字长度 --- 默认无穷大 （汉语两个字节为一个汉字，英文一个单词为一个一字节）
    var textLengthLimit:Int = LONG_MAX
    
    ///输入框类型
    var tfType:TextFieldType{
        willSet{
            
        }
    }
    
    ///是否展示 菜单
    var showMenuAction:Bool = false
    
    ///上一次文本长度
    private var uptextLength = 0
    
    ///view数组
    private var viewsArray:[UIView] = []
    
    ///自定义竖线
    private var lineView = GFLineTF()
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(textFieldType:TextFieldType = .Default, lengthLimit:Int = LONG_MAX, menuShow:Bool = false) {
        tfType = textFieldType
        textLengthLimit = lengthLimit
        showMenuAction = menuShow
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    override init(frame: CGRect) {
        tfType = .Default
        
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledEditChanged(noti:)), name: NSNotification.Name(rawValue: ""), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ************************* 输入框文字变化通知 *************************
    @objc func textFiledEditChanged(noti:Notification) {
        
        var toBeString:String = self.text ?? ""
        let lang = self.textInputMode?.primaryLanguage
        
        if lang == "zh-Hans" {
            //简体中文输入，包括简体拼音，健体五笔，简体手写
            let selectedRange = self.markedTextRange
            //获取高亮部分
            let position = self.position(from: selectedRange?.start ?? UITextPosition(), offset: 0)
            //没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if position != nil {
                if toBeString.count > textLengthLimit {
                    self.text = toBeString.string_range(start: 0, end: textLengthLimit - 1)
                }
            }else{
                //有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        }else{
            //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if toBeString.count > textLengthLimit {
                self.text = toBeString.string_range(start: 0, end: textLengthLimit - 1)
            }
        }
        
        
        //处理
        switch tfType {
            
        case .Default:
            //默认
            Print("")
        case .Mobile:
            //判断在输入还是删除
            
            //再次获取文字
            toBeString = self.text ?? ""
            
            if uptextLength < self.text?.count ?? 0 {
                //输入字符
                if toBeString.count == 3 || toBeString.count == 8 {
                    self.text = toBeString + " "
                }else if uptextLength == 3 || uptextLength == 8 {
                    self.text = String(format: "%@ %@", toBeString.string_range(start: 0, end: uptextLength - 1),toBeString.string_range(start: uptextLength, end: toBeString.count - 1))
                }
            }else if uptextLength > toBeString.count {
                //删除字符
                if toBeString.count == 4 || toBeString.count == 9 {
                    self.text = toBeString.string_range(start: 0, end: toBeString.count - 2)
                }
            }
            
            uptextLength = self.text?.count ?? 0 //更新长度
            
        case .Code_Cipher,.Code_Clear:
            //验证码隐藏
            
            //再次获取文字
            toBeString = self.text ?? ""
            
            if viewsArray.count > 0 {
                for backView in viewsArray {
                    let index = backView.tag - 1000
                    
                    if index < toBeString.count {
                        //要显示的
                        backView.isHidden = false
                        
                        if tfType == .Code_Clear {
                            //明文
                            let label = backView as! UILabel
                            label.text = toBeString.string_range(start: index, end: index)
                        }else{
                            backView.isHidden = true
                        }
                    }else{
                        if tfType == .Code_Clear {
                            let label = backView as! UILabel
                            label.text = ""
                        }else{
                            backView.isHidden = true
                        }
                    }
                }
                
                //控制竖线闪烁
                if toBeString.count >= textLengthLimit {
                    //填满
                    lineView.stopFlashAndHide()
                }else{
                    let backView = viewsArray[toBeString.count]
                    lineView.center = backView.center
                    lineView.startFlash()
                }
            }
        }
        
    }
    
    ///设置输入框类型设置
    func setTextFieldType(tfType:TextFieldType, borderColor:UIColor, lineColor:UIColor) {
        
        if tfType != .Default {
            
            if textLengthLimit != LONG_MAX {
                
                //设置外边框的样式
                self.borderStyle = .none
                self.layer.borderColor = borderColor.cgColor
                self.layer.borderWidth = 1;
                self.tintColor = UIColor.clear
                self.textColor = UIColor.clear
                
                let widthSpace:CGFloat = self.frame.size.width / CGFloat(textLengthLimit)
                let height:CGFloat = self.frame.size.height
                
                for index in 0..<textLengthLimit {
                    
                    let line = UIView()
                    line.backgroundColor = borderColor
                    //改变竖条的大小
                    line.frame = CGRect(x: ((widthSpace - 1) + (widthSpace + 1)*CGFloat(index)), y: 1.5, width: 1, height: height - 3)
                    
                    if index != textLengthLimit - 1 {
                        //最后一条线不加
                        self.addSubview(line)
                    }
                    
                    if tfType == .Code_Cipher {
                        //密文
                        let backView = UIView()
                        backView.backgroundColor = UIColor.black
                        backView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
                        backView.center = CGPoint(x: widthSpace / 2 + widthSpace*CGFloat(index), y: height / 2)
                        //设置小圆点大小
                        backView.layer.cornerRadius = 5
                        backView.layer.masksToBounds = true
                        self.addSubview(backView)
                        backView.isHidden = true
                        backView.tag = 1000 + index
                        viewsArray.append(backView)
                        
                    }else if tfType == .Code_Clear {
                        //明文
                        let label:UILabel = UILabel()
                        label.textAlignment = .center
                        label.textColor = UIColor.black
                        label.backgroundColor = UIColor.clear
                        //改变label的frame
                        label.frame = CGRect(x: 0, y: 0, width: widthSpace - 4, height: height - 4)
                        label.center = CGPoint(x: widthSpace / 2 + widthSpace*CGFloat(index), y: height/2)
                        self.addSubview(label)
                        label.isHidden = true
                        label.tag = 1000 + index
                        viewsArray.append(label)
                    }
                    
                }
                
                lineView.backgroundColor = lineColor
                lineView.frame = CGRect(x: 0, y: 0, width: 2, height: 24)
                lineView.center = CGPoint(x: widthSpace / 2, y: height / 2)
                self.addSubview(lineView)
            }
        }
    }
    
    
    ///设置清除按钮图片
    func setClearBtnImage(image:UIImage) {
        let clearBtn:UIButton? = self.value(forKey: "clearButton") as? UIButton
        clearBtn?.setImage(image, for: .normal)
    }
    
    //MARK: ************************* 赋值粘贴 代理处理 *************************
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if showMenuAction {
            let menuController = UIMenuController.shared
            menuController.isMenuVisible = false
            //控制显示的菜单
            if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    override func paste(_ sender: Any?) {
        super.paste(sender)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
            self.posted()
        }
    }
    
    ///菜单弹框隐藏触发
    private func posted() {
        
        if tfType == .Mobile && self.text?.count ?? 0 > 0 {
            //手机号码类型
            let numArray = self.text!.components(separatedBy: " ")
            
            //去空格
            let mobileStr = numArray.count > 1 ? numArray.joined(separator: "") : self.text!
            
            //获取新的带空格手机号
            var phoneStr = ""
            
            for index in 0..<phoneStr.count {
                
                let oneNum = self.string_range(string: mobileStr, start: index, end: index)
                
                phoneStr.append(oneNum)
                
                if phoneStr.count == 3 || phoneStr.count == 8 {
                    phoneStr.append(" ")//添加空格
                }
                
                if phoneStr.count >= 13 {
                    break;
                }
            }
            
            self.text = phoneStr
        }
        
    }
    
    
    ///字符串截取
    private func string_range(string:String, start:Int, end:Int) -> String {
        
        var indexS = start < 0 ? 0 : start
        
        let indexE = end > (string.count - 1) ? string.count - 1 : end;
        
        if indexS > indexE {
            indexS = indexE
        }
        
        let indexStart = string.index(string.startIndex, offsetBy: indexS)
        let indexEnd = string.index(string.startIndex, offsetBy: indexE)
        
        let substr = String(string[indexStart...indexEnd])
        
        return substr
    }
}


//MARK: ************************* 输入框竖线 *************************
fileprivate class GFLineTF: UIView {
    
    ///隐藏 & 显示
    var isHide = false
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.backgroundColor = UIColor.blue
        self.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///不停闪烁
    @objc func constantlyFlashing() {
        if !isHide {
            UIView.animate(withDuration: 0.5, animations: {
                self.isHidden = !self.isHidden
            }) { (finished) in
                self.perform(#selector(self.constantlyFlashing), with: nil, afterDelay: 0.5)
            }
        }
    }
    
    ///隐藏 && 停止闪烁
    func stopFlashAndHide() {
        if !isHide {
            isHide = true
            self.isHidden = true
        }
    }
    
    ///开始闪烁
    func startFlash() {
        if isHide {
            isHide = false
            self.isHidden = false
            self.constantlyFlashing()
        }
    }
    
}
