//
//  APPTextImageButton.swift
//  APPSwift
//  自定义 文字&图片 按钮
//  Created by 峰 on 2020/6/23.
//  Copyright © 2020 north_feng. All rights reserved.
//

import UIKit

class APPTextImageButton: UIButton {
    
    enum APPTextImageButtonType:Int {
        ///文字和图片是水平方向(左边文字，右边图片)
        case Horizontal_TextImg = 0
        
        ///文字和图片是水平方向(左边图片，右边文字)
        case Horizontal_ImgText
        
        ///文字和图片是竖直方向(上边文字，下边图片)
        case Vertical_TextImg
        
        ///文字和图片是竖直方向(上边图片，下边文字)
        case Vertical_ImgText
    }
    
    ///存放 图片和按钮
    private let backView = UIView()
    
    ///文字label
    let btnLabel = UILabel()
    
    let btnImgview = UIImageView()
    
    ///更新文字
    func updateText(text:String) {
        btnLabel.text = text
    }
    
    ///更新图片
    func updateImage(imgName:String) {
        btnImgview.image = UIImage(named: imgName)
    }
    
    /// 赋值 按钮上的 文字和图片
    /// - Parameters:
    ///   - text: 文字
    ///   - textSize: 文字size
    ///   - font: 字体
    ///   - color: 颜色
    ///   - imgName: 图片img
    ///   - imgSize: 图片size
    ///   - btnType: 按钮类型
    ///   - spaceing: 文字与按钮 间距
    func setTextAndImage(text:String, textSize:CGSize, font:UIFont, color:UIColor, imgName:String, imgSize:CGSize, btnType:APPTextImageButtonType, spaceing:CGFloat) {
        
        backView.isUserInteractionEnabled = false
        backView.backgroundColor = UIColor.clear
        self.addSubview(backView)
        
        btnLabel.backgroundColor = UIColor.clear
        btnLabel.text = text
        btnLabel.font = font
        btnLabel.textColor = color
        backView.addSubview(btnLabel)
        
        btnImgview.contentMode = .scaleAspectFit
        btnImgview.backgroundColor = UIColor.clear
        btnImgview.image = UIImage(named: imgName)
        backView.addSubview(btnImgview)
        
        var totalWidth:CGFloat = 0.0
        var totalHeight:CGFloat = 0.0
        
        switch btnType {
        case .Horizontal_TextImg:
            //水平 ——> 文字+图片
            btnLabel.textAlignment = .right
            totalWidth = textSize.width + imgSize.width + spaceing
            totalHeight = textSize.height > imgSize.height ? textSize.height : imgSize.height
            
            btnLabel.snp.makeConstraints { (make) in
                make.left.centerY.equalTo(backView)
                make.size.equalTo(textSize)
            }
            btnImgview.snp.makeConstraints { (make) in
                make.right.centerY.equalTo(backView)
                make.size.equalTo(imgSize)
            }
        case .Horizontal_ImgText:
            //水平 ——> 图片+文字
            btnLabel.textAlignment = .left
            totalWidth = textSize.width + imgSize.width + spaceing;
            totalHeight = textSize.height > imgSize.height ? textSize.height : imgSize.height;
            
            btnImgview.snp.makeConstraints { (make) in
                make.left.centerY.equalTo(backView)
                make.size.equalTo(imgSize)
            }
            btnLabel.snp.makeConstraints { (make) in
                make.right.centerY.equalTo(backView)
                make.size.equalTo(textSize)
            }
            
        case .Vertical_TextImg:
            //竖直 ——> 文字+图片
            btnLabel.textAlignment = .center
            totalWidth = textSize.width > imgSize.width ? textSize.width : imgSize.width;
            totalHeight = textSize.height + imgSize.height + spaceing;
            
            btnLabel.snp.makeConstraints { (make) in
                make.top.centerX.equalTo(backView)
                make.size.equalTo(textSize)
            }
            btnImgview.snp.makeConstraints { (make) in
                make.bottom.centerX.equalTo(backView)
                make.size.equalTo(imgSize)
            }
            
        case .Vertical_ImgText:
            //竖直 ——> 图片+文字
            btnLabel.textAlignment = .center
            totalWidth = textSize.width > imgSize.width ? textSize.width : imgSize.width;
            totalHeight = textSize.height + imgSize.height + spaceing;
            
            btnImgview.snp.makeConstraints { (make) in
                make.top.centerX.equalTo(backView)
                make.size.equalTo(imgSize)
            }
            btnLabel.snp.makeConstraints { (make) in
                make.bottom.centerX.equalTo(backView)
                make.size.equalTo(textSize)
            }
        }
        
        backView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(totalWidth)
            make.height.equalTo(totalHeight)
        }
        
        
    }
    
    
}
