//
//  APPViewTool.swift
//  APPSwift
//  视图工厂工具
//  Created by 峰 on 2020/6/29.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation


struct APPViewTool {
    
    ///创建view
    static func view_createView(bgColor:UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = bgColor
        return view
    }
    
    ///创建ImgView
    static func view_createImgview(imgName:String) -> UIImageView {
        let imgView = UIImageView(image: UIImage(named: imgName))
        /**
         scaleToFill = 0  //填充满， 但是 会变形

        scaleAspectFit  //可能会填充不满，但是 不会变形，宽 填满 、高 填满

        scaleAspectFill //填充满 ，也不会变形，但是填充过大，超过相框
         */
        //imgView.contentMode = .scaleToFill
        
        return imgView
    }
    
    ///创建label
    static func view_createLabel(text:String, font:UIFont, color:UIColor, alignment:NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.textAlignment = alignment
        return label
    }
    
    ///一：文字按钮
    static func view_createButtonTitle(title:String, font:UIFont, color:UIColor, bgColor:UIColor) -> UIButton {
        let button = UIButton(type: .custom)
        let attrString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:color])
        button.setAttributedTitle(attrString, for: .normal)
        button.backgroundColor = bgColor
        return button
    }
    
    ///二： 文字   颜色 —> 默认& 选中  按钮
    static func view_createButtonTitle(title:String, font:UIFont, color_n:UIColor, color_s:UIColor, bgColor:UIColor) -> UIButton {
        let button = UIButton(type: .custom)
        
        let attrString_n = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:color_n])
        button.setAttributedTitle(attrString_n, for: .normal)
        
        let attrString_s = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font:font,NSAttributedString.Key.foregroundColor:color_s])
        button.setAttributedTitle(attrString_s, for: .selected)
        
        button.backgroundColor = bgColor
        return button
    }
    
    ///三： 文字   颜色、字体、文字 —> 默认& 选中   按钮
    static func view_createButtonTitle(title_n:String, font_n:UIFont, color_n:UIColor, title_s:String? = nil, font_s:UIFont? = nil, color_s:UIColor, bgColor:UIColor) -> UIButton {
        let button = UIButton(type: .custom)
        let attrString_n = NSAttributedString(string: title_n, attributes: [NSAttributedString.Key.font:font_n,NSAttributedString.Key.foregroundColor:color_n])
        button.setAttributedTitle(attrString_n, for: .normal)
        
        let attrString_s = NSAttributedString(string: title_s ?? title_n, attributes: [NSAttributedString.Key.font:font_s ?? font_n,NSAttributedString.Key.foregroundColor:color_s])
        button.setAttributedTitle(attrString_s, for: .selected)
        
        button.backgroundColor = bgColor
        return button
    }
    
    ///四：普通图片  按钮
    static func view_createButtonImage(imgName:String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imgName), for: .normal)
        return button
    }
    
    ///五：图片 —> 默认 & 选中
    static func view_createButtonImage(imgName_n:String, imgName_s:String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imgName_n), for: .normal)
        button.setImage(UIImage(named: imgName_s), for: .selected)
        button.isSelected = false
        return button
    }
    
    ///六：图片填充满
    static func view_createButtonImageFill(imgName:String) -> UIButton {
        let button = APPImageButton_gf(type: .custom)
        button.setImage(UIImage(named: imgName), for: .normal)
        return button
    }
    
    ///七：图片填充满 —> 默认 & 选中
    static func view_createButtonImageFill(imgName_n:String, imgName_s:String) -> UIButton {
        let button = APPImageButton_gf(type: .custom)
        button.setImage(UIImage(named: imgName_n), for: .normal)
        button.setImage(UIImage(named: imgName_s), for: .selected)
        return button
    }
    
    ///八：创建一个 图文按钮
    static func view_createButtonImageText(_ btnType:APPTextImageButton.APPTextImageButtonType, title:String, font:UIFont, color:UIColor, titleSize:CGSize, imgName:String, imgSize:CGSize, spacing:CGFloat) -> APPTextImageButton {
        let button = APPTextImageButton()
        button.setTextAndImage(text: title, textSize: titleSize, font: font, color: color, imgName: imgName, imgSize: imgSize, btnType: btnType, spaceing: spacing)
        return button
    }
    
    //MARK: ************************* view的边角、阴影 *************************

    ///一：普通四角圆角
    static func view_addRoundedCorners(superView:UIView, width:CGFloat, masksBounds:Bool) {
        superView.layer.cornerRadius = width
        superView.layer.masksToBounds = masksBounds
    }
    
    
    ///二：添加指定位置的圆角 (使用前必须先设置frame)
    static func view_addRoundedCorners(superView:UIView, corners:UIRectCorner, width:CGFloat) {
        let maskPath = UIBezierPath(roundedRect: superView.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: width, height: width))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = superView.bounds
        maskLayer.path = maskPath.cgPath
        superView.layer.mask = maskLayer
    }
    
    ///三：添加指定位置的圆角  (传入view的frame)
    static func view_addRoundedCorners(superView:UIView, viewFrame:CGRect, corners:UIRectCorner, width:CGFloat) {
        let maskPath = UIBezierPath(roundedRect: superView.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: width, height: width))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = viewFrame
        maskLayer.path = maskPath.cgPath
        superView.layer.mask = maskLayer
    }
    
    ///设置视图的 圆角 和 边框线
    static func view_addBorder(superView:UIView, width:CGFloat, color:UIColor, radius:CGFloat) {
        superView.layer.cornerRadius = radius
        superView.layer.borderWidth = width
        superView.layer.borderColor = color.cgColor
    }
    
    ///添加阴影
    static func view_addShadow(superView:UIView, offset:CGSize, color:UIColor, shadowAlpha:Float) {
        superView.layer.shadowOffset = offset
        superView.layer.shadowColor = color.cgColor
        superView.layer.shadowOpacity = shadowAlpha
    }
    
    ///父视图主动移除所有的子视图
    static func view_removeAllChildsView(superView:UIView) {
        let views:[UIView] = superView.subviews
        for subView in views {
            subView.removeFromSuperview()
        }
    }
    
    
    private class APPImageButton_gf: UIButton {
        
        override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
            return CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        }
    }
}
