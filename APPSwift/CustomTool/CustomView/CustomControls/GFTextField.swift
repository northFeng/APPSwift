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
        //默认
        case Default
        ///手机号
        case Mobile
        ///验证码 密文
        case Code_Cipher
        ///验证码 明文
        case Code_Clear
    }
    
    ///限制文字长度 --- 默认无穷大 （汉语两个字节为一个汉字，英文一个单词为一个一字节）
    var textLengthLimit:Int = LONG_MAX
    
    ///输入框类型
    var tfType:TextFieldType = .Default
    
    ///是否展示 菜单
    var showMenuAction:Bool = false
    
    ///上一次文本长度
    private var uptextLength = 0
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledEditChanged(noti:)), name: NSNotification.Name(rawValue: ""), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ************************* 输入框文字变化通知 *************************
    @objc func textFiledEditChanged(noti:Notification) {
        
        let toBeString:String = self.text ?? ""
        let lang = self.textInputMode?.primaryLanguage
        
        if lang == "zh-Hans" {
            //简体中文输入，包括简体拼音，健体五笔，简体手写
            let selectedRange = self.markedTextRange
            //获取高亮部分
            let position = self.position(from: selectedRange?.start ?? UITextPosition(), offset: 0)
            //没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if position != nil {
                if toBeString.count > textLengthLimit {
                    self.text = String(toBeString[...toBeString.index(toBeString.endIndex, offsetBy: 0)])
                }
            }else{
                //有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        }else{
            //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if toBeString.count > textLengthLimit {
                self.text = String(toBeString[...toBeString.index(toBeString.endIndex, offsetBy: 0)])
            }
        }
        
        //处理
        switch tfType {
        case .Mobile:
            //判断在输入还是删除
            if uptextLength < self.text?.count ?? 0 {
                //输入字符
                if self.text?.count == 3 || self.text?.count == 8 {
                    self.text = self.text! + " "
                }else if uptextLength == 3 || uptextLength == 8 {
                    self.text = String(format: "%@ %@", String(self.text![self.text!.startIndex..<self.text!.index(self.text!.startIndex, offsetBy: uptextLength)]),String(self.text![self.text!.index(self.text!.startIndex, offsetBy: uptextLength)...self.text!.endIndex]))
                }
            }else if uptextLength > self.text?.count ?? 0 {
                //删除字符
                if self.text?.count == 4 || self.text?.count == 9 {
                    self.text = String(self.text![self.text!.startIndex...self.text!.index(before: self.text!.endIndex)])
                }
            }
//        case .Code_Cipher:
//        case .Code_Clear:
//
//        default:
            
        }
        
        
    }
    
    
}
